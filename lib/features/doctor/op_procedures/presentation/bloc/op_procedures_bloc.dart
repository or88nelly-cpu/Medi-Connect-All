import 'op_procedures_event.dart';
import 'op_procedures_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/features/doctor/op_procedures/domain/usecases/get_op_procedures_usecase.dart';

@injectable
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
