/// Data model for emergency alerts with JSON serialization.
library;

import 'package:medi_connect/shared/dashboard/domain/entities/emergency_entity.dart';

class EmergencyModel extends EmergencyEntity {
  const EmergencyModel({
    required super.id,
    required super.message,
    required super.level,
    required super.createdAt,
    super.isResolved,
  });

  factory EmergencyModel.fromJson(Map<String, dynamic> json) {
    return EmergencyModel(
      id: json['id']?.toString() ?? '',
      message: json['message'] as String? ?? '',
      level: json['level'] as String? ?? 'Medium',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      isResolved: json['is_resolved'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'level': level,
    'is_resolved': isResolved,
  };
}
