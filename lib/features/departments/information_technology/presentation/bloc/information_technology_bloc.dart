import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/features/departments/information_technology/domain/usecases/get_information_technology_stats_usecase.dart';

// EVENTS
abstract class InformationTechnologyEvent extends Equatable {
  const InformationTechnologyEvent();
  @override
  List<Object?> get props => [];
}

class LoadInformationTechnologyStats extends InformationTechnologyEvent {}

// STATES
abstract class InformationTechnologyState extends Equatable {
  const InformationTechnologyState();
  @override
  List<Object?> get props => [];
}

class InformationTechnologyInitial extends InformationTechnologyState {}
class InformationTechnologyLoading extends InformationTechnologyState {}
class InformationTechnologyLoaded extends InformationTechnologyState {
  final Map<String, dynamic> stats;
  const InformationTechnologyLoaded(this.stats);
  @override
  List<Object?> get props => [stats];
}
class InformationTechnologyError extends InformationTechnologyState {
  final String message;
  const InformationTechnologyError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class InformationTechnologyBloc extends Bloc<InformationTechnologyEvent, InformationTechnologyState> {
  final GetInformationTechnologyStatsUseCase _useCase;

  InformationTechnologyBloc(this._useCase) : super(InformationTechnologyInitial()) {
    on<LoadInformationTechnologyStats>(_onLoadStats);
  }

  Future<void> _onLoadStats(LoadInformationTechnologyStats event, Emitter<InformationTechnologyState> emit) async {
    emit(InformationTechnologyLoading());
    final result = await _useCase(const NoParams());
    result.fold(
      (failure) => emit(InformationTechnologyError(failure.message)),
      (stats) => emit(InformationTechnologyLoaded(stats)),
    );
  }
}
