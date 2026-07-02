import 'package:medi_connect/shared/auth/domain/entities/doctor_entity.dart';

class DoctorModel extends DoctorEntity {
  const DoctorModel({
    required super.id,
    required super.employeeId,
    super.licenseNumber,
    super.consultationFee,
    super.yearsOfExperience,
    super.digitalSignatureUrl,
    super.biography,
    super.isConsultant,
    super.isActive,
    super.createdAt,
    super.updatedAt,
    super.specialityId,
    super.doctorCode,
    super.departmentId,
    super.medicalRegistrationNumber,
    super.qualification,
    super.subSpeciality,
    super.experienceYears,
    super.followupFee,
    super.consultationDuration,
    super.languages,
    super.education,
    super.signatureUrl,
    super.profilePhoto,
    super.acceptsOnlineConsultation,
    super.isAvailable,
    super.userId,
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      id: json['id'] as String,
      employeeId: json['employee_id'] as String,
      licenseNumber: json['license_number'] as String?,
      consultationFee: json['consultation_fee'] != null
          ? (json['consultation_fee'] as num).toDouble()
          : 0.0,
      yearsOfExperience: json['years_of_experience'] as int? ?? 0,
      digitalSignatureUrl: json['digital_signature_url'] as String?,
      biography: json['biography'] as String?,
      isConsultant: json['is_consultant'] as bool? ?? false,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
      specialityId: json['speciality_id'] as String?,
      doctorCode: json['doctor_code'] as String?,
      departmentId: json['department_id'] as String?,
      medicalRegistrationNumber: json['medical_registration_number'] as String?,
      qualification: json['qualification'] as String?,
      subSpeciality: json['sub_speciality'] as String?,
      experienceYears: json['experience_years'] as int? ?? 0,
      followupFee: json['followup_fee'] != null
          ? (json['followup_fee'] as num).toDouble()
          : 0.0,
      consultationDuration: json['consultation_duration'] as int? ?? 15,
      languages: json['languages'] != null
          ? List<String>.from(json['languages'] as List)
          : null,
      education: json['education'] as String?,
      signatureUrl: json['signature_url'] as String?,
      profilePhoto: json['profile_photo'] as String?,
      acceptsOnlineConsultation: json['accepts_online_consultation'] as bool? ?? true,
      isAvailable: json['is_available'] as bool? ?? true,
      userId: json['user_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'employee_id': employeeId,
      'license_number': licenseNumber,
      'consultation_fee': consultationFee,
      'years_of_experience': yearsOfExperience,
      'digital_signature_url': digitalSignatureUrl,
      'biography': biography,
      'is_consultant': isConsultant,
      'is_active': isActive,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'speciality_id': specialityId,
      'doctor_code': doctorCode,
      'department_id': departmentId,
      'medical_registration_number': medicalRegistrationNumber,
      'qualification': qualification,
      'sub_speciality': subSpeciality,
      'experience_years': experienceYears,
      'followup_fee': followupFee,
      'consultation_duration': consultationDuration,
      'languages': languages,
      'education': education,
      'signature_url': signatureUrl,
      'profile_photo': profilePhoto,
      'accepts_online_consultation': acceptsOnlineConsultation,
      'is_available': isAvailable,
      'user_id': userId,
    };
  }

  factory DoctorModel.fromEntity(DoctorEntity entity) {
    return DoctorModel(
      id: entity.id,
      employeeId: entity.employeeId,
      licenseNumber: entity.licenseNumber,
      consultationFee: entity.consultationFee,
      yearsOfExperience: entity.yearsOfExperience,
      digitalSignatureUrl: entity.digitalSignatureUrl,
      biography: entity.biography,
      isConsultant: entity.isConsultant,
      isActive: entity.isActive,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      specialityId: entity.specialityId,
      doctorCode: entity.doctorCode,
      departmentId: entity.departmentId,
      medicalRegistrationNumber: entity.medicalRegistrationNumber,
      qualification: entity.qualification,
      subSpeciality: entity.subSpeciality,
      experienceYears: entity.experienceYears,
      followupFee: entity.followupFee,
      consultationDuration: entity.consultationDuration,
      languages: entity.languages,
      education: entity.education,
      signatureUrl: entity.signatureUrl,
      profilePhoto: entity.profilePhoto,
      acceptsOnlineConsultation: entity.acceptsOnlineConsultation,
      isAvailable: entity.isAvailable,
      userId: entity.userId,
    );
  }
}
