import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/features/departments/general_store/domain/usecases/get_general_store_stats_usecase.dart';

// EVENTS
abstract class GeneralStoreEvent extends Equatable {
  const GeneralStoreEvent();
  @override
  List<Object?> get props => [];
}

class LoadGeneralStoreStats extends GeneralStoreEvent {}

// STATES
abstract class GeneralStoreState extends Equatable {
  const GeneralStoreState();
  @override
  List<Object?> get props => [];
}

class GeneralStoreInitial extends GeneralStoreState {}

class GeneralStoreLoading extends GeneralStoreState {}

class GeneralStoreLoaded extends GeneralStoreState {
  final Map<String, dynamic> stats;
  const GeneralStoreLoaded(this.stats);
  @override
  List<Object?> get props => [stats];
}

class GeneralStoreError extends GeneralStoreState {
  final String message;
  const GeneralStoreError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class GeneralStoreBloc extends Bloc<GeneralStoreEvent, GeneralStoreState> {
  final GetGeneralStoreStatsUseCase _useCase;

  GeneralStoreBloc(this._useCase) : super(GeneralStoreInitial()) {
    on<LoadGeneralStoreStats>(_onLoadStats);
  }

  Future<void> _onLoadStats(
    LoadGeneralStoreStats event,
    Emitter<GeneralStoreState> emit,
  ) async {
    emit(GeneralStoreLoading());
    final result = await _useCase(const NoParams());
    result.fold(
      (failure) => emit(GeneralStoreError(failure.message)),
      (stats) => emit(GeneralStoreLoaded(stats)),
    );
  }
}
