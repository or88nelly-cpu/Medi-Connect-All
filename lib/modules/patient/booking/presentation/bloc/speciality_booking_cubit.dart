import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/core/constants/app_enum.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:medi_connect/modules/patient/booking/presentation/bloc/speciality_booking_state.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/shared/auth/data/models/doctor_model.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_appointments_bloc.dart';

class SpecialityBookingCubit extends Cubit<SpecialityBookingState> {
  SpecialityBookingCubit() : super(const SpecialityBookingState());

  // 1. Load doctors inside specialty
  Future<void> loadDoctors(String specialityId, String specialityName) async {
    emit(state.copyWith(status: SpecialityBookingStatus.loading));
    try {
      print('*** loadDoctors started for: ID=$specialityId, Name=$specialityName ***');
      final response = await Supabase.instance.client
          .from('users')
          .select('*, employees(*, doctors!doctors_employee_id_fkey(*))')
          .eq('role', 'Doctor');

      print('*** Supabase returned ${response.length} doctor users. ***');
      final list = response as List<dynamic>? ?? [];
      final doctorsList = <DoctorBookingInfo>[];

      for (final item in list) {
        final map = Map<String, dynamic>.from(item as Map);
        print('*** Doctor User details: name=${map['name'] ?? map['first_name']}, role=${map['role']}, dept=${map['department']} ***');
        
        final empJson = map.remove('employees');
        Map<String, dynamic>? rawEmpMap;
        if (empJson is List && empJson.isNotEmpty) {
          rawEmpMap = Map<String, dynamic>.from(empJson.first as Map);
        } else if (empJson is Map<String, dynamic>) {
          rawEmpMap = Map<String, dynamic>.from(empJson);
        }

        dynamic docListJson;
        if (rawEmpMap != null) {
          docListJson = rawEmpMap.remove('doctors');
          map.addAll(rawEmpMap);
        }

        if (docListJson == null && map.containsKey('doctors')) {
          docListJson = map.remove('doctors');
        }
        
        DoctorModel? doctorModel;
        Map<String, dynamic>? rawDocMap;

        if (docListJson is List && docListJson.isNotEmpty) {
          rawDocMap = Map<String, dynamic>.from(docListJson.first as Map);
          rawDocMap['id'] = map['id'];
          rawDocMap['employee_id'] ??= rawEmpMap?['id'] ?? 'EMP-${map['id'].hashCode.abs()}';
          doctorModel = DoctorModel.fromJson(rawDocMap);
        } else if (docListJson is Map<String, dynamic>) {
          rawDocMap = Map<String, dynamic>.from(docListJson);
          rawDocMap['id'] = map['id'];
          rawDocMap['employee_id'] ??= rawEmpMap?['id'] ?? 'EMP-${map['id'].hashCode.abs()}';
          doctorModel = DoctorModel.fromJson(rawDocMap);
        }

        final userModel = UserModel.fromJson(map);

        bool isMatch = false;
        
        // 1. Match by speciality_id
        final specIdMatch = doctorModel != null && doctorModel.specialityId == specialityId;
        if (specIdMatch) isMatch = true;

        // 2. Match by specialization in doctors table
        final specialization = rawDocMap?['specialization'] as String?;
        final specNameMatch = specialization != null &&
            specialization.toLowerCase() == specialityName.toLowerCase();
        if (specNameMatch) isMatch = true;

        // 3. Match by sub_speciality in doctors table
        final subSpec = rawDocMap?['sub_speciality'] as String?;
        final subSpecMatch = subSpec != null &&
            subSpec.toLowerCase() == specialityName.toLowerCase();
        if (subSpecMatch) isMatch = true;
        
        // 4. Match by department in users table
        final dept = map['department'] as String?;
        final deptMatch = dept != null &&
            dept.toLowerCase() == specialityName.toLowerCase();
        if (deptMatch) isMatch = true;

        print('*** Match decision: name=${userModel.fullName}, specIdMatch=$specIdMatch (db value: ${doctorModel?.specialityId}), specNameMatch=$specNameMatch (db value: $specialization), subSpecMatch=$subSpecMatch (db value: $subSpec), deptMatch=$deptMatch (db value: $dept) -> final isMatch=$isMatch ***');

        if (isMatch) {
          doctorsList.add(DoctorBookingInfo(user: userModel, doctorInfo: doctorModel));
        }
      }
      print('*** Final doctorsList count: ${doctorsList.length} ***');

      emit(state.copyWith(
        status: SpecialityBookingStatus.doctorsLoaded,
        doctors: doctorsList,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SpecialityBookingStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  // 2. Select doctor
  void selectDoctor(DoctorBookingInfo doctor) {
    final fee = doctor.doctorInfo?.consultationFee ?? 500.0;
    emit(state.copyWith(
      selectedDoctor: doctor,
      consultationFee: fee,
      clearSelectedDate: true,
      clearSelectedSlot: true,
      status: SpecialityBookingStatus.doctorDetail,
    ));
  }

  // 3. Select date & load slots availability
  Future<void> selectDate(DateTime date) async {
    final doctor = state.selectedDoctor;
    if (doctor == null) return;

    emit(state.copyWith(
      selectedDate: date,
      clearSelectedSlot: true,
      status: SpecialityBookingStatus.doctorDetail,
    ));

    try {
      final dateStr = date.toIso8601String().split('T').first;
      final response = await Supabase.instance.client
          .from('appointments')
          .select('appointment_time')
          .eq('doctor_id', doctor.user.id)
          .eq('appointment_date', dateStr)
          .neq('status', 'Cancelled');

      final list = response as List<dynamic>? ?? [];
      final booked = list
          .map((item) => (item['appointment_time'] ?? '').toString())
          .where((t) => t.isNotEmpty)
          .toList();

      emit(state.copyWith(
        bookedSlots: booked,
      ));
    } catch (_) {
      emit(state.copyWith(
        bookedSlots: const [],
      ));
    }
  }

  // 4. Select slot
  void selectSlot(String slot) {
    emit(state.copyWith(
      selectedSlot: slot,
    ));
  }

  // 5. Proceed to payment
  void proceedToPayment() {
    if (state.selectedDoctor == null || state.selectedDate == null || state.selectedSlot == null) {
      emit(state.copyWith(
        status: SpecialityBookingStatus.error,
        errorMessage: "Please select doctor, date and slot time.",
      ));
      return;
    }
    emit(state.copyWith(
      status: SpecialityBookingStatus.paymentPending,
    ));
  }

  // 6. Confirm payment & insert appointment
  Future<void> confirmPayment(
    AdminAppointmentsBloc appointmentsBloc,
    String patientId,
    String patientName,
    String specialtyName,
  ) async {
    final doctor = state.selectedDoctor;
    final date = state.selectedDate;
    final slot = state.selectedSlot;

    if (doctor == null || date == null || slot == null) {
      emit(state.copyWith(
        status: SpecialityBookingStatus.error,
        errorMessage: "Invalid booking details.",
      ));
      return;
    }

    emit(state.copyWith(status: SpecialityBookingStatus.loading));

    try {
      final dateStr = date.toIso8601String().split('T').first;
      
      final docName = doctor.user.fullName;
      final cleanName = docName
          .replaceAll(RegExp(r'^(dr\.|dr|Dr\.|Dr)\s+', caseSensitive: false), '')
          .trim();
      final parts = cleanName.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
      String initials = 'DR';
      if (parts.isNotEmpty) {
        if (parts.length == 1) {
          initials = parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
        } else {
          initials = '${parts.first[0].toUpperCase()}${parts.last[0].toUpperCase()}';
        }
      }
      final token = '${initials}A${(DateTime.now().millisecondsSinceEpoch % 1000).toString().padLeft(3, '0')}';

      final appointmentData = {
        'patient_id': patientId,
        'patient_name': patientName,
        'doctor_id': doctor.user.id,
        'doctor_name': doctor.user.fullName,
        'specialty': specialtyName,
        'appointment_date': dateStr,
        'appointment_time': slot,
        'status': 'Confirmed',
        'type': 'Consultation',
        'token': token,
        'amount': state.consultationFee,
      };

      await Supabase.instance.client.from('appointments').insert(appointmentData);

      appointmentsBloc.add(LoadAppointments());

      emit(state.copyWith(
        status: SpecialityBookingStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: SpecialityBookingStatus.error,
        errorMessage: e.toString(),
      ));
    }
  }

  void reset() {
    emit(const SpecialityBookingState());
  }
}
