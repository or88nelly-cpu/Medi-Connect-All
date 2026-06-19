import 'package:equatable/equatable.dart';

enum PatientRegistrationStatus { initial, loading, success, failure }

class PatientRegistrationState extends Equatable {
  // Form Field Values
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

  // BLoC State variables
  final String generatedUHID;
  final String photoPath;
  final String selectedTab; // 'front' or 'back'
  final String pincodeFetchedAddress;
  final bool isFetchingAddress;
  final PatientRegistrationStatus status;
  final String errorMessage;

  const PatientRegistrationState({
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.dob = '',
    this.sex = 'Male',
    this.genderIdentity = 'Cisgender Male',
    this.bloodGroup = 'O+',
    this.place = '',
    this.wardNum = '',
    this.insuranceProvider = 'Star Health Insurance',
    this.insurancePolicyId = '',
    this.insuranceValidTill = '',
    this.smoking = 'No',
    this.alcohol = 'Occasionally',
    this.dietType = 'Non Vegetarian',
    this.exercise = 'Regular',
    this.allergies = '',
    this.otherDetails = '',
    this.emergencyName = '',
    this.emergencyRelationship = 'Wife',
    this.emergencyPhone = '',
    this.generatedUHID = '',
    this.photoPath = '',
    this.selectedTab = 'front',
    this.pincodeFetchedAddress = '',
    this.isFetchingAddress = false,
    this.status = PatientRegistrationStatus.initial,
    this.errorMessage = '',
  });

  PatientRegistrationState copyWith({
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? dob,
    String? sex,
    String? genderIdentity,
    String? bloodGroup,
    String? place,
    String? wardNum,
    String? insuranceProvider,
    String? insurancePolicyId,
    String? insuranceValidTill,
    String? smoking,
    String? alcohol,
    String? dietType,
    String? exercise,
    String? allergies,
    String? otherDetails,
    String? emergencyName,
    String? emergencyRelationship,
    String? emergencyPhone,
    String? generatedUHID,
    String? photoPath,
    String? selectedTab,
    String? pincodeFetchedAddress,
    bool? isFetchingAddress,
    PatientRegistrationStatus? status,
    String? errorMessage,
  }) {
    return PatientRegistrationState(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dob: dob ?? this.dob,
      sex: sex ?? this.sex,
      genderIdentity: genderIdentity ?? this.genderIdentity,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      place: place ?? this.place,
      wardNum: wardNum ?? this.wardNum,
      insuranceProvider: insuranceProvider ?? this.insuranceProvider,
      insurancePolicyId: insurancePolicyId ?? this.insurancePolicyId,
      insuranceValidTill: insuranceValidTill ?? this.insuranceValidTill,
      smoking: smoking ?? this.smoking,
      alcohol: alcohol ?? this.alcohol,
      dietType: dietType ?? this.dietType,
      exercise: exercise ?? this.exercise,
      allergies: allergies ?? this.allergies,
      otherDetails: otherDetails ?? this.otherDetails,
      emergencyName: emergencyName ?? this.emergencyName,
      emergencyRelationship: emergencyRelationship ?? this.emergencyRelationship,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      generatedUHID: generatedUHID ?? this.generatedUHID,
      photoPath: photoPath ?? this.photoPath,
      selectedTab: selectedTab ?? this.selectedTab,
      pincodeFetchedAddress: pincodeFetchedAddress ?? this.pincodeFetchedAddress,
      isFetchingAddress: isFetchingAddress ?? this.isFetchingAddress,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

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
        generatedUHID,
        photoPath,
        selectedTab,
        pincodeFetchedAddress,
        isFetchingAddress,
        status,
        errorMessage,
      ];
}
