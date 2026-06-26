import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';

abstract class FireSafetyRepository {
  Future<Either<Failure, Map<String, dynamic>>> getFireSafetyStats();
}
