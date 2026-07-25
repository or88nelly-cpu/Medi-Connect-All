import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/features/admin/home/domain/entities/admin_dashboard_module_entity.dart';

/// Title + description text block for the module card.
class AdminModuleCardBody extends StatelessWidget {
  final AdminDashboardModuleEntity module;
  final bool isDark;

  const AdminModuleCardBody({
    super.key,
    required this.module,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          module.title,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w800,
            color: isDark ? Colors.white : AppColors.textDarkNavy,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 3.h),
        Text(
          module.description,
          style: TextStyle(
            fontSize: 10.sp,
            height: 1.35,
            color: isDark ? Colors.white54 : Colors.grey.shade500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
