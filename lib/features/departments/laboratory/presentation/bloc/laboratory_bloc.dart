import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/features/departments/laboratory/domain/usecases/get_laboratory_stats_usecase.dart';

// EVENTS
abstract class LaboratoryEvent extends Equatable {
  const LaboratoryEvent();
  @override
  List<Object?> get props => [];
}

class LoadLaboratoryStats extends LaboratoryEvent {}

// STATES
abstract class LaboratoryState extends Equatable {
  const LaboratoryState();
  @override
  List<Object?> get props => [];
}

class LaboratoryInitial extends LaboratoryState {}
class LaboratoryLoading extends LaboratoryState {}
class LaboratoryLoaded extends LaboratoryState {
  final Map<String, dynamic> stats;
  const LaboratoryLoaded(this.stats);
  @override
  List<Object?> get props => [stats];
}
class LaboratoryError extends LaboratoryState {
  final String message;
  const LaboratoryError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class LaboratoryBloc extends Bloc<LaboratoryEvent, LaboratoryState> {
  final GetLaboratoryStatsUseCase _useCase;

  LaboratoryBloc(this._useCase) : super(LaboratoryInitial()) {
    on<LoadLaboratoryStats>(_onLoadStats);
  }

  Future<void> _onLoadStats(LoadLaboratoryStats event, Emitter<LaboratoryState> emit) async {
    emit(LaboratoryLoading());
    final result = await _useCase(const NoParams());
    result.fold(
      (failure) => emit(LaboratoryError(failure.message)),
      (stats) => emit(LaboratoryLoaded(stats)),
    );
  }
}
