import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/doctors/opinfo/data/datasources/op_info_remote_datasource.dart';
import 'package:medi_connect/features/doctors/opinfo/domain/entities/op_info_summary_entity.dart';
import 'package:medi_connect/features/doctors/opinfo/domain/repositories/op_info_repository.dart';

class OpInfoRepositoryImpl implements OpInfoRepository {
  final OpInfoRemoteDataSource _remoteDataSource;

  OpInfoRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, OpInfoSummaryEntity>> getOpInfo({
    required String doctorId,
    required DateTime date,
  }) async {
    try {
      final summary = await _remoteDataSource.getOpInfo(
        doctorId: doctorId,
        date: date,
      );
      return Right(summary);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
