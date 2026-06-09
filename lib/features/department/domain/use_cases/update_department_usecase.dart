import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/core/usecases/usecase.dart';
import 'package:medi_connect/features/department/domain/entities/department_entity.dart';
import 'package:medi_connect/features/department/domain/repositories/department_repository.dart';

class UpdateDepartmentParams extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;

  const UpdateDepartmentParams({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, description, imageUrl];
}

class UpdateDepartmentUseCase
    extends UseCase<DepartmentEntity, UpdateDepartmentParams> {
  final DepartmentRepository _repository;

  const UpdateDepartmentUseCase(this._repository);

  @override
  Future<Either<Failure, DepartmentEntity>> call(
    UpdateDepartmentParams params,
  ) => _repository.updateDepartment(
    id: params.id,
    name: params.name,
    description: params.description,
    imageUrl: params.imageUrl,
  );
}
