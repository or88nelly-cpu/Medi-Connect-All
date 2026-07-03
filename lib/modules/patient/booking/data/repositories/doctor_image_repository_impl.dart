
import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/modules/patient/booking/data/datasources/doctor_image_remote_datasource.dart';
import 'package:medi_connect/modules/patient/booking/domain/entities/doctor_image_entity.dart';
import 'package:medi_connect/modules/patient/booking/domain/repositories/doctor_image_repository.dart';

class DoctorImageRepositoryImpl implements DoctorImageRepository {
  final DoctorImageRemoteDataSource _remoteDataSource;

  DoctorImageRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, DoctorImageEntity>> getDoctorImageUrl(String doctorId) async {
    try {
      final imageUrl = await _remoteDataSource.getDoctorImageUrl(doctorId);
      return Right(DoctorImageEntity(imageUrl));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
