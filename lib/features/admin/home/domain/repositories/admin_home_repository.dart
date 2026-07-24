import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/admin/home/domain/entities/admin_dashboard_module_entity.dart';

/// Repository interface for Admin Control Center operations.
abstract class AdminHomeRepository {
  /// Fetches all active Control Center module cards with their dynamic statistics.
  Future<Either<Failure, List<AdminDashboardModuleEntity>>>
  getDashboardModules();
}
