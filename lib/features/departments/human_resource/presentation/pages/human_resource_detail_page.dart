import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/utils/profile_image_helper.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_event.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_state.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/common/directory_pagination.dart';
import 'package:medi_connect/core/common_widgets/dialogs/dialogs.dart';

class HumanResourceDetailPage extends StatefulWidget {
  const HumanResourceDetailPage({super.key});

  @override
  State<HumanResourceDetailPage> createState() =>
      _HumanResourceDetailPageState();
}

class _HumanResourceDetailPageState extends State<HumanResourceDetailPage> {
  // Reactive State Notifiers
  final ValueNotifier<String> _searchNotifier = ValueNotifier<String>('');
  final ValueNotifier<String> _statusFilterNotifier = ValueNotifier<String>(
    'All',
  );
  final ValueNotifier<String> _sortByNotifier = ValueNotifier<String>('None');
  final ValueNotifier<bool> _isListViewNotifier = ValueNotifier<bool>(true);
  final ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(1);

  final int _itemsPerPage = 5;

  @override
  void initState() {
    super.initState();
    // Fetch from Supabase
    context.read<DoctorStaffBloc>().add(
      const LoadDoctorStaff('Human Resource'),
    );
  }

  @override
  void dispose() {
    _searchNotifier.dispose();
    _statusFilterNotifier.dispose();
    _sortByNotifier.dispose();
    _isListViewNotifier.dispose();
    _currentPageNotifier.dispose();
    super.dispose();
  }

