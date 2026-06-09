import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/features/department/domain/entities/department_entity.dart';
import 'package:medi_connect/features/department/domain/repositories/department_repository.dart';

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
