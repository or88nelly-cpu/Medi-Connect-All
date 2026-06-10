import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/common_app_bar.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_event.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_state.dart';
import 'dart:math';

class DoctorStaffCreatePage extends StatefulWidget {
  const DoctorStaffCreatePage({
    super.key,
    required this.role,
    required this.departmentName,
  });

  final String role;
  final String departmentName;

  @override
  State<DoctorStaffCreatePage> createState() => _DoctorStaffCreatePageState();
}

class _DoctorStaffCreatePageState extends State<DoctorStaffCreatePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _qualificationsController = TextEditingController();
  final _specializationController = TextEditingController();
  final _feeController = TextEditingController();
  final _expController = TextEditingController();
  final _staffRoleController = TextEditingController();
  final _designationController = TextEditingController();

  String _gender = 'Male';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _qualificationsController.dispose();
    _specializationController.dispose();
    _feeController.dispose();
    _expController.dispose();
    _staffRoleController.dispose();
    _designationController.dispose();
    super.dispose();
  }

  String _generateUUID() {
    final random = Random();
    String hex(int length) {
      return List.generate(length, (_) => random.nextInt(16).toRadixString(16)).join();
    }
    return '${hex(8)}-${hex(4)}-4${hex(3)}-${(random.nextInt(4) + 8).toRadixString(16)}${hex(3)}-${hex(12)}';
  }

  @override
  Widget build(BuildContext context) {
    final isDoctor = widget.role == 'doctor';

    return CustomScaffold(
      customAppbar: CommonAppBar(title: "Add New ${widget.role.toUpperCase()}"),
      body: BlocListener<DoctorStaffBloc, DoctorStaffState>(
        listener: (context, state) {
          if (state is DoctorStaffActionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("New ${widget.role.toUpperCase()} added successfully.")),
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
              Text(
                "Department: ${widget.departmentName}",
                style: AppTextStyles.titleMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.h),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Full Name"),
                validator: (val) => val == null || val.isEmpty ? AppStrings.requiredField : null,
              ),
              SizedBox(height: 12.h),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: "Email Address"),
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
                    final newUser = UserModel(
                      id: _generateUUID(),
                      email: _emailController.text,
                      name: _nameController.text,
                      phoneNumber: _phoneController.text,
                      role: widget.role,
                      profileCompletionStatus: true,
                      status: 'Available',
                      department: widget.departmentName,
                      qualification: isDoctor ? _qualificationsController.text : null,
                      gender: _gender,
                      experience: isDoctor ? int.tryParse(_expController.text) : null,
                      specialization: isDoctor ? _specializationController.text : null,
                      consultationFee: isDoctor ? double.tryParse(_feeController.text) : null,
                      staffRole: !isDoctor ? _staffRoleController.text : null,
                      designation: !isDoctor ? _designationController.text : null,
                      availabilityStatus: 'Available',
                    );
                    context.read<DoctorStaffBloc>().add(CreateDoctorStaffMember(newUser));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(vertical: 16.h),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                ),
                child: Text("Create ${widget.role.toUpperCase()}", style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
