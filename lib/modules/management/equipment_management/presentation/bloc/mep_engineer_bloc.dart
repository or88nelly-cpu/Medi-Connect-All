import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/equipment_management/domain/usecases/get_mep_engineer_stats_usecase.dart';

// EVENTS
abstract class MepEngineerEvent extends Equatable {
  const MepEngineerEvent();
  @override
  List<Object?> get props => [];
}

class LoadMepEngineerStats extends MepEngineerEvent {}

// STATES
abstract class MepEngineerState extends Equatable {
  const MepEngineerState();
  @override
  List<Object?> get props => [];
}

class MepEngineerInitial extends MepEngineerState {}

class MepEngineerLoading extends MepEngineerState {}

class MepEngineerLoaded extends MepEngineerState {
  final Map<String, dynamic> stats;
  const MepEngineerLoaded(this.stats);
  @override
  List<Object?> get props => [stats];
}

class MepEngineerError extends MepEngineerState {
  final String message;
  const MepEngineerError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class MepEngineerBloc extends Bloc<MepEngineerEvent, MepEngineerState> {
  final GetMepEngineerStatsUseCase _useCase;

  MepEngineerBloc(this._useCase) : super(MepEngineerInitial()) {
    on<LoadMepEngineerStats>(_onLoadStats);
  }

  Future<void> _onLoadStats(
    LoadMepEngineerStats event,
    Emitter<MepEngineerState> emit,
  ) async {
    emit(MepEngineerLoading());
    final result = await _useCase(const NoParams());
    result.fold(
      (failure) => emit(MepEngineerError(failure.message)),
      (stats) => emit(MepEngineerLoaded(stats)),
    );
  }
}
