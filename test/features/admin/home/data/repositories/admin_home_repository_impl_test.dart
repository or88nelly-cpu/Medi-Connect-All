import 'package:flutter_test/flutter_test.dart';
import 'package:medi_connect/core/models/exceptions.dart';
import 'package:medi_connect/features/admin/home/data/datasources/admin_home_remote_data_source.dart';
import 'package:medi_connect/features/admin/home/data/models/admin_dashboard_module_model.dart';
import 'package:medi_connect/features/admin/home/data/repositories/admin_home_repository_impl.dart';

class MockAdminHomeRemoteDataSource implements AdminHomeRemoteDataSource {
  bool shouldThrowServerException = false;
  bool shouldThrowUnexpectedException = false;

  @override
  Future<List<AdminDashboardModuleModel>> getDashboardModules() async {
    if (shouldThrowServerException) {
      throw ServerException('Failed server call');
    }
    if (shouldThrowUnexpectedException) {
      throw Exception('Unexpected error');
    }
    return const [
      AdminDashboardModuleModel(
        id: 'doctors',
        title: 'Doctors',
        description: 'Manage doctors',
        countText: '86 Doctors',
        iconKey: 'doctors',
        colorHex: 0xFFEA580C,
        accentColorHex: 0xFFF97316,
      ),
    ];
  }
}

void main() {
  late AdminHomeRepositoryImpl repository;
  late MockAdminHomeRemoteDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockAdminHomeRemoteDataSource();
    repository = AdminHomeRepositoryImpl(remoteDataSource: mockDataSource);
  });

  test(
    'should return list of module entities when remote data source calls succeed',
    () async {
      final result = await repository.getDashboardModules();

      expect(result.isRight(), true);
      result.fold((l) => fail('Expected Right'), (r) {
        expect(r.length, 1);
        expect(r.first.id, 'doctors');
      });
    },
  );

  test(
    'should return ServerFailure when remote data source throws ServerException',
    () async {
      mockDataSource.shouldThrowServerException = true;

      final result = await repository.getDashboardModules();

      expect(result.isLeft(), true);
    },
  );

  test(
    'should return UnknownFailure when remote data source throws unexpected Exception',
    () async {
      mockDataSource.shouldThrowUnexpectedException = true;

      final result = await repository.getDashboardModules();

      expect(result.isLeft(), true);
    },
  );
}
