import 'package:equatable/equatable.dart';

enum PatientRegistrationStatus { initial, loading, success, failure }

class PatientRegistrationState extends Equatable {
  // ── Navigation ────────────────────────────────────────────────
  final int currentStep; // 1-based: 1, 2, 3 | 4 = success screen
  final bool isPatientMode; // true when patient self-onboarding
  final String userId; // Unique identifier of the logged-in patient

  // ── Basic Info (Step 1) ───────────────────────────────────────
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String dob;
  final String sex;

  // ── Address (Step 1 continued) ────────────────────────────────
  final String place;
  final String wardNum;
  final String pincodeFetchedAddress;
  final bool isFetchingAddress;

  // ── Medical Info (Step 2) ─────────────────────────────────────
  final String genderIdentity;
  final String bloodGroup;
  final String smoking;
  final String alcohol;
  final String dietType;
  final String exercise;
  final String allergies;
  final String otherDetails;

  // ── Insurance (Step 2) ────────────────────────────────────────
  final String insuranceProvider;
  final String insurancePolicyId;
  final String insuranceValidTill;

  // ── Emergency Contact (Step 2) ────────────────────────────────
  final String emergencyName;
  final String emergencyRelationship;
  final String emergencyPhone;

  // ── Photo & UHID ──────────────────────────────────────────────
  final String generatedUHID;
  final String photoPath;
  final String selectedTab; // 'front' | 'back'

  // ── BLoC Status ───────────────────────────────────────────────
  final PatientRegistrationStatus status;
  final String errorMessage;

  const PatientRegistrationState({
    this.currentStep = 1,
    this.isPatientMode = false,
    this.userId = '',
    this.firstName = '',
    this.lastName = '',
    this.email = '',
    this.phone = '',
    this.dob = '',
    this.sex = 'Male',
    this.place = '',
    this.wardNum = '',
    this.pincodeFetchedAddress = '',
    this.isFetchingAddress = false,
    this.genderIdentity = 'Cisgender Male',
    this.bloodGroup = 'O+',
    this.smoking = 'No',
    this.alcohol = 'Occasionally',
    this.dietType = 'Non Vegetarian',
    this.exercise = 'Regular',
    this.allergies = '',
    this.otherDetails = '',
    this.insuranceProvider = 'Star Health Insurance',
    this.insurancePolicyId = '',
    this.insuranceValidTill = '',
    this.emergencyName = '',
    this.emergencyRelationship = 'Wife',
    this.emergencyPhone = '',
    this.generatedUHID = '',
    this.photoPath = '',
    this.selectedTab = 'front',
    this.status = PatientRegistrationStatus.initial,
    this.errorMessage = '',
  });

  PatientRegistrationState copyWith({
    int? currentStep,
    bool? isPatientMode,
    String? userId,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? dob,
    String? sex,
    String? place,
    String? wardNum,
    String? pincodeFetchedAddress,
    bool? isFetchingAddress,
    String? genderIdentity,
    String? bloodGroup,
    String? smoking,
    String? alcohol,
    String? dietType,
    String? exercise,
    String? allergies,
    String? otherDetails,
    String? insuranceProvider,
    String? insurancePolicyId,
    String? insuranceValidTill,
    String? emergencyName,
    String? emergencyRelationship,
    String? emergencyPhone,
    String? generatedUHID,
    String? photoPath,
    String? selectedTab,
    PatientRegistrationStatus? status,
    String? errorMessage,
  }) {
    return PatientRegistrationState(
      currentStep: currentStep ?? this.currentStep,
      isPatientMode: isPatientMode ?? this.isPatientMode,
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      dob: dob ?? this.dob,
      sex: sex ?? this.sex,
      place: place ?? this.place,
      wardNum: wardNum ?? this.wardNum,
      pincodeFetchedAddress:
          pincodeFetchedAddress ?? this.pincodeFetchedAddress,
      isFetchingAddress: isFetchingAddress ?? this.isFetchingAddress,
      genderIdentity: genderIdentity ?? this.genderIdentity,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      smoking: smoking ?? this.smoking,
      alcohol: alcohol ?? this.alcohol,
      dietType: dietType ?? this.dietType,
      exercise: exercise ?? this.exercise,
      allergies: allergies ?? this.allergies,
      otherDetails: otherDetails ?? this.otherDetails,
      insuranceProvider: insuranceProvider ?? this.insuranceProvider,
      insurancePolicyId: insurancePolicyId ?? this.insurancePolicyId,
      insuranceValidTill: insuranceValidTill ?? this.insuranceValidTill,
      emergencyName: emergencyName ?? this.emergencyName,
      emergencyRelationship:
          emergencyRelationship ?? this.emergencyRelationship,
      emergencyPhone: emergencyPhone ?? this.emergencyPhone,
      generatedUHID: generatedUHID ?? this.generatedUHID,
      photoPath: photoPath ?? this.photoPath,
      selectedTab: selectedTab ?? this.selectedTab,
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    currentStep,
    isPatientMode,
    userId,
    firstName,
    lastName,
    email,
    phone,
    dob,
    sex,
    place,
    wardNum,
    pincodeFetchedAddress,
    isFetchingAddress,
    genderIdentity,
    bloodGroup,
    smoking,
    alcohol,
    dietType,
    exercise,
    allergies,
    otherDetails,
    insuranceProvider,
    insurancePolicyId,
    insuranceValidTill,
    emergencyName,
    emergencyRelationship,
    emergencyPhone,
    generatedUHID,
    photoPath,
    selectedTab,
    status,
    errorMessage,
  ];
}
