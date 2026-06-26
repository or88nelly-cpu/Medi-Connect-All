import 'package:equatable/equatable.dart';

abstract class PatientRegistrationEvent extends Equatable {
  const PatientRegistrationEvent();

  @override
  List<Object?> get props => [];
}

class GenerateUHIDEvent extends PatientRegistrationEvent {}

class FetchAddressEvent extends PatientRegistrationEvent {
  final String pincode;
  const FetchAddressEvent(this.pincode);

  @override
  List<Object?> get props => [pincode];
}

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

class SubmitFormEvent extends PatientRegistrationEvent {
  const SubmitFormEvent();
}

class SubmitProfileUpdateEvent extends PatientRegistrationEvent {
  final String userId;
  const SubmitProfileUpdateEvent(this.userId);

  @override
  List<Object?> get props => [userId];
}
