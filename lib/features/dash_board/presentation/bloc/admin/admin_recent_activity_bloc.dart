import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/features/dash_board/domain/entities/activity_log_entity.dart';
import 'package:medi_connect/features/dash_board/domain/use_cases/admin_operations_usecases.dart';

// Events
abstract class AdminRecentActivityEvent {}

class LoadRecentActivity extends AdminRecentActivityEvent {}

// States
abstract class AdminRecentActivityState {}

class AdminRecentActivityInitial extends AdminRecentActivityState {}

class AdminRecentActivityLoading extends AdminRecentActivityState {}

class AdminRecentActivityLoaded extends AdminRecentActivityState {
  final List<ActivityLogEntity> logs;
  AdminRecentActivityLoaded(this.logs);
}

class AdminRecentActivityError extends AdminRecentActivityState {
  final String message;
  AdminRecentActivityError(this.message);
}

// Bloc
class AdminRecentActivityBloc
    extends Bloc<AdminRecentActivityEvent, AdminRecentActivityState> {
  final GetActivityLogsUseCase _getActivityLogs;

  AdminRecentActivityBloc({required this._getActivityLogs})
    : super(AdminRecentActivityInitial()) {
    on<LoadRecentActivity>(_onLoadRecentActivity);
  }

  Future<void> _onLoadRecentActivity(
    LoadRecentActivity event,
    Emitter<AdminRecentActivityState> emit,
  ) async {
    emit(AdminRecentActivityLoading());
    final result = await _getActivityLogs();
    result.fold(
      (failure) => emit(AdminRecentActivityError(failure.message)),
      (logs) => emit(AdminRecentActivityLoaded(logs)),
    );
  }
}
