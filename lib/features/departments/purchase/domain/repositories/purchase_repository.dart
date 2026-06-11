import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';

abstract class PurchaseRepository {
  Future<Either<Failure, Map<String, dynamic>>> getPurchaseStats();
}
