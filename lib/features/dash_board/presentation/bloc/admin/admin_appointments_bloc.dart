import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:medi_connect/features/dash_board/domain/entities/appointment_entity.dart';
import 'package:medi_connect/features/dash_board/domain/use_cases/admin_operations_usecases.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/doctor/doctor_appointments_bloc.dart';

// Events
abstract class AdminAppointmentsEvent {}

class LoadAppointments extends AdminAppointmentsEvent {}

class CreateAppointmentEvent extends AdminAppointmentsEvent {
  final Map<String, dynamic> data;
  CreateAppointmentEvent(this.data);
}

class CancelAppointment extends AdminAppointmentsEvent {
  final String id;
  CancelAppointment(this.id);
}

class CompleteAppointment extends AdminAppointmentsEvent {
  final String id;
  CompleteAppointment(this.id);
}

class UpdateAppointmentVitals extends AdminAppointmentsEvent {
  final String id;
  final Map<String, dynamic> vitals;
  UpdateAppointmentVitals(this.id, this.vitals);
}

// States
abstract class AdminAppointmentsState {}

class AdminAppointmentsInitial extends AdminAppointmentsState {}

class AdminAppointmentsLoading extends AdminAppointmentsState {}

class AdminAppointmentsLoaded extends AdminAppointmentsState {
  final List<AppointmentEntity> appointments;
  AdminAppointmentsLoaded(this.appointments);
}

class AdminAppointmentsError extends AdminAppointmentsState {
  final String message;
  AdminAppointmentsError(this.message);
}

// Bloc
class AdminAppointmentsBloc
    extends Bloc<AdminAppointmentsEvent, AdminAppointmentsState> {
  final GetAppointmentsUseCase _getAppointments;
  final CreateAppointmentUseCase _createAppointment;
  final UpdateAppointmentStatusUseCase _updateStatus;
  final UpdateAppointmentVitalsUseCase _updateVitals;

  AdminAppointmentsBloc({
    required this._getAppointments,
    required this._createAppointment,
    required this._updateStatus,
    required this._updateVitals,
  }) : super(AdminAppointmentsInitial()) {
    on<LoadAppointments>(_onLoadAppointments);
    on<CreateAppointmentEvent>(_onCreateAppointment);
    on<CancelAppointment>(_onCancelAppointment);
    on<CompleteAppointment>(_onCompleteAppointment);
    on<UpdateAppointmentVitals>(_onUpdateAppointmentVitals);
  }

  Future<void> _onLoadAppointments(
    LoadAppointments event,
    Emitter<AdminAppointmentsState> emit,
  ) async {
    emit(AdminAppointmentsLoading());
    final result = await _getAppointments();
    result.fold(
      (failure) => emit(AdminAppointmentsError(failure.message)),
      (list) => emit(AdminAppointmentsLoaded(list)),
    );
  }

  Future<void> _onCreateAppointment(
    CreateAppointmentEvent event,
    Emitter<AdminAppointmentsState> emit,
  ) async {
    final result = await _createAppointment(event.data);
    result.fold((failure) => emit(AdminAppointmentsError(failure.message)), (
      _,
    ) {
      add(LoadAppointments());
      try {
        GetIt.instance<DoctorAppointmentsBloc>().add(LoadDoctorAppointments());
      } catch (e) {
        // Fallback if not registered yet
      }
    });
  }

  Future<void> _onCancelAppointment(
    CancelAppointment event,
    Emitter<AdminAppointmentsState> emit,
  ) async {
    final result = await _updateStatus(event.id, 'Cancelled');
    result.fold((failure) => emit(AdminAppointmentsError(failure.message)), (
      _,
    ) {
      add(LoadAppointments());
      try {
        GetIt.instance<DoctorAppointmentsBloc>().add(LoadDoctorAppointments());
      } catch (e) {
        // Fallback
      }
    });
  }

  Future<void> _onCompleteAppointment(
    CompleteAppointment event,
    Emitter<AdminAppointmentsState> emit,
  ) async {
    final result = await _updateStatus(event.id, 'Completed');
    result.fold((failure) => emit(AdminAppointmentsError(failure.message)), (
      _,
    ) {
      add(LoadAppointments());
      try {
        GetIt.instance<DoctorAppointmentsBloc>().add(LoadDoctorAppointments());
      } catch (e) {
        // Fallback
      }
    });
  }

  Future<void> _onUpdateAppointmentVitals(
    UpdateAppointmentVitals event,
    Emitter<AdminAppointmentsState> emit,
  ) async {
    final result = await _updateVitals(event.id, event.vitals);
    result.fold((failure) => emit(AdminAppointmentsError(failure.message)), (
      _,
    ) {
      add(LoadAppointments());
      try {
        GetIt.instance<DoctorAppointmentsBloc>().add(LoadDoctorAppointments());
      } catch (e) {
        // Fallback
      }
    });
  }
}
