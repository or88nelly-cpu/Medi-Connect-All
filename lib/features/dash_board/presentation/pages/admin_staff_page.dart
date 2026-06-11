import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';
import 'package:medi_connect/features/department/presentation/bloc/department_bloc.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_event.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_state.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/utils/profile_image_helper.dart';

class AdminStaffPage extends StatefulWidget {
  const AdminStaffPage({super.key});

  @override
  State<AdminStaffPage> createState() => _AdminStaffPageState();
}

class _AdminStaffPageState extends State<AdminStaffPage> {
  final ValueNotifier<String> _searchNotifier = ValueNotifier<String>('');
  final ValueNotifier<String> _selectedFilterNotifier = ValueNotifier<String>('All');
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
    _selectedFilterNotifier.dispose();
    _currentPageNotifier.dispose();
    super.dispose();
  }

  void _showSelectDepartmentAndCreate(BuildContext context) {
    final state = context.read<DepartmentBloc>().state;
    List<String> list = [];
    if (state is DepartmentsLoaded) {
      list.addAll(state.sections.map((e) => e.name));
      list.addAll(state.departments.map((e) => e.name));
    }

    if (list.isEmpty) {
      list = ['General Medicine', 'Cardiology', 'Neurology', 'Pediatrics', 'Emergency', 'OPD'];
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
                      extra: {'role': 'staff', 'department': selectedDept},
                    )
                    .then((value) {
                      if (value == true && context.mounted) {
                        context.read<DoctorStaffBloc>().add(const LoadDoctorStaff('All'));
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
    final cardBg = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final borderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final textColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;

    return BlocProvider(
      create: (context) => GetIt.I<DoctorStaffBloc>()..add(const LoadDoctorStaff('All')),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Staff",
                              style: AppTextStyles.titleLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                fontSize: 24.sp,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              "Manage and view all staff",
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
                    BlocBuilder<DepartmentBloc, DepartmentState>(
                      builder: (context, state) {
                        final List<String> categories = ['All'];
                        if (state is DepartmentsLoaded) {
                          categories.addAll(state.sections.map((e) => e.name));
                          categories.addAll(state.departments.map((e) => e.name));
                        }

                        return Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: ValueListenableBuilder<String>(
                                valueListenable: _selectedFilterNotifier,
                                builder: (context, selectedFilter, _) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                                    decoration: BoxDecoration(
                                      color: cardBg,
                                      borderRadius: BorderRadius.circular(8.r),
                                      border: Border.all(color: borderColor, width: 1.2),
                                    ),
                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        value: categories.contains(selectedFilter) ? selectedFilter : 'All',
                                        icon: Icon(Icons.keyboard_arrow_down, color: labelColor),
                                        isExpanded: true,
                                        dropdownColor: cardBg,
                                        items: categories.map((cat) {
                                          return DropdownMenuItem(
                                            value: cat,
                                            child: Text(
                                              cat == 'All' ? 'All Categories' : cat,
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
                                            _selectedFilterNotifier.value = val;
                                            _currentPageNotifier.value = 1;
                                            context.read<DoctorStaffBloc>().add(LoadDoctorStaff(val));
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
                        );
                      },
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
                          hintText: "Search staff by name or role...",
                          hintStyle: TextStyle(color: labelColor.withValues(alpha: 0.7)),
                          prefixIcon: Icon(Icons.search, color: labelColor),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // 4. Staff List (Paginated & Filtered)
                    Expanded(
                      child: Stack(
                        children: [
                          BlocBuilder<DoctorStaffBloc, DoctorStaffState>(
                            builder: (context, state) {
                              if (state is DoctorStaffLoading) {
                                return const Center(child: CircularProgressIndicator());
                              } else if (state is DoctorStaffError) {
                                return Center(
                                  child: Text(
                                    "Error: ${state.message}",
                                    style: TextStyle(color: AppColors.error),
                                  ),
                                );
                              }

                              List<UserModel> staffList = [];
                              if (state is DoctorStaffLoaded) {
                                staffList = state.staff;
                              }

                              if (staffList.isEmpty) {
                                return Center(
                                  child: Text(
                                    "No staff registered.",
                                    style: TextStyle(color: labelColor),
                                  ),
                                );
                              }

                              return ValueListenableBuilder<String>(
                                valueListenable: _searchNotifier,
                                builder: (context, searchQuery, _) {
                                  return ValueListenableBuilder<String>(
                                    valueListenable: _selectedFilterNotifier,
                                    builder: (context, selectedFilter, _) {
                                      final filtered = staffList.where((stf) {
                                        final matchesSearch = (stf.name ?? '').toLowerCase().contains(searchQuery.toLowerCase()) ||
                                            (stf.staffRole ?? '').toLowerCase().contains(searchQuery.toLowerCase());
                                        final matchesFilter = selectedFilter == 'All' ||
                                            (stf.department ?? '').toLowerCase() == selectedFilter.toLowerCase();
                                        return matchesSearch && matchesFilter;
                                      }).toList();

                                      if (filtered.isEmpty) {
                                        return Center(
                                          child: Text(
                                            "No matching staff found.",
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
                                                    final stf = paginatedList[idx];
                                                    final status = stf.status;

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
                                                                  stf.profileImage,
                                                                  'staff',
                                                                  stf.gender,
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
                                                                  stf.name ?? '',
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
                                                                        color: AppColors.secondary.withValues(alpha: 0.15),
                                                                        borderRadius: BorderRadius.circular(4.r),
                                                                      ),
                                                                      child: Text(
                                                                        stf.staffRole ?? 'Support Staff',
                                                                        style: TextStyle(
                                                                          color: AppColors.secondary,
                                                                          fontSize: 10.sp,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                SizedBox(height: 4.h),
                                                                Text(
                                                                  "Dept: ${stf.department ?? 'None'} | Shift: Rotational",
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
                                                                onSelected: (action) async {
                                                                  if (action == 'view') {
                                                                    context.push('/admin/doctor-staff/detail', extra: stf);
                                                                  } else if (action == 'edit') {
                                                                    final res = await context.push('/admin/doctor-staff/edit', extra: stf);
                                                                    if (res == true && context.mounted) {
                                                                      context.read<DoctorStaffBloc>().add(const LoadDoctorStaff('All'));
                                                                    }
                                                                  }
                                                                },
                                                                itemBuilder: (ctx) => [
                                                                  PopupMenuItem(
                                                                    value: 'view',
                                                                    child: Text("View Profile", style: TextStyle(color: textColor)),
                                                                  ),
                                                                  PopupMenuItem(
                                                                    value: 'edit',
                                                                    child: Text("Edit Staff", style: TextStyle(color: textColor)),
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
                                              // 5. Pagination controls
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
                          // Custom Add Staff FAB & Label underneath
                          Positioned(
                            bottom: 16.h,
                            right: 16.w,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FloatingActionButton(
                                  heroTag: 'add_staff_fab',
                                  onPressed: () => _showSelectDepartmentAndCreate(context),
                                  backgroundColor: AppColors.primary,
                                  child: const Icon(Icons.add, color: Colors.white),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  "Add Staff",
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
        }
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
}
