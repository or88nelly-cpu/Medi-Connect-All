import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/doctor/op_procedures/domain/entities/op_procedure_entity.dart';

abstract class OpProceduresRepository {
  Future<Either<Failure, List<OpProcedureEntity>>> getOpProcedures();
}
