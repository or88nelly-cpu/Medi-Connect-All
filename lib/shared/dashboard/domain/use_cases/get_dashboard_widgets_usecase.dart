import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/shared/dashboard/data/models/dashboard_widget_model.dart';
import 'package:medi_connect/shared/dashboard/domain/repositories/dashboard_repository.dart';

class GetDashboardWidgetsUseCase {
  final DashboardRepository repository;

  GetDashboardWidgetsUseCase(this.repository);

  Future<Either<Failure, List<DashboardWidgetModel>>> call() async {
    return await repository.getDashboardWidgets();
  }
}
