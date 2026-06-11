import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';

abstract class IcuRepository {
  Future<Either<Failure, Map<String, dynamic>>> getIcuStats();
}
