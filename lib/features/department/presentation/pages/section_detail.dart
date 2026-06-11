import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/common_widgets/dialogs/dialogs.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';
import 'package:medi_connect/features/department/data/models/department_model.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_event.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_state.dart';

// Section Detail sub-widgets
import 'package:medi_connect/features/department/presentation/widgets/section_detail/section_detail_header.dart';
import 'package:medi_connect/features/department/presentation/widgets/section_detail/section_quick_access.dart';
import 'package:medi_connect/features/department/presentation/widgets/section_detail/section_overview_stats.dart';
import 'package:medi_connect/features/department/presentation/widgets/section_detail/section_doctor_grid_card.dart';
import 'package:medi_connect/features/department/presentation/widgets/section_detail/section_staff_grid_card.dart';
import 'package:medi_connect/features/department/presentation/widgets/section_detail/section_search_bar.dart';
import 'package:medi_connect/features/department/presentation/widgets/section_detail/section_filter_sort_row.dart';

// Shared and standard widgets
import 'package:medi_connect/features/dash_board/presentation/widgets/admin_doctors/doctor_card.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/admin_staff/staff_card.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/common/directory_pagination.dart';

class SectionDetail extends StatefulWidget {
  const SectionDetail({super.key, required this.section});
  final DepartmentModel section;

  @override
  State<SectionDetail> createState() => _SectionDetailState();
}

