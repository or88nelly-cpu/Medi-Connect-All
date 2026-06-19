import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/modules/departments/biomedical_engineering/domain/usecases/get_biomedical_engineering_stats_usecase.dart';

// EVENTS
abstract class BiomedicalEngineeringEvent extends Equatable {
  const BiomedicalEngineeringEvent();
  @override
  List<Object?> get props => [];
}

class LoadBiomedicalEngineeringStats extends BiomedicalEngineeringEvent {}

// STATES
abstract class BiomedicalEngineeringState extends Equatable {
  const BiomedicalEngineeringState();
  @override
  List<Object?> get props => [];
}

class BiomedicalEngineeringInitial extends BiomedicalEngineeringState {}

class BiomedicalEngineeringLoading extends BiomedicalEngineeringState {}

class BiomedicalEngineeringLoaded extends BiomedicalEngineeringState {
  final Map<String, dynamic> stats;
  const BiomedicalEngineeringLoaded(this.stats);
  @override
  List<Object?> get props => [stats];
}

class BiomedicalEngineeringError extends BiomedicalEngineeringState {
  final String message;
  const BiomedicalEngineeringError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class BiomedicalEngineeringBloc
    extends Bloc<BiomedicalEngineeringEvent, BiomedicalEngineeringState> {
  final GetBiomedicalEngineeringStatsUseCase _useCase;

  BiomedicalEngineeringBloc(this._useCase)
    : super(BiomedicalEngineeringInitial()) {
    on<LoadBiomedicalEngineeringStats>(_onLoadStats);
  }

  Future<void> _onLoadStats(
    LoadBiomedicalEngineeringStats event,
    Emitter<BiomedicalEngineeringState> emit,
  ) async {
    emit(BiomedicalEngineeringLoading());
    final result = await _useCase(const NoParams());
    result.fold(
      (failure) => emit(BiomedicalEngineeringError(failure.message)),
      (stats) => emit(BiomedicalEngineeringLoaded(stats)),
    );
  }
}
