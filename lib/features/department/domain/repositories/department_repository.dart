import 'package:fpdart/fpdart.dart';
import 'package:medi_connect/core/common_models/failures/failure.dart';
import 'package:medi_connect/features/department/domain/entities/department_entity.dart';

/// Abstract contract for the Department feature repository.
abstract class DepartmentRepository {
  /// Fetch all departments.
  Future<Either<Failure, List<DepartmentEntity>>> getDepartments({required bool isConsultationDept});

  /// Create a new department.
  Future<Either<Failure, DepartmentEntity>> addDepartment({
    required String name,
    String? description,
    String? imageUrl,
  });

  /// Update an existing department.
  Future<Either<Failure, DepartmentEntity>> updateDepartment({
    required String id,
    required String name,
    String? description,
    String? imageUrl,
  });

  /// Delete a department by ID.
  Future<Either<Failure, Unit>> deleteDepartment(String id);
}
