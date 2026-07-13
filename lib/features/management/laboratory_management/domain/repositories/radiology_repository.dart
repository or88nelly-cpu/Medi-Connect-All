import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';

abstract class RadiologyRepository {
  Future<Either<Failure, Map<String, dynamic>>> getRadiologyStats();
}
