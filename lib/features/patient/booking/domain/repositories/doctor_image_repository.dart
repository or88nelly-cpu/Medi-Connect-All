import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/patient/booking/domain/entities/doctor_image_entity.dart';

abstract class DoctorImageRepository {
  Future<Either<Failure, DoctorImageEntity>> getDoctorImageUrl(String doctorId);
}
