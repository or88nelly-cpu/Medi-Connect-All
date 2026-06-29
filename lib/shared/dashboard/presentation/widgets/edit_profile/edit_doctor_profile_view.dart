import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/functions/date_utils.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_state.dart';

import 'package:medi_connect/shared/dashboard/presentation/widgets/edit_profile/edit_additional_info.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/edit_profile/edit_address_info.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/edit_profile/edit_documents_section.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/edit_profile/edit_personal_info.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/edit_profile/edit_professional_info.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/edit_profile/edit_profile_doctor_card.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/edit_profile/edit_profile_header.dart';

class EditDoctorProfileView extends StatefulWidget {
  final UserModel user;

  const EditDoctorProfileView({super.key, required this.user});

  @override
  State<EditDoctorProfileView> createState() => _EditDoctorProfileViewState();
}

class _EditDoctorProfileViewState extends State<EditDoctorProfileView> {
  final _formKey = GlobalKey<FormState>();

  // Personal Info Controllers
  late final TextEditingController _nameController;
  late final TextEditingController _dobController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _alternatePhoneController;
  late String _gender;
  late String _bloodGroup;

  // Professional Info Controllers
  late final TextEditingController _qualificationController;
  late final TextEditingController _experienceController;
  late final TextEditingController _regNumberController;
  late final TextEditingController _feeController;
  late String _selectedDept;
  late String _selectedSpec;

  // Address Info Controllers
  late final TextEditingController _address1Controller;
  late final TextEditingController _address2Controller;
  late final TextEditingController _cityController;
  late final TextEditingController _pincodeController;
  late String _selectedState;

  // Additional Info Fields
  late List<String> _languages;
  late List<String> _selectedConsultationModes;
  late final TextEditingController _aboutController;

  @override
  void initState() {
    super.initState();

    // Personal details initialization
    _nameController = TextEditingController(text: widget.user.fullName);
    _dobController = TextEditingController(
      text: AppDateUtils.formatDate(widget.user.dob??DateTime.now()),
    );
    _emailController = TextEditingController(text: widget.user.email);

    // Format phone number to remove +91 if present for UI editing
    String rawPhone = widget.user.phone ?? "";
    if (rawPhone.startsWith("+91 ")) {
      rawPhone = rawPhone.replaceFirst("+91 ", "");
    } else if (rawPhone.startsWith("+91")) {
      rawPhone = rawPhone.replaceFirst("+91", "");
    }
    _phoneController = TextEditingController(text: rawPhone);
    

    // Address details initialization
    final addressParts =  [];
    _address1Controller = TextEditingController(
      text: addressParts.isNotEmpty
          ? addressParts[0].trim()
          : "123 Health Street",
    );
    _address2Controller = TextEditingController(
      text: addressParts.length > 1
          ? addressParts[1].trim()
          : "Clinic Building",
    );
    _cityController = TextEditingController(
      text: addressParts.length > 2 ? addressParts[2].trim() : "Mumbai",
    );
    _selectedState = addressParts.length > 3
        ? addressParts[3].trim()
        : "Maharashtra";
    _pincodeController = TextEditingController(
      text: addressParts.length > 4 ? addressParts[4].trim() : "400001",
    );

    // Additional info initialization
    _languages =["English", "Hindi", "Punjabi"];
    _selectedConsultationModes =
       
        ["Video", "In-Person"];
    _aboutController = TextEditingController(
      text:
          "Dr. ${widget.user.fullName ?? ''} is a dedicated medical specialist with over a decade of clinical excellence.",
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _alternatePhoneController.dispose();
    _qualificationController.dispose();
    _experienceController.dispose();
    _regNumberController.dispose();
    _feeController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _pincodeController.dispose();
    _aboutController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      // Build address string
      final fullAddress =
          "${_address1Controller.text}, ${_address2Controller.text}, ${_cityController.text}, $_selectedState, ${_pincodeController.text}";

      // Build metadata
      final updatedMetadata = Map<String, dynamic>.from(
        {},
      );
      updatedMetadata['languages'] = _languages;
      updatedMetadata['consultation_modes'] = _selectedConsultationModes;
      updatedMetadata['about'] = _aboutController.text;

      final formattedPhone = _phoneController.text.startsWith("+91")
          ? _phoneController.text
          : "+91 ${_phoneController.text}";

     
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      appBarNeeded: false,
      body: BlocListener<DoctorStaffBloc, DoctorStaffState>(
        listener: (context, state) {
          if (state is DoctorStaffActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Doctor profile updated successfully."),
              ),
            );
            Navigator.pop(context, true);
          } else if (state is DoctorStaffError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            children: [
              const EditProfileHeader(),
              SizedBox(height: 16.h),
              EditProfileDoctorCard(user: widget.user),
              SizedBox(height: 16.h),
              EditPersonalInfo(
                nameController: _nameController,
                dobController: _dobController,
                emailController: _emailController,
                phoneController: _phoneController,
                alternatePhoneController: _alternatePhoneController,
                gender: _gender,
                onGenderChanged: (val) {
                  if (val != null) setState(() => _gender = val);
                },
                bloodGroup: _bloodGroup,
                onBloodGroupChanged: (val) {
                  if (val != null) setState(() => _bloodGroup = val);
                },
              ),
              SizedBox(height: 16.h),
              EditProfessionalInfo(
                qualificationController: _qualificationController,
                experienceController: _experienceController,
                regNumberController: _regNumberController,
                feeController: _feeController,
                selectedDepartment: _selectedDept,
                onDepartmentChanged: (val) {
                  if (val != null) setState(() => _selectedDept = val);
                },
                selectedSpecialization: _selectedSpec,
                onSpecializationChanged: (val) {
                  if (val != null) setState(() => _selectedSpec = val);
                },
              ),
              SizedBox(height: 16.h),
              EditAddressInfo(
                address1Controller: _address1Controller,
                address2Controller: _address2Controller,
                cityController: _cityController,
                selectedState: _selectedState,
                onStateChanged: (val) {
                  if (val != null) setState(() => _selectedState = val);
                },
                pincodeController: _pincodeController,
              ),
              SizedBox(height: 16.h),
              EditAdditionalInfo(
                languages: _languages,
                onAddLanguage: (lang) {
                  if (!_languages.contains(lang)) {
                    setState(() => _languages.add(lang));
                  }
                },
                onRemoveLanguage: (lang) {
                  setState(() => _languages.remove(lang));
                },
                selectedConsultationModes: _selectedConsultationModes,
                onToggleConsultationMode: (mode) {
                  setState(() {
                    if (_selectedConsultationModes.contains(mode)) {
                      _selectedConsultationModes.remove(mode);
                    } else {
                      _selectedConsultationModes.add(mode);
                    }
                  });
                },
                aboutController: _aboutController,
              ),
              SizedBox(height: 16.h),
              const EditDocumentsSection(),
              SizedBox(height: 24.h),
              // Save / Cancel action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.primary),
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.sp,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveChanges,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(vertical: 14.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                      child: const Text(
                        "Save Changes",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

