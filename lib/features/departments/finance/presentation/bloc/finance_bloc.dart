import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/features/departments/finance/domain/usecases/get_finance_stats_usecase.dart';

// EVENTS
abstract class FinanceEvent extends Equatable {
  const FinanceEvent();
  @override
  List<Object?> get props => [];
}

class LoadFinanceStats extends FinanceEvent {}

// STATES
abstract class FinanceState extends Equatable {
  const FinanceState();
  @override
  List<Object?> get props => [];
}

class FinanceInitial extends FinanceState {}

class FinanceLoading extends FinanceState {}

class FinanceLoaded extends FinanceState {
  final Map<String, dynamic> stats;
  const FinanceLoaded(this.stats);
  @override
  List<Object?> get props => [stats];
}

class FinanceError extends FinanceState {
  final String message;
  const FinanceError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  final GetFinanceStatsUseCase _useCase;

  FinanceBloc(this._useCase) : super(FinanceInitial()) {
    on<LoadFinanceStats>(_onLoadStats);
  }

  Future<void> _onLoadStats(
    LoadFinanceStats event,
    Emitter<FinanceState> emit,
  ) async {
    emit(FinanceLoading());
    final result = await _useCase(const NoParams());
    result.fold(
      (failure) => emit(FinanceError(failure.message)),
      (stats) => emit(FinanceLoaded(stats)),
    );
  }
}
