import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:medi_connect/features/patient/booking/domain/entities/doctor_booking_info.dart';
import 'package:medi_connect/features/patient/booking/domain/usecases/booking_usecases.dart';
import 'package:medi_connect/features/patient/booking/presentation/bloc/speciality_booking_state.dart';
import 'package:medi_connect/features/patient/booking/presentation/bloc/speciality_booking_status.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_appointments_bloc.dart';

// ── Events ──────────────────────────────────────────────────────────
abstract class SpecialityBookingEvent extends Equatable {
  const SpecialityBookingEvent();

  @override
  List<Object?> get props => [];
}

class LoadDoctors extends SpecialityBookingEvent {
  final String specialityId;
  final String specialityName;

  const LoadDoctors({required this.specialityId, required this.specialityName});

  @override
  List<Object?> get props => [specialityId, specialityName];
}

class SelectDoctor extends SpecialityBookingEvent {
  final DoctorBookingInfo doctor;

  const SelectDoctor({required this.doctor});

  @override
  List<Object?> get props => [doctor];
}

class SelectDate extends SpecialityBookingEvent {
  final DateTime date;

  const SelectDate({required this.date});

  @override
  List<Object?> get props => [date];
}

class SelectSlot extends SpecialityBookingEvent {
  final String slot;

  const SelectSlot({required this.slot});

  @override
  List<Object?> get props => [slot];
}

class ProceedToPayment extends SpecialityBookingEvent {}

class ConfirmPayment extends SpecialityBookingEvent {
  final AdminAppointmentsBloc appointmentsBloc;
  final String patientId;
  final String patientName;
  final String specialtyName;
  final String paymentMethod;

  const ConfirmPayment({
    required this.appointmentsBloc,
    required this.patientId,
    required this.patientName,
    required this.specialtyName,
    required this.paymentMethod,
  });

  @override
  List<Object?> get props => [
    appointmentsBloc,
    patientId,
    patientName,
    specialtyName,
    paymentMethod,
  ];
}

class ResetBooking extends SpecialityBookingEvent {}

// ── Bloc ────────────────────────────────────────────────────────────
class SpecialityBookingBloc
    extends Bloc<SpecialityBookingEvent, SpecialityBookingState> {
  final LoadDoctorsBySpecialtyUseCase _loadDoctorsUseCase;
  final GetSlotsUseCase _getSlotsUseCase;
  final BookAppointmentUseCase _bookAppointmentUseCase;

  SpecialityBookingBloc({
    LoadDoctorsBySpecialtyUseCase? loadDoctorsUseCase,
    GetSlotsUseCase? getSlotsUseCase,
    BookAppointmentUseCase? bookAppointmentUseCase,
  }) : _loadDoctorsUseCase =
           loadDoctorsUseCase ??
           GetIt.instance<LoadDoctorsBySpecialtyUseCase>(),
       _getSlotsUseCase = getSlotsUseCase ?? GetIt.instance<GetSlotsUseCase>(),
       _bookAppointmentUseCase =
           bookAppointmentUseCase ?? GetIt.instance<BookAppointmentUseCase>(),
       super(const SpecialityBookingState()) {
    on<LoadDoctors>(_onLoadDoctors);
    on<SelectDoctor>(_onSelectDoctor);
    on<SelectDate>(_onSelectDate);
    on<SelectSlot>(_onSelectSlot);
    on<ProceedToPayment>(_onProceedToPayment);
    on<ConfirmPayment>(_onConfirmPayment);
    on<ResetBooking>(_onResetBooking);
  }

  Future<void> _onLoadDoctors(
    LoadDoctors event,
    Emitter<SpecialityBookingState> emit,
  ) async {
    emit(state.copyWith(status: SpecialityBookingStatus.loading));
    try {
      final doctorsList = await _loadDoctorsUseCase(
        event.specialityId,
        event.specialityName,
      );
      emit(
        state.copyWith(
          status: SpecialityBookingStatus.doctorsLoaded,
          doctors: doctorsList,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: SpecialityBookingStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onSelectDoctor(
    SelectDoctor event,
    Emitter<SpecialityBookingState> emit,
  ) {
    final fee = event.doctor.doctorInfo?.consultationFee ?? 500.0;
    emit(
      state.copyWith(
        selectedDoctor: event.doctor,
        consultationFee: fee,
        clearSelectedDate: true,
        clearSelectedSlot: true,
        status: SpecialityBookingStatus.doctorDetail,
      ),
    );
  }

  Future<void> _onSelectDate(
    SelectDate event,
    Emitter<SpecialityBookingState> emit,
  ) async {
    final doctor = state.selectedDoctor;
    if (doctor == null) return;

    emit(
      state.copyWith(
        selectedDate: event.date,
        clearSelectedSlot: true,
        status: SpecialityBookingStatus.doctorDetail,
      ),
    );

    try {
      final response = await _getSlotsUseCase(
        doctorId: doctor.doctorInfo?.id ?? doctor.user.id,
        selectedDate: event.date,
      );

      emit(
        state.copyWith(
          bookedSlots: response.bookedSlots,
          availableSlots: response.availableSlots,
        ),
      );
    } catch (_) {
      emit(state.copyWith(bookedSlots: const [], availableSlots: const []));
    }
  }

  void _onSelectSlot(SelectSlot event, Emitter<SpecialityBookingState> emit) {
    emit(state.copyWith(selectedSlot: event.slot));
  }

  void _onProceedToPayment(
    ProceedToPayment event,
    Emitter<SpecialityBookingState> emit,
  ) {
    if (state.selectedDoctor == null ||
        state.selectedDate == null ||
        state.selectedSlot == null) {
      emit(
        state.copyWith(
          status: SpecialityBookingStatus.error,
          errorMessage: "Please select doctor, date and slot time.",
        ),
      );
      return;
    }
    emit(state.copyWith(status: SpecialityBookingStatus.paymentPending));
  }

  Future<void> _onConfirmPayment(
    ConfirmPayment event,
    Emitter<SpecialityBookingState> emit,
  ) async {
    final doctor = state.selectedDoctor;
    final date = state.selectedDate;
    final slot = state.selectedSlot;

    if (doctor == null || date == null || slot == null) {
      emit(
        state.copyWith(
          status: SpecialityBookingStatus.error,
          errorMessage: "Invalid booking details.",
        ),
      );
      return;
    }

    emit(state.copyWith(status: SpecialityBookingStatus.loading));

    try {
      await _bookAppointmentUseCase(
        patientId: event.patientId,
        patientName: event.patientName,
        doctorId: doctor.doctorInfo?.id ?? doctor.user.id,
        doctorName: doctor.user.fullName,
        specialty: event.specialtyName,
        date: date,
        slot: slot,
        fee: state.consultationFee,
        paymentMethod: event.paymentMethod,
      );

      event.appointmentsBloc.add(LoadAppointments());

      emit(state.copyWith(status: SpecialityBookingStatus.success));
    } catch (e) {
      emit(
        state.copyWith(
          status: SpecialityBookingStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  void _onResetBooking(
    ResetBooking event,
    Emitter<SpecialityBookingState> emit,
  ) {
    emit(const SpecialityBookingState());
  }
}
