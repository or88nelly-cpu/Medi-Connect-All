import 'package:medi_connect/shared/auth/domain/entities/employee_entity.dart';

class EmployeeModel extends EmployeeEntity {
  const EmployeeModel({
    required super.id,
    super.hospitalId,
    super.userId,
    super.employeeCode,
    super.departmentId,
    super.designationId,
    super.employmentTypeId,
    super.reportingManager,
    super.attendanceRequired,
    super.status,
    super.lastLoginAt,
    super.activeAt,
    super.lastLoginIp,
    super.lastLoginDevice,
    super.currentLocation,
    super.currentLatitude,
    super.currentLongitude,
    super.createdAt,
    super.updatedAt,
  });

  factory EmployeeModel.fromJson(Map<String, dynamic> json) {
    return EmployeeModel(
      id: json['id'] as String,
      hospitalId: json['hospital_id'] as String?,
      userId: json['user_id'] as String?,
      employeeCode: json['employee_code'] as String?,
      departmentId: json['department_id'] as String?,
      designationId: json['designation_id'] as String?,
      employmentTypeId: json['employment_type_id'] as String?,
      reportingManager: json['reporting_manager'] as String?,
      attendanceRequired: json['attendance_required'] as bool? ?? true,
      status: json['status'] as String? ?? 'active',
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'] as String)
          : null,
      activeAt: json['active_at'] != null
          ? DateTime.parse(json['active_at'] as String)
          : null,
      lastLoginIp: json['last_login_ip'] as String?,
      lastLoginDevice: json['last_login_device'] as String?,
      currentLocation: json['current_location'] as String?,
      currentLatitude: json['current_latitude'] != null
          ? (json['current_latitude'] as num).toDouble()
          : null,
      currentLongitude: json['current_longitude'] != null
          ? (json['current_longitude'] as num).toDouble()
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hospital_id': hospitalId,
      'user_id': userId,
      'employee_code': employeeCode,
      'department_id': departmentId,
      'designation_id': designationId,
      'employment_type_id': employmentTypeId,
      'reporting_manager': reportingManager,
      'attendance_required': attendanceRequired,
      'status': status,
      'last_login_at': lastLoginAt?.toIso8601String(),
      'active_at': activeAt?.toIso8601String(),
      'last_login_ip': lastLoginIp,
      'last_login_device': lastLoginDevice,
      'current_location': currentLocation,
      'current_latitude': currentLatitude,
      'current_longitude': currentLongitude,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory EmployeeModel.fromEntity(EmployeeEntity entity) {
    return EmployeeModel(
      id: entity.id,
      hospitalId: entity.hospitalId,
      userId: entity.userId,
      employeeCode: entity.employeeCode,
      departmentId: entity.departmentId,
      designationId: entity.designationId,
      employmentTypeId: entity.employmentTypeId,
      reportingManager: entity.reportingManager,
      attendanceRequired: entity.attendanceRequired,
      status: entity.status,
      lastLoginAt: entity.lastLoginAt,
      activeAt: entity.activeAt,
      lastLoginIp: entity.lastLoginIp,
      lastLoginDevice: entity.lastLoginDevice,
      currentLocation: entity.currentLocation,
      currentLatitude: entity.currentLatitude,
      currentLongitude: entity.currentLongitude,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
