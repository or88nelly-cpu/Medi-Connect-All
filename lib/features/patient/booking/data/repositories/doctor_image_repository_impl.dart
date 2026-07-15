import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/patient/booking/data/datasources/doctor_image_remote_datasource.dart';
import 'package:medi_connect/features/patient/booking/domain/entities/doctor_image_entity.dart';
import 'package:medi_connect/features/patient/booking/domain/repositories/doctor_image_repository.dart';

@LazySingleton(as: DoctorImageRepository)
class DoctorImageRepositoryImpl implements DoctorImageRepository {
  final DoctorImageRemoteDataSource _remoteDataSource;

  DoctorImageRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, DoctorImageEntity>> getDoctorImageUrl(
    String doctorId,
  ) async {
    try {
      final result = await _remoteDataSource.getDoctorImageUrl(doctorId);
      return Right(DoctorImageEntity(result.imageUrl, result.gender));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
