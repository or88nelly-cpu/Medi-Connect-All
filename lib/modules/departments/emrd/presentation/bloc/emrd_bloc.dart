import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/modules/departments/emrd/domain/usecases/get_emrd_stats_usecase.dart';
import 'package:medi_connect/modules/departments/emrd/domain/usecases/get_emr_records_usecase.dart';

abstract class EmrdEvent extends Equatable {
  const EmrdEvent();

  @override
  List<Object?> get props => [];
}

class LoadEmrdStats extends EmrdEvent {}

abstract class EmrdState extends Equatable {
  const EmrdState();

  @override
  List<Object?> get props => [];
}

class EmrdInitial extends EmrdState {}

class EmrdLoading extends EmrdState {}

class EmrdLoaded extends EmrdState {
  final Map<String, dynamic> stats;
  final List<Map<String, dynamic>> emrRecords;

  const EmrdLoaded(this.stats, {this.emrRecords = const []});

  @override
  List<Object?> get props => [stats, emrRecords];
}

class EmrdError extends EmrdState {
  final String message;
  const EmrdError(this.message);

  @override
  List<Object?> get props => [message];
}

class EmrdBloc extends Bloc<EmrdEvent, EmrdState> {
  final GetEmrdStatsUseCase _getStats;
  final GetEmrRecordsUseCase _getRecords;

  EmrdBloc(this._getStats, this._getRecords) : super(EmrdInitial()) {
    on<LoadEmrdStats>(_onLoadStats);
  }

  Future<void> _onLoadStats(
    LoadEmrdStats event,
    Emitter<EmrdState> emit,
  ) async {
    emit(EmrdLoading());

    final statsRes = await _getStats(NoParams());
    final recordsRes = await _getRecords(NoParams());

    Map<String, dynamic> stats = {};
    List<Map<String, dynamic>> records = [];

    statsRes.fold((_) {}, (val) => stats = val);
    recordsRes.fold((_) {}, (val) => records = val);

    emit(EmrdLoaded(stats, emrRecords: records));
  }
}
