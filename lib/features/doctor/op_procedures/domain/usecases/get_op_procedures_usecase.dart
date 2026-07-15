import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/doctor/op_procedures/domain/entities/op_procedure_entity.dart';
import 'package:medi_connect/features/doctor/op_procedures/domain/repositories/op_procedures_repository.dart';

@lazySingleton
class GetOpProceduresUseCase {
  final OpProceduresRepository repository;

  GetOpProceduresUseCase(this.repository);

  Future<Either<Failure, List<OpProcedureEntity>>> call() {
    return repository.getOpProcedures();
  }
}
