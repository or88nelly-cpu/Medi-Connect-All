import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/features/dash_board/domain/entities/appointment_entity.dart';
import 'package:medi_connect/features/dash_board/domain/use_cases/admin_operations_usecases.dart';

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

  AdminAppointmentsBloc({
    required GetAppointmentsUseCase getAppointments,
    required CreateAppointmentUseCase createAppointment,
    required UpdateAppointmentStatusUseCase updateStatus,
  })  : _getAppointments = getAppointments,
        _createAppointment = createAppointment,
        _updateStatus = updateStatus,
        super(AdminAppointmentsInitial()) {
    on<LoadAppointments>(_onLoadAppointments);
    on<CreateAppointmentEvent>(_onCreateAppointment);
    on<CancelAppointment>(_onCancelAppointment);
    on<CompleteAppointment>(_onCompleteAppointment);
  }

  Future<void> _onLoadAppointments(
      LoadAppointments event, Emitter<AdminAppointmentsState> emit) async {
    emit(AdminAppointmentsLoading());
    final result = await _getAppointments();
    result.fold(
      (failure) => emit(AdminAppointmentsError(failure.message)),
      (list) => emit(AdminAppointmentsLoaded(list)),
    );
  }

  Future<void> _onCreateAppointment(
      CreateAppointmentEvent event, Emitter<AdminAppointmentsState> emit) async {
    final result = await _createAppointment(event.data);
    result.fold(
      (failure) => emit(AdminAppointmentsError(failure.message)),
      (_) => add(LoadAppointments()),
    );
  }

  Future<void> _onCancelAppointment(
      CancelAppointment event, Emitter<AdminAppointmentsState> emit) async {
    final result = await _updateStatus(event.id, 'Cancelled');
    result.fold(
      (failure) => emit(AdminAppointmentsError(failure.message)),
      (_) => add(LoadAppointments()),
    );
  }

  Future<void> _onCompleteAppointment(
      CompleteAppointment event, Emitter<AdminAppointmentsState> emit) async {
    final result = await _updateStatus(event.id, 'Completed');
    result.fold(
      (failure) => emit(AdminAppointmentsError(failure.message)),
      (_) => add(LoadAppointments()),
    );
  }
}
