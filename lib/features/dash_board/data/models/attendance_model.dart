/// Data model for staff attendance records with JSON serialization.
library;

import 'package:medi_connect/features/dash_board/domain/entities/attendance_entity.dart';

class AttendanceModel extends AttendanceEntity {
  const AttendanceModel({
    required super.id,
    required super.staffId,
    required super.staffName,
    required super.role,
    required super.status,
    super.checkInTime,
    super.checkOutTime,
    required super.date,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    return AttendanceModel(
      id: json['id']?.toString() ?? '',
      staffId: json['staff_id']?.toString() ?? '',
      staffName: json['staff_name'] as String? ?? '',
      role: json['role'] as String? ?? '',
      status: json['status'] as String? ?? 'Absent',
      checkInTime: json['check_in_time'] as String?,
      checkOutTime: json['check_out_time'] as String?,
      date: json['date'] != null
          ? DateTime.tryParse(json['date'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'staff_id': staffId,
    'staff_name': staffName,
    'role': role,
    'status': status,
    'check_in_time': checkInTime,
    'check_out_time': checkOutTime,
    'date': date.toIso8601String().split('T').first,
  };
}
