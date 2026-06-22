import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';

abstract class IcuRepository {
  Future<Either<Failure, Map<String, dynamic>>> getIcuStats();
}
