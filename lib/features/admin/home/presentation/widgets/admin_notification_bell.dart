import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_colors.dart';

/// Notification bell icon with red count badge.
class AdminNotificationBell extends StatelessWidget {
  final bool isDark;
  const AdminNotificationBell({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 8,
              ),
            ],
          ),
          child: Icon(
            Icons.notifications_none_rounded,
            size: 20.r,
            color: isDark ? Colors.white : AppColors.textDarkNavy,
          ),
        ),
        Positioned(
          right: 0,
          top: 0,
          child: Container(
            padding: EdgeInsets.all(3.r),
            decoration: const BoxDecoration(
              color: AppColors.badgeRed,
              shape: BoxShape.circle,
            ),
            child: Text(
              AppStrings.notificationCountDefault,
              style: TextStyle(
                color: Colors.white,
                fontSize: 8.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
