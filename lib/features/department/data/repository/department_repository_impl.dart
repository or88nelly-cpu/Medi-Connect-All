import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/features/department/data/datasource/department_remote_datasource.dart';
import 'package:medi_connect/features/department/domain/entities/department_entity.dart';
import 'package:medi_connect/features/department/domain/repositories/department_repository.dart';

class DepartmentRepositoryImpl implements DepartmentRepository {
  final DepartmentRemoteDataSource _dataSource;

  DepartmentRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<DepartmentEntity>>> getDepartments() async {
    try {
      final models = await _dataSource.getDepartments();
      return Right(models);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DepartmentEntity>> addDepartment({
    required String name,
    String? description,
    String? imageUrl,
  }) async {
    try {
      final model = await _dataSource.addDepartment(
        name: name,
        description: description,
        imageUrl: imageUrl,
      );
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DepartmentEntity>> updateDepartment({
    required String id,
    required String name,
    String? description,
    String? imageUrl,
  }) async {
    try {
      final model = await _dataSource.updateDepartment(
        id: id,
        name: name,
        description: description,
        imageUrl: imageUrl,
      );
      return Right(model);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteDepartment(String id) async {
    try {
      await _dataSource.deleteDepartment(id);
      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
