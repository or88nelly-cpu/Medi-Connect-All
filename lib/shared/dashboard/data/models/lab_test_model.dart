/// Data model for lab test records with JSON serialization.
library;

import 'package:medi_connect/shared/dashboard/domain/entities/lab_test_entity.dart';

class LabTestModel extends LabTestEntity {
  const LabTestModel({
    required super.id,
    required super.patientName,
    required super.testName,
    required super.status,
    required super.priority,
    super.createdAt,
  });

  factory LabTestModel.fromJson(Map<String, dynamic> json) {
    return LabTestModel(
      id: json['id']?.toString() ?? '',
      patientName: json['patient_name'] as String? ?? '',
      testName: json['test_name'] as String? ?? '',
      status: json['status'] as String? ?? 'Pending',
      priority: json['priority'] as String? ?? 'Normal',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'patient_name': patientName,
    'test_name': testName,
    'status': status,
    'priority': priority,
  };
}
