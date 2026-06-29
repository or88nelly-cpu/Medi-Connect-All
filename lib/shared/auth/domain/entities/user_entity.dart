import 'package:equatable/equatable.dart';
import 'package:medi_connect/core/constants/app_enum.dart';

class UserEntity extends Equatable {
  final String id;
  final String? authUserId;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String? email;
  final String? phone;
  final String? gender;
  final DateTime? dob;
  final String? bloodGroup;
  final String? profilePhoto;
  final String? status;
  final DateTime? lastLoginAt;
  final DateTime? activeAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final UserRole role;

  const UserEntity({
    required this.id,
    this.authUserId,
    required this.firstName,
    this.middleName,
    required this.lastName,
    this.email,
    this.phone,
    this.gender,
    this.dob,
    this.bloodGroup,
    this.profilePhoto,
    this.status,
    this.lastLoginAt,
    this.activeAt,
    this.createdAt,
    this.updatedAt,
    this.role = UserRole.patient,
  });

  @override
  List<Object?> get props => [
    id,
    authUserId,
    firstName,
    middleName,
    lastName,
    email,
    phone,
    gender,
    dob,
    bloodGroup,
    profilePhoto,
    status,
    lastLoginAt,
    activeAt,
    createdAt,
    updatedAt,
    role,
  ];
  String get fullName {
    return "$firstName ${middleName ?? ''} $lastName";
  }
}
