import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/ward_management/domain/usecases/get_ward_stats_usecase.dart';

// EVENTS
abstract class WardEvent extends Equatable {
  const WardEvent();
  @override
  List<Object?> get props => [];
}

class LoadWardStats extends WardEvent {}

// STATES
abstract class WardState extends Equatable {
  const WardState();
  @override
  List<Object?> get props => [];
}

class WardInitial extends WardState {}

class WardLoading extends WardState {}

class WardLoaded extends WardState {
  final Map<String, dynamic> stats;
  const WardLoaded(this.stats);
  @override
  List<Object?> get props => [stats];
}

class WardError extends WardState {
  final String message;
  const WardError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class WardBloc extends Bloc<WardEvent, WardState> {
  final GetWardStatsUseCase _useCase;

  WardBloc(this._useCase) : super(WardInitial()) {
    on<LoadWardStats>(_onLoadStats);
  }

  Future<void> _onLoadStats(
    LoadWardStats event,
    Emitter<WardState> emit,
  ) async {
    emit(WardLoading());
    final result = await _useCase(const NoParams());
    result.fold(
      (failure) => emit(WardError(failure.message)),
      (stats) => emit(WardLoaded(stats)),
    );
  }
}
