import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/constants/app_enum.dart';
import 'package:medi_connect/core/widgets/appbar/common_app_bar.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/edit_profile/edit_doctor_profile_view.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_event.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_state.dart';

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
    _nameController = TextEditingController(text: widget.user.fullName);
    _phoneController = TextEditingController(text: widget.user.phone);
    _qualificationsController = TextEditingController(text: '');
    _specializationController = TextEditingController(text: '');
    _feeController = TextEditingController(text: '');
    _expController = TextEditingController(text: '');
    _staffRoleController = TextEditingController(text: '');
    _designationController = TextEditingController(text: '');

    _availabilityStatus = 'Available';
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
    if (widget.user.role == UserRole.doctor) {
      return EditDoctorProfileView(user: widget.user);
    }

    final isDoctor = widget.user.role == UserRole.doctor;

    return CustomScaffold(
      customAppbar: CommonAppBar(
        title: "Edit ${widget.user.role.value.toUpperCase()}",
      ),
      body: BlocListener<DoctorStaffBloc, DoctorStaffState>(
        listener: (context, state) {
          if (state is DoctorStaffActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "${widget.user.role.value.toUpperCase()} updated successfully.",
                ),
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
            padding: EdgeInsets.all(20.r),
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: (val) => val == null || val.isEmpty
                    ? AppStrings.requiredField
                    : null,
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
                    items: ['Available', 'On Leave', 'Busy', 'Offline'].map((
                      s,
                    ) {
                      return DropdownMenuItem(value: s, child: Text(s));
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _availabilityStatus = val);
                      }
                    },
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              if (isDoctor) ...[
                TextFormField(
                  controller: _specializationController,
                  decoration: const InputDecoration(
                    labelText: "Specialization",
                  ),
                  validator: (val) => val == null || val.isEmpty
                      ? AppStrings.requiredField
                      : null,
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: _qualificationsController,
                  decoration: const InputDecoration(
                    labelText: "Qualifications",
                  ),
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: _feeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Consultation Fee (₹)",
                  ),
                ),
                SizedBox(height: 12.h),
                TextFormField(
                  controller: _expController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Experience (Years)",
                  ),
                ),
              ] else ...[
                TextFormField(
                  controller: _staffRoleController,
                  decoration: const InputDecoration(labelText: "Staff Role"),
                  validator: (val) => val == null || val.isEmpty
                      ? AppStrings.requiredField
                      : null,
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
                    final nameParts = _nameController.text.trim().split(' ');
                    final firstName = nameParts.isNotEmpty
                        ? nameParts.first
                        : '';
                    final lastName = nameParts.length > 1
                        ? nameParts.sublist(1).join(' ')
                        : '';

                    final updatedUser = UserModel.fromEntity(widget.user)
                        .copyWith(
                          firstName: firstName,
                          lastName: lastName,
                          phone: _phoneController.text,
                          gender: _gender,
                        );
                    context.read<DoctorStaffBloc>().add(
                      UpdateDoctorStaffMember(updatedUser),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: const Text(
                  "Save Changes",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on UserModel {
  UserModel copyWith({String? name, String? phoneNumber, String? gender}) {
    final nameParts = (name ?? fullName).trim().split(' ');
    final firstName = nameParts.isNotEmpty ? nameParts.first : '';
    final lastName = nameParts.length > 1
        ? nameParts.sublist(1).join(' ')
        : 'Staff';
    return UserModel(
      id: id,
      authUserId: authUserId,
      firstName: firstName,
      lastName: lastName,
      email: email,
      phone: phoneNumber ?? phone,
      gender: gender ?? this.gender,
      dob: dob,
      bloodGroup: bloodGroup,
      profilePhoto: profilePhoto,
      status: status,
      lastLoginAt: lastLoginAt,
      activeAt: activeAt,
      createdAt: createdAt,
      updatedAt: updatedAt,
      role: role,
    );
  }
}
