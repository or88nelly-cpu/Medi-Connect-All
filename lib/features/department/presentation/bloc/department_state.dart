part of 'department_bloc.dart';

abstract class DepartmentState extends Equatable {
  const DepartmentState();

  @override
  List<Object?> get props => [];
}

class DepartmentInitial extends DepartmentState {}

class DepartmentLoading extends DepartmentState {}

class DepartmentsLoaded extends DepartmentState {
  final List<DepartmentEntity> departments;

  const DepartmentsLoaded(this.departments);

  @override
  List<Object?> get props => [departments];
}

class DepartmentError extends DepartmentState {
  final Failure failure;

  const DepartmentError(this.failure);

  @override
  List<Object?> get props => [failure];
}

/// Emitted after a successful add/update/delete.
/// Contains the message and the refreshed department list.
class DepartmentActionSuccess extends DepartmentState {
  final String message;
  final List<DepartmentEntity> updatedDepartments;

  const DepartmentActionSuccess({
    required this.message,
    required this.updatedDepartments,
  });

  @override
  List<Object?> get props => [message, updatedDepartments];
}
