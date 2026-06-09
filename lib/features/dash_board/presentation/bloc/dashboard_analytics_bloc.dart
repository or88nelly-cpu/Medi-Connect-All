import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/features/dash_board/domain/use_cases/admin_analytics_usecases.dart';


// EVENTS
abstract class DashboardAnalyticsEvent extends Equatable {
  const DashboardAnalyticsEvent();
  @override
  List<Object?> get props => [];
}

class LoadDashboardStats extends DashboardAnalyticsEvent {}

// STATES
abstract class DashboardAnalyticsState extends Equatable {
  const DashboardAnalyticsState();
  @override
  List<Object?> get props => [];
}

class DashboardAnalyticsInitial extends DashboardAnalyticsState {}

class DashboardAnalyticsLoading extends DashboardAnalyticsState {}

class DashboardAnalyticsLoaded extends DashboardAnalyticsState {
  final Map<String, dynamic> stats;
  const DashboardAnalyticsLoaded(this.stats);
  @override
  List<Object?> get props => [stats];
}

class DashboardAnalyticsError extends DashboardAnalyticsState {
  final String message;
  const DashboardAnalyticsError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class DashboardAnalyticsBloc extends Bloc<DashboardAnalyticsEvent, DashboardAnalyticsState> {
  final GetDashboardStatsUseCase _getDashboardStatsUseCase;

  DashboardAnalyticsBloc({
    required GetDashboardStatsUseCase getDashboardStatsUseCase,
  })  : _getDashboardStatsUseCase = getDashboardStatsUseCase,
        super(DashboardAnalyticsInitial()) {
    on<LoadDashboardStats>(_onLoadDashboardStats);
  }

  Future<void> _onLoadDashboardStats(
    LoadDashboardStats event,
    Emitter<DashboardAnalyticsState> emit,
  ) async {
    emit(DashboardAnalyticsLoading());
    final result = await _getDashboardStatsUseCase(const NoParams());
    result.fold(
      (failure) => emit(DashboardAnalyticsError(failure.message)),
      (stats) => emit(DashboardAnalyticsLoaded(stats)),
    );
  }
}
