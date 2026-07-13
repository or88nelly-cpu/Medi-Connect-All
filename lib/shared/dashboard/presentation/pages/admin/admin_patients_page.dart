import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/features/management/patient_management/presentation/bloc/patient_bloc.dart';

// Extracted sub-widgets
import 'package:medi_connect/shared/dashboard/presentation/widgets/common/directory_pagination.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_patients/patient_header.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_patients/patient_search_bar.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_patients/patient_filter_sort_row.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_patients/patient_card.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_patients/admin_patient_dialogs.dart';
import 'package:medi_connect/core/constants/app_constants.dart';

class AdminPatientsPage extends StatefulWidget {
  const AdminPatientsPage({super.key});

  @override
  State<AdminPatientsPage> createState() => _AdminPatientsPageState();
}

class _AdminPatientsPageState extends State<AdminPatientsPage> {
  final ValueNotifier<String> _searchNotifier = ValueNotifier<String>('');
  final ValueNotifier<String> _selectedBloodNotifier = ValueNotifier<String>(
    'All',
  );
  final ValueNotifier<String> _sortByNotifier = ValueNotifier<String>('None');
  final ValueNotifier<String> _statusFilterNotifier = ValueNotifier<String>(
    'All',
  );
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark
        ? AppColors.terminalDarkLabel
        : AppColors.terminalLightLabel;
    final List<String> bloodGroups = [
      'All',
      'A+',
      'A-',
      'B+',
      'B-',
      AppConstants.defaultBloodGroup,
      'O-',
      'AB+',
      'AB-',
    ];

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
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (state is PatientError &&
                              state is! PatientLoaded) {
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
                              patientsList =
                                  (bloc.state as PatientLoaded).patients;
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
                                          final filtered = patientsList.where((
                                            p,
                                          ) {
                                            final matchesSearch =
                                                (p.fullName)
                                                    .toLowerCase()
                                                    .contains(
                                                      searchQuery.toLowerCase(),
                                                    ) ||
                                                (p.phone ?? "").contains(
                                                  searchQuery,
                                                );
                                            final matchesBlood =
                                                selectedBlood == 'All' ||
                                                (p.bloodGroup ?? "")
                                                        .toLowerCase() ==
                                                    selectedBlood.toLowerCase();
                                            final matchesStatus =
                                                statusFilter == 'All' ||
                                                (p.status)?.toLowerCase() ==
                                                    statusFilter.toLowerCase();
                                            return matchesSearch &&
                                                matchesBlood &&
                                                matchesStatus;
                                          }).toList();

                                          // 2. Sort
                                          if (sortBy == 'Name (A-Z)') {
                                            filtered.sort(
                                              (a, b) => (a.fullName).compareTo(
                                                b.fullName,
                                              ),
                                            );
                                          } else if (sortBy == 'Name (Z-A)') {
                                            filtered.sort(
                                              (a, b) => (b.fullName).compareTo(
                                                a.fullName,
                                              ),
                                            );
                                          }

                                          if (filtered.isEmpty) {
                                            return Center(
                                              child: Text(
                                                "No matching patients found.",
                                                style: TextStyle(
                                                  color: labelColor,
                                                ),
                                              ),
                                            );
                                          }

                                          return ValueListenableBuilder<int>(
                                            valueListenable:
                                                _currentPageNotifier,
                                            builder: (context, currentPage, _) {
                                              final totalPages =
                                                  (filtered.length /
                                                          _itemsPerPage)
                                                      .ceil();
                                              final startIndex =
                                                  (currentPage - 1) *
                                                  _itemsPerPage;
                                              final endIndex =
                                                  (startIndex + _itemsPerPage)
                                                      .clamp(
                                                        0,
                                                        filtered.length,
                                                      );
                                              final paginatedList = filtered
                                                  .sublist(
                                                    startIndex,
                                                    endIndex,
                                                  );

                                              return Column(
                                                children: [
                                                  Expanded(
                                                    child: ListView.builder(
                                                      itemCount:
                                                          paginatedList.length,
                                                      itemBuilder: (context, idx) {
                                                        final patient =
                                                            paginatedList[idx];
                                                        return PatientCard(
                                                          patient: patient,
                                                          onTap: () {
                                                            AdminPatientDialogs.showPatientDetailSheet(
                                                              context,
                                                              patient,
                                                            );
                                                          },
                                                          onEdit: () {
                                                            AdminPatientDialogs.showEditPatientDialog(
                                                              context,
                                                              patient,
                                                            );
                                                          },
                                                          onDelete: () {
                                                            AdminPatientDialogs.confirmDeletePatient(
                                                              context,
                                                              patient,
                                                            );
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  DirectoryPagination(
                                                    currentPage: currentPage,
                                                    totalPages: totalPages,
                                                    onPageChanged: (page) {
                                                      _currentPageNotifier
                                                              .value =
                                                          page;
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
                              onPressed: () =>
                                  AdminPatientDialogs.showAddPatientDialog(
                                    context,
                                  ),
                              backgroundColor: AppColors.primary,
                              child: const Icon(
                                Icons.add,
                                color: AppColors.surface,
                              ),
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
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
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
}
