import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/features/departments/marketing/domain/usecases/get_marketing_stats_usecase.dart';

// EVENTS
abstract class MarketingEvent extends Equatable {
  const MarketingEvent();
  @override
  List<Object?> get props => [];
}

class LoadMarketingStats extends MarketingEvent {}

// STATES
abstract class MarketingState extends Equatable {
  const MarketingState();
  @override
  List<Object?> get props => [];
}

class MarketingInitial extends MarketingState {}

class MarketingLoading extends MarketingState {}

class MarketingLoaded extends MarketingState {
  final Map<String, dynamic> stats;
  const MarketingLoaded(this.stats);
  @override
  List<Object?> get props => [stats];
}

class MarketingError extends MarketingState {
  final String message;
  const MarketingError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class MarketingBloc extends Bloc<MarketingEvent, MarketingState> {
  final GetMarketingStatsUseCase _useCase;

  MarketingBloc(this._useCase) : super(MarketingInitial()) {
    on<LoadMarketingStats>(_onLoadStats);
  }

  Future<void> _onLoadStats(
    LoadMarketingStats event,
    Emitter<MarketingState> emit,
  ) async {
    emit(MarketingLoading());
    final result = await _useCase(const NoParams());
    result.fold(
      (failure) => emit(MarketingError(failure.message)),
      (stats) => emit(MarketingLoaded(stats)),
    );
  }
}
