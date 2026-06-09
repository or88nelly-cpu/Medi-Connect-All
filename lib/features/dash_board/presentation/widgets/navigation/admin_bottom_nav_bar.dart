import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';

import 'admin_nav_item.dart';

class AdminBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AdminBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20.r,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AdminNavItem(
                index: 0,
                outlineIcon: Icons.dashboard_customize_outlined,
                solidIcon: Icons.dashboard_customize,
                label: "Dashboard",
                currentIndex: currentIndex,
                onTap: onTap,
              ),
              AdminNavItem(
                index: 1,
                outlineIcon: Icons.payment_outlined,
                solidIcon: Icons.payment,
                label: "Payments",
                currentIndex: currentIndex,
                onTap: onTap,
              ),
              AdminNavItem(
                index: 2,
                outlineIcon: Icons.analytics_outlined,
                solidIcon: Icons.analytics,
                label: "Analytics",
                currentIndex: currentIndex,
                onTap: onTap,
              ),
              AdminNavItem(
                index: 3,
                outlineIcon: Icons.article_outlined,
                solidIcon: Icons.article,
                label: "Posts",
                currentIndex: currentIndex,
                onTap: onTap,
              ),
              AdminNavItem(
                index: 4,
                outlineIcon: Icons.person_outline,
                solidIcon: Icons.person,
                label: "Profile",
                currentIndex: currentIndex,
                onTap: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
