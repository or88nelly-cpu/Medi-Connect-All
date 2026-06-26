import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/modules/management/staff_management/domain/entities/department_entity.dart';

class BookingWizardState {
  final int currentStep;
  final UserModel? selectedPatient;
  final String patientSearchQuery;
  final bool isCreatingPatient;
  final DepartmentEntity? selectedSection;
  final UserModel? selectedDoctor;
  final DateTime selectedDate;
  final String? selectedSlotTime;
  final String selectedType;
  final bool isWaitingList;
  final int currentNormalCount;
  final int currentWaitingCount;
  final bool isLoadingCounts;
  final String gender;
  final double consultationFee;
  final bool isFollowUp;
  final bool isLoadingFeeCheck;

  BookingWizardState({
    required this.currentStep,
    this.selectedPatient,
    required this.patientSearchQuery,
    required this.isCreatingPatient,
    this.selectedSection,
    this.selectedDoctor,
    required this.selectedDate,
    this.selectedSlotTime,
    required this.selectedType,
    required this.isWaitingList,
    required this.currentNormalCount,
    required this.currentWaitingCount,
    required this.isLoadingCounts,
    required this.gender,
    this.consultationFee = 0.0,
    this.isFollowUp = false,
    this.isLoadingFeeCheck = false,
  });

  BookingWizardState copyWith({
    int? currentStep,
    UserModel? selectedPatient,
    String? patientSearchQuery,
    bool? isCreatingPatient,
    DepartmentEntity? selectedSection,
    UserModel? selectedDoctor,
    DateTime? selectedDate,
    String? selectedSlotTime,
    String? selectedType,
    bool? isWaitingList,
    int? currentNormalCount,
    int? currentWaitingCount,
    bool? isLoadingCounts,
    String? gender,
    double? consultationFee,
    bool? isFollowUp,
    bool? isLoadingFeeCheck,
    bool clearSelectedPatient = false,
    bool clearSelectedSection = false,
    bool clearSelectedDoctor = false,
    bool clearSelectedSlot = false,
  }) {
    return BookingWizardState(
      currentStep: currentStep ?? this.currentStep,
      selectedPatient: clearSelectedPatient
          ? null
          : (selectedPatient ?? this.selectedPatient),
      patientSearchQuery: patientSearchQuery ?? this.patientSearchQuery,
      isCreatingPatient: isCreatingPatient ?? this.isCreatingPatient,
      selectedSection: clearSelectedSection
          ? null
          : (selectedSection ?? this.selectedSection),
      selectedDoctor: clearSelectedDoctor
          ? null
          : (selectedDoctor ?? this.selectedDoctor),
      selectedDate: selectedDate ?? this.selectedDate,
      selectedSlotTime: clearSelectedSlot
          ? null
          : (selectedSlotTime ?? this.selectedSlotTime),
      selectedType: selectedType ?? this.selectedType,
      isWaitingList: isWaitingList ?? this.isWaitingList,
      currentNormalCount: currentNormalCount ?? this.currentNormalCount,
      currentWaitingCount: currentWaitingCount ?? this.currentWaitingCount,
      isLoadingCounts: isLoadingCounts ?? this.isLoadingCounts,
      gender: gender ?? this.gender,
      consultationFee: consultationFee ?? this.consultationFee,
      isFollowUp: isFollowUp ?? this.isFollowUp,
      isLoadingFeeCheck: isLoadingFeeCheck ?? this.isLoadingFeeCheck,
    );
  }
}

class BookingWizardCubit extends Cubit<BookingWizardState> {
  BookingWizardCubit()
    : super(
        BookingWizardState(
          currentStep: 0,
          patientSearchQuery: '',
          isCreatingPatient: false,
          selectedDate: DateTime.now(),
          selectedType: 'Consultation',
          isWaitingList: false,
          currentNormalCount: 0,
          currentWaitingCount: 0,
          isLoadingCounts: false,
          gender: 'Male',
          consultationFee: 0.0,
          isFollowUp: false,
          isLoadingFeeCheck: false,
        ),
      );

  void setGender(String val) {
    emit(state.copyWith(gender: val));
  }

  void setStep(int step) {
    emit(state.copyWith(currentStep: step));
  }

