import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:medi_connect/shared/dashboard/domain/entities/appointment_entity.dart';
import 'package:medi_connect/shared/dashboard/domain/use_cases/admin_operations_usecases.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_appointments_bloc.dart';

// Events
abstract class DoctorAppointmentsEvent {}

class LoadDoctorAppointments extends DoctorAppointmentsEvent {}

class CreateDoctorAppointmentEvent extends DoctorAppointmentsEvent {
  final Map<String, dynamic> data;
  CreateDoctorAppointmentEvent(this.data);
}

class CancelDoctorAppointment extends DoctorAppointmentsEvent {
  final String id;
  CancelDoctorAppointment(this.id);
}

class CompleteDoctorAppointment extends DoctorAppointmentsEvent {
  final String id;
  CompleteDoctorAppointment(this.id);
}

class UpdateDoctorAppointmentVitals extends DoctorAppointmentsEvent {
  final String id;
  final Map<String, dynamic> vitals;
  UpdateDoctorAppointmentVitals(this.id, this.vitals);
}

// States
abstract class DoctorAppointmentsState {}

class DoctorAppointmentsInitial extends DoctorAppointmentsState {}

class DoctorAppointmentsLoading extends DoctorAppointmentsState {}

class DoctorAppointmentsLoaded extends DoctorAppointmentsState {
  final List<AppointmentEntity> appointments;
  DoctorAppointmentsLoaded(this.appointments);
}

class DoctorAppointmentsError extends DoctorAppointmentsState {
  final String message;
  DoctorAppointmentsError(this.message);
}

// Bloc
class DoctorAppointmentsBloc
    extends Bloc<DoctorAppointmentsEvent, DoctorAppointmentsState> {
  final GetAppointmentsUseCase _getAppointments;
  final CreateAppointmentUseCase _createAppointment;
  final UpdateAppointmentStatusUseCase _updateStatus;
  final UpdateAppointmentVitalsUseCase _updateVitals;

  DoctorAppointmentsBloc({
    required this._getAppointments,
    required this._createAppointment,
    required this._updateStatus,
    required this._updateVitals,
  }) : super(DoctorAppointmentsInitial()) {
    on<LoadDoctorAppointments>(_onLoadDoctorAppointments);
    on<CreateDoctorAppointmentEvent>(_onCreateDoctorAppointment);
    on<CancelDoctorAppointment>(_onCancelDoctorAppointment);
    on<CompleteDoctorAppointment>(_onCompleteDoctorAppointment);
    on<UpdateDoctorAppointmentVitals>(_onUpdateDoctorAppointmentVitals);
  }

  Future<void> _onLoadDoctorAppointments(
    LoadDoctorAppointments event,
    Emitter<DoctorAppointmentsState> emit,
  ) async {
    emit(DoctorAppointmentsLoading());
    final result = await _getAppointments();
    result.fold(
      (failure) => emit(DoctorAppointmentsError(failure.message)),
      (list) => emit(DoctorAppointmentsLoaded(list)),
    );
  }

  Future<void> _onCreateDoctorAppointment(
    CreateDoctorAppointmentEvent event,
    Emitter<DoctorAppointmentsState> emit,
  ) async {
    final result = await _createAppointment(event.data);
    result.fold((failure) => emit(DoctorAppointmentsError(failure.message)), (
      _,
    ) {
      add(LoadDoctorAppointments());
      try {
        GetIt.instance<AdminAppointmentsBloc>().add(LoadAppointments());
      } catch (e) {
        // Fallback if not registered yet
      }
    });
  }

  Future<void> _onCancelDoctorAppointment(
    CancelDoctorAppointment event,
    Emitter<DoctorAppointmentsState> emit,
  ) async {
    final result = await _updateStatus(event.id, 'Cancelled');
    result.fold((failure) => emit(DoctorAppointmentsError(failure.message)), (
      _,
    ) {
      add(LoadDoctorAppointments());
      try {
        GetIt.instance<AdminAppointmentsBloc>().add(LoadAppointments());
      } catch (e) {
        // Fallback
      }
    });
  }

  Future<void> _onCompleteDoctorAppointment(
    CompleteDoctorAppointment event,
    Emitter<DoctorAppointmentsState> emit,
  ) async {
    final result = await _updateStatus(event.id, 'Completed');
    result.fold((failure) => emit(DoctorAppointmentsError(failure.message)), (
      _,
    ) {
      add(LoadDoctorAppointments());
      try {
        GetIt.instance<AdminAppointmentsBloc>().add(LoadAppointments());
      } catch (e) {
        // Fallback
      }
    });
  }

  Future<void> _onUpdateDoctorAppointmentVitals(
    UpdateDoctorAppointmentVitals event,
    Emitter<DoctorAppointmentsState> emit,
  ) async {
    final result = await _updateVitals(event.id, event.vitals);
    result.fold((failure) => emit(DoctorAppointmentsError(failure.message)), (
      _,
    ) {
      add(LoadDoctorAppointments());
      try {
        GetIt.instance<AdminAppointmentsBloc>().add(LoadAppointments());
      } catch (e) {
        // Fallback
      }
    });
  }
}
