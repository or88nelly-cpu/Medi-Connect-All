import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/customer_care/domain/usecases/get_customer_care_stats_usecase.dart';

// EVENTS
abstract class CustomerCareEvent extends Equatable {
  const CustomerCareEvent();
  @override
  List<Object?> get props => [];
}

class LoadCustomerCareStats extends CustomerCareEvent {}

// STATES
abstract class CustomerCareState extends Equatable {
  const CustomerCareState();
  @override
  List<Object?> get props => [];
}

class CustomerCareInitial extends CustomerCareState {}

class CustomerCareLoading extends CustomerCareState {}

class CustomerCareLoaded extends CustomerCareState {
  final Map<String, dynamic> stats;
  const CustomerCareLoaded(this.stats);
  @override
  List<Object?> get props => [stats];
}

class CustomerCareError extends CustomerCareState {
  final String message;
  const CustomerCareError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class CustomerCareBloc extends Bloc<CustomerCareEvent, CustomerCareState> {
  final GetCustomerCareStatsUseCase _useCase;

  CustomerCareBloc(this._useCase) : super(CustomerCareInitial()) {
    on<LoadCustomerCareStats>(_onLoadStats);
  }

  Future<void> _onLoadStats(
    LoadCustomerCareStats event,
    Emitter<CustomerCareState> emit,
  ) async {
    emit(CustomerCareLoading());
    final result = await _useCase(const NoParams());
    result.fold(
      (failure) => emit(CustomerCareError(failure.message)),
      (stats) => emit(CustomerCareLoaded(stats)),
    );
  }
}
