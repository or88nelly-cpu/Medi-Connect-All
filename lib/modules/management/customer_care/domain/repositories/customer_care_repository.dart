import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';

abstract class CustomerCareRepository {
  Future<Either<Failure, Map<String, dynamic>>> getCustomerCareStats();
}
