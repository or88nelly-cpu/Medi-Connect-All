import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/core/functions/usecase.dart';
import 'package:medi_connect/modules/management/staff_management/domain/entities/department_entity.dart';
import 'package:medi_connect/modules/management/staff_management/domain/repositories/department_repository.dart';

class AddDepartmentParams extends Equatable {
  final String name;
  final String? description;
  final String? imageUrl;

  const AddDepartmentParams({
    required this.name,
    this.description,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [name, description, imageUrl];
}

class AddDepartmentUseCase
    extends UseCase<DepartmentEntity, AddDepartmentParams> {
  final DepartmentRepository _repository;

  const AddDepartmentUseCase(this._repository);

  @override
  Future<Either<Failure, DepartmentEntity>> call(AddDepartmentParams params) =>
      _repository.addDepartment(
        name: params.name,
        description: params.description,
        imageUrl: params.imageUrl,
      );
}
