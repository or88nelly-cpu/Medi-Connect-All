import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/admin/home/domain/entities/admin_dashboard_module_entity.dart';
import 'package:medi_connect/features/admin/home/domain/repositories/admin_home_repository.dart';
import 'package:medi_connect/features/admin/home/domain/usecases/get_admin_dashboard_modules_usecase.dart';

class MockAdminHomeRepository implements AdminHomeRepository {
  bool shouldReturnError = false;

  @override
  Future<Either<Failure, List<AdminDashboardModuleEntity>>>
  getDashboardModules() async {
    if (shouldReturnError) {
      return Left(ServerFailure('Server Exception'));
    }
    return const Right([
      AdminDashboardModuleEntity(
        id: 'departments',
        title: 'Departments',
        description: 'Manage hospital departments',
        countText: '24 Departments',
        iconKey: 'departments',
        colorHex: 0xFF9333EA,
        accentColorHex: 0xFFA855F7,
      ),
    ]);
  }
}

void main() {
  late GetAdminDashboardModulesUseCase useCase;
  late MockAdminHomeRepository mockRepository;

  setUp(() {
    mockRepository = MockAdminHomeRepository();
    useCase = GetAdminDashboardModulesUseCase(mockRepository);
  });

  test(
    'should return list of AdminDashboardModuleEntity when repository succeeds',
    () async {
      final result = await useCase();

      expect(result.isRight(), true);
      result.fold((l) => fail('Should not return failure'), (r) {
        expect(r.length, 1);
        expect(r.first.title, 'Departments');
      });
    },
  );

  test('should return ServerFailure when repository fails', () async {
    mockRepository.shouldReturnError = true;

    final result = await useCase();

    expect(result.isLeft(), true);
  });
}
