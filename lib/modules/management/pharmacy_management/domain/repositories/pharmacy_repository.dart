import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';

abstract class PharmacyRepository {
  Future<Either<Failure, Map<String, dynamic>>> getPharmacyStats();
}
