import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';
import 'package:medi_connect/features/patient/presentation/bloc/patient_bloc.dart';
import 'booking_wizard_cubit.dart';

class PatientStep extends StatelessWidget {
  final GlobalKey<FormState> patientFormKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController ageController;

  const PatientStep({
    super.key,
    required this.patientFormKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.ageController,
  });

  String _generateUUID() {
    final random = math.Random();
    String hex(int length) {
      return List.generate(
        length,
        (_) => random.nextInt(16).toRadixString(16),
      ).join();
    }

    return '${hex(8)}-${hex(4)}-4${hex(3)}-${(random.nextInt(4) + 8).toRadixString(16)}${hex(3)}-${hex(12)}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.watch<BookingWizardCubit>();
    final state = cubit.state;

    if (state.isCreatingPatient) {
      return Form(
        key: patientFormKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "New Patient Registration",
                    style: AppTextStyles.titleMedium.copyWith(
                      color: isDark
                          ? Colors.white
                          : AppColors.textPrimary(context),
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => cubit.toggleCreatingPatient(false),
                    icon: const Icon(Icons.list),
                    label: const Text("Select Existing"),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: firstNameController,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isDark
                            ? Colors.white
                            : AppColors.textPrimary(context),
                      ),
                      decoration: const InputDecoration(
                        labelText: "First Name",
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? "Required" : null,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TextFormField(
                      controller: lastNameController,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isDark
                            ? Colors.white
                            : AppColors.textPrimary(context),
                      ),
                      decoration: const InputDecoration(
                        labelText: "Last Name",
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? "Required" : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDark ? Colors.white : AppColors.textPrimary(context),
                ),
                decoration: const InputDecoration(
                  labelText: "Email ID",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                ),
                validator: (val) => val == null || !val.contains("@")
                    ? "Enter a valid email"
                    : null,
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isDark
                            ? Colors.white
                            : AppColors.textPrimary(context),
                      ),
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                      ),
                      validator: (val) => val == null || val.length < 10
                          ? "Enter 10 digits"
                          : null,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TextFormField(
                      controller: ageController,
                      keyboardType: TextInputType.number,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isDark
                            ? Colors.white
                            : AppColors.textPrimary(context),
                      ),
                      decoration: const InputDecoration(
                        labelText: "Age",
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                      ),
                      validator: (val) =>
                          val == null || int.tryParse(val) == null
                          ? "Enter age"
                          : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Text(
                    "Gender:  ",
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isDark
                          ? Colors.white70
                          : AppColors.textPrimary(context),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: ['Male', 'Female', 'Other'].map((g) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio<String>(
                            value: g,
                            groupValue: state.gender,
                            onChanged: (val) {
                              if (val != null) cubit.setGender(val);
                            },
                          ),
                          Text(
                            g,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isDark
                                  ? Colors.white70
                                  : AppColors.textPrimary(context),
                            ),
                          ),
                          SizedBox(width: 8.w),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (patientFormKey.currentState!.validate()) {
                        final newPatient = UserModel(
                          id: _generateUUID(),
                          email: emailController.text.trim(),
                          name:
                              "${firstNameController.text.trim()} ${lastNameController.text.trim()}",
                          firstName: firstNameController.text.trim(),
                          lastName: lastNameController.text.trim(),
                          phoneNumber: phoneController.text.trim(),
                          role: 'patient',
                          profileCompletionStatus: true,
                          status: 'Active',
                          gender: state.gender,
                          age: int.tryParse(ageController.text.trim()) ?? 0,
                          metadata: {
                            'first_name': firstNameController.text.trim(),
                            'last_name': lastNameController.text.trim(),
                            'age': int.tryParse(ageController.text.trim()) ?? 0,
                            'gender': state.gender,
                          },
                        );
                        context.read<PatientBloc>().add(
                          CreatePatient(newPatient),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                    ),
                    child: Text(
                      "Register & Select",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextField(
                onChanged: (val) => cubit.setPatientSearchQuery(val),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDark ? Colors.white : AppColors.textPrimary(context),
                ),
                decoration: InputDecoration(
                  hintText: "Search patient name, email, or phone...",
                  hintStyle: AppTextStyles.bodySmall.copyWith(
                    color: isDark
                        ? Colors.white54
                        : AppColors.textSecondary(context),
                  ),
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.r,
                    vertical: 8.r,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            IconButton(
              onPressed: () => cubit.toggleCreatingPatient(true),
              icon: const Icon(Icons.person_add, color: AppColors.primary),
              tooltip: "New Patient",
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Expanded(
          child: BlocBuilder<PatientBloc, PatientState>(
            builder: (context, patientState) {
              if (patientState is PatientLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (patientState is PatientLoaded) {
                final list = patientState.patients.where((p) {
                  final nameMatch =
                      (p.name ?? '').toLowerCase().contains(
                        state.patientSearchQuery.toLowerCase(),
                      ) ||
                      (p.firstName ?? '').toLowerCase().contains(
                        state.patientSearchQuery.toLowerCase(),
                      ) ||
                      (p.lastName ?? '').toLowerCase().contains(
                        state.patientSearchQuery.toLowerCase(),
                      );
                  final emailMatch = (p.email).toLowerCase().contains(
                    state.patientSearchQuery.toLowerCase(),
                  );
                  final phoneMatch = (p.phoneNumber ?? '').contains(
                    state.patientSearchQuery,
                  );
                  return nameMatch || emailMatch || phoneMatch;
                }).toList();

                if (list.isEmpty) {
                  return Center(
                    child: Text(
                      "No patients found. Create one!",
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isDark
                            ? Colors.white54
                            : AppColors.textSecondary(context),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (ctx, idx) {
                    final p = list[idx];
                    final isSelected = state.selectedPatient?.id == p.id;
                    return GestureDetector(
                      onTap: () => cubit.selectPatient(p),
                      child: Container(
                        margin: EdgeInsets.only(bottom: 8.h),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withValues(alpha: 0.1)
                              : (isDark
                                    ? AppColors.terminalDarkBg
                                    : Colors.grey[50]),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : (AppColors.border(context)),
                            width: isSelected ? 1.5 : 1,
                          ),
                        ),
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 4.h,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: isSelected
                                ? AppColors.primary
                                : (isDark
                                      ? AppColors.terminalDarkBorder
                                      : Colors.grey[300]),
                            child: Icon(
                              isSelected ? Icons.check : Icons.person,
                              color: isSelected
                                  ? Colors.white
                                  : (isDark
                                        ? Colors.white54
                                        : Colors.grey[600]),
                            ),
                          ),
                          title: Text(
                            p.name ?? '${p.firstName} ${p.lastName}'.trim(),
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.textPrimary(context),
                            ),
                          ),
                          subtitle: Text(
                            "${p.email} • ${p.phoneNumber ?? 'No Phone'}",
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isDark
                                  ? Colors.white54
                                  : AppColors.textSecondary(context),
                            ),
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                "Age: ${p.age ?? p.metadata?['age'] ?? 'N/A'}",
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.white70
                                      : AppColors.textPrimary(context),
                                ),
                              ),
                              Text(
                                p.gender ?? p.metadata?['gender'] ?? 'N/A',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: isDark
                                      ? Colors.white38
                                      : AppColors.textSecondary(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
