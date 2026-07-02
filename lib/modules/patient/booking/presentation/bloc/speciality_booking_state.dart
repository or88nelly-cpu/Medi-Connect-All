import 'package:equatable/equatable.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/shared/auth/data/models/doctor_model.dart';

enum SpecialityBookingStatus {
  initial,
  loading,
  doctorsLoaded,
  doctorDetail,
  paymentPending,
  success,
  error,
}

class DoctorBookingInfo extends Equatable {
  final UserModel user;
  final DoctorModel? doctorInfo;

  const DoctorBookingInfo({required this.user, this.doctorInfo});

  @override
  List<Object?> get props => [user, doctorInfo];
}

class SpecialityBookingState extends Equatable {
  final SpecialityBookingStatus status;
  final List<DoctorBookingInfo> doctors;
  final DoctorBookingInfo? selectedDoctor;
  final DateTime? selectedDate;
  final String? selectedSlot;
  final List<String> bookedSlots;
  final double consultationFee;
  final String? errorMessage;

  const SpecialityBookingState({
    this.status = SpecialityBookingStatus.initial,
    this.doctors = const [],
    this.selectedDoctor,
    this.selectedDate,
    this.selectedSlot,
    this.bookedSlots = const [],
    this.consultationFee = 0.0,
    this.errorMessage,
  });

  SpecialityBookingState copyWith({
    SpecialityBookingStatus? status,
    List<DoctorBookingInfo>? doctors,
    DoctorBookingInfo? selectedDoctor,
    DateTime? selectedDate,
    String? selectedSlot,
    List<String>? bookedSlots,
    double? consultationFee,
    String? errorMessage,
    bool clearSelectedDoctor = false,
    bool clearSelectedSlot = false,
    bool clearSelectedDate = false,
  }) {
    return SpecialityBookingState(
      status: status ?? this.status,
      doctors: doctors ?? this.doctors,
      selectedDoctor: clearSelectedDoctor ? null : (selectedDoctor ?? this.selectedDoctor),
      selectedDate: clearSelectedDate ? null : (selectedDate ?? this.selectedDate),
      selectedSlot: clearSelectedSlot ? null : (selectedSlot ?? this.selectedSlot),
      bookedSlots: bookedSlots ?? this.bookedSlots,
      consultationFee: consultationFee ?? this.consultationFee,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        doctors,
        selectedDoctor,
        selectedDate,
        selectedSlot,
        bookedSlots,
        consultationFee,
        errorMessage,
      ];
}
