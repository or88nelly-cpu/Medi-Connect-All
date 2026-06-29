import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/ward_management/domain/usecases/get_icu_stats_usecase.dart';

// EVENTS
abstract class IcuEvent extends Equatable {
  const IcuEvent();
  @override
  List<Object?> get props => [];
}

class LoadIcuStats extends IcuEvent {}

// STATES
abstract class IcuState extends Equatable {
  const IcuState();
  @override
  List<Object?> get props => [];
}

class IcuInitial extends IcuState {}

class IcuLoading extends IcuState {}

class IcuLoaded extends IcuState {
  final Map<String, dynamic> stats;
  const IcuLoaded(this.stats);
  @override
  List<Object?> get props => [stats];
}

class IcuError extends IcuState {
  final String message;
  const IcuError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class IcuBloc extends Bloc<IcuEvent, IcuState> {
  final GetIcuStatsUseCase _useCase;

  IcuBloc(this._useCase) : super(IcuInitial()) {
    on<LoadIcuStats>(_onLoadStats);
  }

  Future<void> _onLoadStats(LoadIcuStats event, Emitter<IcuState> emit) async {
    emit(IcuLoading());
    final result = await _useCase(const NoParams());
    result.fold(
      (failure) => emit(IcuError(failure.message)),
      (stats) => emit(IcuLoaded(stats)),
    );
  }
}
