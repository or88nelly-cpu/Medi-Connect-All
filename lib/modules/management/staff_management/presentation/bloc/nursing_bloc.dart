import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/staff_management/domain/usecases/get_nursing_stats_usecase.dart';

// EVENTS
abstract class NursingEvent extends Equatable {
  const NursingEvent();
  @override
  List<Object?> get props => [];
}

class LoadNursingStats extends NursingEvent {}

// STATES
abstract class NursingState extends Equatable {
  const NursingState();
  @override
  List<Object?> get props => [];
}

class NursingInitial extends NursingState {}

class NursingLoading extends NursingState {}

class NursingLoaded extends NursingState {
  final Map<String, dynamic> stats;
  const NursingLoaded(this.stats);
  @override
  List<Object?> get props => [stats];
}

class NursingError extends NursingState {
  final String message;
  const NursingError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class NursingBloc extends Bloc<NursingEvent, NursingState> {
  final GetNursingStatsUseCase _useCase;

  NursingBloc(this._useCase) : super(NursingInitial()) {
    on<LoadNursingStats>(_onLoadStats);
  }

  Future<void> _onLoadStats(
    LoadNursingStats event,
    Emitter<NursingState> emit,
  ) async {
    emit(NursingLoading());
    final result = await _useCase(const NoParams());
    result.fold(
      (failure) => emit(NursingError(failure.message)),
      (stats) => emit(NursingLoaded(stats)),
    );
  }
}
