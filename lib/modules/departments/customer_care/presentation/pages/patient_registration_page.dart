import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/app_responsive.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/patient/domain/repositories/patient_repository.dart';
import 'package:medi_connect/features/patient/presentation/bloc/patient_bloc.dart';

import '../bloc/patient_registration_bloc.dart';
import '../bloc/patient_registration_event.dart';
import '../bloc/patient_registration_state.dart';
import '../widgets/registration/address_info_section.dart';
import '../widgets/registration/emergency_contact_section.dart';
import '../widgets/registration/id_card_actions.dart';
import '../widgets/registration/id_card_preview.dart';
import '../widgets/registration/insurance_info_section.dart';
import '../widgets/registration/lifestyle_info_section.dart';
import '../widgets/registration/personal_info_section.dart';
import '../widgets/registration/uhid_display_card.dart';

class PatientRegistrationPage extends StatefulWidget {
  const PatientRegistrationPage({super.key});

  @override
  State<PatientRegistrationPage> createState() => _PatientRegistrationPageState();
}

class _PatientRegistrationPageState extends State<PatientRegistrationPage> {
  // Controllers
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

  late PatientRegistrationBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = PatientRegistrationBloc(GetIt.I<PatientRepository>());

    // Wire up listeners to update the state as the user types (real-time ID card preview)
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
    _bloc.close();
    super.dispose();
  }

  void _onFieldsChanged() {
    _bloc.add(UpdateFormFieldsEvent(
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
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : const Color(0xFF0F2C59);
    final secondaryTextColor = isDark ? const Color(0xFF5E98C7) : const Color(0xFF3F6D94);

    return BlocProvider.value(
      value: _bloc,
      child: CustomScaffold(
        appBarNeeded: false,
        body: BlocListener<PatientRegistrationBloc, PatientRegistrationState>(
          listener: (context, state) {
            // If address is fetched from pincode, fill the place controller
            if (state.place != _placeCtrl.text && state.place.isNotEmpty && _placeCtrl.text.isEmpty) {
              _placeCtrl.text = state.place;
            }

            if (state.status == PatientRegistrationStatus.success) {
              // Refresh the global patients list
              context.read<PatientBloc>().add(LoadPatients());
              _showSuccessDialog(context, state.generatedUHID);
            } else if (state.status == PatientRegistrationStatus.failure) {
              _showErrorSnackBar(context, state.errorMessage);
            }
          },
          child: BlocBuilder<PatientRegistrationBloc, PatientRegistrationState>(
            builder: (context, state) {
              final double width = MediaQuery.of(context).size.width;
              final isWide = width > 1000;

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.horizontalPadding(context),
                  vertical: 24.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top header row
                    _buildHeader(context, state, primaryTextColor, secondaryTextColor),
                    SizedBox(height: 24.h),

                    // Main Layout
                    isWide
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Left Form Column
                              Expanded(
                                flex: 3,
                                child: Column(
                                  children: [
                                    PersonalInfoSection(
                                      firstNameCtrl: _firstNameCtrl,
                                      lastNameCtrl: _lastNameCtrl,
                                      emailCtrl: _emailCtrl,
                                      phoneCtrl: _phoneCtrl,
                                      dobCtrl: _dobCtrl,
                                      selectedSex: state.sex,
                                      selectedGenderIdentity: state.genderIdentity,
                                      selectedBloodGroup: state.bloodGroup,
                                      photoPath: state.photoPath,
                                      onSexChanged: (val) => _bloc.add(UpdateFormFieldsEvent(
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
                                      )),
                                      onGenderIdentityChanged: (val) => _bloc.add(UpdateFormFieldsEvent(
                                        firstName: _firstNameCtrl.text,
                                        lastName: _lastNameCtrl.text,
                                        email: _emailCtrl.text,
                                        phone: _phoneCtrl.text,
                                        dob: _dobCtrl.text,
                                        sex: state.sex,
                                        genderIdentity: val,
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
                                      )),
                                      onBloodGroupChanged: (val) => _bloc.add(UpdateFormFieldsEvent(
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
                                      )),
                                      onPhotoPick: _simulatePhotoUpload,
                                      onFieldsChanged: _onFieldsChanged,
                                    ),
                                    SizedBox(height: 20.h),
                                    AddressInfoSection(
                                      pincodeCtrl: _pincodeCtrl,
                                      placeCtrl: _placeCtrl,
                                      wardCtrl: _wardCtrl,
                                      fetchedAddress: state.pincodeFetchedAddress,
                                      isFetchingAddress: state.isFetchingAddress,
                                      onFetchAddress: (pin) => _bloc.add(FetchAddressEvent(pin)),
                                      onFieldsChanged: _onFieldsChanged,
                                    ),
                                    SizedBox(height: 20.h),
                                    InsuranceInfoSection(
                                      policyIdCtrl: _policyIdCtrl,
                                      validTillCtrl: _validTillCtrl,
                                      selectedProvider: state.insuranceProvider,
                                      onProviderChanged: (val) => _bloc.add(UpdateFormFieldsEvent(
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
                                      )),
                                      onFieldsChanged: _onFieldsChanged,
                                    ),
                                    SizedBox(height: 20.h),
                                    LifestyleInfoSection(
                                      allergiesCtrl: _allergiesCtrl,
                                      otherDetailsCtrl: _otherDetailsCtrl,
                                      selectedSmoking: state.smoking,
                                      selectedAlcohol: state.alcohol,
                                      selectedDietType: state.dietType,
                                      selectedExercise: state.exercise,
                                      onSmokingChanged: (val) => _bloc.add(UpdateFormFieldsEvent(
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
                                      )),
                                      onAlcoholChanged: (val) => _bloc.add(UpdateFormFieldsEvent(
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
                                      )),
                                      onDietTypeChanged: (val) => _bloc.add(UpdateFormFieldsEvent(
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
                                      )),
                                      onExerciseChanged: (val) => _bloc.add(UpdateFormFieldsEvent(
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
                                      )),
                                      onFieldsChanged: _onFieldsChanged,
                                    ),
                                    SizedBox(height: 20.h),
                                    EmergencyContactSection(
                                      nameCtrl: _emergencyNameCtrl,
                                      phoneCtrl: _emergencyPhoneCtrl,
                                      selectedRelationship: state.emergencyRelationship,
                                      onRelationshipChanged: (val) => _bloc.add(UpdateFormFieldsEvent(
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
                                      )),
                                      onFieldsChanged: _onFieldsChanged,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 24.w),

                              // Right ID Card Column
                              Expanded(
                                flex: 2,
                                child: _buildIdCardColumn(context, state),
                              ),
                            ],
                          )
                        : Column(
                            children: [
                              // Form first
                              PersonalInfoSection(
                                firstNameCtrl: _firstNameCtrl,
                                lastNameCtrl: _lastNameCtrl,
                                emailCtrl: _emailCtrl,
                                phoneCtrl: _phoneCtrl,
                                dobCtrl: _dobCtrl,
                                selectedSex: state.sex,
                                selectedGenderIdentity: state.genderIdentity,
                                selectedBloodGroup: state.bloodGroup,
                                photoPath: state.photoPath,
                                onSexChanged: (val) => _bloc.add(UpdateFormFieldsEvent(
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
                                )),
                                onGenderIdentityChanged: (val) => _bloc.add(UpdateFormFieldsEvent(
                                  firstName: _firstNameCtrl.text,
                                  lastName: _lastNameCtrl.text,
                                  email: _emailCtrl.text,
                                  phone: _phoneCtrl.text,
                                  dob: _dobCtrl.text,
                                  sex: state.sex,
                                  genderIdentity: val,
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
                                )),
                                onBloodGroupChanged: (val) => _bloc.add(UpdateFormFieldsEvent(
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
                                )),
                                onPhotoPick: _simulatePhotoUpload,
                                onFieldsChanged: _onFieldsChanged,
                              ),
                              SizedBox(height: 20.h),
                              AddressInfoSection(
                                pincodeCtrl: _pincodeCtrl,
                                placeCtrl: _placeCtrl,
                                wardCtrl: _wardCtrl,
                                fetchedAddress: state.pincodeFetchedAddress,
                                isFetchingAddress: state.isFetchingAddress,
                                onFetchAddress: (pin) => _bloc.add(FetchAddressEvent(pin)),
                                onFieldsChanged: _onFieldsChanged,
                              ),
                              SizedBox(height: 20.h),
                              _buildIdCardColumn(context, state),
                            ],
                          ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    PatientRegistrationState state,
    Color primaryColor,
    Color secondaryColor,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // Back button matching theme
            IconButton(
              icon: Icon(Icons.arrow_back_ios_new_rounded, color: primaryColor, size: 20.r),
              onPressed: () => context.pop(),
            ),
            SizedBox(width: 8.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Patient Registration",
                  style: AppTextStyles.headingMedium.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "Register a new patient and generate unique UHID",
                  style: AppTextStyles.bodySmall.copyWith(color: secondaryColor),
                ),
              ],
            ),
          ],
        ),
        
        Row(
          children: [
            // Top UHID card
            UhidDisplayCard(uhid: state.generatedUHID),
            SizedBox(width: 16.w),

            // Save & Send to MRD Button
            ElevatedButton.icon(
              onPressed: state.status == PatientRegistrationStatus.loading
                  ? null
                  : () {
                      _bloc.add(const SubmitFormEvent());
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              icon: state.status == PatientRegistrationStatus.loading
                  ? SizedBox(
                      width: 20.r,
                      height: 20.r,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Icon(Icons.send_rounded, color: Colors.white, size: 18.r),
              label: Text(
                "Save & Send to MRD",
                style: AppTextStyles.buttonMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIdCardColumn(BuildContext context, PatientRegistrationState state) {
    return Column(
      children: [
        IdCardPreview(
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
          selectedTab: state.selectedTab,
          onTabChanged: (tab) => _bloc.add(ToggleTabEvent(tab)),
        ),
        SizedBox(height: 20.h),
        // Direct Back Preview Box (always visible back preview)
        _buildBackPreviewDirectCard(state),
        SizedBox(height: 20.h),
        IdCardActions(
          patientName: '${state.firstName} ${state.lastName}',
          uhid: state.generatedUHID,
        ),
      ],
    );
  }

  Widget _buildBackPreviewDirectCard(PatientRegistrationState state) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF09121F) : Colors.white;
    final borderColor = isDark ? const Color(0xFF16253B) : const Color(0xFFD3E0EE);
    
    final displayEmergency = state.emergencyName.trim().isEmpty ? "Sita Kumar" : state.emergencyName.trim();
    final displayEmergencyPhone = state.emergencyPhone.trim().isEmpty ? "+91 91234 56789" : state.emergencyPhone.trim();
    final displayAddress = state.pincodeFetchedAddress.trim().isEmpty 
        ? "#45, MG Road, Bengaluru, Karnataka - 560001" 
        : state.pincodeFetchedAddress.trim();

    final textTitleColor = isDark ? const Color(0xFF5E98C7) : const Color(0xFF3F6D94);
    final textValueColor = isDark ? Colors.white : const Color(0xFF0C192E);

    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.style_outlined, color: AppColors.primary, size: 22.r),
              SizedBox(width: 10.w),
              Text(
                "ID Card Back Preview",
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F2C59),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Render Back Side Card
          Container(
            height: 160.h,
            width: double.infinity,
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF0F1E36), const Color(0xFF070F1C)]
                    : [const Color(0xFFE2EAF8), const Color(0xFFC7D7F3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                  blurRadius: 10.r,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Emergency Contact",
                              style: AppTextStyles.bodyXSmall.copyWith(color: textTitleColor, fontSize: 8.sp, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              "$displayEmergency (${state.emergencyRelationship})",
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodySmall.copyWith(color: textValueColor, fontWeight: FontWeight.bold, fontSize: 10.sp),
                            ),
                            Text(
                              displayEmergencyPhone,
                              style: AppTextStyles.bodyXSmall.copyWith(color: textValueColor, fontSize: 9.sp),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              "Address",
                              style: AppTextStyles.bodyXSmall.copyWith(color: textTitleColor, fontSize: 8.sp, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              displayAddress,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.bodyXSmall.copyWith(color: textValueColor, fontSize: 9.sp, height: 1.2),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Blood Group",
                              style: AppTextStyles.bodyXSmall.copyWith(color: textTitleColor, fontSize: 8.sp, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 2.h),
                            Row(
                              children: [
                                Icon(Icons.bloodtype, color: AppColors.error, size: 12.r),
                                SizedBox(width: 4.w),
                                Text(
                                  state.bloodGroup,
                                  style: AppTextStyles.bodySmall.copyWith(color: textValueColor, fontWeight: FontWeight.bold, fontSize: 10.sp),
                                ),
                              ],
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              "Issued On",
                              style: AppTextStyles.bodyXSmall.copyWith(color: textTitleColor, fontSize: 8.sp, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              DateFormat('dd/MM/yyyy').format(DateTime.now()),
                              style: AppTextStyles.bodySmall.copyWith(color: textValueColor, fontWeight: FontWeight.bold, fontSize: 10.sp),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.black26 : Colors.white24,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                  child: Center(
                    child: Text(
                      "In case of emergency, please contact your nearest hospital.",
                      style: AppTextStyles.bodyXSmall.copyWith(
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF4A5568),
                        fontSize: 8.sp,
                        fontStyle: FontStyle.italic,
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
  }

  void _simulatePhotoUpload() {
    // Simulate setting a high-quality avatar photo
    _bloc.add(const SelectPhotoEvent(
      "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150"
    ));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Mock photo scanned / uploaded successfully."),
        backgroundColor: AppColors.success,
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String uhid) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF09121F)
            : Colors.white,
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.success),
            SizedBox(width: 10.w),
            Text("Registration Saved", style: AppTextStyles.titleMedium),
          ],
        ),
        content: Text(
          "Patient has been successfully registered and data has been sent to MRD.\n\nGenerated UHID: $uhid",
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx); // pop dialog
              context.pop();      // pop registration page back to Customer Care
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text("OK", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(error),
        backgroundColor: AppColors.error,
      ),
    );
  }
}
