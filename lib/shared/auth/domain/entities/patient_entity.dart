import 'package:equatable/equatable.dart';

class PatientEntity extends Equatable {
  final String id;
  final String? userId;
  final String? hospitalId;
  final String? patientNo;
  final DateTime? registrationDate;
  final String? title;
  final String? maritalStatus;
  final String? occupation;
  final String? nationality;
  final double? height;
  final double? weight;
  final String? guardianName;
  final String? guardianRelationship;
  final String? emergencyContactName;
  final String? emergencyContactNumber;
  final String? referredBy;
  final String? registrationSource;
  final String? remarks;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? address;
  final int? age;
  final String? allergies;
  final String? bloodGroup;
  final String? chronicDiseases;
  final DateTime? dateOfBirth;
  final String? emergencyContact;
  final String? gender;
  final String? insuranceNumber;
  final String? insuranceProvider;
  final String? patientId;

  const PatientEntity({
    required this.id,
    this.userId,
    this.hospitalId,
    this.patientNo,
    this.registrationDate,
    this.title,
    this.maritalStatus,
    this.occupation,
    this.nationality,
    this.height,
    this.weight,
    this.guardianName,
    this.guardianRelationship,
    this.emergencyContactName,
    this.emergencyContactNumber,
    this.referredBy,
    this.registrationSource,
    this.remarks,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.address,
    this.age,
    this.allergies,
    this.bloodGroup,
    this.chronicDiseases,
    this.dateOfBirth,
    this.emergencyContact,
    this.gender,
    this.insuranceNumber,
    this.insuranceProvider,
    this.patientId,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        hospitalId,
        patientNo,
        registrationDate,
        title,
        maritalStatus,
        occupation,
        nationality,
        height,
        weight,
        guardianName,
        guardianRelationship,
        emergencyContactName,
        emergencyContactNumber,
        referredBy,
        registrationSource,
        remarks,
        isActive,
        createdAt,
        updatedAt,
        address,
        age,
        allergies,
        bloodGroup,
        chronicDiseases,
        dateOfBirth,
        emergencyContact,
        gender,
        insuranceNumber,
        insuranceProvider,
        patientId,
      ];
}
