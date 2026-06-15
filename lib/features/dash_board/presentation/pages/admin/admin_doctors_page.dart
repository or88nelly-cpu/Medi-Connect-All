import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';
import 'package:medi_connect/features/department/presentation/bloc/department_bloc.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_event.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_state.dart';

// Extracted sub-widgets
import 'package:medi_connect/features/dash_board/presentation/widgets/common/directory_pagination.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/admin_doctors/doctors_header.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/admin_doctors/doctors_search_bar.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/admin_doctors/doctors_filter_sort_row.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/admin_doctors/doctor_card.dart';

class AdminDoctorsPage extends StatefulWidget {
  const AdminDoctorsPage({super.key});

  @override
  State<AdminDoctorsPage> createState() => _AdminDoctorsPageState();
}

class _AdminDoctorsPageState extends State<AdminDoctorsPage> {
  final ValueNotifier<String> _searchNotifier = ValueNotifier<String>('');
  final ValueNotifier<String> _selectedSectionNotifier = ValueNotifier<String>(
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
    context.read<DepartmentBloc>().add(const LoadDepartments());
  }

  @override
  void dispose() {
    _searchNotifier.dispose();
    _selectedSectionNotifier.dispose();
    _sortByNotifier.dispose();
    _statusFilterNotifier.dispose();
    _currentPageNotifier.dispose();
    super.dispose();
  }

