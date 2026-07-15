import 'package:equatable/equatable.dart';
import 'package:medi_connect/features/doctor/op_procedures/domain/entities/op_procedure_entity.dart';

abstract class OpProceduresState extends Equatable {
  const OpProceduresState();
  @override
  List<Object?> get props => [];
}

class OpProceduresInitial extends OpProceduresState {}

class OpProceduresLoading extends OpProceduresState {}

class OpProceduresLoaded extends OpProceduresState {
  final List<OpProcedureEntity> procedures;
  const OpProceduresLoaded(this.procedures);

  @override
  List<Object?> get props => [procedures];
}

class OpProceduresError extends OpProceduresState {
  final String message;
  const OpProceduresError(this.message);

  @override
  List<Object?> get props => [message];
}