class _SectionDetailState extends State<SectionDetail>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  // Reactive State Notifiers
  final ValueNotifier<int> _activeTabNotifier = ValueNotifier<int>(0);
  final ValueNotifier<String> _searchNotifier = ValueNotifier<String>('');
  final ValueNotifier<String> _statusFilterNotifier = ValueNotifier<String>('All');
  final ValueNotifier<String> _sortByNotifier = ValueNotifier<String>('None');
  final ValueNotifier<bool> _isListViewNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(1);

  final int _itemsPerPage = 5;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);

    // Initial load
    context.read<DoctorStaffBloc>().add(LoadDoctorStaff(widget.section.name));
  }

  void _handleTabSelection() {
    if (!_tabController.indexIsChanging) {
      _activeTabNotifier.value = _tabController.index;
      // Reset page and filters on tab switch
      _searchNotifier.value = '';
      _statusFilterNotifier.value = 'All';
      _sortByNotifier.value = 'None';
      _currentPageNotifier.value = 1;
    }
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
    _tabController.dispose();

    _activeTabNotifier.dispose();
    _searchNotifier.dispose();
    _statusFilterNotifier.dispose();
    _sortByNotifier.dispose();
    _isListViewNotifier.dispose();
    _currentPageNotifier.dispose();

    super.dispose();
  }

  void _confirmDelete(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      builder: (ctx) => ConfirmationDialog(
        title: "Delete Profile",
        message:
            "Are you sure you want to delete ${user.name ?? 'this user'}? This action cannot be undone.",
        onConfirm: () {
          context.read<DoctorStaffBloc>().add(
            DeleteDoctorStaffMember(
              userId: user.id,
              departmentName: widget.section.name,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.terminalDarkBg : AppColors.terminalLightBg;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;

    return BlocListener<DoctorStaffBloc, DoctorStaffState>(
      listener: (context, state) {
        if (state is DoctorStaffActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Action completed successfully.")),
          );
          context.read<DoctorStaffBloc>().add(LoadDoctorStaff(widget.section.name));
        } else if (state is DoctorStaffError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: ${state.message}"),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Dynamic Header
                  SectionDetailHeader(
                    department: widget.section,
                    onSearchTap: () {
                      // Toggle/Focus search
                    },
                    onFilterTap: () {
                      // Launch filters
                    },
                  ),
                  SizedBox(height: 16.h),

                  // 2. Tab Bar
                  Theme(
                    data: Theme.of(context).copyWith(
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorColor: AppColors.primary,
                      indicatorWeight: 3.h,
                      labelColor: isDark ? Colors.white : AppColors.primary,
                      unselectedLabelColor: labelColor,
                      labelStyle: AppTextStyles.labelMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                      tabs: const [
                        Tab(text: "Doctors"),
                        Tab(text: "Staff"),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),

                  // 3. Search and Filters wrapped inside Tab listener builder
                  ValueListenableBuilder<int>(
                    valueListenable: _activeTabNotifier,
                    builder: (context, activeTab, _) {
                      final isDoctor = activeTab == 0;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Search Bar
                          SectionSearchBar(
                            searchNotifier: _searchNotifier,
                            currentPageNotifier: _currentPageNotifier,
                            hintText: isDoctor
                                ? "Search doctors by name, email or phone..."
                                : "Search staff by name, email or role...",
                          ),
                          SizedBox(height: 12.h),

                          // Filters & Sort Row with List/Grid Toggle
                          SectionFilterSortRow(
                            sortByNotifier: _sortByNotifier,
                            statusFilterNotifier: _statusFilterNotifier,
                            isListViewNotifier: _isListViewNotifier,
                            currentPageNotifier: _currentPageNotifier,
                            isDoctor: isDoctor,
                          ),
                          SizedBox(height: 16.h),

                          // 4. Data lists loading & displaying
                          BlocBuilder<DoctorStaffBloc, DoctorStaffState>(
                            builder: (context, state) {
                              if (state is DoctorStaffLoading) {
                                return const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 24),
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              }

                              List<UserModel> sourceList = [];
                              if (state is DoctorStaffLoaded) {
                                sourceList = isDoctor ? state.doctors : state.staff;
                              }

                              return ValueListenableBuilder<String>(
                                valueListenable: _searchNotifier,
                                builder: (context, searchQuery, _) {
                                  return ValueListenableBuilder<String>(
                                    valueListenable: _statusFilterNotifier,
                                    builder: (context, statusFilter, _) {
                                      return ValueListenableBuilder<String>(
                                        valueListenable: _sortByNotifier,
                                        builder: (context, sortBy, _) {
                                          // Filter
                                          final filtered = sourceList.where((u) {
                                            final matchesSearch = (u.name ?? '').toLowerCase().contains(searchQuery.toLowerCase()) ||
                                                (u.email ?? '').toLowerCase().contains(searchQuery.toLowerCase()) ||
                                                (u.phoneNumber ?? '').contains(searchQuery) ||
                                                (u.staffRole ?? '').toLowerCase().contains(searchQuery.toLowerCase());
                                            final matchesStatus = statusFilter == 'All' ||
                                                u.status.toLowerCase() == statusFilter.toLowerCase();
                                            return matchesSearch && matchesStatus;
                                          }).toList();

                                          // Sort
                                          if (sortBy == 'Name (A-Z)') {
                                            filtered.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
                                          } else if (sortBy == 'Name (Z-A)') {
                                            filtered.sort((a, b) => (b.name ?? '').compareTo(a.name ?? ''));
                                          } else if (sortBy == 'Experience (High-Low)') {
                                            filtered.sort((a, b) {
                                              final expA = (a.age ?? 35) - 25;
                                              final expB = (b.age ?? 35) - 25;
                                              return expB.compareTo(expA);
                                            });
                                          }

                                          // Subtitle Row: Count & Add Button
                                          final entityName = isDoctor ? "Doctor" : "Staff";
                                          return Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "${filtered.length} ${isDoctor ? 'Doctors' : 'Staff'} found",
                                                    style: AppTextStyles.bodyMedium.copyWith(
                                                      color: labelColor,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 12.sp,
                                                    ),
                                                  ),
                                                  TextButton.icon(
                                                    onPressed: () async {
                                                      final res = await context.push(
                                                        '/admin/doctor-staff/create',
                                                        extra: {
                                                          'role': isDoctor ? 'doctor' : 'staff',
                                                          'department': widget.section.name,
                                                        },
                                                      );
                                                      if (res == true) {
                                                        if (context.mounted) {
                                                          context.read<DoctorStaffBloc>().add(
                                                            LoadDoctorStaff(widget.section.name),
                                                          );
                                                        }
                                                      }
                                                    },
                                                    icon: const Icon(Icons.add, size: 14),
                                                    label: Text(
                                                      "Add $entityName",
                                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                                    ),
                                                    style: TextButton.styleFrom(
                                                      foregroundColor: AppColors.primary,
                                                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8.h),
                                              if (filtered.isEmpty)
                                                Center(
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(vertical: 24.h),
                                                    child: Text(
                                                      "No matching $entityName found.",
                                                      style: TextStyle(color: labelColor),
                                                    ),
                                                  ),
                                                )
                                              else
                                                ValueListenableBuilder<int>(
                                                  valueListenable: _currentPageNotifier,
                                                  builder: (context, currentPage, _) {
                                                    final totalPages = (filtered.length / _itemsPerPage).ceil();
                                                    final startIndex = (currentPage - 1) * _itemsPerPage;
                                                    final endIndex = (startIndex + _itemsPerPage).clamp(0, filtered.length);
                                                    final paginatedList = filtered.sublist(startIndex, endIndex);

                                                    return ValueListenableBuilder<bool>(
                                                      valueListenable: _isListViewNotifier,
                                                      builder: (context, isList, _) {
                                                        return Column(
                                                          children: [
                                                            if (isList)
                                                              ListView.builder(
                                                                shrinkWrap: true,
                                                                physics: const NeverScrollableScrollPhysics(),
                                                                itemCount: paginatedList.length,
                                                                itemBuilder: (context, idx) {
                                                                  final user = paginatedList[idx];
                                                                  return isDoctor
                                                                      ? DoctorCard(
                                                                          doc: user,
                                                                          onTap: () => context.push('/admin/doctor-staff/detail', extra: user),
                                                                          onView: () => context.push('/admin/doctor-staff/detail', extra: user),
                                                                          onEdit: () async {
                                                                            final res = await context.push('/admin/doctor-staff/edit', extra: user);
                                                                            if (res == true && context.mounted) {
                                                                              context.read<DoctorStaffBloc>().add(LoadDoctorStaff(widget.section.name));
                                                                            }
                                                                          },
                                                                        )
                                                                      : StaffCard(
                                                                          stf: user,
                                                                          onTap: () => context.push('/admin/doctor-staff/detail', extra: user),
                                                                          onView: () => context.push('/admin/doctor-staff/detail', extra: user),
                                                                          onEdit: () async {
                                                                            final res = await context.push('/admin/doctor-staff/edit', extra: user);
                                                                            if (res == true && context.mounted) {
                                                                              context.read<DoctorStaffBloc>().add(LoadDoctorStaff(widget.section.name));
                                                                            }
                                                                          },
                                                                        );
                                                                },
                                                              )
                                                            else
                                                              GridView.builder(
                                                                shrinkWrap: true,
                                                                physics: const NeverScrollableScrollPhysics(),
                                                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                                                  crossAxisCount: 2,
                                                                  childAspectRatio: 0.8,
                                                                  mainAxisSpacing: 10.r,
                                                                  crossAxisSpacing: 10.r,
                                                                ),
                                                                itemCount: paginatedList.length,
                                                                itemBuilder: (context, idx) {
                                                                  final user = paginatedList[idx];
                                                                  return isDoctor
                                                                      ? SectionDoctorGridCard(
                                                                          doc: user,
                                                                          onTap: () => context.push('/admin/doctor-staff/detail', extra: user),
                                                                          onView: () => context.push('/admin/doctor-staff/detail', extra: user),
                                                                          onEdit: () async {
                                                                            final res = await context.push('/admin/doctor-staff/edit', extra: user);
                                                                            if (res == true && context.mounted) {
                                                                              context.read<DoctorStaffBloc>().add(LoadDoctorStaff(widget.section.name));
                                                                            }
                                                                          },
                                                                        )
                                                                      : SectionStaffGridCard(
                                                                          stf: user,
                                                                          onTap: () => context.push('/admin/doctor-staff/detail', extra: user),
                                                                          onView: () => context.push('/admin/doctor-staff/detail', extra: user),
                                                                          onEdit: () async {
                                                                            final res = await context.push('/admin/doctor-staff/edit', extra: user);
                                                                            if (res == true && context.mounted) {
                                                                              context.read<DoctorStaffBloc>().add(LoadDoctorStaff(widget.section.name));
                                                                            }
                                                                          },
                                                                        );
                                                                },
                                                              ),
                                                            SizedBox(height: 12.h),
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
                          ),
                        ],
                      );
                    },
                  ),
                  SizedBox(height: 24.h),

                  // 5. Department Quick Access
                  const SectionQuickAccess(),
                  SizedBox(height: 24.h),

                  // 6. Today's Overview Statistics
                  BlocBuilder<DoctorStaffBloc, DoctorStaffState>(
                    builder: (context, state) {
                      int activeDocs = 0;
                      int activeStf = 0;
                      int docsLeave = 0;
                      int stfLeave = 0;

                      if (state is DoctorStaffLoaded) {
                        activeDocs = state.doctors.where((d) => d.status.toLowerCase() == 'active').length;
                        activeStf = state.staff.where((s) => s.status.toLowerCase() == 'active').length;
                        docsLeave = state.doctors.where((d) => d.status.toLowerCase() == 'away').length;
                        stfLeave = state.staff.where((s) => s.status.toLowerCase() == 'away').length;
                      }

                      return SectionOverviewStats(
                        departmentName: widget.section.name,
                        activeDoctors: activeDocs,
                        activeStaff: activeStf,
                        doctorsOnLeave: docsLeave,
                        staffOnLeave: stfLeave,
                      );
                    },
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
