import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';

abstract class InformationTechnologyRepository {
  Future<Either<Failure, Map<String, dynamic>>> getInformationTechnologyStats();
}
