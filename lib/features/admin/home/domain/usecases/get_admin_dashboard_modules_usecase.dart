import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/admin/home/domain/entities/admin_dashboard_module_entity.dart';
import 'package:medi_connect/features/admin/home/domain/repositories/admin_home_repository.dart';

/// Use case to retrieve all Admin Control Center module cards.
@lazySingleton
class GetAdminDashboardModulesUseCase {
  final AdminHomeRepository repository;

  GetAdminDashboardModulesUseCase(this.repository);

  Future<Either<Failure, List<AdminDashboardModuleEntity>>> call() async {
    return await repository.getDashboardModules();
  }
}
