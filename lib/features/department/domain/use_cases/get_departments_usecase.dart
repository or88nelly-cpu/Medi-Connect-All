import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/features/department/domain/entities/department_entity.dart';
import 'package:medi_connect/features/department/domain/repositories/department_repository.dart';

class GetDepartmentsUseCase extends UseCase<List<DepartmentEntity>, NoParams> {
  final DepartmentRepository _repository;

  const GetDepartmentsUseCase(this._repository);

  @override
  Future<Either<Failure, List<DepartmentEntity>>> call(NoParams params) =>
      _repository.getDepartments();
}
