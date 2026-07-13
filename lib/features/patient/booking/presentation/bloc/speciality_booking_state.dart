import 'package:equatable/equatable.dart';
import 'package:medi_connect/features/patient/booking/domain/entities/doctor_booking_info.dart';
import 'package:medi_connect/features/patient/booking/presentation/bloc/speciality_booking_status.dart';

class SpecialityBookingState extends Equatable {
  final SpecialityBookingStatus status;
  final List<DoctorBookingInfo> doctors;
  final DoctorBookingInfo? selectedDoctor;
  final DateTime? selectedDate;
  final String? selectedSlot;
  final List<String> bookedSlots;
  final List<String> availableSlots;
  final double consultationFee;
  final String? errorMessage;

  const SpecialityBookingState({
    this.status = SpecialityBookingStatus.initial,
    this.doctors = const [],
    this.selectedDoctor,
    this.selectedDate,
    this.selectedSlot,
    this.bookedSlots = const [],
    this.availableSlots = const [],
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
    List<String>? availableSlots,
    double? consultationFee,
    String? errorMessage,
    bool clearSelectedDoctor = false,
    bool clearSelectedSlot = false,
    bool clearSelectedDate = false,
  }) {
    return SpecialityBookingState(
      status: status ?? this.status,
      doctors: doctors ?? this.doctors,
      selectedDoctor: clearSelectedDoctor
          ? null
          : (selectedDoctor ?? this.selectedDoctor),
      selectedDate: clearSelectedDate
          ? null
          : (selectedDate ?? this.selectedDate),
      selectedSlot: clearSelectedSlot
          ? null
          : (selectedSlot ?? this.selectedSlot),
      bookedSlots: bookedSlots ?? this.bookedSlots,
      availableSlots: availableSlots ?? this.availableSlots,
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
    availableSlots,
    consultationFee,
    errorMessage,
  ];
}
