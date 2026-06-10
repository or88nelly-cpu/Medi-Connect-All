part of 'department_bloc.dart';

abstract class DepartmentEvent extends Equatable {
  const DepartmentEvent();

  @override
  List<Object?> get props => [];
}

class LoadDepartments extends DepartmentEvent {
  const LoadDepartments();
}

class LoadConsultDepartments extends DepartmentEvent {
  const LoadConsultDepartments();
}

class AddDepartmentEvent extends DepartmentEvent {
  final String name;
  final String? description;
  final String? imageUrl;

  const AddDepartmentEvent({
    required this.name,
    this.description,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [name, description, imageUrl];
}

class UpdateDepartmentEvent extends DepartmentEvent {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;

  const UpdateDepartmentEvent({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, description, imageUrl];
}

class DeleteDepartmentEvent extends DepartmentEvent {
  final String id;

  const DeleteDepartmentEvent(this.id);

  @override
  List<Object?> get props => [id];
}
