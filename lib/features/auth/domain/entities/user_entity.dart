
import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String id;
  final String email;
  final String? name;
  final String? phoneNumber;
  final String role; // patient, doctor, staff, admin
  final bool profileCompletionStatus;
  final String status;
  final String? department;
  final String? qualification;
  final Map<String, dynamic>? metadata;

  // Stage 2 onboarding fields
  final String? firstName;
  final String? lastName;
  final String? dateOfBirth;
  final int? age;
  final String? gender;
  final String? profileImage;
  final String? address;
  final String? emergencyContact;
  final String? bloodGroup;
  final String? maritalStatus;

  // Stage 3 onboarding fields
  final String? employeeId;
  final String? patientId;
  final String? medicalRegistrationNumber;
  final int? experience;
  final String? specialization;
  final double? consultationFee;
  final String? availabilityStatus;
  final String? staffRole;
  final String? joiningDate;
  final String? allergies;
  final String? chronicDiseases;
  final String? insuranceProvider;
  final String? insuranceNumber;
  final String? designation;
  final String? accessLevel;

  const UserEntity({
    required this.id,
    required this.email,
    this.name,
    this.phoneNumber,
    required this.role,
    this.profileCompletionStatus = false,
    this.status = 'Pending Registration',
    this.department,
    this.qualification,
    this.metadata,
    this.firstName,
    this.lastName,
    this.dateOfBirth,
    this.age,
    this.gender,
    this.profileImage,
    this.address,
    this.emergencyContact,
    this.bloodGroup,
    this.maritalStatus,
    this.employeeId,
    this.patientId,
    this.medicalRegistrationNumber,
    this.experience,
    this.specialization,
    this.consultationFee,
    this.availabilityStatus = 'Available',
    this.staffRole,
    this.joiningDate,
    this.allergies,
    this.chronicDiseases,
    this.insuranceProvider,
    this.insuranceNumber,
    this.designation,
    this.accessLevel,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        phoneNumber,
        role,
        profileCompletionStatus,
        status,
        department,
        qualification,
        metadata,
        firstName,
        lastName,
        dateOfBirth,
        age,
        gender,
        profileImage,
        address,
        emergencyContact,
        bloodGroup,
        maritalStatus,
        employeeId,
        patientId,
        medicalRegistrationNumber,
        experience,
        specialization,
        consultationFee,
        availabilityStatus,
        staffRole,
        joiningDate,
        allergies,
        chronicDiseases,
        insuranceProvider,
        insuranceNumber,
        designation,
        accessLevel,
      ];
}
