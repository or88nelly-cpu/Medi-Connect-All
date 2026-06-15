/// Domain entity for a staff attendance record.
library;

import 'package:equatable/equatable.dart';

class AttendanceEntity extends Equatable {
  final String id;
  final String staffId;
  final String staffName;
  final String role;
  final String status;
  final String? checkInTime;
  final String? checkOutTime;
  final DateTime date;

  const AttendanceEntity({
    required this.id,
    required this.staffId,
    required this.staffName,
    required this.role,
    required this.status,
    this.checkInTime,
    this.checkOutTime,
    required this.date,
  });

  @override
  List<Object?> get props => [id, staffId, staffName, role, status, date];
}
