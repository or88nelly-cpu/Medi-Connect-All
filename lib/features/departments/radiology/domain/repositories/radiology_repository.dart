import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';

abstract class RadiologyRepository {
  Future<Either<Failure, Map<String, dynamic>>> getRadiologyStats();
}
