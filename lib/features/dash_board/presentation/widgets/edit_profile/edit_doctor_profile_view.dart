import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_event.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_state.dart';

import 'edit_additional_info.dart';
import 'edit_address_info.dart';
import 'edit_documents_section.dart';
import 'edit_personal_info.dart';
import 'edit_professional_info.dart';
import 'edit_profile_doctor_card.dart';
import 'edit_profile_header.dart';

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
    _nameController = TextEditingController(text: widget.user.name);
    _dobController = TextEditingController(text: widget.user.dateOfBirth ?? "20 May 1985");
    _emailController = TextEditingController(text: widget.user.email);
    
    // Format phone number to remove +91 if present for UI editing
    String rawPhone = widget.user.phoneNumber ?? "";
    if (rawPhone.startsWith("+91 ")) {
      rawPhone = rawPhone.replaceFirst("+91 ", "");
    } else if (rawPhone.startsWith("+91")) {
      rawPhone = rawPhone.replaceFirst("+91", "");
    }
    _phoneController = TextEditingController(text: rawPhone);
    _alternatePhoneController = TextEditingController(text: widget.user.emergencyContact ?? "");
    _gender = widget.user.gender ?? "Male";
    _bloodGroup = widget.user.bloodGroup ?? "A+";

    // Professional details initialization
    _qualificationController = TextEditingController(text: widget.user.qualification ?? "MBBS, MD");
    _experienceController = TextEditingController(text: widget.user.experience?.toString() ?? "10");
    _regNumberController = TextEditingController(text: widget.user.medicalRegistrationNumber ?? "REG-12345");
    _feeController = TextEditingController(text: widget.user.consultationFee?.toString() ?? "500");
    _selectedDept = widget.user.department ?? "Cardiology";
    _selectedSpec = widget.user.specialization ?? "Cardiologist";

    // Address details initialization
    final addressParts = widget.user.address?.split(',') ?? [];
    _address1Controller = TextEditingController(
      text: addressParts.isNotEmpty ? addressParts[0].trim() : "123 Health Street",
    );
    _address2Controller = TextEditingController(
      text: addressParts.length > 1 ? addressParts[1].trim() : "Clinic Building",
    );
    _cityController = TextEditingController(
      text: addressParts.length > 2 ? addressParts[2].trim() : "Mumbai",
    );
    _selectedState = addressParts.length > 3 ? addressParts[3].trim() : "Maharashtra";
    _pincodeController = TextEditingController(
      text: addressParts.length > 4 ? addressParts[4].trim() : "400001",
    );

    // Additional info initialization
    _languages = widget.user.metadata != null && widget.user.metadata!['languages'] != null
        ? List<String>.from(widget.user.metadata!['languages'])
        : ["English", "Hindi", "Punjabi"];
    _selectedConsultationModes = widget.user.metadata != null && widget.user.metadata!['consultation_modes'] != null
        ? List<String>.from(widget.user.metadata!['consultation_modes'])
        : ["Video", "In-Person"];
    _aboutController = TextEditingController(
      text: widget.user.metadata != null && widget.user.metadata!['about'] != null
          ? widget.user.metadata!['about'] as String
          : "Dr. ${widget.user.name ?? ''} is a dedicated medical specialist with over a decade of clinical excellence.",
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
      final fullAddress = "${_address1Controller.text}, ${_address2Controller.text}, ${_cityController.text}, $_selectedState, ${_pincodeController.text}";

      // Build metadata
      final updatedMetadata = Map<String, dynamic>.from(widget.user.metadata ?? {});
      updatedMetadata['languages'] = _languages;
      updatedMetadata['consultation_modes'] = _selectedConsultationModes;
      updatedMetadata['about'] = _aboutController.text;

      final formattedPhone = _phoneController.text.startsWith("+91") 
          ? _phoneController.text 
          : "+91 ${_phoneController.text}";

      final updatedUser = widget.user.copyWithDoctorFields(
        name: _nameController.text,
        phoneNumber: formattedPhone,
        gender: _gender,
        email: _emailController.text,
        dateOfBirth: _dobController.text,
        bloodGroup: _bloodGroup,
        emergencyContact: _alternatePhoneController.text,
        department: _selectedDept,
        specialization: _selectedSpec,
        qualification: _qualificationController.text,
        experience: int.tryParse(_experienceController.text),
        medicalRegistrationNumber: _regNumberController.text,
        consultationFee: double.tryParse(_feeController.text),
        address: fullAddress,
        metadata: updatedMetadata,
      );

      context.read<DoctorStaffBloc>().add(
        UpdateDoctorStaffMember(updatedUser),
      );
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
              const SnackBar(content: Text("Doctor profile updated successfully.")),
            );
            Navigator.pop(context, true);
          } else if (state is DoctorStaffError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
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

extension on UserModel {
  UserModel copyWithDoctorFields({
    String? name,
    String? phoneNumber,
    String? gender,
    String? email,
    String? dateOfBirth,
    String? bloodGroup,
    String? emergencyContact,
    String? department,
    String? specialization,
    String? qualification,
    int? experience,
    String? medicalRegistrationNumber,
    double? consultationFee,
    String? address,
    Map<String, dynamic>? metadata,
  }) {
    return UserModel(
      id: id,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role,
      profileCompletionStatus: profileCompletionStatus,
      status: status,
      department: department ?? this.department,
      qualification: qualification ?? this.qualification,
      metadata: metadata ?? this.metadata,
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      age: age,
      gender: gender ?? this.gender,
      profileImage: profileImage,
      address: address ?? this.address,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      maritalStatus: maritalStatus,
      employeeId: employeeId,
      patientId: patientId,
      medicalRegistrationNumber: medicalRegistrationNumber ?? this.medicalRegistrationNumber,
      experience: experience ?? this.experience,
      specialization: specialization ?? this.specialization,
      consultationFee: consultationFee ?? this.consultationFee,
      availabilityStatus: availabilityStatus,
      staffRole: staffRole,
      joiningDate: joiningDate,
      allergies: allergies,
      chronicDiseases: chronicDiseases,
      insuranceProvider: insuranceProvider,
      insuranceNumber: insuranceNumber,
      designation: designation,
      accessLevel: accessLevel,
    );
  }
}
