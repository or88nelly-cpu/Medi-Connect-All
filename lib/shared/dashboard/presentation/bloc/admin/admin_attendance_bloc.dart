import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/shared/dashboard/domain/entities/attendance_entity.dart';
import 'package:medi_connect/shared/dashboard/domain/use_cases/admin_operations_usecases.dart';

// Events
abstract class AdminAttendanceEvent {}

class LoadStaffAttendance extends AdminAttendanceEvent {
  final DateTime? date;
  LoadStaffAttendance({this.date});
}

class UpdateAttendanceStatus extends AdminAttendanceEvent {
  final String id;
  final String status;
  final DateTime? date;
  UpdateAttendanceStatus(this.id, this.status, {this.date});
}

// States
abstract class AdminAttendanceState {}

class AdminAttendanceInitial extends AdminAttendanceState {}

class AdminAttendanceLoading extends AdminAttendanceState {}

class AdminAttendanceLoaded extends AdminAttendanceState {
  final List<AttendanceEntity> logs;
  final DateTime date;
  AdminAttendanceLoaded(this.logs, this.date);
}

class AdminAttendanceError extends AdminAttendanceState {
  final String message;
  AdminAttendanceError(this.message);
}

// Bloc
class AdminAttendanceBloc
    extends Bloc<AdminAttendanceEvent, AdminAttendanceState> {
  final GetStaffAttendanceUseCase _getAttendance;
  final UpdateAttendanceStatusUseCase _updateStatus;

  AdminAttendanceBloc({
    required this._getAttendance,
    required this._updateStatus,
  }) : super(AdminAttendanceInitial()) {
    on<LoadStaffAttendance>(_onLoadStaffAttendance);
    on<UpdateAttendanceStatus>(_onUpdateAttendanceStatus);
  }

  Future<void> _onLoadStaffAttendance(
    LoadStaffAttendance event,
    Emitter<AdminAttendanceState> emit,
  ) async {
    emit(AdminAttendanceLoading());
    final targetDate = event.date ?? DateTime.now();
    final result = await _getAttendance(date: targetDate);
    result.fold(
      (failure) => emit(AdminAttendanceError(failure.message)),
      (logs) => emit(AdminAttendanceLoaded(logs, targetDate)),
    );
  }

  Future<void> _onUpdateAttendanceStatus(
    UpdateAttendanceStatus event,
    Emitter<AdminAttendanceState> emit,
  ) async {
    final result = await _updateStatus(event.id, event.status);
    result.fold(
      (failure) => emit(AdminAttendanceError(failure.message)),
      (_) => add(LoadStaffAttendance(date: event.date)),
    );
  }
}
