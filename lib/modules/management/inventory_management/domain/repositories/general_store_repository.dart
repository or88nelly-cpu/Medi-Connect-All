import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';

abstract class GeneralStoreRepository {
  Future<Either<Failure, Map<String, dynamic>>> getGeneralStoreStats();
}
