/// Domain entity for a lab test record.
library;

import 'package:equatable/equatable.dart';

class LabTestEntity extends Equatable {
  final String id;
  final String patientName;
  final String testName;
  final String status;
  final String priority;
  final DateTime? createdAt;

  const LabTestEntity({
    required this.id,
    required this.patientName,
    required this.testName,
    required this.status,
    required this.priority,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id, patientName, testName, status, priority];
}
