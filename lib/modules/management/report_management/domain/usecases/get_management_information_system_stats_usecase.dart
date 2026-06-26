import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/report_management/domain/repositories/management_information_system_repository.dart';

class GetManagementInformationSystemStatsUseCase
    extends UseCase<Map<String, dynamic>, NoParams> {
  final ManagementInformationSystemRepository _repository;
  GetManagementInformationSystemStatsUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>>> call(NoParams params) {
    return _repository.getManagementInformationSystemStats();
  }
}
