import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/room_management/domain/usecases/get_operation_theatre_stats_usecase.dart';

// EVENTS
abstract class OperationTheatreEvent extends Equatable {
  const OperationTheatreEvent();
  @override
  List<Object?> get props => [];
}

class LoadOperationTheatreStats extends OperationTheatreEvent {}

// STATES
abstract class OperationTheatreState extends Equatable {
  const OperationTheatreState();
  @override
  List<Object?> get props => [];
}

class OperationTheatreInitial extends OperationTheatreState {}

class OperationTheatreLoading extends OperationTheatreState {}

class OperationTheatreLoaded extends OperationTheatreState {
  final Map<String, dynamic> stats;
  const OperationTheatreLoaded(this.stats);
  @override
  List<Object?> get props => [stats];
}

class OperationTheatreError extends OperationTheatreState {
  final String message;
  const OperationTheatreError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class OperationTheatreBloc
    extends Bloc<OperationTheatreEvent, OperationTheatreState> {
  final GetOperationTheatreStatsUseCase _useCase;

  OperationTheatreBloc(this._useCase) : super(OperationTheatreInitial()) {
    on<LoadOperationTheatreStats>(_onLoadStats);
  }

  Future<void> _onLoadStats(
    LoadOperationTheatreStats event,
    Emitter<OperationTheatreState> emit,
  ) async {
    emit(OperationTheatreLoading());
    final result = await _useCase(const NoParams());
    result.fold(
      (failure) => emit(OperationTheatreError(failure.message)),
      (stats) => emit(OperationTheatreLoaded(stats)),
    );
  }
}
