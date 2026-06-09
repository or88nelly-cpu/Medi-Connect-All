import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/navigation/admin_nav_item.dart';

class PatientBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const PatientBottomNavBar({
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
                outlineIcon: Icons.home_outlined,
                solidIcon: Icons.home,
                label: "Home",
                currentIndex: currentIndex,
                onTap: onTap,
              ),
              AdminNavItem(
                index: 1,
                outlineIcon: Icons.calendar_today_outlined,
                solidIcon: Icons.calendar_today,
                label: "Appointments",
                currentIndex: currentIndex,
                onTap: onTap,
              ),
              AdminNavItem(
                index: 2,
                outlineIcon: Icons.folder_open_outlined,
                solidIcon: Icons.folder,
                label: "Records",
                currentIndex: currentIndex,
                onTap: onTap,
              ),
              AdminNavItem(
                index: 3,
                outlineIcon: Icons.chat_bubble_outline,
                solidIcon: Icons.chat_bubble,
                label: "Chat",
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
