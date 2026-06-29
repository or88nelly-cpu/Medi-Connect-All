import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/core/constants/app_enum.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/modules/management/patient_management/domain/repositories/patient_repository.dart';
import 'package:medi_connect/modules/management/customer_care/presentation/bloc/patient_registration_event.dart';
import 'package:medi_connect/modules/management/customer_care/presentation/bloc/patient_registration_state.dart';

class PatientRegistrationBloc
    extends Bloc<PatientRegistrationEvent, PatientRegistrationState> {
  static const int _totalSteps = 3;

  final PatientRepository _patientRepository;

  PatientRegistrationBloc(this._patientRepository)
    : super(const PatientRegistrationState()) {
    // ── Navigation ────────────────────────────────────────────
    on<StepNextRequested>(_onStepNext);
    on<StepBackRequested>(_onStepBack);
    on<StepJumpRequested>(_onStepJump);
    on<SkipOnboardingRequested>(_onSkipOnboarding);

    // ── Initialization ────────────────────────────────────────
    on<PatientModeInitialized>(_onPatientModeInitialized);

    // ── UHID & Address ────────────────────────────────────────
    on<GenerateUHIDEvent>(_onGenerateUHID);
    on<FetchAddressEvent>(_onFetchAddress);

    // ── Photo & Tab ───────────────────────────────────────────
    on<ToggleTabEvent>(_onToggleTab);
    on<SelectPhotoEvent>(_onSelectPhoto);

    // ── Granular field updates ────────────────────────────────
    on<BasicInfoUpdated>(_onBasicInfoUpdated);
    on<SexUpdated>(_onSexUpdated);
    on<AddressUpdated>(_onAddressUpdated);
    on<MedicalInfoUpdated>(_onMedicalInfoUpdated);
    on<InsuranceUpdated>(_onInsuranceUpdated);
    on<EmergencyContactUpdated>(_onEmergencyContactUpdated);
    on<UpdateFormFieldsEvent>(_onUpdateFormFields);

    // ── Submission ────────────────────────────────────────────
    on<SubmitFormEvent>(_onSubmitForm);
    on<SubmitProfileUpdateEvent>(_onSubmitProfileUpdate);

    // Auto-generate UHID on start
    add(GenerateUHIDEvent());
  }

  // ─────────────────────────────────────────────────────────────
  // STEP NAVIGATION
  // ─────────────────────────────────────────────────────────────

  Future<void> _onStepNext(
    StepNextRequested event,
    Emitter<PatientRegistrationState> emit,
  ) async {
    if (state.currentStep < _totalSteps) {
      final nextStep = state.currentStep + 1;
      emit(state.copyWith(
        currentStep: nextStep,
        status: PatientRegistrationStatus.initial,
      ));
      
      // Save progress to DB if in patient self-onboarding mode
      if (state.isPatientMode && state.userId.isNotEmpty) {
        await _saveProgress(nextStep);
      }
    }
  }

  void _onStepBack(
    StepBackRequested event,
    Emitter<PatientRegistrationState> emit,
  ) {
    if (state.currentStep > 1) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void _onStepJump(
    StepJumpRequested event,
    Emitter<PatientRegistrationState> emit,
  ) {
    emit(state.copyWith(currentStep: event.step));
  }

  Future<void> _onSkipOnboarding(
    SkipOnboardingRequested event,
    Emitter<PatientRegistrationState> emit,
  ) async {
    if (state.isPatientMode && state.userId.isNotEmpty) {
      // Save current progress step to database
      await _saveProgress(state.currentStep);
    }

    emit(state.copyWith(
      status: PatientRegistrationStatus.success,
      currentStep: 4, // Redirect to dashboard / success flow
    ));
  }

  Future<void> _saveProgress(int step) async {
    final patientModel = _buildPatientModel(
      id: state.userId,
      email: state.email,
      name: '${state.firstName} ${state.lastName}'.trim(),
      profileCompleted: false, // Incomplete until payment step finishes
      onboardingStep: step,
    );
    await _patientRepository.updatePatient(patientModel);
  }

  // ─────────────────────────────────────────────────────────────
  // INITIALIZATION
  // ─────────────────────────────────────────────────────────────

  void _onPatientModeInitialized(
    PatientModeInitialized event,
    Emitter<PatientRegistrationState> emit,
  ) {
    emit(
      state.copyWith(
        isPatientMode: true,
        userId: event.userId,
        firstName: event.firstName,
        lastName: event.lastName,
        email: event.email,
        phone: event.phone,
        dob: event.dob,
        pincodeFetchedAddress: event.address,
        place: event.address,
        sex: event.sex.isNotEmpty ? event.sex : 'Male',
        bloodGroup: event.bloodGroup.isNotEmpty ? event.bloodGroup : 'O+',
        insuranceProvider: event.insuranceProvider.isNotEmpty
            ? event.insuranceProvider
            : 'Star Health Insurance',
        insurancePolicyId: event.insurancePolicyId,
        allergies: event.allergies,
        emergencyName: event.emergencyName,
        emergencyPhone: event.emergencyPhone,
        emergencyRelationship: event.emergencyRelationship.isNotEmpty
            ? event.emergencyRelationship
            : 'Wife',
        wardNum: event.wardNum,
        insuranceValidTill: event.insuranceValidTill,
        genderIdentity: event.genderIdentity.isNotEmpty
            ? event.genderIdentity
            : 'Cisgender Male',
        smoking: event.smoking.isNotEmpty ? event.smoking : 'No',
        alcohol: event.alcohol.isNotEmpty ? event.alcohol : 'Occasionally',
        dietType:
            event.dietType.isNotEmpty ? event.dietType : 'Non Vegetarian',
        exercise: event.exercise.isNotEmpty ? event.exercise : 'Regular',
        otherDetails: event.otherDetails,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // UHID & ADDRESS
  // ─────────────────────────────────────────────────────────────

  void _onGenerateUHID(
    GenerateUHIDEvent event,
    Emitter<PatientRegistrationState> emit,
  ) {
    final random = Random();
    final numStr = (random.nextInt(9000000) + 1000000).toString();
    emit(state.copyWith(generatedUHID: 'CCH25-$numStr'));
  }

  Future<void> _onFetchAddress(
    FetchAddressEvent event,
    Emitter<PatientRegistrationState> emit,
  ) async {
    final pin = event.pincode.trim();
    if (pin.length != 6) {
      emit(state.copyWith(
        pincodeFetchedAddress: 'Invalid pincode format (6 digits required)',
        isFetchingAddress: false,
      ));
      return;
    }

    emit(state.copyWith(isFetchingAddress: true));
    await Future.delayed(const Duration(milliseconds: 600));

    final addressMap = {
      '560001': ('MG Road', '#45, MG Road, Bengaluru, Karnataka - 560001'),
      '110001': (
        'Connaught Place',
        '#12, Connaught Place, New Delhi, Delhi - 110001',
      ),
      '400001': ('Fort Area', '#88, Fort, Mumbai, Maharashtra - 400001'),
      '600001': (
        'George Town',
        '#3, George Town, Chennai, Tamil Nadu - 600001',
      ),
    };

    final result = addressMap[pin] ??
        ('Local Area', '#10, Main Street, Local District, State - $pin');

    emit(state.copyWith(
      pincodeFetchedAddress: result.$2,
      place: result.$1,
      isFetchingAddress: false,
    ));
  }

  // ─────────────────────────────────────────────────────────────
  // PHOTO & TAB
  // ─────────────────────────────────────────────────────────────

  void _onToggleTab(
    ToggleTabEvent event,
    Emitter<PatientRegistrationState> emit,
  ) => emit(state.copyWith(selectedTab: event.tab));

  void _onSelectPhoto(
    SelectPhotoEvent event,
    Emitter<PatientRegistrationState> emit,
  ) => emit(state.copyWith(photoPath: event.photoPath));

  // ─────────────────────────────────────────────────────────────
  // GRANULAR FIELD UPDATES
  // ─────────────────────────────────────────────────────────────

  void _onBasicInfoUpdated(
    BasicInfoUpdated event,
    Emitter<PatientRegistrationState> emit,
  ) => emit(state.copyWith(
    firstName: event.firstName,
    lastName: event.lastName,
    email: event.email,
    phone: event.phone,
    dob: event.dob,
  ));

  void _onSexUpdated(
    SexUpdated event,
    Emitter<PatientRegistrationState> emit,
  ) => emit(state.copyWith(sex: event.sex));

  void _onAddressUpdated(
    AddressUpdated event,
    Emitter<PatientRegistrationState> emit,
  ) => emit(state.copyWith(place: event.place, wardNum: event.wardNum));

  void _onMedicalInfoUpdated(
    MedicalInfoUpdated event,
    Emitter<PatientRegistrationState> emit,
  ) => emit(state.copyWith(
    bloodGroup: event.bloodGroup,
    smoking: event.smoking,
    alcohol: event.alcohol,
    dietType: event.dietType,
    exercise: event.exercise,
    allergies: event.allergies,
    otherDetails: event.otherDetails,
  ));

  void _onInsuranceUpdated(
    InsuranceUpdated event,
    Emitter<PatientRegistrationState> emit,
  ) => emit(state.copyWith(
    insuranceProvider: event.insuranceProvider,
    insurancePolicyId: event.insurancePolicyId,
    insuranceValidTill: event.insuranceValidTill,
  ));

  void _onEmergencyContactUpdated(
    EmergencyContactUpdated event,
    Emitter<PatientRegistrationState> emit,
  ) => emit(state.copyWith(
    emergencyName: event.emergencyName,
    emergencyRelationship: event.emergencyRelationship,
    emergencyPhone: event.emergencyPhone,
  ));

  void _onUpdateFormFields(
    UpdateFormFieldsEvent event,
    Emitter<PatientRegistrationState> emit,
  ) => emit(state.copyWith(
    firstName: event.firstName,
    lastName: event.lastName,
    email: event.email,
    phone: event.phone,
    dob: event.dob,
    sex: event.sex,
    genderIdentity: event.genderIdentity,
    bloodGroup: event.bloodGroup,
    place: event.place,
    wardNum: event.wardNum,
    insuranceProvider: event.insuranceProvider,
    insurancePolicyId: event.insurancePolicyId,
    insuranceValidTill: event.insuranceValidTill,
    smoking: event.smoking,
    alcohol: event.alcohol,
    dietType: event.dietType,
    exercise: event.exercise,
    allergies: event.allergies,
    otherDetails: event.otherDetails,
    emergencyName: event.emergencyName,
    emergencyRelationship: event.emergencyRelationship,
    emergencyPhone: event.emergencyPhone,
  ));

  // ─────────────────────────────────────────────────────────────
  // SUBMISSION
  // ─────────────────────────────────────────────────────────────

  Future<void> _onSubmitForm(
    SubmitFormEvent event,
    Emitter<PatientRegistrationState> emit,
  ) async {
    final validationError = _validateCommonFields();
    if (validationError != null) {
      emit(state.copyWith(
        status: PatientRegistrationStatus.failure,
        errorMessage: validationError,
      ));
      return;
    }

    emit(state.copyWith(status: PatientRegistrationStatus.loading));

    final patientUuid = _generateUUID();
    final patientName = '${state.firstName.trim()} ${state.lastName.trim()}';
    final patientEmail = state.email.trim().isNotEmpty
        ? state.email.trim()
        : '${state.firstName.toLowerCase()}.${state.lastName.toLowerCase()}_temp@mediconnect.com';

    final patientModel = _buildPatientModel(
      id: patientUuid,
      email: patientEmail,
      name: patientName,
    );

    final mrdRecord = {
      'patient_id': patientUuid,
      'patient_name': patientName,
      'specialty': 'Customer Care',
      'doctor_name': 'Customer Care Department',
      'invoice_number': 'REG-${state.generatedUHID.split('-').last}',
      'registration_fee': 200,
      'registration_payment_status': 'Pending',
      'prescription_notes':
          'Initial patient registration from Customer Care. '
          'UHID: ${state.generatedUHID}. '
          'Emergency Contact: ${state.emergencyName} (${state.emergencyRelationship}) - ${state.emergencyPhone}. '
          'Lifestyle: Smoking (${state.smoking}), Alcohol (${state.alcohol}), '
          'Diet (${state.dietType}), Exercise (${state.exercise}). '
          'Insurance: ${state.insuranceProvider} '
          '(ID: ${state.insurancePolicyId.isNotEmpty ? state.insurancePolicyId : "None"}). '
          'Allergies: ${state.allergies.isNotEmpty ? state.allergies : "None"}.',
      'recorded_at': DateTime.now().toIso8601String(),
    };

    final result = await _patientRepository.registerPatientAndSendToMRD(
      patientModel,
      mrdRecord,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        status: PatientRegistrationStatus.failure,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        status: PatientRegistrationStatus.success,
        currentStep: 4, // advance to success screen inside BLoC
      )),
    );
  }

  Future<void> _onSubmitProfileUpdate(
    SubmitProfileUpdateEvent event,
    Emitter<PatientRegistrationState> emit,
  ) async {
    final validationError = _validateCommonFields();
    if (validationError != null) {
      emit(state.copyWith(
        status: PatientRegistrationStatus.failure,
        errorMessage: validationError,
      ));
      return;
    }

    emit(state.copyWith(status: PatientRegistrationStatus.loading));

    final patientEmail = state.email.trim().isNotEmpty
        ? state.email.trim()
        : '${state.firstName.toLowerCase()}.${state.lastName.toLowerCase()}_temp@mediconnect.com';

    final patientModel = _buildPatientModel(
      id: event.userId,
      email: patientEmail,
      name: '${state.firstName.trim()} ${state.lastName.trim()}',
    );

    final result = await _patientRepository.updatePatient(patientModel);

    result.fold(
      (failure) => emit(state.copyWith(
        status: PatientRegistrationStatus.failure,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(
        status: PatientRegistrationStatus.success,
        currentStep: 4,
      )),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────────────────────

  /// Returns a validation error message or null if all required fields pass.
  String? _validateCommonFields() {
    if (state.firstName.trim().isEmpty) return 'First name is required';
    if (state.lastName.trim().isEmpty) return 'Last name is required';
    if (state.phone.trim().isEmpty) return 'Phone number is required';
    if (state.dob.trim().isEmpty) return 'Date of birth is required';
    if (state.pincodeFetchedAddress.trim().isEmpty) {
      return 'Please enter and fetch address from Pincode';
    }
    if (state.place.trim().isEmpty) return 'Place/Area is required';
    if (state.emergencyName.trim().isEmpty) {
      return 'Emergency contact name is required';
    }
    if (state.emergencyPhone.trim().isEmpty) {
      return 'Emergency contact phone is required';
    }
    return null;
  }

  UserModel _buildPatientModel({
    required String id,
    required String email,
    required String name,
    bool profileCompleted = true,
    int onboardingStep = 3,
  }) {
    final nameParts = name.trim().split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : state.firstName.trim();
    final lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : state.lastName.trim();

    return UserModel(
      id: id,
      email: email,
      firstName: firstName.isNotEmpty ? firstName : 'Patient',
      lastName: lastName.isNotEmpty ? lastName : 'User',
      phone: state.phone.trim(),
      dob: DateTime.tryParse(state.dob.trim()),
      gender: state.sex,
      bloodGroup: state.bloodGroup,
      role: UserRole.patient,
      status: 'Active',
      profilePhoto: state.photoPath.isNotEmpty ? state.photoPath : null,
    );
  }

  String _generateUUID() {
    final random = Random();
    String hex(int length) =>
        List.generate(length, (_) => random.nextInt(16).toRadixString(16))
            .join();
    return '${hex(8)}-${hex(4)}-4${hex(3)}-${(random.nextInt(4) + 8).toRadixString(16)}${hex(3)}-${hex(12)}';
  }
}
