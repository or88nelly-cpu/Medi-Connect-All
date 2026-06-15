import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/features/departments/dyalisis/domain/usecases/get_dyalisis_stats_usecase.dart';

// EVENTS
abstract class DyalisisEvent extends Equatable {
  const DyalisisEvent();
  @override
  List<Object?> get props => [];
}

class LoadDyalisisStats extends DyalisisEvent {}

// STATES
abstract class DyalisisState extends Equatable {
  const DyalisisState();
  @override
  List<Object?> get props => [];
}

class DyalisisInitial extends DyalisisState {}

class DyalisisLoading extends DyalisisState {}

class DyalisisLoaded extends DyalisisState {
  final Map<String, dynamic> stats;
  const DyalisisLoaded(this.stats);
  @override
  List<Object?> get props => [stats];
}

class DyalisisError extends DyalisisState {
  final String message;
  const DyalisisError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class DyalisisBloc extends Bloc<DyalisisEvent, DyalisisState> {
  final GetDyalisisStatsUseCase _useCase;

  DyalisisBloc(this._useCase) : super(DyalisisInitial()) {
    on<LoadDyalisisStats>(_onLoadStats);
  }

  Future<void> _onLoadStats(
    LoadDyalisisStats event,
    Emitter<DyalisisState> emit,
  ) async {
    emit(DyalisisLoading());
    final result = await _useCase(const NoParams());
    result.fold(
      (failure) => emit(DyalisisError(failure.message)),
      (stats) => emit(DyalisisLoaded(stats)),
    );
  }
}
