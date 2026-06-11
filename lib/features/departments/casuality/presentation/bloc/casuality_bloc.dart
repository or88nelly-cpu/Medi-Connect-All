import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/features/departments/casuality/domain/usecases/get_casuality_stats_usecase.dart';

// EVENTS
abstract class CasualityEvent extends Equatable {
  const CasualityEvent();
  @override
  List<Object?> get props => [];
}

class LoadCasualityStats extends CasualityEvent {}

// STATES
abstract class CasualityState extends Equatable {
  const CasualityState();
  @override
  List<Object?> get props => [];
}

class CasualityInitial extends CasualityState {}
class CasualityLoading extends CasualityState {}
class CasualityLoaded extends CasualityState {
  final Map<String, dynamic> stats;
  const CasualityLoaded(this.stats);
  @override
  List<Object?> get props => [stats];
}
class CasualityError extends CasualityState {
  final String message;
  const CasualityError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class CasualityBloc extends Bloc<CasualityEvent, CasualityState> {
  final GetCasualityStatsUseCase _useCase;

  CasualityBloc(this._useCase) : super(CasualityInitial()) {
    on<LoadCasualityStats>(_onLoadStats);
  }

  Future<void> _onLoadStats(LoadCasualityStats event, Emitter<CasualityState> emit) async {
    emit(CasualityLoading());
    final result = await _useCase(const NoParams());
    result.fold(
      (failure) => emit(CasualityError(failure.message)),
      (stats) => emit(CasualityLoaded(stats)),
    );
  }
}
