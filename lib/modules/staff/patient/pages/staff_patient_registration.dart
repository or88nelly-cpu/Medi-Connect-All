import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/routes/route_names.dart';
import 'package:medi_connect/core/services/secure_storage_service.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';

import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';

import 'package:medi_connect/modules/management/customer_care/presentation/bloc/patient_registration_bloc.dart';
import 'package:medi_connect/modules/management/customer_care/presentation/bloc/patient_registration_event.dart';
import 'package:medi_connect/modules/management/customer_care/presentation/bloc/patient_registration_state.dart';
import 'package:medi_connect/modules/management/patient_management/domain/repositories/patient_repository.dart';

import 'package:medi_connect/modules/staff/patient/widgets/registration_bottom_bar.dart';
import 'package:medi_connect/modules/staff/patient/widgets/registration_progress_header.dart';
import 'package:medi_connect/modules/staff/patient/widgets/basic_info_step.dart';
import 'package:medi_connect/modules/staff/patient/widgets/additional_info_step.dart';
import 'package:medi_connect/modules/staff/patient/widgets/review_confirm_step.dart';
import 'package:medi_connect/modules/staff/patient/widgets/success_step.dart';

/// Multi-step patient registration / self-onboarding wizard.
///
/// Works in two modes:
///  - **Staff mode** — staff registers a new walk-in patient.
///  - **Patient mode** — authenticated patient completes their own profile.
///
/// Step navigation, form data, and submission status are all managed
/// by [PatientRegistrationBloc]. This page is a thin orchestration shell.
class StaffPatientRegistration extends StatefulWidget {
  const StaffPatientRegistration({super.key});

  @override
  State<StaffPatientRegistration> createState() =>
      _StaffPatientRegistrationState();
}

class _StaffPatientRegistrationState extends State<StaffPatientRegistration> {
  // ── Form keys for in-widget validation before advancing ──────
  final _step1FormKey = GlobalKey<FormState>();
  final _step2FormKey = GlobalKey<FormState>();

  // ── Text controllers (owned here; synced to BLoC on change) ──
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

  late PatientRegistrationBloc _bloc;

  static const int _totalSteps = 3;
  static const List<String> _stepTitles = [
    AppStrings.basicInformation,
    AppStrings.additionalInformation,
    AppStrings.reviewAndConfirm,
  ];

