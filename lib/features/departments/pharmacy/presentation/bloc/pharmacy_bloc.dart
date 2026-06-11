import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/features/departments/pharmacy/domain/usecases/get_pharmacy_stats_usecase.dart';

// EVENTS
abstract class PharmacyEvent extends Equatable {
  const PharmacyEvent();
  @override
  List<Object?> get props => [];
}

class LoadPharmacyStats extends PharmacyEvent {}

// STATES
abstract class PharmacyState extends Equatable {
  const PharmacyState();
  @override
  List<Object?> get props => [];
}

class PharmacyInitial extends PharmacyState {}
class PharmacyLoading extends PharmacyState {}
class PharmacyLoaded extends PharmacyState {
  final Map<String, dynamic> stats;
  const PharmacyLoaded(this.stats);
  @override
  List<Object?> get props => [stats];
}
class PharmacyError extends PharmacyState {
  final String message;
  const PharmacyError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class PharmacyBloc extends Bloc<PharmacyEvent, PharmacyState> {
  final GetPharmacyStatsUseCase _useCase;

  PharmacyBloc(this._useCase) : super(PharmacyInitial()) {
    on<LoadPharmacyStats>(_onLoadStats);
  }

  Future<void> _onLoadStats(LoadPharmacyStats event, Emitter<PharmacyState> emit) async {
    emit(PharmacyLoading());
    final result = await _useCase(const NoParams());
    result.fold(
      (failure) => emit(PharmacyError(failure.message)),
      (stats) => emit(PharmacyLoaded(stats)),
    );
  }
}
