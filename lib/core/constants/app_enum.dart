enum UserRole { patient, admin, doctor, staff }

extension UserRoleExtension on UserRole {
  /// Convert enum to String
  String get value {
    switch (this) {
      case UserRole.patient:
        return 'Patient';
      case UserRole.admin:
        return 'Admin';
      case UserRole.doctor:
        return 'Doctor';
      case UserRole.staff:
        return 'Staff';
    }
  }

  /// Parse String to enum
  static UserRole fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'patient':
        return UserRole.patient;
      case 'admin':
        return UserRole.admin;
      case 'doctor':
        return UserRole.doctor;
      case 'staff':
        return UserRole.staff;
      default:
        return UserRole.staff;
    }
  }
}
