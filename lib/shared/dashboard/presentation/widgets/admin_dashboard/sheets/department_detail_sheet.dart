import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/features/management/staff_management/domain/entities/department_entity.dart';

class DepartmentDetailSheet extends StatefulWidget {
  final DepartmentEntity department;

  const DepartmentDetailSheet({super.key, required this.department});

  static Future<void> show(
    BuildContext context,
    DepartmentEntity department,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DepartmentDetailSheet(department: department),
    );
  }

  @override
  State<DepartmentDetailSheet> createState() => _DepartmentDetailSheetState();
}

class _DepartmentDetailSheetState extends State<DepartmentDetailSheet> {
  bool _loading = true;
  List<Map<String, dynamic>> _staff = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadStaff();
  }

  Future<void> _loadStaff() async {
    try {
      // Fetch all users who are employees in this department
      // Join: employees → users (to get name/photo)
      final response = await Supabase.instance.client
          .from('employees')
          .select('*, users(*)')
          .eq('department_id', widget.department.id)
          .eq('users.status', 'active');

      final list = (response as List<dynamic>)
          .map((e) => e as Map<String, dynamic>)
          .toList();

      if (mounted) {
        setState(() {
          _staff = list;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Could not load staff';
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenH = MediaQuery.of(context).size.height;

    // Derive card color
    const palette = [
      Color(0xFFEF4444), Color(0xFF3B82F6), Color(0xFF22C55E),
      Color(0xFFA855F7), Color(0xFF06B6D4), Color(0xFFF97316),
      Color(0xFFEAB308), Color(0xFFEC4899), Color(0xFF8B5CF6), Color(0xFF14B8A6),
    ];
    int hash = 0;
    for (int i = 0; i < widget.department.name.length; i++) {
      hash = widget.department.name.codeUnitAt(i) + ((hash << 5) - hash);
    }
    final iconColor = palette[hash.abs() % palette.length];

    return Container(
      height: screenH * 0.75,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1A2E) : Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        children: [
          // Drag handle
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 12.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: isDark ? Colors.white24 : Colors.black12,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),

          // Header
          Container(
            margin: EdgeInsets.all(20.r),
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  iconColor.withValues(alpha: 0.12),
                  iconColor.withValues(alpha: 0.04),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: iconColor.withValues(alpha: 0.15)),
            ),
            child: Row(
              children: [
                Container(
                  width: 56.r,
                  height: 56.r,
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: widget.department.imageUrl != null &&
                            widget.department.imageUrl!.isNotEmpty
                        ? CustomImageView(
                            imagePath: widget.department.imageUrl!,
                            width: 32.r,
                            height: 32.r,
                            color: iconColor,
                            fit: BoxFit.contain,
                          )
                        : Icon(Icons.local_hospital, color: iconColor, size: 30.sp),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.department.name,
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.dashboardTextPrimary(context),
                        ),
                      ),
                      if (widget.department.description != null &&
                          widget.department.description!.isNotEmpty) ...[
                        SizedBox(height: 4.h),
                        Text(
                          widget.department.description!,
                          style: AppTextStyles.labelSmall.copyWith(
                            color: AppColors.dashboardTextPrimary(context)
                                .withValues(alpha: 0.6),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: widget.department.consultation
                              ? Colors.blue.withValues(alpha: 0.12)
                              : Colors.green.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          widget.department.consultation
                              ? 'Consultation Dept'
                              : 'General Dept',
                          style: AppTextStyles.labelSmall.copyWith(
                            color: widget.department.consultation
                                ? Colors.blue
                                : Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Staff Section Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Icon(Icons.people_alt_outlined, size: 18.sp, color: iconColor),
                SizedBox(width: 8.w),
                Text(
                  'Staff in this Department',
                  style: AppTextStyles.labelLarge.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.dashboardTextPrimary(context),
                  ),
                ),
                const Spacer(),
                if (!_loading)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Text(
                      '${_staff.length} members',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: iconColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 12.h),

          // Staff List
          Expanded(
            child: _loading
                ? Center(
                    child: CircularProgressIndicator(color: iconColor),
                  )
                : _error != null
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.cloud_off_outlined,
                                size: 40.sp, color: Colors.grey),
                            SizedBox(height: 8.h),
                            Text(_error!,
                                style: AppTextStyles.labelMedium
                                    .copyWith(color: Colors.grey)),
                          ],
                        ),
                      )
                    : _staff.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.person_off_outlined,
                                    size: 48.sp, color: Colors.grey),
                                SizedBox(height: 8.h),
                                Text('No staff assigned yet',
                                    style: AppTextStyles.labelMedium
                                        .copyWith(color: Colors.grey)),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            itemCount: _staff.length,
                            separatorBuilder: (_, __) => Divider(
                              height: 1,
                              color: isDark ? Colors.white10 : Colors.black12,
                            ),
                            itemBuilder: (context, index) {
                              final emp = _staff[index];
                              final user = emp['users'] as Map<String, dynamic>?;
                              final firstName =
                                  (user?['first_name'] as String? ?? '').trim();
                              final lastName =
                                  (user?['last_name'] as String? ?? '').trim();
                              final name = [firstName, lastName]
                                  .where((s) => s.isNotEmpty)
                                  .join(' ');
                              final photo = user?['profile_photo'] as String?;
                              final role = user?['role'] as String? ?? 'Staff';
                              final status =
                                  emp['status'] as String? ?? 'active';

                              return ListTile(
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 6.h, horizontal: 0),
                                leading: CircleAvatar(
                                  radius: 22.r,
                                  backgroundColor:
                                      iconColor.withValues(alpha: 0.1),
                                  backgroundImage:
                                      photo != null && photo.isNotEmpty
                                          ? NetworkImage(photo)
                                          : null,
                                  child: photo == null || photo.isEmpty
                                      ? Text(
                                          name.isNotEmpty
                                              ? name[0].toUpperCase()
                                              : '?',
                                          style: TextStyle(
                                            color: iconColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.sp,
                                          ),
                                        )
                                      : null,
                                ),
                                title: Text(
                                  name.isNotEmpty ? name : 'Unknown',
                                  style: AppTextStyles.labelMedium.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.dashboardTextPrimary(context),
                                  ),
                                ),
                                subtitle: Text(
                                  role,
                                  style: AppTextStyles.labelSmall.copyWith(
                                    color: AppColors.dashboardTextPrimary(context)
                                        .withValues(alpha: 0.5),
                                  ),
                                ),
                                trailing: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 3.h),
                                  decoration: BoxDecoration(
                                    color: status == 'active'
                                        ? Colors.green.withValues(alpha: 0.12)
                                        : Colors.red.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                  child: Text(
                                    status.capitalize(),
                                    style: AppTextStyles.labelSmall.copyWith(
                                      color: status == 'active'
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

extension StringCapitalize on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}
