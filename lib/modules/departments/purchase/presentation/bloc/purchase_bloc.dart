import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/modules/departments/purchase/domain/usecases/get_purchase_stats_usecase.dart';

// EVENTS
abstract class PurchaseEvent extends Equatable {
  const PurchaseEvent();
  @override
  List<Object?> get props => [];
}

class LoadPurchaseStats extends PurchaseEvent {}

// STATES
abstract class PurchaseState extends Equatable {
  const PurchaseState();
  @override
  List<Object?> get props => [];
}

class PurchaseInitial extends PurchaseState {}

class PurchaseLoading extends PurchaseState {}

class PurchaseLoaded extends PurchaseState {
  final Map<String, dynamic> stats;
  const PurchaseLoaded(this.stats);
  @override
  List<Object?> get props => [stats];
}

class PurchaseError extends PurchaseState {
  final String message;
  const PurchaseError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class PurchaseBloc extends Bloc<PurchaseEvent, PurchaseState> {
  final GetPurchaseStatsUseCase _useCase;

  PurchaseBloc(this._useCase) : super(PurchaseInitial()) {
    on<LoadPurchaseStats>(_onLoadStats);
  }

  Future<void> _onLoadStats(
    LoadPurchaseStats event,
    Emitter<PurchaseState> emit,
  ) async {
    emit(PurchaseLoading());
    final result = await _useCase(const NoParams());
    result.fold(
      (failure) => emit(PurchaseError(failure.message)),
      (stats) => emit(PurchaseLoaded(stats)),
    );
  }
}