  void nextStep() {
    if (state.currentStep < 4) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    }
  }

  void previousStep() {
    if (state.currentStep > 0) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void selectPatient(UserModel? patient) {
    emit(state.copyWith(selectedPatient: patient, isCreatingPatient: false));
    checkFollowUpStatus();
  }

  void setPatientSearchQuery(String query) {
    emit(state.copyWith(patientSearchQuery: query));
  }

  void toggleCreatingPatient(bool val) {
    emit(state.copyWith(isCreatingPatient: val));
  }

  void selectSection(DepartmentEntity? section) {
    emit(
      state.copyWith(
        selectedSection: section,
        clearSelectedDoctor: true,
        clearSelectedSlot: true,
      ),
    );
  }

  void selectDoctor(UserModel? doctor) {
    emit(state.copyWith(selectedDoctor: doctor, clearSelectedSlot: true));
    if (doctor != null) {
      loadAppointmentCounts();
    }
    checkFollowUpStatus();
  }

  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: date, clearSelectedSlot: true));
    loadAppointmentCounts();
    checkFollowUpStatus();
  }

  void selectSlotTime(String? time) {
    emit(state.copyWith(selectedSlotTime: time));
  }

  void setWaitingList(bool val) {
    emit(state.copyWith(isWaitingList: val));
  }

  void selectType(String type) {
    emit(state.copyWith(selectedType: type));
  }

  Future<void> checkFollowUpStatus() async {
    final patient = state.selectedPatient;
    final doctor = state.selectedDoctor;
    if (patient == null || doctor == null) {
      emit(state.copyWith(
        isFollowUp: false,
        consultationFee: 0.0,
      ));
      return;
    }

    emit(state.copyWith(isLoadingFeeCheck: true));
    try {
      final res = await Supabase.instance.client
          .from('appointments')
          .select('appointment_date')
          .eq('patient_id', patient.id)
          .eq('doctor_id', doctor.id)
          .neq('status', 'Cancelled');

      final list = res as List<dynamic>? ?? [];
      bool followUp = false;
      for (final item in list) {
        final dateStr = item['appointment_date'] as String?;
        if (dateStr != null) {
          final aptDate = DateTime.tryParse(dateStr);
          if (aptDate != null) {
            final diff = state.selectedDate.difference(aptDate).inDays.abs();
            if (diff < 7) {
              followUp = true;
              break;
            }
          }
        }
      }

      final double baseFee = doctor.consultationFee ?? 500.0;
      final double finalFee = followUp ? 0.0 : baseFee;

      emit(state.copyWith(
        isFollowUp: followUp,
        consultationFee: finalFee,
        isLoadingFeeCheck: false,
      ));
    } catch (e) {
      final double baseFee = doctor.consultationFee ?? 500.0;
      emit(state.copyWith(
        isFollowUp: false,
        consultationFee: baseFee,
        isLoadingFeeCheck: false,
      ));
    }
  }

  Future<void> loadAppointmentCounts() async {
    if (state.selectedDoctor == null) return;
    emit(state.copyWith(isLoadingCounts: true));
    try {
      final dateStr = state.selectedDate.toIso8601String().split('T').first;
      final doctorName =
          state.selectedDoctor!.name ??
          '${state.selectedDoctor!.firstName} ${state.selectedDoctor!.lastName}'
              .trim();

      final res = await Supabase.instance.client
          .from('appointments')
          .select('token')
          .eq('doctor_name', doctorName)
          .eq('appointment_date', dateStr);

      final list = res as List<dynamic>? ?? [];
      // Compute the prefix based on doctor initials
      final cleanName = doctorName
          .replaceAll(
            RegExp(r'^(dr\.|dr|Dr\.|Dr)\s+', caseSensitive: false),
            '',
          )
          .trim();
      final parts = cleanName
          .split(RegExp(r'\s+'))
          .where((s) => s.isNotEmpty)
          .toList();
      String initials = 'DR';
      if (parts.isNotEmpty) {
        if (parts.length == 1) {
          initials = parts[0]
              .substring(0, parts[0].length >= 2 ? 2 : 1)
              .toUpperCase();
        } else {
          initials =
              '${parts.first[0].toUpperCase()}${parts.last[0].toUpperCase()}';
        }
      }

      final normalPrefix = '${initials}A';
      final waitingPrefix = '${initials}W';

      int normal = 0;
      int waiting = 0;
      for (final item in list) {
        final t = item['token'] as String?;
        if (t != null) {
          if (t.startsWith(waitingPrefix)) {
            waiting++;
          } else if (t.startsWith(normalPrefix)) {
            normal++;
          }
        }
      }
      emit(
        state.copyWith(
          currentNormalCount: normal,
          currentWaitingCount: waiting,
          isLoadingCounts: false,
        ),
      );
    } catch (_) {
      emit(state.copyWith(isLoadingCounts: false));
    }
  }
}
