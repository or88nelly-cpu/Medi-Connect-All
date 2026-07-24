import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/features/admin/home/domain/entities/admin_dashboard_module_entity.dart';
import 'package:medi_connect/features/admin/home/domain/repositories/admin_home_repository.dart';
import 'package:medi_connect/features/admin/home/domain/usecases/get_admin_dashboard_modules_usecase.dart';
import 'package:medi_connect/features/admin/home/presentation/bloc/admin_home_bloc.dart';
import 'package:medi_connect/features/admin/home/presentation/bloc/admin_home_event.dart';
import 'package:medi_connect/features/admin/home/presentation/bloc/admin_home_state.dart';

class MockAdminHomeRepositoryForBloc implements AdminHomeRepository {
  bool shouldFail = false;

  @override
  Future<Either<Failure, List<AdminDashboardModuleEntity>>>
  getDashboardModules() async {
    if (shouldFail) {
      return Left(ServerFailure('Connection Failed'));
    }
    return const Right([
      AdminDashboardModuleEntity(
        id: 'departments',
        title: 'Departments',
        description: 'Manage all departments',
        countText: '24 Departments',
        iconKey: 'departments',
        colorHex: 0xFF9333EA,
        accentColorHex: 0xFFA855F7,
      ),
      AdminDashboardModuleEntity(
        id: 'doctors',
        title: 'Doctors',
        description: 'Manage doctors and profiles',
        countText: '86 Doctors',
        iconKey: 'doctors',
        colorHex: 0xFFEA580C,
        accentColorHex: 0xFFF97316,
      ),
    ]);
  }
}

void main() {
  late AdminHomeBloc bloc;
  late GetAdminDashboardModulesUseCase useCase;
  late MockAdminHomeRepositoryForBloc repository;

  setUp(() {
    repository = MockAdminHomeRepositoryForBloc();
    useCase = GetAdminDashboardModulesUseCase(repository);
    bloc = AdminHomeBloc(getAdminDashboardModulesUseCase: useCase);
  });

  tearDown(() {
    bloc.close();
  });

  test('initial state should be AdminHomeInitial', () {
    expect(bloc.state, const AdminHomeInitial());
  });

  test(
    'should emit [AdminHomeLoading, AdminHomeLoaded] on successful LoadAdminDashboardModules',
    () async {
      final expectedStates = [const AdminHomeLoading(), isA<AdminHomeLoaded>()];

      expectLater(bloc.stream, emitsInOrder(expectedStates));

      bloc.add(const LoadAdminDashboardModules());
    },
  );

  test(
    'should emit [AdminHomeLoading, AdminHomeError] when loading modules fails',
    () async {
      repository.shouldFail = true;

      final expectedStates = [
        const AdminHomeLoading(),
        const AdminHomeError('Connection Failed'),
      ];

      expectLater(bloc.stream, emitsInOrder(expectedStates));

      bloc.add(const LoadAdminDashboardModules());
    },
  );

  test(
    'should filter modules when FilterAdminDashboardModules event is dispatched',
    () async {
      bloc.add(const LoadAdminDashboardModules());
      await Future.delayed(const Duration(milliseconds: 50));

      bloc.add(const FilterAdminDashboardModules('Doctors'));
      await Future.delayed(const Duration(milliseconds: 50));

      final state = bloc.state as AdminHomeLoaded;
      expect(state.filteredModules.length, 1);
      expect(state.filteredModules.first.title, 'Doctors');
    },
  );
}
