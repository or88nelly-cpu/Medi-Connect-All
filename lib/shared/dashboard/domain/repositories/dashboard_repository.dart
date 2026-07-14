import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/shared/dashboard/data/models/dashboard_widget_model.dart';

abstract class DashboardRepository {
  Future<Either<Failure, List<DashboardWidgetModel>>> getDashboardWidgets();
}
