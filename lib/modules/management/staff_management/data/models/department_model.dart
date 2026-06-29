import 'dart:developer';

import 'package:medi_connect/modules/management/staff_management/domain/entities/department_entity.dart';

/// Data model extending [DepartmentEntity] with JSON serialization.
class DepartmentModel extends DepartmentEntity {
  const DepartmentModel({
    required super.id,
    required super.name,
    super.description,
    super.imageUrl,
    required super.createdAt,
    required super.consultation,
  });

  factory DepartmentModel.fromJson(Map<String, dynamic> json) {
    log(' Department json: $json', name: 'DepartmentModel');
    return DepartmentModel(
      id: json['id'].toString(),
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      imageUrl: json['image_url'] as String?,
      createdAt:
          DateTime.tryParse(json['created_at'] as String? ?? "") ??
          DateTime.now(),
      consultation: json['consultation'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory DepartmentModel.fromEntity(DepartmentEntity entity) {
    return DepartmentModel(
      id: entity.id,
      name: entity.name,
      description: entity.description,
      imageUrl: entity.imageUrl,
      createdAt: entity.createdAt,
      consultation: entity.consultation,
    );
  }
}
