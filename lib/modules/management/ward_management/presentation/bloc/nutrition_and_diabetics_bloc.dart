import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/ward_management/domain/usecases/get_nutrition_and_diabetics_stats_usecase.dart';

// EVENTS
abstract class NutritionAndDiabeticsEvent extends Equatable {
  const NutritionAndDiabeticsEvent();
  @override
  List<Object?> get props => [];
}

class LoadNutritionAndDiabeticsStats extends NutritionAndDiabeticsEvent {}

// STATES
abstract class NutritionAndDiabeticsState extends Equatable {
  const NutritionAndDiabeticsState();
  @override
  List<Object?> get props => [];
}

class NutritionAndDiabeticsInitial extends NutritionAndDiabeticsState {}

class NutritionAndDiabeticsLoading extends NutritionAndDiabeticsState {}

class NutritionAndDiabeticsLoaded extends NutritionAndDiabeticsState {
  final Map<String, dynamic> stats;
  const NutritionAndDiabeticsLoaded(this.stats);
  @override
  List<Object?> get props => [stats];
}

class NutritionAndDiabeticsError extends NutritionAndDiabeticsState {
  final String message;
  const NutritionAndDiabeticsError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class NutritionAndDiabeticsBloc
    extends Bloc<NutritionAndDiabeticsEvent, NutritionAndDiabeticsState> {
  final GetNutritionAndDiabeticsStatsUseCase _useCase;

  NutritionAndDiabeticsBloc(this._useCase)
    : super(NutritionAndDiabeticsInitial()) {
    on<LoadNutritionAndDiabeticsStats>(_onLoadStats);
  }

  Future<void> _onLoadStats(
    LoadNutritionAndDiabeticsStats event,
    Emitter<NutritionAndDiabeticsState> emit,
  ) async {
    emit(NutritionAndDiabeticsLoading());
    final result = await _useCase(const NoParams());
    result.fold(
      (failure) => emit(NutritionAndDiabeticsError(failure.message)),
      (stats) => emit(NutritionAndDiabeticsLoaded(stats)),
    );
  }
}
