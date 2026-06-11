import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';
import 'package:medi_connect/features/patient/presentation/bloc/patient_bloc.dart';
import 'dart:math';

class AdminPatientsPage extends StatefulWidget {
  const AdminPatientsPage({super.key});

  @override
  State<AdminPatientsPage> createState() => _AdminPatientsPageState();
}

class _AdminPatientsPageState extends State<AdminPatientsPage> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<PatientBloc>().add(LoadPatients());
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

  @override
  Widget build(BuildContext context) {
    return BlocListener<PatientBloc, PatientState>(
      listener: (context, state) {
        if (state is PatientActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Action completed successfully."),
            ),
          );
        } else if (state is PatientError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: ${state.message}"),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddPatientDialog(context),
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text("Add Patient", style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.primary,
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppStrings.patients,
                    style: AppTextStyles.headingMedium.copyWith(fontSize: 22.sp),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              TextField(
                onChanged: (val) => setState(() => _searchQuery = val),
                decoration: InputDecoration(
                  hintText: "Search patient by name or phone...",
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: EdgeInsets.all(12.r),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: BlocBuilder<PatientBloc, PatientState>(
                  builder: (context, state) {
                    if (state is PatientLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is PatientError && state is! PatientLoaded) {
                      return Center(
                        child: Text(
                          "Error: ${state.message}",
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      );
                    }
                    
                    List<UserModel> patientsList = [];
                    if (state is PatientLoaded) {
                      patientsList = state.patients;
                    } else {
                      // fallback if loaded was previously there but currently action is taking place
                      final bloc = context.read<PatientBloc>();
                      if (bloc.state is PatientLoaded) {
                        patientsList = (bloc.state as PatientLoaded).patients;
                      }
                    }

                    if (patientsList.isEmpty) {
                      return Center(
                        child: Text(
                          AppStrings.noRecords,
                          style: AppTextStyles.bodyMedium,
                        ),
                      );
                    }

                    final filteredList = patientsList.where((p) {
                      final matchesName = (p.name ?? '').toLowerCase().contains(
                        _searchQuery.toLowerCase(),
                      );
                      final matchesPhone = (p.phoneNumber ?? '').contains(
                        _searchQuery,
                      );
                      return matchesName || matchesPhone;
                    }).toList();

                    if (filteredList.isEmpty) {
                      return Center(
                        child: Text(
                          "No matching patients found.",
                          style: AppTextStyles.bodyMedium,
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, idx) {
                        final patient = filteredList[idx];
                        return Card(
                          margin: EdgeInsets.only(bottom: 12.h),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            side: const BorderSide(color: AppColors.border),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16.r),
                            leading: CircleAvatar(
                              backgroundColor: AppColors.primary.withOpacity(0.1),
                              child: Icon(
                                patient.gender == 'Female'
                                    ? Icons.female
                                    : Icons.male,
                                color: AppColors.primary,
                              ),
                            ),
                            title: Text(
                              patient.name ?? 'Unnamed Patient',
                              style: AppTextStyles.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 4.h),
                                Text(
                                  "ID: ${patient.patientId ?? 'N/A'} | Age: ${patient.age ?? 'N/A'} | Blood: ${patient.bloodGroup ?? 'N/A'}",
                                ),
                                SizedBox(height: 2.h),
                                Text("Phone: ${patient.phoneNumber ?? 'N/A'}"),
                                if (patient.email.isNotEmpty) ...[
                                  SizedBox(height: 2.h),
                                  Text("Email: ${patient.email}"),
                                ],
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit_outlined,
                                    color: AppColors.warning,
                                  ),
                                  onPressed: () =>
                                      _showEditPatientDialog(context, patient),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: AppColors.error,
                                  ),
                                  onPressed: () =>
                                      _confirmDeletePatient(context, patient),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddPatientDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final ageController = TextEditingController();
    final phoneController = TextEditingController();
    String gender = 'Male';
    String blood = 'O+';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text("Add Patient", style: AppTextStyles.titleLarge),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Full Name"),
                ),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: "Email Address"),
                ),
                TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Age"),
                ),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: "Phone Number"),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    const Text("Gender: "),
                    SizedBox(width: 8.w),
                    DropdownButton<String>(
                      value: gender,
                      items: ['Male', 'Female', 'Other'].map((g) {
                        return DropdownMenuItem(value: g, child: Text(g));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => gender = val);
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text("Blood: "),
                    SizedBox(width: 8.w),
                    DropdownButton<String>(
                      value: blood,
                      items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
                          .map((b) {
                            return DropdownMenuItem(value: b, child: Text(b));
                          })
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => blood = val);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(AppStrings.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  final emailVal = emailController.text.trim().isNotEmpty
                      ? emailController.text.trim()
                      : 'patient-${Random().nextInt(900000) + 100000}@mediconnect.com';

                  final newPatient = UserModel(
                    id: _generateUUID(),
                    email: emailVal,
                    name: nameController.text.trim(),
                    phoneNumber: phoneController.text.trim().isNotEmpty
                        ? phoneController.text.trim()
                        : null,
                    role: 'patient',
                    profileCompletionStatus: true,
                    status: 'Active',
                    age: int.tryParse(ageController.text) ?? 30,
                    gender: gender,
                    bloodGroup: blood,
                    patientId: 'PAT-${Random().nextInt(900000) + 100000}',
                  );

                  context.read<PatientBloc>().add(CreatePatient(newPatient));
                  Navigator.pop(ctx);
                }
              },
              child: const Text(AppStrings.submit),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditPatientDialog(BuildContext context, UserModel patient) {
    final nameController = TextEditingController(text: patient.name);
    final emailController = TextEditingController(text: patient.email);
    final ageController = TextEditingController(
      text: patient.age?.toString() ?? '',
    );
    final phoneController = TextEditingController(
      text: patient.phoneNumber ?? '',
    );
    String gender = patient.gender ?? 'Male';
    String blood = patient.bloodGroup ?? 'O+';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text("Edit Patient", style: AppTextStyles.titleLarge),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Full Name"),
                ),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: "Email Address"),
                ),
                TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Age"),
                ),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: "Phone Number"),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    const Text("Gender: "),
                    SizedBox(width: 8.w),
                    DropdownButton<String>(
                      value: gender,
                      items: ['Male', 'Female', 'Other'].map((g) {
                        return DropdownMenuItem(value: g, child: Text(g));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => gender = val);
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text("Blood: "),
                    SizedBox(width: 8.w),
                    DropdownButton<String>(
                      value: blood,
                      items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
                          .map((b) {
                            return DropdownMenuItem(value: b, child: Text(b));
                          })
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => blood = val);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(AppStrings.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  final updatedPatient = UserModel(
                    id: patient.id,
                    email: emailController.text.trim(),
                    name: nameController.text.trim(),
                    phoneNumber: phoneController.text.trim().isNotEmpty
                        ? phoneController.text.trim()
                        : null,
                    role: 'patient',
                    profileCompletionStatus: patient.profileCompletionStatus,
                    status: patient.status,
                    age: int.tryParse(ageController.text) ?? patient.age,
                    gender: gender,
                    bloodGroup: blood,
                    patientId: patient.patientId,
                  );

                  context.read<PatientBloc>().add(UpdatePatient(updatedPatient));
                  Navigator.pop(ctx);
                }
              },
              child: const Text(AppStrings.submit),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeletePatient(BuildContext context, UserModel patient) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Patient Profile"),
        content: Text(
          "Are you sure you want to delete ${patient.name ?? 'this patient'}? This will soft-delete their profile.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<PatientBloc>().add(DeletePatient(patient.id));
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text("Delete", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

