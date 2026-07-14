import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/errors/exceptions.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/shared/dashboard/data/data_source/dashboard_remote_data_source.dart';
import 'package:medi_connect/shared/dashboard/data/models/dashboard_widget_model.dart';
import 'package:medi_connect/shared/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<DashboardWidgetModel>>>
  getDashboardWidgets() async {
    try {
      final widgets = await remoteDataSource.getDashboardWidgets();
      return right(widgets);
    } on ServerException catch (e) {
      return left(ServerFailure(e.message));
    } catch (e) {
      return left(NetworkFailure(e.toString()));
    }
  }
}
