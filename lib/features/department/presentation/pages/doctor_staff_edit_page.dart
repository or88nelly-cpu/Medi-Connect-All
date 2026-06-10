import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/common_app_bar.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_event.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_state.dart';

class DoctorStaffEditPage extends StatefulWidget {
  const DoctorStaffEditPage({super.key, required this.user});
  final UserModel user;

  @override
  State<DoctorStaffEditPage> createState() => _DoctorStaffEditPageState();
}

class _DoctorStaffEditPageState extends State<DoctorStaffEditPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _qualificationsController;
  late final TextEditingController _specializationController;
  late final TextEditingController _feeController;
  late final TextEditingController _expController;
  late final TextEditingController _staffRoleController;
  late final TextEditingController _designationController;

  late String _availabilityStatus;
  late String _gender;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _phoneController = TextEditingController(text: widget.user.phoneNumber);
    _qualificationsController = TextEditingController(text: widget.user.qualification);
    _specializationController = TextEditingController(text: widget.user.specialization);
    _feeController = TextEditingController(text: widget.user.consultationFee?.toString() ?? '');
    _expController = TextEditingController(text: widget.user.experience?.toString() ?? '');
    _staffRoleController = TextEditingController(text: widget.user.staffRole);
    _designationController = TextEditingController(text: widget.user.designation);

    _availabilityStatus = widget.user.availabilityStatus ?? 'Available';
    _gender = widget.user.gender ?? 'Male';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _qualificationsController.dispose();
    _specializationController.dispose();
    _feeController.dispose();
    _expController.dispose();
    _staffRoleController.dispose();
    _designationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDoctor = widget.user.role == 'doctor';

    return CustomScaffold(
      customAppbar: CommonAppBar(title: "Edit ${widget.user.role.toUpperCase()}"),
      body: BlocListener<DoctorStaffBloc, DoctorStaffState>(
        listener: (context, state) {
          if (state is DoctorStaffActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("${widget.user.role.toUpperCase()} updated successfully.")),
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
            padding: EdgeInsets.all(20.r),
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: (val) => val == null || val.isEmpty ? AppStrings.requiredField : null,
              ),
              SizedBox(height: 12.h),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: "Phone Number"),
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  const Text("Gender: "),
                  SizedBox(width: 12.w),
                  DropdownButton<String>(
                    value: _gender,
                    items: ['Male', 'Female', 'Other'].map((g) {
                      return DropdownMenuItem(value: g, child: Text(g));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _gender = val);
                    },
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  const Text("Status: "),
                  SizedBox(width: 12.w),
                  DropdownButton<String>(
                    value: _availabilityStatus,
                    items: ['Available', 'On Leave', 'Busy', 'Offline'].map((s) {
                      return DropdownMenuItem(value: s, child: Text(s));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _availabilityStatus = val);
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              if (isDoctor) ...[
                TextFormField(
                  controller: _specializationController,
                  decoration: const InputDecoration(labelText: "Specialization"),
                  validator: (val) => val == null || val.isEmpty ? AppStrings.requiredField : null,
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: _qualificationsController,
                  decoration: const InputDecoration(labelText: "Qualifications"),
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: _feeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Consultation Fee (₹)"),
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: _expController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Experience (Years)"),
                ),
              ] else ...[
                TextFormField(
                  controller: _staffRoleController,
                  decoration: const InputDecoration(labelText: "Staff Role"),
                  validator: (val) => val == null || val.isEmpty ? AppStrings.requiredField : null,
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: _designationController,
                  decoration: const InputDecoration(labelText: "Designation"),
                ),
              ],
              SizedBox(height: 24.h),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final updatedUser = UserModel.fromEntity(widget.user).copyWith(
                      name: _nameController.text,
                      phoneNumber: _phoneController.text,
                      gender: _gender,
                      availabilityStatus: _availabilityStatus,
                      specialization: isDoctor ? _specializationController.text : null,
                      qualification: isDoctor ? _qualificationsController.text : null,
                      consultationFee: isDoctor ? double.tryParse(_feeController.text) : null,
                      experience: isDoctor ? int.tryParse(_expController.text) : null,
                      staffRole: !isDoctor ? _staffRoleController.text : null,
                      designation: !isDoctor ? _designationController.text : null,
                    );
                    context.read<DoctorStaffBloc>().add(UpdateDoctorStaffMember(updatedUser));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                child: const Text("Save Changes", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on UserModel {
  UserModel copyWith({
    String? name,
    String? phoneNumber,
    String? gender,
    String? availabilityStatus,
    String? specialization,
    String? qualification,
    double? consultationFee,
    int? experience,
    String? staffRole,
    String? designation,
  }) {
    return UserModel(
      id: id,
      email: email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      role: role,
      profileCompletionStatus: profileCompletionStatus,
      status: status,
      department: department,
      qualification: qualification ?? this.qualification,
      metadata: metadata,
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: dateOfBirth,
      age: age,
      gender: gender ?? this.gender,
      profileImage: profileImage,
      address: address,
      emergencyContact: emergencyContact,
      bloodGroup: bloodGroup,
      maritalStatus: maritalStatus,
      employeeId: employeeId,
      patientId: patientId,
      medicalRegistrationNumber: medicalRegistrationNumber,
      experience: experience ?? this.experience,
      specialization: specialization ?? this.specialization,
      consultationFee: consultationFee ?? this.consultationFee,
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      staffRole: staffRole ?? this.staffRole,
      joiningDate: joiningDate,
      allergies: allergies,
      chronicDiseases: chronicDiseases,
      insuranceProvider: insuranceProvider,
      insuranceNumber: insuranceNumber,
      designation: designation ?? this.designation,
      accessLevel: accessLevel,
    );
  }
}