  void _showSelectDepartmentAndCreate(BuildContext context) {
    final state = context.read<DepartmentBloc>().state;
    List<String> list = [];
    if (state is DepartmentsLoaded) {
      list.addAll(
        state.sections.map((e) => e.name).where((name) => name.isNotEmpty),
      );
      list.addAll(
        state.departments.map((e) => e.name).where((name) => name.isNotEmpty),
      );
      list = list.toSet().toList();
    }

    if (list.isEmpty) {
      list = [
        'General Medicine',
        'Cardiology',
        'Neurology',
        'Pediatrics',
        'Emergency',
        'OPD',
      ];
    }

    String selectedDept = list.first;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text("Select Department"),
          content: DropdownButton<String>(
            value: selectedDept,
            isExpanded: true,
            items: list.map((d) {
              return DropdownMenuItem(value: d, child: Text(d));
            }).toList(),
            onChanged: (val) {
              if (val != null) setDialogState(() => selectedDept = val);
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(ctx);
                context
                    .push(
                      '/admin/doctor-staff/create',
                      extra: {'role': 'doctor', 'department': selectedDept},
                    )
                    .then((value) {
                      if (value == true && context.mounted) {
                        context.read<DoctorStaffBloc>().add(
                          const LoadDoctorStaff('All'),
                        );
                      }
                    });
              },
              child: const Text("Next"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark
        ? AppColors.terminalDarkLabel
        : AppColors.terminalLightLabel;

    return BlocProvider(
      create: (context) =>
          GetIt.I<DoctorStaffBloc>()..add(const LoadDoctorStaff('All')),
      child: Builder(
        builder: (context) {
          return CustomScaffold(
            appBarNeeded: false,
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Custom Header
                    const DoctorsHeader(),
                    SizedBox(height: 16.h),

                    // 2. Dropdowns/Filters Row
                    BlocBuilder<DepartmentBloc, DepartmentState>(
                      builder: (context, state) {
                        final List<String> sections = ['All'];
                        if (state is DepartmentsLoaded) {
                          sections.addAll(
                            state.sections
                                .map((e) => e.name)
                                .where((name) => name.isNotEmpty),
                          );
                        }
                        final uniqueSections = sections.toSet().toList();

                        return DoctorsFilterSortRow(
                          selectedSectionNotifier: _selectedSectionNotifier,
                          sortByNotifier: _sortByNotifier,
                          statusFilterNotifier: _statusFilterNotifier,
                          currentPageNotifier: _currentPageNotifier,
                          sections: uniqueSections,
                        );
                      },
                    ),
                    SizedBox(height: 12.h),

                    // 3. Search Bar
                    DoctorsSearchBar(
                      searchNotifier: _searchNotifier,
                      currentPageNotifier: _currentPageNotifier,
                    ),
                    SizedBox(height: 16.h),

                    // 4. Doctors List (Paginated, Filtered & Sorted)
                    Expanded(
                      child: Stack(
                        children: [
                          BlocBuilder<DoctorStaffBloc, DoctorStaffState>(
                            builder: (context, state) {
                              if (state is DoctorStaffLoading) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              } else if (state is DoctorStaffError) {
                                return Center(
                                  child: Text(
                                    state.message,
                                    style: TextStyle(color: AppColors.error),
                                  ),
                                );
                              }

                              List<UserModel> doctorsList = [];
                              if (state is DoctorStaffLoaded) {
                                doctorsList = state.doctors
                                    .where((u) => u.role == 'doctor')
                                    .toList();
                              }

                              if (doctorsList.isEmpty) {
                                return Center(
                                  child: Text(
                                    "No doctors found.",
                                    style: TextStyle(color: labelColor),
                                  ),
                                );
                              }

                              return ValueListenableBuilder<String>(
                                valueListenable: _searchNotifier,
                                builder: (context, searchQuery, _) {
                                  return ValueListenableBuilder<String>(
                                    valueListenable: _selectedSectionNotifier,
                                    builder: (context, selectedSection, _) {
                                      return ValueListenableBuilder<String>(
                                        valueListenable: _sortByNotifier,
                                        builder: (context, sortBy, _) {
                                          return ValueListenableBuilder<String>(
                                            valueListenable:
                                                _statusFilterNotifier,
                                            builder: (context, statusFilter, _) {
                                              // 1. Filter
                                              final filtered = doctorsList.where(
                                                (doc) {
                                                  final matchesSearch =
                                                      (doc.name ?? '')
                                                          .toLowerCase()
                                                          .contains(
                                                            searchQuery
                                                                .toLowerCase(),
                                                          ) ||
                                                      (doc.specialization ?? '')
                                                          .toLowerCase()
                                                          .contains(
                                                            searchQuery
                                                                .toLowerCase(),
                                                          );
                                                  final matchesSection =
                                                      selectedSection ==
                                                          'All' ||
                                                      doc.department ==
                                                          selectedSection;
                                                  final matchesStatus =
                                                      statusFilter == 'All' ||
                                                      doc.status
                                                              .toLowerCase() ==
                                                          statusFilter
                                                              .toLowerCase();
                                                  return matchesSearch &&
                                                      matchesSection &&
                                                      matchesStatus;
                                                },
                                              ).toList();

                                              // 2. Sort
                                              if (sortBy == 'Name (A-Z)') {
                                                filtered.sort(
                                                  (a, b) => (a.name ?? '')
                                                      .compareTo(b.name ?? ''),
                                                );
                                              } else if (sortBy ==
                                                  'Name (Z-A)') {
                                                filtered.sort(
                                                  (a, b) => (b.name ?? '')
                                                      .compareTo(a.name ?? ''),
                                                );
                                              } else if (sortBy ==
                                                  'Experience (High-Low)') {
                                                filtered.sort((a, b) {
                                                  final expA =
                                                      (a.age ?? 35) - 25;
                                                  final expB =
                                                      (b.age ?? 35) - 25;
                                                  return expB.compareTo(expA);
                                                });
                                              }

                                              if (filtered.isEmpty) {
                                                return Center(
                                                  child: Text(
                                                    "No matching doctors found.",
                                                    style: TextStyle(
                                                      color: labelColor,
                                                    ),
                                                  ),
                                                );
                                              }

                                              return ValueListenableBuilder<
                                                int
                                              >(
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
                                                      (startIndex +
                                                              _itemsPerPage)
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
                                                              paginatedList
                                                                  .length,
                                                          itemBuilder: (context, idx) {
                                                            final doc =
                                                                paginatedList[idx];
                                                            return DoctorCard(
                                                              doc: doc,
                                                              onTap: () {
                                                                context.push(
                                                                  '/admin/doctor-staff/detail',
                                                                  extra: doc,
                                                                );
                                                              },
                                                              onView: () {
                                                                context.push(
                                                                  '/admin/doctor-staff/detail',
                                                                  extra: doc,
                                                                );
                                                              },
                                                              onEdit: () async {
                                                                final res =
                                                                    await context.push(
                                                                      '/admin/doctor-staff/edit',
                                                                      extra:
                                                                          doc,
                                                                    );
                                                                if (res ==
                                                                        true &&
                                                                    context
                                                                        .mounted) {
                                                                  context
                                                                      .read<
                                                                        DoctorStaffBloc
                                                                      >()
                                                                      .add(
                                                                        const LoadDoctorStaff(
                                                                          'All',
                                                                        ),
                                                                      );
                                                                }
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      DirectoryPagination(
                                                        currentPage:
                                                            currentPage,
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
                          // Custom Add Doctor FAB & Label underneath
                          Positioned(
                            bottom: 16.h,
                            right: 16.w,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FloatingActionButton(
                                  heroTag: 'add_doctor_fab',
                                  onPressed: () =>
                                      _showSelectDepartmentAndCreate(context),
                                  backgroundColor: AppColors.primary,
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  "Add Doctor",
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
          );
        },
      ),
    );
  }
}
