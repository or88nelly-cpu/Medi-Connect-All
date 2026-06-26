import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/routes/route_names.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/core/services/secure_storage_service.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';

// Bloc
import 'package:medi_connect/modules/management/customer_care/presentation/bloc/patient_registration_bloc.dart';
import 'package:medi_connect/modules/management/customer_care/presentation/bloc/patient_registration_event.dart';
import 'package:medi_connect/modules/management/customer_care/presentation/bloc/patient_registration_state.dart';
import 'package:medi_connect/modules/management/patient_management/domain/repositories/patient_repository.dart';

// Widgets
import 'package:medi_connect/modules/staff/patient/widgets/registration_progress_header.dart';
import 'package:medi_connect/modules/staff/patient/widgets/basic_info_step.dart';
import 'package:medi_connect/modules/staff/patient/widgets/additional_info_step.dart';
import 'package:medi_connect/modules/staff/patient/widgets/review_confirm_step.dart';
import 'package:medi_connect/modules/staff/patient/widgets/success_step.dart';

class StaffPatientRegistration extends StatefulWidget {
  const StaffPatientRegistration({super.key});

  @override
  State<StaffPatientRegistration> createState() =>
      _StaffPatientRegistrationState();
}

class _StaffPatientRegistrationState extends State<StaffPatientRegistration> {
  // Form Controllers
  final _firstNameCtrl = TextEditingController();
  final _lastNameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _dobCtrl = TextEditingController();
  final _pincodeCtrl = TextEditingController();
  final _placeCtrl = TextEditingController();
  final _wardCtrl = TextEditingController();
  final _policyIdCtrl = TextEditingController();
  final _validTillCtrl = TextEditingController();
  final _allergiesCtrl = TextEditingController();
  final _otherDetailsCtrl = TextEditingController();
  final _emergencyNameCtrl = TextEditingController();
  final _emergencyPhoneCtrl = TextEditingController();
  final _alternatePhoneCtrl = TextEditingController();

  final _step1FormKey = GlobalKey<FormState>();
  final _step2FormKey = GlobalKey<FormState>();

  final ValueNotifier<int> _currentStep = ValueNotifier<int>(1);
  final int totalSteps = 3;

  late PatientRegistrationBloc _bloc;
  bool _isPatientMode = false;

  final List<String> stepTitles = [
    "Basic Information",
    "Additional Information",
    "Review & Confirm",
  ];

