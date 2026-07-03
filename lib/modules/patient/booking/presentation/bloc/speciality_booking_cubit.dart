import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:medi_connect/core/constants/app_enum.dart';
import 'package:medi_connect/modules/patient/booking/domain/entities/doctor_booking_info.dart';
import 'package:medi_connect/modules/patient/booking/presentation/bloc/speciality_booking_state.dart';
import 'package:medi_connect/modules/patient/booking/domain/usecases/booking_usecases.dart';
import 'package:medi_connect/modules/patient/booking/presentation/bloc/speciality_booking_status.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_appointments_bloc.dart';

class SpecialityBookingCubit extends Cubit<SpecialityBookingState> {
  final LoadDoctorsBySpecialtyUseCase _loadDoctorsUseCase;
  final GetSlotsUseCase _getSlotsUseCase;
  final BookAppointmentUseCase _bookAppointmentUseCase;

  SpecialityBookingCubit({
    LoadDoctorsBySpecialtyUseCase? loadDoctorsUseCase,
    GetSlotsUseCase? getSlotsUseCase,
    BookAppointmentUseCase? bookAppointmentUseCase,
  })  : _loadDoctorsUseCase = loadDoctorsUseCase ?? GetIt.instance<LoadDoctorsBySpecialtyUseCase>(),
        _getSlotsUseCase = getSlotsUseCase ?? GetIt.instance<GetSlotsUseCase>(),
        _bookAppointmentUseCase = bookAppointmentUseCase ?? GetIt.instance<BookAppointmentUseCase>(),
        super(const SpecialityBookingState());

  // 1. Load doctors inside specialty
  Future<void> loadDoctors(String specialityId, String specialityName) async {
    emit(state.copyWith(status: SpecialityBookingStatus.loading));
    try {
      final doctorsList = await _loadDoctorsUseCase(specialityId, specialityName);
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
      final response = await _getSlotsUseCase(
        doctorId: doctor.user.id,
        selectedDate: date,
      );

      emit(state.copyWith(
        bookedSlots: response.bookedSlots,
        availableSlots: response.availableSlots,
      ));
    } catch (_) {
      emit(state.copyWith(
        bookedSlots: const [],
        availableSlots: const [],
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
    String paymentMethod,
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
      await _bookAppointmentUseCase(
        patientId: patientId,
        patientName: patientName,
        doctorId: doctor.user.id,
        doctorName: doctor.user.fullName,
        specialty: specialtyName,
        date: date,
        slot: slot,
        fee: state.consultationFee,
        paymentMethod: paymentMethod,
      );

      // Refresh appointments list in the app
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
