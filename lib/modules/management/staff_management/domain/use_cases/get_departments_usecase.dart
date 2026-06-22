import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/staff_management/domain/entities/department_entity.dart';
import 'package:medi_connect/modules/management/staff_management/domain/repositories/department_repository.dart';

class GetDepartmentsUseCase extends UseCase<List<DepartmentEntity>, bool> {
  final DepartmentRepository _repository;

  const GetDepartmentsUseCase(this._repository);

  @override
  Future<Either<Failure, List<DepartmentEntity>>> call(
    bool isConsultationDept,
  ) => _repository.getDepartments(isConsultationDept: isConsultationDept);
}
