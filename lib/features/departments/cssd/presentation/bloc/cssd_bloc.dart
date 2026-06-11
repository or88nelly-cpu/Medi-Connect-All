import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/features/departments/cssd/domain/usecases/get_cssd_stats_usecase.dart';

// EVENTS
abstract class CssdEvent extends Equatable {
  const CssdEvent();
  @override
  List<Object?> get props => [];
}

class LoadCssdStats extends CssdEvent {}

// STATES
abstract class CssdState extends Equatable {
  const CssdState();
  @override
  List<Object?> get props => [];
}

class CssdInitial extends CssdState {}
class CssdLoading extends CssdState {}
class CssdLoaded extends CssdState {
  final Map<String, dynamic> stats;
  const CssdLoaded(this.stats);
  @override
  List<Object?> get props => [stats];
}
class CssdError extends CssdState {
  final String message;
  const CssdError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class CssdBloc extends Bloc<CssdEvent, CssdState> {
  final GetCssdStatsUseCase _useCase;

  CssdBloc(this._useCase) : super(CssdInitial()) {
    on<LoadCssdStats>(_onLoadStats);
  }

  Future<void> _onLoadStats(LoadCssdStats event, Emitter<CssdState> emit) async {
    emit(CssdLoading());
    final result = await _useCase(const NoParams());
    result.fold(
      (failure) => emit(CssdError(failure.message)),
      (stats) => emit(CssdLoaded(stats)),
    );
  }
}
