import 'package:equatable/equatable.dart';

class DoctorEntity extends Equatable {
  final String id;
  final String employeeId;
  final String? licenseNumber;
  final double consultationFee;
  final int yearsOfExperience;
  final String? digitalSignatureUrl;
  final String? biography;
  final bool isConsultant;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? specialityId;
  final String? doctorCode;
  final String? departmentId;
  final String? medicalRegistrationNumber;
  final String? qualification;
  final String? subSpeciality;
  final int experienceYears;
  final double followupFee;
  final int consultationDuration;
  final List<String>? languages;
  final String? education;
  final String? signatureUrl;
  final String? profilePhoto;
  final bool acceptsOnlineConsultation;
  final bool isAvailable;
  final String? userId;

  const DoctorEntity({
    required this.id,
    required this.employeeId,
    this.licenseNumber,
    this.consultationFee = 0.0,
    this.yearsOfExperience = 0,
    this.digitalSignatureUrl,
    this.biography,
    this.isConsultant = false,
    this.isActive = true,
    this.createdAt,
    this.updatedAt,
    this.specialityId,
    this.doctorCode,
    this.departmentId,
    this.medicalRegistrationNumber,
    this.qualification,
    this.subSpeciality,
    this.experienceYears = 0,
    this.followupFee = 0.0,
    this.consultationDuration = 15,
    this.languages,
    this.education,
    this.signatureUrl,
    this.profilePhoto,
    this.acceptsOnlineConsultation = true,
    this.isAvailable = true,
    this.userId,
  });

  @override
  List<Object?> get props => [
        id,
        employeeId,
        licenseNumber,
        consultationFee,
        yearsOfExperience,
        digitalSignatureUrl,
        biography,
        isConsultant,
        isActive,
        createdAt,
        updatedAt,
        specialityId,
        doctorCode,
        departmentId,
        medicalRegistrationNumber,
        qualification,
        subSpeciality,
        experienceYears,
        followupFee,
        consultationDuration,
        languages,
        education,
        signatureUrl,
        profilePhoto,
        acceptsOnlineConsultation,
        isAvailable,
        userId,
      ];
}
