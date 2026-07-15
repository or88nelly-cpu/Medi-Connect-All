import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/patient/booking/domain/entities/doctor_image_entity.dart';
import 'package:medi_connect/features/patient/booking/domain/repositories/doctor_image_repository.dart';

@lazySingleton
class GetDoctorImageUseCase {
  final DoctorImageRepository _repository;

  GetDoctorImageUseCase(this._repository);

  Future<Either<Failure, DoctorImageEntity>> call(String doctorId) {
    return _repository.getDoctorImageUrl(doctorId);
  }
}
