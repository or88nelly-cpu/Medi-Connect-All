import 'package:equatable/equatable.dart';

abstract class PatientRegistrationEvent extends Equatable {
  const PatientRegistrationEvent();

  @override
  List<Object?> get props => [];
}

// ─────────────────────────────────────────────────────────────
// Step navigation
// ─────────────────────────────────────────────────────────────

class StepNextRequested extends PatientRegistrationEvent {
  const StepNextRequested();
}

class StepBackRequested extends PatientRegistrationEvent {
  const StepBackRequested();
}

class SkipOnboardingRequested extends PatientRegistrationEvent {
  const SkipOnboardingRequested();
}

class StepJumpRequested extends PatientRegistrationEvent {
  final int step;
  const StepJumpRequested(this.step);

  @override
  List<Object?> get props => [step];
}

// ─────────────────────────────────────────────────────────────
// Initialization
// ─────────────────────────────────────────────────────────────

class PatientModeInitialized extends PatientRegistrationEvent {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String dob;
  final String address;
  final String sex;
  final String bloodGroup;
  final String insuranceProvider;
  final String insurancePolicyId;
  final String allergies;
  final String emergencyName;
  final String emergencyPhone;
  final String emergencyRelationship;
  final String wardNum;
  final String insuranceValidTill;
  final String genderIdentity;
  final String smoking;
  final String alcohol;
  final String dietType;
  final String exercise;
  final String otherDetails;

  const PatientModeInitialized({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.dob,
    required this.address,
    required this.sex,
    required this.bloodGroup,
    required this.insuranceProvider,
    required this.insurancePolicyId,
    required this.allergies,
    required this.emergencyName,
    required this.emergencyPhone,
    required this.emergencyRelationship,
    required this.wardNum,
    required this.insuranceValidTill,
    required this.genderIdentity,
    required this.smoking,
    required this.alcohol,
    required this.dietType,
    required this.exercise,
    required this.otherDetails,
  });

  @override
  List<Object?> get props => [userId, email, phone];
}

// ─────────────────────────────────────────────────────────────
// UHID & Address
// ─────────────────────────────────────────────────────────────

class GenerateUHIDEvent extends PatientRegistrationEvent {}

class FetchAddressEvent extends PatientRegistrationEvent {
  final String pincode;
  const FetchAddressEvent(this.pincode);

  @override
  List<Object?> get props => [pincode];
}

// ─────────────────────────────────────────────────────────────
// Photo & Tab
// ─────────────────────────────────────────────────────────────

class ToggleTabEvent extends PatientRegistrationEvent {
  final String tab; // 'front' or 'back'
  const ToggleTabEvent(this.tab);

  @override
  List<Object?> get props => [tab];
}

class SelectPhotoEvent extends PatientRegistrationEvent {
  final String photoPath;
  const SelectPhotoEvent(this.photoPath);

  @override
  List<Object?> get props => [photoPath];
}

// ─────────────────────────────────────────────────────────────
// Granular field update events
// Each event updates only the relevant subset of fields,
// so widgets don't need to pass the entire form state every time.
// ─────────────────────────────────────────────────────────────

class BasicInfoUpdated extends PatientRegistrationEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String dob;

  const BasicInfoUpdated({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.dob,
  });

  @override
  List<Object?> get props => [firstName, lastName, email, phone, dob];
}

class SexUpdated extends PatientRegistrationEvent {
  final String sex;
  const SexUpdated(this.sex);

  @override
  List<Object?> get props => [sex];
}

class AddressUpdated extends PatientRegistrationEvent {
  final String place;
  final String wardNum;

  const AddressUpdated({required this.place, required this.wardNum});

  @override
  List<Object?> get props => [place, wardNum];
}

class MedicalInfoUpdated extends PatientRegistrationEvent {
  final String bloodGroup;
  final String smoking;
  final String alcohol;
  final String dietType;
  final String exercise;
  final String allergies;
  final String otherDetails;

  const MedicalInfoUpdated({
    required this.bloodGroup,
    required this.smoking,
    required this.alcohol,
    required this.dietType,
    required this.exercise,
    required this.allergies,
    required this.otherDetails,
  });

  @override
  List<Object?> get props => [
    bloodGroup,
    smoking,
    alcohol,
    dietType,
    exercise,
    allergies,
  ];
}

class InsuranceUpdated extends PatientRegistrationEvent {
  final String insuranceProvider;
  final String insurancePolicyId;
  final String insuranceValidTill;

  const InsuranceUpdated({
    required this.insuranceProvider,
    required this.insurancePolicyId,
    required this.insuranceValidTill,
  });

  @override
  List<Object?> get props => [
    insuranceProvider,
    insurancePolicyId,
    insuranceValidTill,
  ];
}

class EmergencyContactUpdated extends PatientRegistrationEvent {
  final String emergencyName;
  final String emergencyRelationship;
  final String emergencyPhone;

  const EmergencyContactUpdated({
    required this.emergencyName,
    required this.emergencyRelationship,
    required this.emergencyPhone,
  });

  @override
  List<Object?> get props => [
    emergencyName,
    emergencyRelationship,
    emergencyPhone,
  ];
}

// ─────────────────────────────────────────────────────────────
// Submission
// ─────────────────────────────────────────────────────────────

class SubmitFormEvent extends PatientRegistrationEvent {
  const SubmitFormEvent();
}

class SubmitProfileUpdateEvent extends PatientRegistrationEvent {
  final String userId;
  const SubmitProfileUpdateEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateFormFieldsEvent extends PatientRegistrationEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String dob;
  final String sex;
  final String genderIdentity;
  final String bloodGroup;
  final String place;
  final String wardNum;
  final String insuranceProvider;
  final String insurancePolicyId;
  final String insuranceValidTill;
  final String smoking;
  final String alcohol;
  final String dietType;
  final String exercise;
  final String allergies;
  final String otherDetails;
  final String emergencyName;
  final String emergencyRelationship;
  final String emergencyPhone;

  const UpdateFormFieldsEvent({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.dob,
    required this.sex,
    required this.genderIdentity,
    required this.bloodGroup,
    required this.place,
    required this.wardNum,
    required this.insuranceProvider,
    required this.insurancePolicyId,
    required this.insuranceValidTill,
    required this.smoking,
    required this.alcohol,
    required this.dietType,
    required this.exercise,
    required this.allergies,
    required this.otherDetails,
    required this.emergencyName,
    required this.emergencyRelationship,
    required this.emergencyPhone,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    phone,
    dob,
    sex,
    genderIdentity,
    bloodGroup,
    place,
    wardNum,
    insuranceProvider,
    insurancePolicyId,
    insuranceValidTill,
    smoking,
    alcohol,
    dietType,
    exercise,
    allergies,
    otherDetails,
    emergencyName,
    emergencyRelationship,
    emergencyPhone,
  ];
}
