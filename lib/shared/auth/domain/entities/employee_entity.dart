import 'package:equatable/equatable.dart';

class EmployeeEntity extends Equatable {
  final String id;
  final String? hospitalId;
  final String? userId;
  final String? employeeCode;
  final String? departmentId;
  final String? designationId;
  final String? employmentTypeId;
  final String? reportingManager;
  final bool attendanceRequired;
  final String? status;
  final DateTime? lastLoginAt;
  final DateTime? activeAt;
  final String? lastLoginIp;
  final String? lastLoginDevice;
  final String? currentLocation;
  final double? currentLatitude;
  final double? currentLongitude;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const EmployeeEntity({
    required this.id,
    this.hospitalId,
    this.userId,
    this.employeeCode,
    this.departmentId,
    this.designationId,
    this.employmentTypeId,
    this.reportingManager,
    this.attendanceRequired = true,
    this.status = 'active',
    this.lastLoginAt,
    this.activeAt,
    this.lastLoginIp,
    this.lastLoginDevice,
    this.currentLocation,
    this.currentLatitude,
    this.currentLongitude,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        hospitalId,
        userId,
        employeeCode,
        departmentId,
        designationId,
        employmentTypeId,
        reportingManager,
        attendanceRequired,
        status,
        lastLoginAt,
        activeAt,
        lastLoginIp,
        lastLoginDevice,
        currentLocation,
        currentLatitude,
        currentLongitude,
        createdAt,
        updatedAt,
      ];
}
