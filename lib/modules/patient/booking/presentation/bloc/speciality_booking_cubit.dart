import 'package:flutter_bloc/flutter_bloc.dart';
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
      final response = await Supabase.instance.client
          .from('users')
          .select('*, doctors(*)')
          .eq('role', 'doctor');

      final list = response as List<dynamic>? ?? [];
      final doctorsList = <DoctorBookingInfo>[];

      for (final item in list) {
        final map = Map<String, dynamic>.from(item as Map);
        final docListJson = map['doctors'];
        
        DoctorModel? doctorModel;
        if (docListJson is List && docListJson.isNotEmpty) {
          final docMap = Map<String, dynamic>.from(docListJson.first as Map);
          docMap['id'] = map['id'];
          docMap['employee_id'] ??= 'EMP-${map['id'].hashCode.abs()}';
          doctorModel = DoctorModel.fromJson(docMap);
        } else if (docListJson is Map<String, dynamic>) {
          final docMap = Map<String, dynamic>.from(docListJson);
          docMap['id'] = map['id'];
          docMap['employee_id'] ??= 'EMP-${map['id'].hashCode.abs()}';
          doctorModel = DoctorModel.fromJson(docMap);
        }

        final userModel = UserModel.fromJson(map);

        bool isMatch = false;
        if (doctorModel != null) {
          if (doctorModel.specialityId == specialityId) {
            isMatch = true;
          }
        }
        
        final dept = map['department'] as String?;
        if (dept != null && dept.toLowerCase() == specialityName.toLowerCase()) {
          isMatch = true;
        }

        if (isMatch) {
          doctorsList.add(DoctorBookingInfo(user: userModel, doctorInfo: doctorModel));
        }
      }

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
