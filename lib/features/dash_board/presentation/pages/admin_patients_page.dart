import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';
import 'package:medi_connect/features/patient/presentation/bloc/patient_bloc.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/utils/profile_image_helper.dart';
import 'dart:math';

class AdminPatientsPage extends StatefulWidget {
  const AdminPatientsPage({super.key});

  @override
  State<AdminPatientsPage> createState() => _AdminPatientsPageState();
}

class _AdminPatientsPageState extends State<AdminPatientsPage> {
  final ValueNotifier<String> _searchNotifier = ValueNotifier<String>('');
  final ValueNotifier<String> _selectedBloodNotifier = ValueNotifier<String>('All');
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final borderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final textColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Patients",
                          style: AppTextStyles.titleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            fontSize: 24.sp,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "Manage and view all patients",
                          style: AppTextStyles.bodySmall.copyWith(
                            color: labelColor,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        _buildRoundHeaderButton(Icons.search, () {}),
                        SizedBox(width: 8.w),
                        _buildRoundHeaderButton(Icons.filter_list, () {}),
                        SizedBox(width: 8.w),
                        _buildRoundHeaderButton(Icons.more_vert, () {}),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // 2. Dropdowns Row
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: ValueListenableBuilder<String>(
                        valueListenable: _selectedBloodNotifier,
                        builder: (context, selectedBlood, _) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.w),
                            decoration: BoxDecoration(
                              color: cardBg,
                              borderRadius: BorderRadius.circular(8.r),
                              border: Border.all(color: borderColor, width: 1.2),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: bloodGroups.contains(selectedBlood) ? selectedBlood : 'All',
                                icon: Icon(Icons.keyboard_arrow_down, color: labelColor),
                                isExpanded: true,
                                dropdownColor: cardBg,
                                items: bloodGroups.map((bg) {
                                  return DropdownMenuItem(
                                    value: bg,
                                    child: Text(
                                      bg == 'All' ? 'All Blood Groups' : bg,
                                      style: TextStyle(
                                        color: textColor,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (val) {
                                  if (val != null) {
                                    _selectedBloodNotifier.value = val;
                                    _currentPageNotifier.value = 1;
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      flex: 3,
                      child: _buildFilterSortButton("Filters", Icons.tune, () {}),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      flex: 3,
                      child: _buildFilterSortButton("Sort", Icons.swap_vert, () {}),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                // 3. Search Bar
                Container(
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: borderColor, width: 1.2),
                  ),
                  child: TextField(
                    onChanged: (val) {
                      _searchNotifier.value = val;
                      _currentPageNotifier.value = 1;
                    },
                    style: TextStyle(color: textColor, fontSize: 13.sp),
                    decoration: InputDecoration(
                      hintText: "Search patients by name, email or phone...",
                      hintStyle: TextStyle(color: labelColor.withValues(alpha: 0.7)),
                      prefixIcon: Icon(Icons.search, color: labelColor),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                // 4. Patients List (Paginated & Filtered)
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
                                  final filtered = patientsList.where((p) {
                                    final matchesSearch = (p.name ?? '').toLowerCase().contains(searchQuery.toLowerCase()) ||
                                        (p.phoneNumber ?? '').contains(searchQuery);
                                    final matchesBlood = selectedBlood == 'All' ||
                                        (p.bloodGroup ?? '').toLowerCase() == selectedBlood.toLowerCase();
                                    return matchesSearch && matchesBlood;
                                  }).toList();

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
                                                final status = patient.status;

                                                return Container(
                                                  margin: EdgeInsets.only(bottom: 12.h),
                                                  padding: EdgeInsets.all(12.r),
                                                  decoration: BoxDecoration(
                                                    color: cardBg,
                                                    borderRadius: BorderRadius.circular(12.r),
                                                    border: Border.all(color: borderColor, width: 1.2),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      CircleAvatar(
                                                        radius: 24.r,
                                                        backgroundColor: isDark ? Colors.white12 : Colors.black12,
                                                        child: ClipOval(
                                                          child: CustomImageView(
                                                            imagePath: ProfileImageHelper.resolveImagePath(
                                                              patient.profileImage,
                                                              'patient',
                                                              patient.gender,
                                                            ),
                                                            width: 48.r,
                                                            height: 48.r,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(width: 12.w),
                                                      Expanded(
                                                        child: Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            Text(
                                                              patient.name ?? 'Unnamed Patient',
                                                              style: AppTextStyles.bodyMedium.copyWith(
                                                                fontWeight: FontWeight.bold,
                                                                color: textColor,
                                                                fontSize: 14.sp,
                                                              ),
                                                            ),
                                                            SizedBox(height: 4.h),
                                                            Row(
                                                              children: [
                                                                Container(
                                                                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                                                                  decoration: BoxDecoration(
                                                                    color: AppColors.primary.withValues(alpha: 0.15),
                                                                    borderRadius: BorderRadius.circular(4.r),
                                                                  ),
                                                                  child: Text(
                                                                    patient.patientId ?? 'PAT-N/A',
                                                                    style: TextStyle(
                                                                      color: AppColors.primary,
                                                                      fontSize: 10.sp,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(height: 4.h),
                                                            Text(
                                                              "Age: ${patient.age ?? 'N/A'} | Blood: ${patient.bloodGroup ?? 'N/A'} | Phone: ${patient.phoneNumber ?? 'N/A'}",
                                                              style: TextStyle(
                                                                color: labelColor,
                                                                fontSize: 11.sp,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          _buildStatusPill(status),
                                                          PopupMenuButton<String>(
                                                            icon: Icon(Icons.more_vert, color: labelColor),
                                                            color: cardBg,
                                                            onSelected: (action) {
                                                              if (action == 'edit') {
                                                                _showEditPatientDialog(context, patient);
                                                              } else if (action == 'delete') {
                                                                _confirmDeletePatient(context, patient);
                                                              }
                                                            },
                                                            itemBuilder: (ctx) => [
                                                              PopupMenuItem(
                                                                value: 'edit',
                                                                child: Text("Edit Patient", style: TextStyle(color: textColor)),
                                                              ),
                                                              PopupMenuItem(
                                                                value: 'delete',
                                                                child: Text("Delete Patient", style: TextStyle(color: AppColors.error)),
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          _buildPaginationControls(currentPage, totalPages),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
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

  Widget _buildRoundHeaderButton(IconData icon, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final btnBg = isDark ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.05);
    final iconColor = isDark ? Colors.white : AppColors.terminalLightText;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: btnBg,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 18.r),
      ),
    );
  }

  Widget _buildFilterSortButton(String label, IconData icon, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final borderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final textColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: labelColor, size: 16.r),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                color: textColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    Color dotColor = AppColors.success;
    Color bgPillColor = AppColors.success.withValues(alpha: 0.1);
    String label = "Active";

    if (status.toLowerCase().contains("away")) {
      dotColor = AppColors.accent;
      bgPillColor = AppColors.accent.withValues(alpha: 0.1);
      label = "Away";
    } else if (status.toLowerCase().contains("inactive")) {
      dotColor = AppColors.error;
      bgPillColor = AppColors.error.withValues(alpha: 0.1);
      label = "Inactive";
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgPillColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: dotColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              color: dotColor,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationControls(int currentPage, int totalPages) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;
    final textColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;
    final activeBg = AppColors.primary;
    final inactiveBg = isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05);

    return Padding(
      padding: EdgeInsets.only(top: 12.h, bottom: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$currentPage of ${totalPages > 0 ? totalPages : 1}",
            style: TextStyle(color: labelColor, fontSize: 12.sp, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              // Back arrow
              _buildPaginationArrow(Icons.chevron_left, currentPage > 1 ? () {
                _currentPageNotifier.value = currentPage - 1;
              } : null),
              SizedBox(width: 6.w),

              // Page Numbers
              ...List.generate(totalPages, (index) {
                final pageNum = index + 1;
                final isActive = pageNum == currentPage;
                return GestureDetector(
                  onTap: () {
                    _currentPageNotifier.value = pageNum;
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: isActive ? activeBg : inactiveBg,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      pageNum.toString(),
                      style: TextStyle(
                        color: isActive ? Colors.white : textColor,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),

              SizedBox(width: 6.w),
              // Next arrow
              _buildPaginationArrow(Icons.chevron_right, currentPage < totalPages ? () {
                _currentPageNotifier.value = currentPage + 1;
              } : null),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationArrow(IconData icon, VoidCallback? onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = onTap != null
        ? (isDark ? Colors.white : AppColors.terminalLightText)
        : (isDark ? Colors.white30 : Colors.black26);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4.r),
      child: Container(
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(
            color: isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder,
            width: 1,
          ),
        ),
        child: Icon(icon, color: iconColor, size: 16.r),
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
