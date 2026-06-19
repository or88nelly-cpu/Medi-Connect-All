import 'dart:convert';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';
import 'package:medi_connect/features/patient/domain/repositories/patient_repository.dart';
import 'patient_registration_event.dart';
import 'patient_registration_state.dart';

class PatientRegistrationBloc
    extends Bloc<PatientRegistrationEvent, PatientRegistrationState> {
  final PatientRepository _patientRepository;

  PatientRegistrationBloc(this._patientRepository)
    : super(const PatientRegistrationState()) {
    on<GenerateUHIDEvent>(_onGenerateUHID);
    on<FetchAddressEvent>(_onFetchAddress);
    on<ToggleTabEvent>(_onToggleTab);
    on<SelectPhotoEvent>(_onSelectPhoto);
    on<UpdateFormFieldsEvent>(_onUpdateFormFields);
    on<SubmitFormEvent>(_onSubmitForm);

    // Auto-generate UHID on start
    add(GenerateUHIDEvent());
  }

  String _generateUUID() {
    final random = Random();
    String hex(int length) {
      return List.generate(
        length,
        (_) => random.nextInt(16).toRadixString(16),
      ).join();
    }

    return '${hex(8)}-${hex(4)}-4${hex(3)}-${(random.nextInt(4) + 8).toRadixString(16)}${hex(3)}-${hex(12)}';
  }

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
      emit(
        state.copyWith(
          pincodeFetchedAddress: 'Invalid pincode format (6 digits required)',
          isFetchingAddress: false,
        ),
      );
      return;
    }

    emit(state.copyWith(isFetchingAddress: true));

    // Simulate network latency
    await Future.delayed(const Duration(milliseconds: 600));

    String address = '';
    String place = '';

    switch (pin) {
      case '560001':
        place = 'MG Road';
        address = '#45, MG Road, Bengaluru, Karnataka - 560001';
        break;
      case '110001':
        place = 'Connaught Place';
        address = '#12, Connaught Place, New Delhi, Delhi - 110001';
        break;
      case '400001':
        place = 'Fort Area';
        address = '#88, Fort, Mumbai, Maharashtra - 400001';
        break;
      case '600001':
        place = 'George Town';
        address = '#3, George Town, Chennai, Tamil Nadu - 600001';
        break;
      default:
        place = 'Local Area';
        address = '#10, Main Street, Local District, State - $pin';
        break;
    }

    emit(
      state.copyWith(
        pincodeFetchedAddress: address,
        place: place,
        isFetchingAddress: false,
      ),
    );
  }

  void _onToggleTab(
    ToggleTabEvent event,
    Emitter<PatientRegistrationState> emit,
  ) {
    emit(state.copyWith(selectedTab: event.tab));
  }

  void _onSelectPhoto(
    SelectPhotoEvent event,
    Emitter<PatientRegistrationState> emit,
  ) {
    emit(state.copyWith(photoPath: event.photoPath));
  }

  void _onUpdateFormFields(
    UpdateFormFieldsEvent event,
    Emitter<PatientRegistrationState> emit,
  ) {
    emit(
      state.copyWith(
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
      ),
    );
  }

  Future<void> _onSubmitForm(
    SubmitFormEvent event,
    Emitter<PatientRegistrationState> emit,
  ) async {
    // 1. Validations
    if (state.firstName.trim().isEmpty) {
      emit(
        state.copyWith(
          status: PatientRegistrationStatus.failure,
          errorMessage: 'First name is required',
        ),
      );
      return;
    }
    if (state.lastName.trim().isEmpty) {
      emit(
        state.copyWith(
          status: PatientRegistrationStatus.failure,
          errorMessage: 'Last name is required',
        ),
      );
      return;
    }
    if (state.phone.trim().isEmpty) {
      emit(
        state.copyWith(
          status: PatientRegistrationStatus.failure,
          errorMessage: 'Phone number is required',
        ),
      );
      return;
    }
    if (state.dob.trim().isEmpty) {
      emit(
        state.copyWith(
          status: PatientRegistrationStatus.failure,
          errorMessage: 'Date of birth is required',
        ),
      );
      return;
    }
    if (state.pincodeFetchedAddress.trim().isEmpty) {
      emit(
        state.copyWith(
          status: PatientRegistrationStatus.failure,
          errorMessage: 'Please enter and fetch address from Pincode',
        ),
      );
      return;
    }
    if (state.place.trim().isEmpty) {
      emit(
        state.copyWith(
          status: PatientRegistrationStatus.failure,
          errorMessage: 'Place/Area is required',
        ),
      );
      return;
    }
    if (state.emergencyName.trim().isEmpty) {
      emit(
        state.copyWith(
          status: PatientRegistrationStatus.failure,
          errorMessage: 'Emergency contact name is required',
        ),
      );
      return;
    }
    if (state.emergencyPhone.trim().isEmpty) {
      emit(
        state.copyWith(
          status: PatientRegistrationStatus.failure,
          errorMessage: 'Emergency contact phone is required',
        ),
      );
      return;
    }

    emit(state.copyWith(status: PatientRegistrationStatus.loading));

    final patientUuid = _generateUUID();
    final patientName = '${state.firstName.trim()} ${state.lastName.trim()}';

    // Fallback email if optional is left empty
    final patientEmail = state.email.trim().isNotEmpty
        ? state.email.trim()
        : '${state.firstName.toLowerCase()}.${state.lastName.toLowerCase()}_temp@mediconnect.com';

    final patientModel = UserModel(
      id: patientUuid,
      email: patientEmail,
      name: patientName,
      firstName: state.firstName.trim(),
      lastName: state.lastName.trim(),
      phoneNumber: state.phone.trim(),
      dateOfBirth: state.dob.trim(),
      gender: state.sex,
      bloodGroup: state.bloodGroup,
      role: 'patient',
      profileCompletionStatus: true,
      status: 'Active',
      profileImage: state.photoPath.isNotEmpty ? state.photoPath : null,
      address: state.pincodeFetchedAddress,
      emergencyContact: jsonEncode({
        'name': state.emergencyName.trim(),
        'relationship': state.emergencyRelationship,
        'phone': state.emergencyPhone.trim(),
      }),
      insuranceProvider: state.insuranceProvider,
      insuranceNumber: state.insurancePolicyId.trim().isNotEmpty
          ? state.insurancePolicyId.trim()
          : null,
      metadata: {
        'gender_identity': state.genderIdentity,
        'place': state.place.trim(),
        'ward_num': state.wardNum.trim(),
        'insurance_valid_till': state.insuranceValidTill,
        'smoking': state.smoking,
        'alcohol': state.alcohol,
        'diet_type': state.dietType,
        'exercise': state.exercise,
        'allergies': state.allergies.trim(),
        'other_details': state.otherDetails.trim(),
      },
      patientId: state.generatedUHID,
    );

    final mrdRecord = {
      'patient_id': patientUuid,
      'patient_name': patientName,
      'specialty': 'Customer Care',
      'doctor_name': 'Customer Care Department',
      'invoice_number': 'REG-${state.generatedUHID.split('-').last}',
      'registration_fee': 200.00,
      'registration_payment_status': 'Pending',
      'prescription_notes':
          'Initial patient registration from Customer Care. '
          'UHID: ${state.generatedUHID}. '
          'Emergency Contact: ${state.emergencyName} (${state.emergencyRelationship}) - ${state.emergencyPhone}. '
          'Lifestyle: Smoking (${state.smoking}), Alcohol (${state.alcohol}), Diet (${state.dietType}), Exercise (${state.exercise}). '
          'Insurance: ${state.insuranceProvider} (ID: ${state.insurancePolicyId.isNotEmpty ? state.insurancePolicyId : "None"}). '
          'Allergies: ${state.allergies.isNotEmpty ? state.allergies : "None"}.',
      'recorded_at': DateTime.now().toIso8601String(),
    };

    final result = await _patientRepository.registerPatientAndSendToMRD(
      patientModel,
      mrdRecord,
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PatientRegistrationStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: PatientRegistrationStatus.success)),
    );
  }
}
