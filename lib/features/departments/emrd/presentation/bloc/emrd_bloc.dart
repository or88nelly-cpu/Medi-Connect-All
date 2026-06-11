import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/features/departments/emrd/domain/usecases/get_emrd_stats_usecase.dart';

// EVENTS
abstract class EmrdEvent extends Equatable {
  const EmrdEvent();
  @override
  List<Object?> get props => [];
}

class LoadEmrdStats extends EmrdEvent {}

// STATES
abstract class EmrdState extends Equatable {
  const EmrdState();
  @override
  List<Object?> get props => [];
}

class EmrdInitial extends EmrdState {}
class EmrdLoading extends EmrdState {}
class EmrdLoaded extends EmrdState {
  final Map<String, dynamic> stats;
  const EmrdLoaded(this.stats);
  @override
  List<Object?> get props => [stats];
}
class EmrdError extends EmrdState {
  final String message;
  const EmrdError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class EmrdBloc extends Bloc<EmrdEvent, EmrdState> {
  final GetEmrdStatsUseCase _useCase;

  EmrdBloc(this._useCase) : super(EmrdInitial()) {
    on<LoadEmrdStats>(_onLoadStats);
  }

  Future<void> _onLoadStats(LoadEmrdStats event, Emitter<EmrdState> emit) async {
    emit(EmrdLoading());
    final result = await _useCase(const NoParams());
    result.fold(
      (failure) => emit(EmrdError(failure.message)),
      (stats) => emit(EmrdLoaded(stats)),
    );
  }
}
