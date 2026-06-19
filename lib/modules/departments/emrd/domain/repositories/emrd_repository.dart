import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';

abstract class EmrdRepository {
  Future<Either<Failure, Map<String, dynamic>>> getEmrdStats();
  Future<Either<Failure, List<Map<String, dynamic>>>> getEmrRecords();
}
