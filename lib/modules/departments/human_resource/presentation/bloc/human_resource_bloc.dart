import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/modules/departments/human_resource/domain/usecases/get_human_resource_stats_usecase.dart';

// EVENTS
abstract class HumanResourceEvent extends Equatable {
  const HumanResourceEvent();
  @override
  List<Object?> get props => [];
}

class LoadHumanResourceStats extends HumanResourceEvent {}

// STATES
abstract class HumanResourceState extends Equatable {
  const HumanResourceState();
  @override
  List<Object?> get props => [];
}

class HumanResourceInitial extends HumanResourceState {}

class HumanResourceLoading extends HumanResourceState {}

class HumanResourceLoaded extends HumanResourceState {
  final Map<String, dynamic> stats;
  const HumanResourceLoaded(this.stats);
  @override
  List<Object?> get props => [stats];
}

class HumanResourceError extends HumanResourceState {
  final String message;
  const HumanResourceError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class HumanResourceBloc extends Bloc<HumanResourceEvent, HumanResourceState> {
  final GetHumanResourceStatsUseCase _useCase;

  HumanResourceBloc(this._useCase) : super(HumanResourceInitial()) {
    on<LoadHumanResourceStats>(_onLoadStats);
  }

  Future<void> _onLoadStats(
    LoadHumanResourceStats event,
    Emitter<HumanResourceState> emit,
  ) async {
    emit(HumanResourceLoading());
    final result = await _useCase(const NoParams());
    result.fold(
      (failure) => emit(HumanResourceError(failure.message)),
      (stats) => emit(HumanResourceLoaded(stats)),
    );
  }
}
