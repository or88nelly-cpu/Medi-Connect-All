import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/admin/inventory_management/domain/repositories/general_store_repository.dart';

@lazySingleton
class GetGeneralStoreStatsUseCase
    extends UseCase<Map<String, dynamic>, NoParams> {
  final GeneralStoreRepository _repository;
  GetGeneralStoreStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getGeneralStoreStats();
  }
}
