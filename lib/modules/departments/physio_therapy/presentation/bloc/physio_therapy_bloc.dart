import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/modules/departments/physio_therapy/domain/usecases/get_physio_therapy_stats_usecase.dart';

// EVENTS
abstract class PhysioTherapyEvent extends Equatable {
  const PhysioTherapyEvent();
  @override
  List<Object?> get props => [];
}

class LoadPhysioTherapyStats extends PhysioTherapyEvent {}

// STATES
abstract class PhysioTherapyState extends Equatable {
  const PhysioTherapyState();
  @override
  List<Object?> get props => [];
}

class PhysioTherapyInitial extends PhysioTherapyState {}

class PhysioTherapyLoading extends PhysioTherapyState {}

class PhysioTherapyLoaded extends PhysioTherapyState {
  final Map<String, dynamic> stats;
  const PhysioTherapyLoaded(this.stats);
  @override
  List<Object?> get props => [stats];
}

class PhysioTherapyError extends PhysioTherapyState {
  final String message;
  const PhysioTherapyError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class PhysioTherapyBloc extends Bloc<PhysioTherapyEvent, PhysioTherapyState> {
  final GetPhysioTherapyStatsUseCase _useCase;

  PhysioTherapyBloc(this._useCase) : super(PhysioTherapyInitial()) {
    on<LoadPhysioTherapyStats>(_onLoadStats);
  }

  Future<void> _onLoadStats(
    LoadPhysioTherapyStats event,
    Emitter<PhysioTherapyState> emit,
  ) async {
    emit(PhysioTherapyLoading());
    final result = await _useCase(const NoParams());
    result.fold(
      (failure) => emit(PhysioTherapyError(failure.message)),
      (stats) => emit(PhysioTherapyLoaded(stats)),
    );
  }
}
