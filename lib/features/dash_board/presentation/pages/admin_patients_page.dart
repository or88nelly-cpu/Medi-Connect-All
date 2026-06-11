import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';
import 'package:medi_connect/features/patient/presentation/bloc/patient_bloc.dart';
import 'dart:math';

// Extracted sub-widgets
import 'package:medi_connect/features/dash_board/presentation/widgets/common/directory_pagination.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/admin_patients/patient_header.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/admin_patients/patient_search_bar.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/admin_patients/patient_filter_sort_row.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/admin_patients/patient_card.dart';

class AdminPatientsPage extends StatefulWidget {
  const AdminPatientsPage({super.key});

  @override
  State<AdminPatientsPage> createState() => _AdminPatientsPageState();
}

class _AdminPatientsPageState extends State<AdminPatientsPage> {
  final ValueNotifier<String> _searchNotifier = ValueNotifier<String>('');
  final ValueNotifier<String> _selectedBloodNotifier = ValueNotifier<String>('All');
  final ValueNotifier<String> _sortByNotifier = ValueNotifier<String>('None');
  final ValueNotifier<String> _statusFilterNotifier = ValueNotifier<String>('All');
  final ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(1);
  final int _itemsPerPage = 5;

  @override
  void initState() {
    super.initState();
    context.read<PatientBloc>().add(LoadPatients());
  }

  @override
  void dispose() {
    _searchNotifier.dispose();
    _selectedBloodNotifier.dispose();
    _sortByNotifier.dispose();
    _statusFilterNotifier.dispose();
    _currentPageNotifier.dispose();
    super.dispose();
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
                  decoration: const InputDecoration(labelText: "Email Address (Optional)"),
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
                      value: ['Male', 'Female', 'Other'].contains(gender) ? gender : 'Male',
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
                      value: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'].contains(blood) ? blood : 'O+',
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
                    profileImage: patient.profileImage,
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
        title: const Text("Delete Patient"),
        content: Text("Are you sure you want to delete patient ${patient.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<PatientBloc>().add(DeletePatient(patient.id));
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;
    final List<String> bloodGroups = ['All', 'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

    return BlocListener<PatientBloc, PatientState>(
      listener: (context, state) {
        if (state is PatientActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Action completed successfully.")),
          );
          context.read<PatientBloc>().add(LoadPatients());
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
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Custom Header
                const PatientHeader(),
                SizedBox(height: 16.h),

                // 2. Dropdowns/Filters Row
                PatientFilterSortRow(
                  selectedBloodNotifier: _selectedBloodNotifier,
                  sortByNotifier: _sortByNotifier,
                  statusFilterNotifier: _statusFilterNotifier,
                  currentPageNotifier: _currentPageNotifier,
                  bloodGroups: bloodGroups,
                ),
                SizedBox(height: 12.h),

                // 3. Search Bar
                PatientSearchBar(
                  searchNotifier: _searchNotifier,
                  currentPageNotifier: _currentPageNotifier,
                ),
                SizedBox(height: 16.h),

                // 4. Patients List (Paginated, Filtered & Sorted)
                Expanded(
                  child: Stack(
                    children: [
                      BlocBuilder<PatientBloc, PatientState>(
                        builder: (context, state) {
                          if (state is PatientLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state is PatientError && state is! PatientLoaded) {
                            return Center(
                              child: Text(
                                "Error: ${state.message}",
                                style: TextStyle(color: AppColors.error),
                              ),
                            );
                          }

                          List<UserModel> patientsList = [];
                          if (state is PatientLoaded) {
                            patientsList = state.patients;
                          } else {
                            final bloc = context.read<PatientBloc>();
                            if (bloc.state is PatientLoaded) {
                              patientsList = (bloc.state as PatientLoaded).patients;
                            }
                          }

                          if (patientsList.isEmpty) {
                            return Center(
                              child: Text(
                                AppStrings.noRecords,
                                style: TextStyle(color: labelColor),
                              ),
                            );
                          }

                          return ValueListenableBuilder<String>(
                            valueListenable: _searchNotifier,
                            builder: (context, searchQuery, _) {
                              return ValueListenableBuilder<String>(
                                valueListenable: _selectedBloodNotifier,
                                builder: (context, selectedBlood, _) {
                                  return ValueListenableBuilder<String>(
                                    valueListenable: _sortByNotifier,
                                    builder: (context, sortBy, _) {
                                      return ValueListenableBuilder<String>(
                                        valueListenable: _statusFilterNotifier,
                                        builder: (context, statusFilter, _) {
                                          // 1. Filter
                                          final filtered = patientsList.where((p) {
                                            final matchesSearch = (p.name ?? '').toLowerCase().contains(searchQuery.toLowerCase()) ||
                                                (p.phoneNumber ?? '').contains(searchQuery);
                                            final matchesBlood = selectedBlood == 'All' ||
                                                (p.bloodGroup ?? '').toLowerCase() == selectedBlood.toLowerCase();
                                            final matchesStatus = statusFilter == 'All' ||
                                                (p.status).toLowerCase() == statusFilter.toLowerCase();
                                            return matchesSearch && matchesBlood && matchesStatus;
                                          }).toList();

                                          // 2. Sort
                                          if (sortBy == 'Name (A-Z)') {
                                            filtered.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
                                          } else if (sortBy == 'Name (Z-A)') {
                                            filtered.sort((a, b) => (b.name ?? '').compareTo(a.name ?? ''));
                                          } else if (sortBy == 'Age (Young-Old)') {
                                            filtered.sort((a, b) => (a.age ?? 0).compareTo(b.age ?? 0));
                                          } else if (sortBy == 'Age (Old-Young)') {
                                            filtered.sort((a, b) => (b.age ?? 0).compareTo(a.age ?? 0));
                                          }

                                          if (filtered.isEmpty) {
                                            return Center(
                                              child: Text(
                                                "No matching patients found.",
                                                style: TextStyle(color: labelColor),
                                              ),
                                            );
                                          }

                                          return ValueListenableBuilder<int>(
                                            valueListenable: _currentPageNotifier,
                                            builder: (context, currentPage, _) {
                                              final totalPages = (filtered.length / _itemsPerPage).ceil();
                                              final startIndex = (currentPage - 1) * _itemsPerPage;
                                              final endIndex = (startIndex + _itemsPerPage).clamp(0, filtered.length);
                                              final paginatedList = filtered.sublist(startIndex, endIndex);

                                              return Column(
                                                children: [
                                                  Expanded(
                                                    child: ListView.builder(
                                                      itemCount: paginatedList.length,
                                                      itemBuilder: (context, idx) {
                                                        final patient = paginatedList[idx];
                                                        return PatientCard(
                                                          patient: patient,
                                                          onTap: () {
                                                            _showEditPatientDialog(context, patient);
                                                          },
                                                          onEdit: () {
                                                            _showEditPatientDialog(context, patient);
                                                          },
                                                          onDelete: () {
                                                            _confirmDeletePatient(context, patient);
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  DirectoryPagination(
                                                    currentPage: currentPage,
                                                    totalPages: totalPages,
                                                    onPageChanged: (page) {
                                                      _currentPageNotifier.value = page;
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                      // Custom Add FAB & Label
                      Positioned(
                        bottom: 16.h,
                        right: 16.w,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FloatingActionButton(
                              heroTag: 'add_patient_fab',
                              onPressed: () => _showAddPatientDialog(context),
                              backgroundColor: AppColors.primary,
                              child: const Icon(Icons.add, color: Colors.white),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "Add Patient",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