  @override
  void initState() {
    super.initState();
    _bloc = PatientRegistrationBloc(GetIt.I<PatientRepository>());

    // Sync text-field changes to BLoC without setState.
    void syncBasicInfo() => _bloc.add(BasicInfoUpdated(
          firstName: _firstNameCtrl.text,
          lastName: _lastNameCtrl.text,
          email: _emailCtrl.text,
          phone: _phoneCtrl.text,
          dob: _dobCtrl.text,
        ));

    for (final ctrl in [
      _firstNameCtrl,
      _lastNameCtrl,
      _emailCtrl,
      _phoneCtrl,
      _dobCtrl,
    ]) {
      ctrl.addListener(syncBasicInfo);
    }

    void syncAddress() => _bloc.add(AddressUpdated(
          place: _placeCtrl.text,
          wardNum: _wardCtrl.text,
        ));

    for (final ctrl in [_placeCtrl, _wardCtrl]) {
      ctrl.addListener(syncAddress);
    }

    void syncInsurance() => _bloc.add(InsuranceUpdated(
          insuranceProvider: _bloc.state.insuranceProvider,
          insurancePolicyId: _policyIdCtrl.text,
          insuranceValidTill: _validTillCtrl.text,
        ));

    for (final ctrl in [_policyIdCtrl, _validTillCtrl]) {
      ctrl.addListener(syncInsurance);
    }

    void syncMedical() => _bloc.add(MedicalInfoUpdated(
          bloodGroup: _bloc.state.bloodGroup,
          smoking: _bloc.state.smoking,
          alcohol: _bloc.state.alcohol,
          dietType: _bloc.state.dietType,
          exercise: _bloc.state.exercise,
          allergies: _allergiesCtrl.text,
          otherDetails: _otherDetailsCtrl.text,
        ));

    for (final ctrl in [_allergiesCtrl, _otherDetailsCtrl]) {
      ctrl.addListener(syncMedical);
    }

    void syncEmergency() => _bloc.add(EmergencyContactUpdated(
          emergencyName: _emergencyNameCtrl.text,
          emergencyRelationship: _bloc.state.emergencyRelationship,
          emergencyPhone: _emergencyPhoneCtrl.text,
        ));

    for (final ctrl in [_emergencyNameCtrl, _emergencyPhoneCtrl]) {
      ctrl.addListener(syncEmergency);
    }

    // Initialize patient mode after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initPatientModeIfNeeded();
    });
  }

  // ─────────────────────────────────────────────────────────────
  // INITIALIZATION
  // ─────────────────────────────────────────────────────────────

  void _initPatientModeIfNeeded() {
    final authState = context.read<AuthBloc>().state;
    if (authState is! Authenticated || authState.user.role != 'patient') return;

    final user = authState.user;

    // Split full name into first / last if individual parts are missing.
    String firstName = user.firstName ?? '';
    String lastName = user.lastName ?? '';
    if (firstName.isEmpty && lastName.isEmpty && user.name != null) {
      final parts = user.name!.trim().split(' ');
      if (parts.isNotEmpty) firstName = parts[0];
      if (parts.length > 1) lastName = parts.sublist(1).join(' ');
    }

    // Populate text controllers.
    _firstNameCtrl.text = firstName;
    _lastNameCtrl.text = lastName;
    _emailCtrl.text = user.email;
    _phoneCtrl.text = user.phoneNumber ?? '';
    _dobCtrl.text = user.dateOfBirth ?? '';
    _placeCtrl.text = user.address ?? '';

    final meta = user.metadata ?? {};
    _wardCtrl.text = meta['ward_num'] as String? ?? '';
    _policyIdCtrl.text = user.insuranceNumber ?? '';
    _validTillCtrl.text = meta['insurance_valid_till'] as String? ?? '';
    _allergiesCtrl.text = meta['allergies'] as String? ?? '';
    _otherDetailsCtrl.text = meta['other_details'] as String? ?? '';

    String emergencyName = '';
    String emergencyPhone = '';
    if (user.emergencyContact != null) {
      try {
        final ec = jsonDecode(user.emergencyContact!) as Map<String, dynamic>;
        emergencyName = ec['name'] as String? ?? '';
        emergencyPhone = ec['phone'] as String? ?? '';
        _emergencyNameCtrl.text = emergencyName;
        _emergencyPhoneCtrl.text = emergencyPhone;
      } catch (_) {}
    }

    // Dispatch initialization event to BLoC.
    _bloc.add(PatientModeInitialized(
      userId: user.id,
      firstName: firstName,
      lastName: lastName,
      email: user.email,
      phone: user.phoneNumber ?? '',
      dob: user.dateOfBirth ?? '',
      address: user.address ?? '',
      sex: user.gender ?? 'Male',
      bloodGroup: user.bloodGroup ?? 'O+',
      insuranceProvider: user.insuranceProvider ?? 'Star Health Insurance',
      insurancePolicyId: user.insuranceNumber ?? '',
      allergies: meta['allergies'] as String? ?? '',
      emergencyName: emergencyName,
      emergencyPhone: emergencyPhone,
      emergencyRelationship: meta['emergency_relationship'] as String? ?? 'Wife',
      wardNum: meta['ward_num'] as String? ?? '',
      insuranceValidTill: meta['insurance_valid_till'] as String? ?? '',
      genderIdentity: meta['gender_identity'] as String? ?? 'Cisgender Male',
      smoking: meta['smoking'] as String? ?? 'No',
      alcohol: meta['alcohol'] as String? ?? 'Occasionally',
      dietType: meta['diet_type'] as String? ?? 'Non Vegetarian',
      exercise: meta['exercise'] as String? ?? 'Regular',
      otherDetails: meta['other_details'] as String? ?? '',
    ));

    // Automatically resume from saved onboarding step
    if (user.onboardingStep > 1 && user.onboardingStep <= 3) {
      _bloc.add(StepJumpRequested(user.onboardingStep));
    }
  }

  @override
  void dispose() {
    for (final ctrl in [
      _firstNameCtrl,
      _lastNameCtrl,
      _emailCtrl,
      _phoneCtrl,
      _dobCtrl,
      _pincodeCtrl,
      _placeCtrl,
      _wardCtrl,
      _policyIdCtrl,
      _validTillCtrl,
      _allergiesCtrl,
      _otherDetailsCtrl,
      _emergencyNameCtrl,
      _emergencyPhoneCtrl,
      _alternatePhoneCtrl,
    ]) {
      ctrl.dispose();
    }
    _bloc.close();
    super.dispose();
  }

  // ─────────────────────────────────────────────────────────────
  // SUBMISSION
  // ─────────────────────────────────────────────────────────────

  void _onSubmit(bool isPatientMode) {
    if (isPatientMode) {
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated) {
        _bloc.add(SubmitProfileUpdateEvent(authState.user.id));
      }
    } else {
      _bloc.add(const SubmitFormEvent());
    }
  }

  // ─────────────────────────────────────────────────────────────
  // NEXT BUTTON HANDLER — validates current step then advances
  // ─────────────────────────────────────────────────────────────

  void _handleNextPressed(int currentStep, bool isPatientMode) {
    if (currentStep == 1) {
      if (!(_step1FormKey.currentState?.validate() ?? false)) return;
    } else if (currentStep == 2) {
      if (!(_step2FormKey.currentState?.validate() ?? false)) return;
    }

    if (currentStep < _totalSteps) {
      _bloc.add(const StepNextRequested());
    } else {
      _onSubmit(isPatientMode);
    }
  }

  // ─────────────────────────────────────────────────────────────
  // BUILD
  // ─────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: BlocConsumer<PatientRegistrationBloc, PatientRegistrationState>(
        listenWhen: (prev, curr) =>
            prev.status != curr.status ||
            prev.pincodeFetchedAddress != curr.pincodeFetchedAddress,
        listener: _onBlocStateChanged,
        buildWhen: (prev, curr) =>
            prev.currentStep != curr.currentStep ||
            prev.isPatientMode != curr.isPatientMode,
        builder: (context, state) {
          final currentStep = state.currentStep;
          final isPatientMode = state.isPatientMode;

          return PopScope(
            canPop: currentStep == 1 || currentStep == 4,
            onPopInvokedWithResult: (didPop, _) {
              if (!didPop && currentStep > 1 && currentStep <= _totalSteps) {
                _bloc.add(const StepBackRequested());
              }
            },
            child: CustomScaffold(
              customAppbar: _buildAppBar(context, currentStep, isPatientMode),
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        children: [
                          if (currentStep < 4) ...[
                            RegistrationProgressHeader(
                              currentStep: currentStep,
                              totalSteps: _totalSteps,
                              stepTitle: _stepTitles[currentStep - 1],
                              isPatientMode: isPatientMode,
                            ),
                            SizedBox(height: 20.h),
                          ],
                          _buildStepBody(context, currentStep, isPatientMode),
                        ],
                      ),
                    ),
                    if (currentStep < 4)
                      RegistrationBottomBar(
                        currentStep: currentStep,
                        totalSteps: _totalSteps,
                        onNextPressed: () =>
                            _handleNextPressed(currentStep, isPatientMode),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // LISTENER
  // ─────────────────────────────────────────────────────────────

  void _onBlocStateChanged(
    BuildContext context,
    PatientRegistrationState state,
  ) async {
    // Address auto-fill from pincode fetch
    if (state.pincodeFetchedAddress.isNotEmpty &&
        _placeCtrl.text.isEmpty) {
      _placeCtrl.text = state.place;
    }

    if (state.status == PatientRegistrationStatus.success &&
        state.isPatientMode) {
      // Persist completion flag in secure storage.
      final storage = GetIt.I<SecureStorageService>();
      await storage.write('profile_completion_status', 'true');

      if (!context.mounted) return;

      // Update AuthBloc with the completed profile.
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated) {
        final user = authState.user;
        final updatedUser = UserModel(
          id: user.id,
          email: user.email,
          name:
              '${_firstNameCtrl.text.trim()} ${_lastNameCtrl.text.trim()}'.trim(),
          firstName: _firstNameCtrl.text.trim(),
          lastName: _lastNameCtrl.text.trim(),
          phoneNumber: _phoneCtrl.text.trim(),
          dateOfBirth: _dobCtrl.text.trim(),
          gender: state.sex,
          bloodGroup: state.bloodGroup,
          role: 'patient',
          profileCompletionStatus: true,
          status: 'Active',
          profileImage:
              state.photoPath.isNotEmpty ? state.photoPath : user.profileImage,
          address: state.pincodeFetchedAddress,
          insuranceProvider: state.insuranceProvider,
          insuranceNumber: _policyIdCtrl.text.trim().isNotEmpty
              ? _policyIdCtrl.text.trim()
              : null,
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
        if (context.mounted) {
          context.read<AuthBloc>().add(UserUpdated(updatedUser));
        }
      }
    }

    if (state.status == PatientRegistrationStatus.failure &&
        context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.errorMessage),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  // ─────────────────────────────────────────────────────────────
  // APP BAR
  // ─────────────────────────────────────────────────────────────

  AppBar _buildAppBar(
    BuildContext context,
    int currentStep,
    bool isPatientMode,
  ) {
    return AppBar(
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
                  _bloc.add(const StepBackRequested());
                } else {
                  context.pop();
                }
              },
            ),
      title: Text(
        isPatientMode
            ? AppStrings.completeYourProfile
            : AppStrings.patientRegistrationTitle,
        style: AppTextStyles.titleSmall.copyWith(
          color: AppColors.textPrimary(context),
          fontWeight: FontWeight.bold,
          fontSize: 14.sp,
        ),
      ),
      centerTitle: true,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // STEP BODY — each step widget is stateless & BLoC-connected
  // ─────────────────────────────────────────────────────────────

  Widget _buildStepBody(
    BuildContext context,
    int currentStep,
    bool isPatientMode,
  ) {
    return BlocBuilder<PatientRegistrationBloc, PatientRegistrationState>(
      builder: (context, state) {
        switch (currentStep) {
          case 1:
            return BasicInfoStep(
              formKey: _step1FormKey,
              firstNameCtrl: _firstNameCtrl,
              lastNameCtrl: _lastNameCtrl,
              emailCtrl: _emailCtrl,
              phoneCtrl: _phoneCtrl,
              dobCtrl: _dobCtrl,
              selectedSex: state.sex,
              onSexChanged: (val) =>
                  _bloc.add(SexUpdated(val)),
              pincodeCtrl: _pincodeCtrl,
              placeCtrl: _placeCtrl,
              wardCtrl: _wardCtrl,
              fetchedAddress: state.pincodeFetchedAddress,
              isFetchingAddress: state.isFetchingAddress,
              onFetchAddress: (pin) => _bloc.add(FetchAddressEvent(pin)),
            );

          case 2:
            return AdditionalInfoStep(
              formKey: _step2FormKey,
              policyIdCtrl: _policyIdCtrl,
              validTillCtrl: _validTillCtrl,
              selectedProvider: state.insuranceProvider,
              onProviderChanged: (val) => _bloc.add(InsuranceUpdated(
                insuranceProvider: val,
                insurancePolicyId: _policyIdCtrl.text,
                insuranceValidTill: _validTillCtrl.text,
              )),
              bloodGroup: state.bloodGroup,
              onBloodGroupChanged: (val) => _bloc.add(MedicalInfoUpdated(
                bloodGroup: val,
                smoking: state.smoking,
                alcohol: state.alcohol,
                dietType: state.dietType,
                exercise: state.exercise,
                allergies: _allergiesCtrl.text,
                otherDetails: _otherDetailsCtrl.text,
              )),
              smoking: state.smoking,
              onSmokingChanged: (val) => _bloc.add(MedicalInfoUpdated(
                bloodGroup: state.bloodGroup,
                smoking: val,
                alcohol: state.alcohol,
                dietType: state.dietType,
                exercise: state.exercise,
                allergies: _allergiesCtrl.text,
                otherDetails: _otherDetailsCtrl.text,
              )),
              alcohol: state.alcohol,
              onAlcoholChanged: (val) => _bloc.add(MedicalInfoUpdated(
                bloodGroup: state.bloodGroup,
                smoking: state.smoking,
                alcohol: val,
                dietType: state.dietType,
                exercise: state.exercise,
                allergies: _allergiesCtrl.text,
                otherDetails: _otherDetailsCtrl.text,
              )),
              dietType: state.dietType,
              onDietTypeChanged: (val) => _bloc.add(MedicalInfoUpdated(
                bloodGroup: state.bloodGroup,
                smoking: state.smoking,
                alcohol: state.alcohol,
                dietType: val,
                exercise: state.exercise,
                allergies: _allergiesCtrl.text,
                otherDetails: _otherDetailsCtrl.text,
              )),
              exercise: state.exercise,
              onExerciseChanged: (val) => _bloc.add(MedicalInfoUpdated(
                bloodGroup: state.bloodGroup,
                smoking: state.smoking,
                alcohol: state.alcohol,
                dietType: state.dietType,
                exercise: val,
                allergies: _allergiesCtrl.text,
                otherDetails: _otherDetailsCtrl.text,
              )),
              allergiesCtrl: _allergiesCtrl,
              otherDetailsCtrl: _otherDetailsCtrl,
              emergencyNameCtrl: _emergencyNameCtrl,
              emergencyPhoneCtrl: _emergencyPhoneCtrl,
              emergencyRelationship: state.emergencyRelationship,
              onRelationshipChanged: (val) => _bloc.add(EmergencyContactUpdated(
                emergencyName: _emergencyNameCtrl.text,
                emergencyRelationship: val,
                emergencyPhone: _emergencyPhoneCtrl.text,
              )),
              alternatePhoneCtrl: _alternatePhoneCtrl,
            );

          case 3:
            return ReviewConfirmStep(
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
              onEditPressed: () => _bloc.add(const StepJumpRequested(1)),
            );

          case 4:
            return SuccessStep(
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
              onHomePressed: () => context.go(
                isPatientMode
                    ? RouteNames.patientDashboard
                    : RouteNames.staffDashboard,
              ),
              onSharePressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(AppStrings.idCardDownloadStarted),
                ),
              ),
            );

          default:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
