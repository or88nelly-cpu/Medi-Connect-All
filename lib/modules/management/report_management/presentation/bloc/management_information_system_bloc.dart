import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/report_management/domain/usecases/get_management_information_system_stats_usecase.dart';

// EVENTS
abstract class ManagementInformationSystemEvent extends Equatable {
  const ManagementInformationSystemEvent();
  @override
  List<Object?> get props => [];
}

class LoadManagementInformationSystemStats
    extends ManagementInformationSystemEvent {}

// STATES
abstract class ManagementInformationSystemState extends Equatable {
  const ManagementInformationSystemState();
  @override
  List<Object?> get props => [];
}

class ManagementInformationSystemInitial
    extends ManagementInformationSystemState {}

class ManagementInformationSystemLoading
    extends ManagementInformationSystemState {}

class ManagementInformationSystemLoaded
    extends ManagementInformationSystemState {
  final Map<String, dynamic> stats;
  const ManagementInformationSystemLoaded(this.stats);
  @override
  List<Object?> get props => [stats];
}

class ManagementInformationSystemError
    extends ManagementInformationSystemState {
  final String message;
  const ManagementInformationSystemError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class ManagementInformationSystemBloc
    extends
        Bloc<
          ManagementInformationSystemEvent,
          ManagementInformationSystemState
        > {
  final GetManagementInformationSystemStatsUseCase _useCase;

  ManagementInformationSystemBloc(this._useCase)
    : super(ManagementInformationSystemInitial()) {
    on<LoadManagementInformationSystemStats>(_onLoadStats);
  }

  Future<void> _onLoadStats(
    LoadManagementInformationSystemStats event,
    Emitter<ManagementInformationSystemState> emit,
  ) async {
    emit(ManagementInformationSystemLoading());
    final result = await _useCase(const NoParams());
    result.fold(
      (failure) => emit(ManagementInformationSystemError(failure.message)),
      (stats) => emit(ManagementInformationSystemLoaded(stats)),
    );
  }
}
