import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/features/department/domain/repositories/department_repository.dart';

class DeleteDepartmentParams extends Equatable {
  final String id;

  const DeleteDepartmentParams(this.id);

  @override
  List<Object?> get props => [id];
}

class DeleteDepartmentUseCase extends UseCase<Unit, DeleteDepartmentParams> {
  final DepartmentRepository _repository;

  const DeleteDepartmentUseCase(this._repository);

  @override
  Future<Either<Failure, Unit>> call(DeleteDepartmentParams params) =>
      _repository.deleteDepartment(params.id);
}
