import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/settings_management/domain/usecases/get_fire_safety_stats_usecase.dart';

// EVENTS
abstract class FireSafetyEvent extends Equatable {
  const FireSafetyEvent();
  @override
  List<Object?> get props => [];
}

class LoadFireSafetyStats extends FireSafetyEvent {}

// STATES
abstract class FireSafetyState extends Equatable {
  const FireSafetyState();
  @override
  List<Object?> get props => [];
}

class FireSafetyInitial extends FireSafetyState {}

class FireSafetyLoading extends FireSafetyState {}

class FireSafetyLoaded extends FireSafetyState {
  final Map<String, dynamic> stats;
  const FireSafetyLoaded(this.stats);
  @override
  List<Object?> get props => [stats];
}

class FireSafetyError extends FireSafetyState {
  final String message;
  const FireSafetyError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class FireSafetyBloc extends Bloc<FireSafetyEvent, FireSafetyState> {
  final GetFireSafetyStatsUseCase _useCase;

  FireSafetyBloc(this._useCase) : super(FireSafetyInitial()) {
    on<LoadFireSafetyStats>(_onLoadStats);
  }

  Future<void> _onLoadStats(
    LoadFireSafetyStats event,
    Emitter<FireSafetyState> emit,
  ) async {
    emit(FireSafetyLoading());
    final result = await _useCase(const NoParams());
    result.fold(
      (failure) => emit(FireSafetyError(failure.message)),
      (stats) => emit(FireSafetyLoaded(stats)),
    );
  }
}