  @override
  void initState() {
    super.initState();
    _bloc = PatientRegistrationBloc(GetIt.I<PatientRepository>());

    // Add field change listeners to sync with bloc state
    _firstNameCtrl.addListener(_onFieldsChanged);
    _lastNameCtrl.addListener(_onFieldsChanged);
    _emailCtrl.addListener(_onFieldsChanged);
    _phoneCtrl.addListener(_onFieldsChanged);
    _dobCtrl.addListener(_onFieldsChanged);
    _pincodeCtrl.addListener(_onFieldsChanged);
    _placeCtrl.addListener(_onFieldsChanged);
    _wardCtrl.addListener(_onFieldsChanged);
    _policyIdCtrl.addListener(_onFieldsChanged);
    _validTillCtrl.addListener(_onFieldsChanged);
    _allergiesCtrl.addListener(_onFieldsChanged);
    _otherDetailsCtrl.addListener(_onFieldsChanged);
    _emergencyNameCtrl.addListener(_onFieldsChanged);
    _emergencyPhoneCtrl.addListener(_onFieldsChanged);

    // Initial load for patient check
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAndSetupPatientMode();
    });
  }

  void _checkAndSetupPatientMode() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated && authState.user.role == 'patient') {
      setState(() {
        _isPatientMode = true;
      });

      final user = authState.user;

      // Split Full name to First/Last if separate is not present
      String firstName = user.firstName ?? '';
      String lastName = user.lastName ?? '';
      if (firstName.isEmpty && lastName.isEmpty && user.name != null) {
        final parts = user.name!.trim().split(' ');
        if (parts.isNotEmpty) firstName = parts[0];
        if (parts.length > 1) lastName = parts.sublist(1).join(' ');
      }

      _firstNameCtrl.text = firstName;
      _lastNameCtrl.text = lastName;
      _emailCtrl.text = user.email;
      _phoneCtrl.text = user.phoneNumber ?? '';
      _dobCtrl.text = user.dateOfBirth ?? '';
      _placeCtrl.text = user.address ?? '';

      // Set other fields from metadata
      final meta = user.metadata ?? {};
      _wardCtrl.text = meta['ward_num'] ?? '';
      _policyIdCtrl.text = user.insuranceNumber ?? '';
      _validTillCtrl.text = meta['insurance_valid_till'] ?? '';
      _allergiesCtrl.text = meta['allergies'] ?? '';
      _otherDetailsCtrl.text = meta['other_details'] ?? '';

      // Emergency details
      if (user.emergencyContact != null) {
        try {
          final ec = jsonDecode(user.emergencyContact!);
          _emergencyNameCtrl.text = ec['name'] ?? '';
          _emergencyPhoneCtrl.text = ec['phone'] ?? '';
        } catch (_) {}
      }

      // Sync state with BLoC
      _bloc.add(
        UpdateFormFieldsEvent(
          firstName: firstName,
          lastName: lastName,
          email: user.email,
          phone: user.phoneNumber ?? '',
          dob: user.dateOfBirth ?? '',
          sex: user.gender ?? 'Male',
          genderIdentity: meta['gender_identity'] ?? 'Cisgender Male',
          bloodGroup: user.bloodGroup ?? 'O+',
          place: user.address ?? '',
          wardNum: meta['ward_num'] ?? '',
          insuranceProvider: user.insuranceProvider ?? 'Star Health Insurance',
          insurancePolicyId: user.insuranceNumber ?? '',
          insuranceValidTill: meta['insurance_valid_till'] ?? '',
          smoking: meta['smoking'] ?? 'No',
          alcohol: meta['alcohol'] ?? 'Occasionally',
          dietType: meta['diet_type'] ?? 'Non Vegetarian',
          exercise: meta['exercise'] ?? 'Regular',
          allergies: meta['allergies'] ?? '',
          otherDetails: meta['other_details'] ?? '',
          emergencyName: _emergencyNameCtrl.text,
          emergencyRelationship: meta['emergency_relationship'] ?? 'Wife',
          emergencyPhone: _emergencyPhoneCtrl.text,
        ),
      );
    }
  }

  void _onFieldsChanged() {
    _bloc.add(
      UpdateFormFieldsEvent(
        firstName: _firstNameCtrl.text,
        lastName: _lastNameCtrl.text,
        email: _emailCtrl.text,
        phone: _phoneCtrl.text,
        dob: _dobCtrl.text,
        sex: _bloc.state.sex,
        genderIdentity: _bloc.state.genderIdentity,
        bloodGroup: _bloc.state.bloodGroup,
        place: _placeCtrl.text,
        wardNum: _wardCtrl.text,
        insuranceProvider: _bloc.state.insuranceProvider,
        insurancePolicyId: _policyIdCtrl.text,
        insuranceValidTill: _validTillCtrl.text,
        smoking: _bloc.state.smoking,
        alcohol: _bloc.state.alcohol,
        dietType: _bloc.state.dietType,
        exercise: _bloc.state.exercise,
        allergies: _allergiesCtrl.text,
        otherDetails: _otherDetailsCtrl.text,
        emergencyName: _emergencyNameCtrl.text,
        emergencyRelationship: _bloc.state.emergencyRelationship,
        emergencyPhone: _emergencyPhoneCtrl.text,
      ),
    );
  }

  @override
  void dispose() {
    _firstNameCtrl.dispose();
    _lastNameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _dobCtrl.dispose();
    _pincodeCtrl.dispose();
    _placeCtrl.dispose();
    _wardCtrl.dispose();
    _policyIdCtrl.dispose();
    _validTillCtrl.dispose();
    _allergiesCtrl.dispose();
    _otherDetailsCtrl.dispose();
    _emergencyNameCtrl.dispose();
    _emergencyPhoneCtrl.dispose();
    _alternatePhoneCtrl.dispose();
    _currentStep.dispose();
    _bloc.close();
    super.dispose();
  }

  void _onSubmit() {
    if (_isPatientMode) {
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated) {
        _bloc.add(SubmitProfileUpdateEvent(authState.user.id));
      }
    } else {
      _bloc.add(const SubmitFormEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider.value(
      value: _bloc,
      child: BlocListener<PatientRegistrationBloc, PatientRegistrationState>(
        listener: (context, state) async {
          // If address is fetched from pincode, update place controller
          if (state.place.isNotEmpty && _placeCtrl.text.isEmpty) {
            _placeCtrl.text = state.place;
          }

          if (state.status == PatientRegistrationStatus.success) {
            if (_isPatientMode) {
              // Complete profile: update storage key and dispatch success
              final storage = GetIt.I<SecureStorageService>();
              await storage.write('profile_completion_status', 'true');

              // Dispatch UserUpdated to AuthBloc
              final authState = context.read<AuthBloc>().state;
              if (authState is Authenticated) {
                final user = authState.user;
                final updatedUser = UserModel(
                  id: user.id,
                  email: user.email,
                  name: '${_firstNameCtrl.text.trim()} ${_lastNameCtrl.text.trim()}',
                  firstName: _firstNameCtrl.text.trim(),
                  lastName: _lastNameCtrl.text.trim(),
                  phoneNumber: _phoneCtrl.text.trim(),
                  dateOfBirth: _dobCtrl.text.trim(),
                  gender: state.sex,
                  bloodGroup: state.bloodGroup,
                  role: 'patient',
                  profileCompletionStatus: true,
                  status: 'Active',
                  profileImage: state.photoPath.isNotEmpty ? state.photoPath : user.profileImage,
                  address: state.pincodeFetchedAddress,
                  insuranceProvider: state.insuranceProvider,
                  insuranceNumber: _policyIdCtrl.text.trim().isNotEmpty ? _policyIdCtrl.text.trim() : null,
                  emergencyContact: jsonEncode({
                    'name': _emergencyNameCtrl.text.trim(),
                    'relationship': state.emergencyRelationship,
                    'phone': _emergencyPhoneCtrl.text.trim(),
                  }),
                  metadata: {
                    'gender_identity': state.genderIdentity,
                    'place': _placeCtrl.text.trim(),
                    'ward_num': _wardCtrl.text.trim(),
                    'insurance_valid_till': _validTillCtrl.text.trim(),
                    'smoking': state.smoking,
                    'alcohol': state.alcohol,
                    'diet_type': state.dietType,
                    'exercise': state.exercise,
                    'allergies': _allergiesCtrl.text.trim(),
                    'other_details': _otherDetailsCtrl.text.trim(),
                  },
                  patientId: state.generatedUHID,
                );
                context.read<AuthBloc>().add(UserUpdated(updatedUser));
                
                // Show success screen first before redirecting
                _currentStep.value = 4;
              }
            } else {
              // Staff Mode: Show success screen (Step 4)
              _currentStep.value = 4;
            }
          } else if (state.status == PatientRegistrationStatus.failure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: ValueListenableBuilder<int>(
          valueListenable: _currentStep,
          builder: (context, currentStep, child) {
            return PopScope(
              canPop: currentStep == 1 || currentStep == 4,
              onPopInvokedWithResult: (didPop, result) {
                if (didPop) return;
                if (currentStep > 1 && currentStep <= 3) {
                  _currentStep.value--;
                }
              },
              child: CustomScaffold(
                customAppbar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: currentStep == 4
                      ? const SizedBox.shrink()
                      : IconButton(
                          icon: Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppColors.textPrimary(context),
                            size: 18.r,
                          ),
                          onPressed: () {
                            if (currentStep > 1) {
                              _currentStep.value--;
                            } else {
                              context.pop();
                            }
                          },
                        ),
                  title: Text(
                    _isPatientMode ? "Complete Your Profile" : "Patient Registration",
                    style: AppTextStyles.titleSmall.copyWith(
                      color: AppColors.textPrimary(context),
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
                  centerTitle: true,
                ),
                body: BlocBuilder<PatientRegistrationBloc, PatientRegistrationState>(
                  builder: (context, state) {
                    return SafeArea(
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView(
                              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                              children: [
                                // Stepper progress header (not shown on success step 4)
                                if (currentStep < 4) ...[
                                  RegistrationProgressHeader(
                                    currentStep: currentStep,
                                    totalSteps: totalSteps,
                                    stepTitle: stepTitles[currentStep - 1],
                                    isPatientMode: _isPatientMode,
                                  ),
                                  SizedBox(height: 20.h),
                                ],

                                // Wizard step screens
                                if (currentStep == 1)
                                  BasicInfoStep(
                                    formKey: _step1FormKey,
                                    firstNameCtrl: _firstNameCtrl,
                                    lastNameCtrl: _lastNameCtrl,
                                    emailCtrl: _emailCtrl,
                                    phoneCtrl: _phoneCtrl,
                                    dobCtrl: _dobCtrl,
                                    selectedSex: state.sex,
                                    onSexChanged: (val) => _bloc.add(
                                      UpdateFormFieldsEvent(
                                        firstName: _firstNameCtrl.text,
                                        lastName: _lastNameCtrl.text,
                                        email: _emailCtrl.text,
                                        phone: _phoneCtrl.text,
                                        dob: _dobCtrl.text,
                                        sex: val,
                                        genderIdentity: state.genderIdentity,
                                        bloodGroup: state.bloodGroup,
                                        place: _placeCtrl.text,
                                        wardNum: _wardCtrl.text,
                                        insuranceProvider: state.insuranceProvider,
                                        insurancePolicyId: _policyIdCtrl.text,
                                        insuranceValidTill: _validTillCtrl.text,
                                        smoking: state.smoking,
                                        alcohol: state.alcohol,
                                        dietType: state.dietType,
                                        exercise: state.exercise,
                                        allergies: _allergiesCtrl.text,
                                        otherDetails: _otherDetailsCtrl.text,
                                        emergencyName: _emergencyNameCtrl.text,
                                        emergencyRelationship: state.emergencyRelationship,
                                        emergencyPhone: _emergencyPhoneCtrl.text,
                                      ),
                                    ),
                                    pincodeCtrl: _pincodeCtrl,
                                    placeCtrl: _placeCtrl,
                                    wardCtrl: _wardCtrl,
                                    fetchedAddress: state.pincodeFetchedAddress,
                                    isFetchingAddress: state.isFetchingAddress,
                                    onFetchAddress: (pin) => _bloc.add(FetchAddressEvent(pin)),
                                  )
                                else if (currentStep == 2)
                                  AdditionalInfoStep(
                                    formKey: _step2FormKey,
                                    policyIdCtrl: _policyIdCtrl,
                                    validTillCtrl: _validTillCtrl,
                                    selectedProvider: state.insuranceProvider,
                                    onProviderChanged: (val) => _bloc.add(
                                      UpdateFormFieldsEvent(
                                        firstName: _firstNameCtrl.text,
                                        lastName: _lastNameCtrl.text,
                                        email: _emailCtrl.text,
                                        phone: _phoneCtrl.text,
                                        dob: _dobCtrl.text,
                                        sex: state.sex,
                                        genderIdentity: state.genderIdentity,
                                        bloodGroup: state.bloodGroup,
                                        place: _placeCtrl.text,
                                        wardNum: _wardCtrl.text,
                                        insuranceProvider: val,
                                        insurancePolicyId: _policyIdCtrl.text,
                                        insuranceValidTill: _validTillCtrl.text,
                                        smoking: state.smoking,
                                        alcohol: state.alcohol,
                                        dietType: state.dietType,
                                        exercise: state.exercise,
                                        allergies: _allergiesCtrl.text,
                                        otherDetails: _otherDetailsCtrl.text,
                                        emergencyName: _emergencyNameCtrl.text,
                                        emergencyRelationship: state.emergencyRelationship,
                                        emergencyPhone: _emergencyPhoneCtrl.text,
                                      ),
                                    ),
                                    bloodGroup: state.bloodGroup,
                                    onBloodGroupChanged: (val) => _bloc.add(
                                      UpdateFormFieldsEvent(
                                        firstName: _firstNameCtrl.text,
                                        lastName: _lastNameCtrl.text,
                                        email: _emailCtrl.text,
                                        phone: _phoneCtrl.text,
                                        dob: _dobCtrl.text,
                                        sex: state.sex,
                                        genderIdentity: state.genderIdentity,
                                        bloodGroup: val,
                                        place: _placeCtrl.text,
                                        wardNum: _wardCtrl.text,
                                        insuranceProvider: state.insuranceProvider,
                                        insurancePolicyId: _policyIdCtrl.text,
                                        insuranceValidTill: _validTillCtrl.text,
                                        smoking: state.smoking,
                                        alcohol: state.alcohol,
                                        dietType: state.dietType,
                                        exercise: state.exercise,
                                        allergies: _allergiesCtrl.text,
                                        otherDetails: _otherDetailsCtrl.text,
                                        emergencyName: _emergencyNameCtrl.text,
                                        emergencyRelationship: state.emergencyRelationship,
                                        emergencyPhone: _emergencyPhoneCtrl.text,
                                      ),
                                    ),
                                    smoking: state.smoking,
                                    onSmokingChanged: (val) => _bloc.add(
                                      UpdateFormFieldsEvent(
                                        firstName: _firstNameCtrl.text,
                                        lastName: _lastNameCtrl.text,
                                        email: _emailCtrl.text,
                                        phone: _phoneCtrl.text,
                                        dob: _dobCtrl.text,
                                        sex: state.sex,
                                        genderIdentity: state.genderIdentity,
                                        bloodGroup: state.bloodGroup,
                                        place: _placeCtrl.text,
                                        wardNum: _wardCtrl.text,
                                        insuranceProvider: state.insuranceProvider,
                                        insurancePolicyId: _policyIdCtrl.text,
                                        insuranceValidTill: _validTillCtrl.text,
                                        smoking: val,
                                        alcohol: state.alcohol,
                                        dietType: state.dietType,
                                        exercise: state.exercise,
                                        allergies: _allergiesCtrl.text,
                                        otherDetails: _otherDetailsCtrl.text,
                                        emergencyName: _emergencyNameCtrl.text,
                                        emergencyRelationship: state.emergencyRelationship,
                                        emergencyPhone: _emergencyPhoneCtrl.text,
                                      ),
                                    ),
                                    alcohol: state.alcohol,
                                    onAlcoholChanged: (val) => _bloc.add(
                                      UpdateFormFieldsEvent(
                                        firstName: _firstNameCtrl.text,
                                        lastName: _lastNameCtrl.text,
                                        email: _emailCtrl.text,
                                        phone: _phoneCtrl.text,
                                        dob: _dobCtrl.text,
                                        sex: state.sex,
                                        genderIdentity: state.genderIdentity,
                                        bloodGroup: state.bloodGroup,
                                        place: _placeCtrl.text,
                                        wardNum: _wardCtrl.text,
                                        insuranceProvider: state.insuranceProvider,
                                        insurancePolicyId: _policyIdCtrl.text,
                                        insuranceValidTill: _validTillCtrl.text,
                                        smoking: state.smoking,
                                        alcohol: val,
                                        dietType: state.dietType,
                                        exercise: state.exercise,
                                        allergies: _allergiesCtrl.text,
                                        otherDetails: _otherDetailsCtrl.text,
                                        emergencyName: _emergencyNameCtrl.text,
                                        emergencyRelationship: state.emergencyRelationship,
                                        emergencyPhone: _emergencyPhoneCtrl.text,
                                      ),
                                    ),
                                    dietType: state.dietType,
                                    onDietTypeChanged: (val) => _bloc.add(
                                      UpdateFormFieldsEvent(
                                        firstName: _firstNameCtrl.text,
                                        lastName: _lastNameCtrl.text,
                                        email: _emailCtrl.text,
                                        phone: _phoneCtrl.text,
                                        dob: _dobCtrl.text,
                                        sex: state.sex,
                                        genderIdentity: state.genderIdentity,
                                        bloodGroup: state.bloodGroup,
                                        place: _placeCtrl.text,
                                        wardNum: _wardCtrl.text,
                                        insuranceProvider: state.insuranceProvider,
                                        insurancePolicyId: _policyIdCtrl.text,
                                        insuranceValidTill: _validTillCtrl.text,
                                        smoking: state.smoking,
                                        alcohol: state.alcohol,
                                        dietType: val,
                                        exercise: state.exercise,
                                        allergies: _allergiesCtrl.text,
                                        otherDetails: _otherDetailsCtrl.text,
                                        emergencyName: _emergencyNameCtrl.text,
                                        emergencyRelationship: state.emergencyRelationship,
                                        emergencyPhone: _emergencyPhoneCtrl.text,
                                      ),
                                    ),
                                    exercise: state.exercise,
                                    onExerciseChanged: (val) => _bloc.add(
                                      UpdateFormFieldsEvent(
                                        firstName: _firstNameCtrl.text,
                                        lastName: _lastNameCtrl.text,
                                        email: _emailCtrl.text,
                                        phone: _phoneCtrl.text,
                                        dob: _dobCtrl.text,
                                        sex: state.sex,
                                        genderIdentity: state.genderIdentity,
                                        bloodGroup: state.bloodGroup,
                                        place: _placeCtrl.text,
                                        wardNum: _wardCtrl.text,
                                        insuranceProvider: state.insuranceProvider,
                                        insurancePolicyId: _policyIdCtrl.text,
                                        insuranceValidTill: _validTillCtrl.text,
                                        smoking: state.smoking,
                                        alcohol: state.alcohol,
                                        dietType: state.dietType,
                                        exercise: val,
                                        allergies: _allergiesCtrl.text,
                                        otherDetails: _otherDetailsCtrl.text,
                                        emergencyName: _emergencyNameCtrl.text,
                                        emergencyRelationship: state.emergencyRelationship,
                                        emergencyPhone: _emergencyPhoneCtrl.text,
                                      ),
                                    ),
                                    allergiesCtrl: _allergiesCtrl,
                                    otherDetailsCtrl: _otherDetailsCtrl,
                                    emergencyNameCtrl: _emergencyNameCtrl,
                                    emergencyPhoneCtrl: _emergencyPhoneCtrl,
                                    emergencyRelationship: state.emergencyRelationship,
                                    onRelationshipChanged: (val) => _bloc.add(
                                      UpdateFormFieldsEvent(
                                        firstName: _firstNameCtrl.text,
                                        lastName: _lastNameCtrl.text,
                                        email: _emailCtrl.text,
                                        phone: _phoneCtrl.text,
                                        dob: _dobCtrl.text,
                                        sex: state.sex,
                                        genderIdentity: state.genderIdentity,
                                        bloodGroup: state.bloodGroup,
                                        place: _placeCtrl.text,
                                        wardNum: _wardCtrl.text,
                                        insuranceProvider: state.insuranceProvider,
                                        insurancePolicyId: _policyIdCtrl.text,
                                        insuranceValidTill: _validTillCtrl.text,
                                        smoking: state.smoking,
                                        alcohol: state.alcohol,
                                        dietType: state.dietType,
                                        exercise: state.exercise,
                                        allergies: _allergiesCtrl.text,
                                        otherDetails: _otherDetailsCtrl.text,
                                        emergencyName: _emergencyNameCtrl.text,
                                        emergencyRelationship: val,
                                        emergencyPhone: _emergencyPhoneCtrl.text,
                                      ),
                                    ),
                                    alternatePhoneCtrl: _alternatePhoneCtrl,
                                  )
                                else if (currentStep == 3)
                                  ReviewConfirmStep(
                                    firstName: state.firstName,
                                    lastName: state.lastName,
                                    dob: state.dob,
                                    sex: state.sex,
                                    bloodGroup: state.bloodGroup,
                                    phone: state.phone,
                                    uhid: state.generatedUHID,
                                    photoPath: state.photoPath,
                                    address: state.pincodeFetchedAddress,
                                    emergencyName: state.emergencyName,
                                    emergencyRelationship: state.emergencyRelationship,
                                    emergencyPhone: state.emergencyPhone,
                                    onEditPressed: () => _currentStep.value = 1,
                                  )
                                else if (currentStep == 4)
                                  SuccessStep(
                                    firstName: state.firstName,
                                    lastName: state.lastName,
                                    dob: state.dob,
                                    sex: state.sex,
                                    bloodGroup: state.bloodGroup,
                                    phone: state.phone,
                                    uhid: state.generatedUHID,
                                    photoPath: state.photoPath,
                                    address: state.pincodeFetchedAddress,
                                    emergencyName: state.emergencyName,
                                    emergencyRelationship: state.emergencyRelationship,
                                    emergencyPhone: state.emergencyPhone,
                                    onHomePressed: () {
                                      if (_isPatientMode) {
                                        context.go(RouteNames.patientDashboard);
                                      } else {
                                        context.go(RouteNames.staffDashboard);
                                      }
                                    },
                                    onSharePressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text("ID Card download started..."),
                                        ),
                                      );
                                    },
                                  ),
                              ],
                            ),
                          ),

                          // Bottom buttons (not shown on success step 4)
                          if (currentStep < 4)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                              decoration: BoxDecoration(
                                color: AppColors.card(context),
                                border: Border(
                                  top: BorderSide(color: AppColors.border(context), width: 1.w),
                                ),
                              ),
                              child: Row(
                                children: [
                                  if (currentStep > 1) ...[
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {
                                          _currentStep.value--;
                                        },
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(color: AppColors.primary, width: 1.5),
                                          padding: EdgeInsets.symmetric(vertical: 14.h),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12.r),
                                          ),
                                        ),
                                        child: Text(
                                          "Back",
                                          style: TextStyle(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                  ],
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: state.status == PatientRegistrationStatus.loading
                                          ? null
                                          : () {
                                              if (currentStep < totalSteps) {
                                                if (currentStep == 1) {
                                                  if (!_step1FormKey.currentState!.validate()) {
                                                    return;
                                                  }
                                                } else if (currentStep == 2) {
                                                  if (!_step2FormKey.currentState!.validate()) {
                                                    return;
                                                  }
                                                }
                                                _currentStep.value++;
                                              } else {
                                                _onSubmit();
                                              }
                                            },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.primary,
                                        padding: EdgeInsets.symmetric(vertical: 14.h),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(12.r),
                                        ),
                                      ),
                                      child: state.status == PatientRegistrationStatus.loading
                                          ? SizedBox(
                                              width: 18.r,
                                              height: 18.r,
                                              child: const CircularProgressIndicator(
                                                strokeWidth: 2,
                                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                              ),
                                            )
                                          : Text(
                                              currentStep == totalSteps
                                                  ? "Pay ₹50 & Generate ID Card"
                                                  : "Continue",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