  void _triggerAddStaff() async {
    final res = await context.push(
      '/admin/doctor-staff/create',
      extra: {'role': 'staff', 'department': 'Human Resource'},
    );
    if (res == true) {
      if (mounted) {
        context.read<DoctorStaffBloc>().add(
          const LoadDoctorStaff('Human Resource'),
        );
      }
    }
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
              departmentName: 'Human Resource',
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark
        ? AppColors.terminalDarkBg
        : AppColors.terminalLightBg;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;
    final labelColor = isDark
        ? AppColors.terminalDarkLabel
        : AppColors.terminalLightLabel;
    final actionBg = isDark
        ? AppColors.terminalDarkCard
        : AppColors.terminalLightCard;
    final actionBorder = isDark
        ? AppColors.terminalDarkBorder
        : AppColors.terminalLightBorder;

    return BlocListener<DoctorStaffBloc, DoctorStaffState>(
      listener: (context, state) {
        if (state is DoctorStaffActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Action completed successfully.")),
          );
          context.read<DoctorStaffBloc>().add(
            const LoadDoctorStaff('Human Resource'),
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
                  // 1. Custom App Bar matching screenshot
                  _buildCustomAppBar(
                    context,
                    isDark,
                    textColor,
                    actionBg,
                    actionBorder,
                  ),
                  SizedBox(height: 16.h),

                  // 2. Search Bar
                  _buildSearchBar(isDark, labelColor),
                  SizedBox(height: 12.h),

                  // 3. Filters, Sort, More, View Toggle Row
                  _buildFiltersSortRow(isDark, textColor, labelColor),
                  SizedBox(height: 16.h),

                  // 4. Staff Count Header & Add Staff button
                  _buildStaffSection(isDark, textColor, labelColor),
                  SizedBox(height: 24.h),

                  // 5. HR Functions Grid
                  const _HRFunctionsGrid(),
                  SizedBox(height: 24.h),

                  // 6. Today's Overview statistics
                  const _HROverviewCards(),
                  SizedBox(height: 24.h),

                  // 7. Quick Actions row
                  _HRQuickActions(onAddEmployee: _triggerAddStaff),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomAppBar(
    BuildContext context,
    bool isDark,
    Color textColor,
    Color actionBg,
    Color actionBorder,
  ) {
    return Row(
      children: [
        // Back Button
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(30.r),
          child: Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: actionBg,
              border: Border.all(color: actionBorder),
            ),
            child: Icon(Icons.arrow_back_ios_new, size: 16.r, color: textColor),
          ),
        ),
        SizedBox(width: 12.w),
        // HR Logo Circular Icon
        Container(
          width: 44.r,
          height: 44.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF7928CA).withValues(alpha: 0.15),
            border: Border.all(
              color: const Color(0xFF7928CA).withValues(alpha: 0.25),
              width: 1.5,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.r),
            child: CustomImageView(
              imagePath: 'assets/images/department/human-resource.png',
              fit: BoxFit.contain,
              color: isDark ? Colors.white : const Color(0xFF7928CA),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        // Title and Subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "HR Department",
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontSize: 18.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "Human Resources",
                style: AppTextStyles.bodySmall.copyWith(
                  color: isDark
                      ? AppColors.terminalDarkLabel
                      : AppColors.terminalLightLabel,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        // Action Buttons
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildAppBarAction(
              Icons.search,
              textColor,
              actionBg,
              actionBorder,
              () {},
            ),
            SizedBox(width: 8.w),
            _buildAppBarAction(
              Icons.tune,
              textColor,
              actionBg,
              actionBorder,
              () {},
            ),
            SizedBox(width: 8.w),
            _buildAppBarAction(
              Icons.more_vert,
              textColor,
              actionBg,
              actionBorder,
              () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAppBarAction(
    IconData icon,
    Color color,
    Color bg,
    Color border,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30.r),
      child: Container(
        width: 38.r,
        height: 38.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bg,
          border: Border.all(color: border),
        ),
        child: Icon(icon, size: 18.r, color: color),
      ),
    );
  }

  Widget _buildSearchBar(bool isDark, Color labelColor) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.terminalDarkFieldFill
            : AppColors.terminalLightFieldFill,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: isDark
              ? AppColors.terminalDarkFieldBorder
              : AppColors.terminalLightFieldBorder,
        ),
      ),
      child: TextField(
        onChanged: (val) {
          _searchNotifier.value = val;
          _currentPageNotifier.value = 1;
        },
        style: TextStyle(
          color: isDark ? Colors.white : AppColors.terminalLightText,
          fontSize: 13.sp,
        ),
        decoration: InputDecoration(
          hintText: "Search staff by name, role, email or phone...",
          hintStyle: TextStyle(
            color: isDark
                ? AppColors.terminalDarkFieldHint
                : AppColors.terminalLightFieldHint,
            fontSize: 13.sp,
          ),
          prefixIcon: Icon(Icons.search, color: labelColor, size: 20.r),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 12.h,
          ),
        ),
      ),
    );
  }

  Widget _buildFiltersSortRow(bool isDark, Color textColor, Color labelColor) {
    final activeBg = isDark
        ? AppColors.terminalDarkCard
        : AppColors.terminalLightCard;
    final activeBorder = isDark
        ? AppColors.terminalDarkBorder
        : AppColors.terminalLightBorder;

    return Row(
      children: [
        // Filters Button
        ValueListenableBuilder<String>(
          valueListenable: _statusFilterNotifier,
          builder: (context, filter, _) {
            return _buildDropdownButton(
              label: "Filters: $filter",
              icon: Icons.tune,
              isDark: isDark,
              labelColor: labelColor,
              activeBg: activeBg,
              activeBorder: activeBorder,
              onTap: () {
                _showStatusFilterDialog(context);
              },
            );
          },
        ),
        SizedBox(width: 8.w),

        // Sort Button
        ValueListenableBuilder<String>(
          valueListenable: _sortByNotifier,
          builder: (context, sort, _) {
            return _buildDropdownButton(
              label: "Sort: ${sort == 'None' ? 'Default' : sort}",
              icon: Icons.swap_vert,
              isDark: isDark,
              labelColor: labelColor,
              activeBg: activeBg,
              activeBorder: activeBorder,
              onTap: () {
                _showSortDialog(context);
              },
            );
          },
        ),
        SizedBox(width: 8.w),

        // More Button
        _buildDropdownButton(
          label: "More",
          icon: Icons.more_horiz,
          isDark: isDark,
          labelColor: labelColor,
          activeBg: activeBg,
          activeBorder: activeBorder,
          onTap: () {},
        ),
        const Spacer(),

        // Grid/List View Toggles
        ValueListenableBuilder<bool>(
          valueListenable: _isListViewNotifier,
          builder: (context, isList, _) {
            return Row(
              children: [
                _buildToggleIcon(
                  Icons.list,
                  isList,
                  isDark,
                  () => _isListViewNotifier.value = true,
                ),
                SizedBox(width: 4.w),
                _buildToggleIcon(
                  Icons.grid_view,
                  !isList,
                  isDark,
                  () => _isListViewNotifier.value = false,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildDropdownButton({
    required String label,
    required IconData icon,
    required bool isDark,
    required Color labelColor,
    required Color activeBg,
    required Color activeBorder,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: activeBg,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: activeBorder),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14.r, color: labelColor),
            SizedBox(width: 6.w),
            Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.terminalLightText,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleIcon(
    IconData icon,
    bool isActive,
    bool isDark,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(6.r),
      child: Container(
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          color: isActive
              ? (isDark
                    ? AppColors.primary.withValues(alpha: 0.2)
                    : AppColors.primary.withValues(alpha: 0.1))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(6.r),
          border: Border.all(
            color: isActive ? AppColors.primary : Colors.transparent,
          ),
        ),
        child: Icon(
          icon,
          size: 18.r,
          color: isActive
              ? AppColors.primary
              : (isDark ? Colors.white54 : Colors.black54),
        ),
      ),
    );
  }

  Widget _buildStaffSection(bool isDark, Color textColor, Color labelColor) {
    return BlocBuilder<DoctorStaffBloc, DoctorStaffState>(
      builder: (context, state) {
        if (state is DoctorStaffLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ),
          );
        }

        List<UserModel> sourceList = [];
        if (state is DoctorStaffLoaded) {
          sourceList = state.staff;
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
                    // Filter staff
                    final filtered = sourceList.where((u) {
                      final nameMatch = (u.name ?? '').toLowerCase().contains(
                        searchQuery.toLowerCase(),
                      );
                      final roleMatch = (u.staffRole ?? '')
                          .toLowerCase()
                          .contains(searchQuery.toLowerCase());
                      final emailMatch = u.email.toLowerCase().contains(
                        searchQuery.toLowerCase(),
                      );
                      final phoneMatch = (u.phoneNumber ?? '').contains(
                        searchQuery,
                      );

                      final matchesSearch =
                          nameMatch || roleMatch || emailMatch || phoneMatch;
                      final matchesStatus =
                          statusFilter == 'All' ||
                          u.status.toLowerCase() == statusFilter.toLowerCase();
                      return matchesSearch && matchesStatus;
                    }).toList();

                    // Sort staff
                    if (sortBy == 'Name (A-Z)') {
                      filtered.sort(
                        (a, b) => (a.name ?? '').compareTo(b.name ?? ''),
                      );
                    } else if (sortBy == 'Name (Z-A)') {
                      filtered.sort(
                        (a, b) => (b.name ?? '').compareTo(a.name ?? ''),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${filtered.length} Staff members",
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 13.sp,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: _triggerAddStaff,
                              icon: const Icon(Icons.add, size: 14),
                              label: const Text(
                                "Add Staff",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.primary,
                                padding: EdgeInsets.symmetric(horizontal: 8.w),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        if (filtered.isEmpty)
                          Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 24.h),
                              child: Text(
                                "No staff members found matching constraints.",
                                style: TextStyle(color: labelColor),
                              ),
                            ),
                          )
                        else
                          ValueListenableBuilder<int>(
                            valueListenable: _currentPageNotifier,
                            builder: (context, currentPage, _) {
                              final totalPages =
                                  (filtered.length / _itemsPerPage).ceil();
                              final startIndex =
                                  (currentPage - 1) * _itemsPerPage;
                              final endIndex = (startIndex + _itemsPerPage)
                                  .clamp(0, filtered.length);
                              final paginatedList = filtered.sublist(
                                startIndex,
                                endIndex,
                              );

                              return ValueListenableBuilder<bool>(
                                valueListenable: _isListViewNotifier,
                                builder: (context, isList, _) {
                                  return Column(
                                    children: [
                                      if (isList)
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: paginatedList.length,
                                          itemBuilder: (context, idx) {
                                            final stf = paginatedList[idx];
                                            return _StaffListCard(
                                              staff: stf,
                                              onDelete: () =>
                                                  _confirmDelete(context, stf),
                                              onEdit: () async {
                                                final res = await context.push(
                                                  '/admin/doctor-staff/edit',
                                                  extra: stf,
                                                );
                                                if (res == true &&
                                                    context.mounted) {
                                                  context
                                                      .read<DoctorStaffBloc>()
                                                      .add(
                                                        const LoadDoctorStaff(
                                                          'Human Resource',
                                                        ),
                                                      );
                                                }
                                              },
                                            );
                                          },
                                        )
                                      else
                                        GridView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 2,
                                                childAspectRatio: 0.8,
                                                mainAxisSpacing: 10.r,
                                                crossAxisSpacing: 10.r,
                                              ),
                                          itemCount: paginatedList.length,
                                          itemBuilder: (context, idx) {
                                            final stf = paginatedList[idx];
                                            return _StaffGridCard(
                                              staff: stf,
                                              onDelete: () =>
                                                  _confirmDelete(context, stf),
                                              onEdit: () async {
                                                final res = await context.push(
                                                  '/admin/doctor-staff/edit',
                                                  extra: stf,
                                                );
                                                if (res == true &&
                                                    context.mounted) {
                                                  context
                                                      .read<DoctorStaffBloc>()
                                                      .add(
                                                        const LoadDoctorStaff(
                                                          'Human Resource',
                                                        ),
                                                      );
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
    );
  }

  void _showStatusFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Filter by Status"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['All', 'Active', 'Away', 'Inactive'].map((status) {
            return ListTile(
              title: Text(status),
              onTap: () {
                _statusFilterNotifier.value = status;
                _currentPageNotifier.value = 1;
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showSortDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Sort Staff List"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['None', 'Name (A-Z)', 'Name (Z-A)'].map((sort) {
            return ListTile(
              title: Text(sort == 'None' ? 'Default' : sort),
              onTap: () {
                _sortByNotifier.value = sort;
                Navigator.pop(ctx);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _StaffListCard extends StatelessWidget {
  final UserModel staff;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const _StaffListCard({required this.staff, this.onDelete, this.onEdit});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark
        ? AppColors.terminalDarkCard
        : AppColors.terminalLightCard;
    final borderColor = isDark
        ? AppColors.terminalDarkBorder
        : AppColors.terminalLightBorder;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;
    final labelColor = isDark
        ? AppColors.terminalDarkLabel
        : AppColors.terminalLightLabel;

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
                  staff.profileImage,
                  'staff',
                  staff.gender,
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
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      staff.name ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: textColor,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      staff.staffRole ?? '',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 11.sp,
                        color: isDark
                            ? const Color(0xFFB39DDB)
                            : Colors.deepPurple,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  "${staff.metadata?['sub_department'] ?? staff.department ?? 'Staff'} • ${staff.email}",
                  style: TextStyle(fontSize: 12.sp, color: labelColor),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          _StatusPill(status: staff.status),
          SizedBox(width: 4.w),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: labelColor, size: 20.r),
            color: cardBg,
            onSelected: (val) {
              if (val == 'edit' && onEdit != null) onEdit!();
              if (val == 'delete' && onDelete != null) onDelete!();
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'edit',
                child: Text('Edit Info', style: TextStyle(color: textColor)),
              ),
              PopupMenuItem(
                value: 'delete',
                child: const Text(
                  'Delete Staff',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StaffGridCard extends StatelessWidget {
  final UserModel staff;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const _StaffGridCard({required this.staff, this.onDelete, this.onEdit});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark
        ? AppColors.terminalDarkCard
        : AppColors.terminalLightCard;
    final borderColor = isDark
        ? AppColors.terminalDarkBorder
        : AppColors.terminalLightBorder;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;
    final labelColor = isDark
        ? AppColors.terminalDarkLabel
        : AppColors.terminalLightLabel;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              icon: Icon(Icons.more_vert, color: labelColor, size: 18.r),
              color: cardBg,
              onSelected: (val) {
                if (val == 'edit' && onEdit != null) onEdit!();
                if (val == 'delete' && onDelete != null) onDelete!();
              },
              itemBuilder: (ctx) => [
                PopupMenuItem(
                  value: 'edit',
                  child: Text('Edit Info', style: TextStyle(color: textColor)),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: const Text(
                    'Delete Staff',
                    style: TextStyle(color: AppColors.error),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 26.r,
                  backgroundColor: isDark ? Colors.white12 : Colors.black12,
                  child: ClipOval(
                    child: CustomImageView(
                      imagePath: ProfileImageHelper.resolveImagePath(
                        staff.profileImage,
                        'staff',
                        staff.gender,
                      ),
                      width: 52.r,
                      height: 52.r,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  staff.name ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                    color: textColor,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 2.h),
                Text(
                  staff.staffRole ?? '',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 10.sp,
                    color: isDark ? const Color(0xFFB39DDB) : Colors.deepPurple,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                Text(
                  staff.email,
                  style: TextStyle(fontSize: 9.sp, color: labelColor),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8.h),
                _StatusPill(status: staff.status),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String status;

  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    Color dotColor = AppColors.success;
    Color bgPillColor = AppColors.success.withValues(alpha: 0.1);
    String label = 'Active';

    final lower = status.toLowerCase();
    if (lower.contains('away')) {
      dotColor = AppColors.accent;
      bgPillColor = AppColors.accent.withValues(alpha: 0.1);
      label = 'Away';
    } else if (lower.contains('inactive')) {
      dotColor = AppColors.error;
      bgPillColor = AppColors.error.withValues(alpha: 0.1);
      label = 'Inactive';
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bgPillColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: dotColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5.r,
            height: 5.r,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              color: dotColor,
              fontSize: 9.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _HRFunctionsGrid extends StatelessWidget {
  const _HRFunctionsGrid();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark
        ? AppColors.terminalDarkCard
        : AppColors.terminalLightCard;
    final cardBorder = isDark
        ? AppColors.terminalDarkBorder
        : AppColors.terminalLightBorder;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;

    final List<Map<String, dynamic>> functions = [
      {
        'label': 'Employee Directory',
        'icon': Icons.people_alt_outlined,
        'color': const Color(0xFF7928CA),
      },
      {
        'label': 'Leave Management',
        'icon': Icons.calendar_month_outlined,
        'color': AppColors.success,
      },
      {
        'label': 'Attendance Tracking',
        'icon': Icons.access_time_outlined,
        'color': AppColors.primary,
      },
      {
        'label': 'Payroll Management',
        'icon': Icons.account_balance_wallet_outlined,
        'color': const Color(0xFF00C2A8),
      },
      {
        'label': 'Recruitment',
        'icon': Icons.person_add_alt_1_outlined,
        'color': const Color(0xFFFF0080),
      },
      {
        'label': 'Training & Development',
        'icon': Icons.school_outlined,
        'color': AppColors.accent,
      },
      {
        'label': 'Performance Reviews',
        'icon': Icons.stars_outlined,
        'color': const Color(0xFF3F51B5),
      },
      {
        'label': 'Documents Center',
        'icon': Icons.folder_open_outlined,
        'color': const Color(0xFF9C27B0),
      },
      {
        'label': 'Policies & Handbook',
        'icon': Icons.verified_user_outlined,
        'color': const Color(0xFF4CAF50),
      },
      {
        'label': 'Requests & Approvals',
        'icon': Icons.assignment_turned_in_outlined,
        'color': AppColors.terminalAccentCyan,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "HR Functions",
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 12.h),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 8.w,
            mainAxisSpacing: 8.h,
            childAspectRatio: 0.9,
          ),
          itemCount: functions.length,
          itemBuilder: (context, idx) {
            final fn = functions[idx];
            return InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Launching ${fn['label']} module...")),
                );
              },
              borderRadius: BorderRadius.circular(12.r),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: cardBorder),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(fn['icon'], color: fn['color'], size: 24.r),
                    SizedBox(height: 6.h),
                    Expanded(
                      child: Text(
                        fn['label'],
                        style: TextStyle(
                          color: textColor,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _HROverviewCards extends StatelessWidget {
  const _HROverviewCards();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark
        ? AppColors.terminalDarkCard
        : AppColors.terminalLightCard;
    final cardBorder = isDark
        ? AppColors.terminalDarkBorder
        : AppColors.terminalLightBorder;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;
    final labelColor = isDark
        ? AppColors.terminalDarkLabel
        : AppColors.terminalLightLabel;

    final List<Map<String, dynamic>> stats = [
      {
        'title': 'Total Employees',
        'value': '142',
        'subText': '↑ 5 this month',
        'subColor': AppColors.success,
        'icon': Icons.people_outline,
        'iconColor': const Color(0xFF7928CA),
      },
      {
        'title': 'On Leave Today',
        'value': '12',
        'subText': '↑ 2 this month',
        'subColor': AppColors.success,
        'icon': Icons.calendar_month_outlined,
        'iconColor': AppColors.primary,
      },
      {
        'title': 'New Hires',
        'value': '4',
        'subText': '↑ 1 this month',
        'subColor': AppColors.success,
        'icon': Icons.person_add_outlined,
        'iconColor': AppColors.accent,
      },
      {
        'title': 'Pending Approvals',
        'value': '7',
        'subText': '↑ 3 this month',
        'subColor': AppColors.success,
        'icon': Icons.access_time_outlined,
        'iconColor': const Color(0xFF00C2A8),
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Today's Overview",
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: stats.map((stat) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: cardBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            stat['icon'],
                            color: stat['iconColor'],
                            size: 16.r,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              stat['title'],
                              style: TextStyle(
                                color: labelColor,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        stat['value'],
                        style: TextStyle(
                          color: textColor,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        stat['subText'],
                        style: TextStyle(
                          color: stat['subColor'],
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _HRQuickActions extends StatelessWidget {
  final VoidCallback onAddEmployee;

  const _HRQuickActions({required this.onAddEmployee});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark
        ? AppColors.terminalDarkCard
        : AppColors.terminalLightCard;
    final cardBorder = isDark
        ? AppColors.terminalDarkBorder
        : AppColors.terminalLightBorder;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;

    final List<Map<String, dynamic>> actions = [
      {
        'label': 'Add Employee',
        'icon': Icons.person_add_alt_1_outlined,
        'color': const Color(0xFF7928CA),
        'onTap': onAddEmployee,
      },
      {
        'label': 'Apply Leave',
        'icon': Icons.calendar_month_outlined,
        'color': AppColors.success,
        'onTap': () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Opening Leave Application form...")),
          );
        },
      },
      {
        'label': 'Mark Attendance',
        'icon': Icons.fingerprint,
        'color': AppColors.primary,
        'onTap': () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Opening Attendance Punch...")),
          );
        },
      },
      {
        'label': 'Send Announcement',
        'icon': Icons.campaign_outlined,
        'color': AppColors.accent,
        'onTap': () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Opening Announcement form...")),
          );
        },
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions",
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: textColor,
            fontSize: 14.sp,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: actions.map((act) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: InkWell(
                  onTap: act['onTap'],
                  borderRadius: BorderRadius.circular(12.r),
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    decoration: BoxDecoration(
                      color: cardBg,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(color: cardBorder),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(act['icon'], color: act['color'], size: 18.r),
                        SizedBox(width: 6.w),
                        Flexible(
                          child: Text(
                            act['label'],
                            style: TextStyle(
                              color: textColor,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
