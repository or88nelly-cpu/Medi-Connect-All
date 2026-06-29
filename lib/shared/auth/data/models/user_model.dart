import 'package:medi_connect/core/constants/app_enum.dart';
import 'package:medi_connect/shared/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    super.authUserId,
    required super.firstName,
    super.middleName,
    required super.lastName,
    super.email,
    super.phone,
    super.gender,
    super.dob,
    super.bloodGroup,
    super.profilePhoto,
    super.status,
    super.lastLoginAt,
    super.activeAt,
    super.createdAt,
    super.updatedAt,
    super.role,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      authUserId: json['auth_user_id'] as String?,
      firstName: json['first_name'] as String,
      middleName: json['middle_name'] as String?,
      lastName: json['last_name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      gender: json['gender'] as String?,
      dob: json['dob'] != null ? DateTime.parse(json['dob'] as String) : null,
      bloodGroup: json['blood_group'] as String?,
      profilePhoto: json['profile_photo'] as String?,
      status: json['status'] as String?,
      lastLoginAt: json['last_login_at'] != null
          ? DateTime.parse(json['last_login_at'] as String)
          : null,
      activeAt: json['active_at'] != null
          ? DateTime.parse(json['active_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      role: UserRoleExtension.fromString(json['role'] as String?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'auth_user_id': authUserId,
      'first_name': firstName,
      'middle_name': middleName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'gender': gender,
      'dob': dob?.toIso8601String(),
      'blood_group': bloodGroup,
      'profile_photo': profilePhoto,
      'status': status,
      'last_login_at': lastLoginAt?.toIso8601String(),
      'active_at': activeAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'role': role.value,
    };
  }

  UserModel copyWith({
    String? id,
    String? authUserId,
    String? firstName,
    String? middleName,
    String? lastName,
    String? email,
    String? phone,
    String? gender,
    DateTime? dob,
    String? bloodGroup,
    String? profilePhoto,
    String? status,
    DateTime? lastLoginAt,
    DateTime? activeAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    UserRole? role,
  }) {
    return UserModel(
      id: id ?? this.id,
      authUserId: authUserId ?? this.authUserId,
      firstName: firstName ?? this.firstName,
      middleName: middleName ?? this.middleName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      gender: gender ?? this.gender,
      dob: dob ?? this.dob,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      status: status ?? this.status,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      activeAt: activeAt ?? this.activeAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      role: role ?? this.role,
    );
  }

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      authUserId: entity.authUserId,
      firstName: entity.firstName,
      middleName: entity.middleName,
      lastName: entity.lastName,
      email: entity.email,
      phone: entity.phone,
      gender: entity.gender,
      dob: entity.dob,
      bloodGroup: entity.bloodGroup,
      profilePhoto: entity.profilePhoto,
      status: entity.status,
      lastLoginAt: entity.lastLoginAt,
      activeAt: entity.activeAt,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      role: entity.role,
    );
  }
}
