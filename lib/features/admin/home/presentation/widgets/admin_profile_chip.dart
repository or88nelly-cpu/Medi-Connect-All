import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/features/authentication/domain/entities/user_entity.dart';

/// Admin profile avatar + name chip for the top bar.
class AdminProfileChip extends StatelessWidget {
  final UserEntity? user;
  final bool isDark;
  final bool showLabel;

  const AdminProfileChip({
    super.key,
    this.user,
    required this.isDark,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 17.r,
          backgroundColor: AppColors.primary.withValues(alpha: 0.12),
          child: Icon(
            Icons.admin_panel_settings_rounded,
            size: 18.r,
            color: AppColors.primary,
          ),
        ),
        if (showLabel) ...[
          SizedBox(width: 7.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.fullName ?? AppStrings.login,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11.sp,
                  color: isDark ? Colors.white : AppColors.textDarkNavy,
                ),
              ),
              Text(
                AppStrings.superAdmin,
                style: TextStyle(fontSize: 9.sp, color: Colors.grey),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
