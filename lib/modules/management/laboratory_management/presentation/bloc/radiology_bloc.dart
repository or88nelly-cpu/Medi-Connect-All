import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/laboratory_management/domain/usecases/get_radiology_stats_usecase.dart';

// EVENTS
abstract class RadiologyEvent extends Equatable {
  const RadiologyEvent();
  @override
  List<Object?> get props => [];
}

class LoadRadiologyStats extends RadiologyEvent {}

// STATES
abstract class RadiologyState extends Equatable {
  const RadiologyState();
  @override
  List<Object?> get props => [];
}

class RadiologyInitial extends RadiologyState {}

class RadiologyLoading extends RadiologyState {}

class RadiologyLoaded extends RadiologyState {
  final Map<String, dynamic> stats;
  const RadiologyLoaded(this.stats);
  @override
  List<Object?> get props => [stats];
}

class RadiologyError extends RadiologyState {
  final String message;
  const RadiologyError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class RadiologyBloc extends Bloc<RadiologyEvent, RadiologyState> {
  final GetRadiologyStatsUseCase _useCase;

  RadiologyBloc(this._useCase) : super(RadiologyInitial()) {
    on<LoadRadiologyStats>(_onLoadStats);
  }

  Future<void> _onLoadStats(
    LoadRadiologyStats event,
    Emitter<RadiologyState> emit,
  ) async {
    emit(RadiologyLoading());
    final result = await _useCase(const NoParams());
    result.fold(
      (failure) => emit(RadiologyError(failure.message)),
      (stats) => emit(RadiologyLoaded(stats)),
    );
  }
}
