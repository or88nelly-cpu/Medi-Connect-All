import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/doctor/op_procedures/data/datasources/op_procedures_remote_datasource.dart';
import 'package:medi_connect/features/doctor/op_procedures/domain/entities/op_procedure_entity.dart';
import 'package:medi_connect/features/doctor/op_procedures/domain/repositories/op_procedures_repository.dart';

@LazySingleton(as: OpProceduresRepository)
class OpProceduresRepositoryImpl implements OpProceduresRepository {
  final OpProceduresRemoteDataSource remoteDataSource;

  OpProceduresRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<OpProcedureEntity>>> getOpProcedures() async {
    try {
      final result = await remoteDataSource.getOpProcedures();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
