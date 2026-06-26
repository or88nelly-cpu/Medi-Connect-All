import 'package:equatable/equatable.dart';

/// Domain entity representing a hospital department.
class DepartmentEntity extends Equatable {
  final String id;
  final String name;
  final String? description;
  final String? imageUrl;
  final DateTime createdAt;
  final bool consultation;

  const DepartmentEntity({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
    required this.createdAt,
    required this.consultation,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    imageUrl,
    createdAt,
    consultation,
  ];
}
