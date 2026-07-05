import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/features/doctors/opinfo/domain/entities/op_procedure_entity.dart';
import 'package:medi_connect/features/doctors/opinfo/domain/usecases/get_op_info_usecase.dart';
import 'op_info_event.dart';
import 'op_info_state.dart';

class OpInfoBloc extends Bloc<OpInfoEvent, OpInfoState> {
  final GetOpInfoUseCase _getOpInfo;

  OpInfoBloc({required this._getOpInfo}) : super(const OpInfoInitial()) {
    on<OpInfoLoadRequested>(_onLoad);
    on<OpInfoDateChanged>(_onDateChanged);
    on<OpInfoSearchChanged>(_onSearchChanged);
    on<OpInfoFilterChanged>(_onFilterChanged);
    on<OpInfoPreviousDay>(_onPreviousDay);
    on<OpInfoNextDay>(_onNextDay);
  }

  Future<void> _onLoad(
    OpInfoLoadRequested event,
    Emitter<OpInfoState> emit,
  ) async {
    emit(const OpInfoLoading());
    final result = await _getOpInfo(
      GetOpInfoParams(doctorId: event.doctorId, date: event.date),
    );
    result.fold(
      (failure) => emit(OpInfoError(failure.message)),
      (summary) => emit(
        OpInfoLoaded(
          summary: summary,
          filteredProcedures: summary.procedures,
          selectedDate: event.date,
          searchQuery: '',
          activeFilter: AppStrings.opInfoFilterAll,
          doctorId: event.doctorId,
        ),
      ),
    );
  }

  Future<void> _reload(Emitter<OpInfoState> emit, OpInfoLoaded current) async {
    emit(const OpInfoLoading());
    final result = await _getOpInfo(
      GetOpInfoParams(doctorId: current.doctorId, date: current.selectedDate),
    );
    result.fold((failure) => emit(OpInfoError(failure.message)), (summary) {
      emit(
        current.copyWith(
          summary: summary,
          filteredProcedures: _filterProcedures(
            summary.procedures,
            current.searchQuery,
            current.activeFilter,
          ),
        ),
      );
    });
  }

  Future<void> _onDateChanged(
    OpInfoDateChanged event,
    Emitter<OpInfoState> emit,
  ) async {
    if (state is! OpInfoLoaded) return;
    final current = state as OpInfoLoaded;
    emit(current.copyWith(selectedDate: event.date));
    await _reload(emit, current.copyWith(selectedDate: event.date));
  }

  void _onSearchChanged(OpInfoSearchChanged event, Emitter<OpInfoState> emit) {
    if (state is! OpInfoLoaded) return;
    final current = state as OpInfoLoaded;
    emit(
      current.copyWith(
        searchQuery: event.query,
        filteredProcedures: _filterProcedures(
          current.summary.procedures,
          event.query,
          current.activeFilter,
        ),
      ),
    );
  }

  void _onFilterChanged(OpInfoFilterChanged event, Emitter<OpInfoState> emit) {
    if (state is! OpInfoLoaded) return;
    final current = state as OpInfoLoaded;
    emit(
      current.copyWith(
        activeFilter: event.filter,
        filteredProcedures: _filterProcedures(
          current.summary.procedures,
          current.searchQuery,
          event.filter,
        ),
      ),
    );
  }

  Future<void> _onPreviousDay(
    OpInfoPreviousDay event,
    Emitter<OpInfoState> emit,
  ) async {
    if (state is! OpInfoLoaded) return;
    final current = state as OpInfoLoaded;
    final newDate = current.selectedDate.subtract(const Duration(days: 1));
    add(OpInfoDateChanged(newDate));
  }

  Future<void> _onNextDay(
    OpInfoNextDay event,
    Emitter<OpInfoState> emit,
  ) async {
    if (state is! OpInfoLoaded) return;
    final current = state as OpInfoLoaded;
    final newDate = current.selectedDate.add(const Duration(days: 1));
    add(OpInfoDateChanged(newDate));
  }

  List<OpProcedureEntity> _filterProcedures(
    List<OpProcedureEntity> all,
    String query,
    String filter,
  ) {
    var result = all;
    if (filter != AppStrings.opInfoFilterAll) {
      result = result
          .where((p) => p.status.toLowerCase() == filter.toLowerCase())
          .toList();
    }
    if (query.isNotEmpty) {
      final q = query.toLowerCase();
      result = result
          .where(
            (p) =>
                p.patientName.toLowerCase().contains(q) ||
                p.patientId.toLowerCase().contains(q),
          )
          .toList();
    }
    return result;
  }
}
