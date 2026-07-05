import 'package:equatable/equatable.dart';
import 'package:medi_connect/features/doctors/opinfo/domain/entities/op_procedure_entity.dart';

class OpInfoSummaryEntity extends Equatable {
  final int total;
  final int pending;
  final int completed;
  final int cancelled;
  final List<OpProcedureEntity> procedures;

  const OpInfoSummaryEntity({
    required this.total,
    required this.pending,
    required this.completed,
    required this.cancelled,
    required this.procedures,
  });

  @override
  List<Object?> get props => [total, pending, completed, cancelled, procedures];
}
