import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/features/doctors/op_procedures/domain/usecases/get_op_procedures_usecase.dart';
import 'op_procedures_event.dart';
import 'op_procedures_state.dart';

class OpProceduresBloc extends Bloc<OpProceduresEvent, OpProceduresState> {
  final GetOpProceduresUseCase getOpProcedures;

  OpProceduresBloc({required this.getOpProcedures}) : super(OpProceduresInitial()) {
    on<LoadOpProcedures>(_onLoadOpProcedures);
  }

  Future<void> _onLoadOpProcedures(
    LoadOpProcedures event,
    Emitter<OpProceduresState> emit,
  ) async {
    emit(OpProceduresLoading());
    final result = await getOpProcedures();
    result.fold(
      (failure) => emit(OpProceduresError(failure.message)),
      (list) => emit(OpProceduresLoaded(list)),
    );
  }
}
