import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/routes/route_names.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_dimensions.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/features/authentication/domain/entities/user_entity.dart';

/// Navigation Sidebar matching the specification UI design.
class AdminSidebar extends StatelessWidget {
  final UserEntity? user;
  final String activeRoute;

  const AdminSidebar({
    super.key,
    this.user,
    this.activeRoute = RouteNames.adminDashboard,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 250.w,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : AppColors.sidebarDarkNavy,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(4, 0),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo & Brand Header
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      AppColors.controlCenterBlue,
                      AppColors.controlCenterBlueAccent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.local_hospital_rounded,
                  color: Colors.white,
                  size: 24.r,
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.mediConnectBrand,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      fontSize: 16.sp,
                    ),
                  ),
                  Text(
                    AppStrings.hospitalPlatform,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 10.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: AppDimensions.spaceXL),

          // Navigation Links List
          Expanded(
            child: ListView(
              children: [
                _buildNavItem(
                  context,
                  icon: Icons.grid_view_rounded,
                  label: AppStrings.dashboard,
                  route: RouteNames.adminDashboard,
                  isActive: activeRoute == RouteNames.adminDashboard,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.calendar_today_rounded,
                  label: AppStrings.appointments,
                  route: RouteNames.appointments,
                  isActive: activeRoute == RouteNames.appointments,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.people_outline_rounded,
                  label: AppStrings.staffSuffix,
                  route: '/patient/dashboard',
                  isActive: activeRoute == '/patient/dashboard',
                ),
                _buildNavItem(
                  context,
                  icon: Icons.receipt_long_rounded,
                  label: AppStrings.payments,
                  route: RouteNames.payments,
                  isActive: activeRoute == RouteNames.payments,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.analytics_outlined,
                  label: AppStrings.medicalRecords,
                  route: '/admin/reports',
                  isActive: activeRoute == '/admin/reports',
                ),
                _buildNavItem(
                  context,
                  icon: Icons.chat_bubble_outline_rounded,
                  label: AppStrings.chat,
                  route: RouteNames.chat,
                  isActive: activeRoute == RouteNames.chat,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.notifications_none_rounded,
                  label: AppStrings.notifications,
                  route: RouteNames.notifications,
                  isActive: activeRoute == RouteNames.notifications,
                ),
                _buildNavItem(
                  context,
                  icon: Icons.settings_outlined,
                  label: AppStrings.profile,
                  route: RouteNames.adminSettings,
                  isActive: activeRoute == RouteNames.adminSettings,
                ),
              ],
            ),
          ),

          // "Go Premium" Promotion Card
          Container(
            padding: EdgeInsets.all(14.r),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primaryDark, AppColors.controlCenterBlue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.workspace_premium_rounded,
                      color: AppColors.secondary,
                      size: 20.r,
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      AppStrings.goPremium,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13.sp,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  AppStrings.goPremiumDesc,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 10.sp,
                  ),
                ),
                SizedBox(height: 10.h),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primaryDark,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        AppStrings.upgradeNow,
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Icon(Icons.chevron_right_rounded, size: 14.r),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppDimensions.spaceM),

          // User Footer Profile Badge
          Row(
            children: [
              CircleAvatar(
                radius: 18.r,
                backgroundColor: AppColors.primaryLight,
                child: Text(
                  user?.fullName.isNotEmpty == true ? user!.fullName[0] : 'A',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.fullName ?? AppStrings.login,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      AppStrings.superAdmin,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
    required bool isActive,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (!isActive) {
              context.go(route);
            }
          },
          borderRadius: BorderRadius.circular(12.r),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: isActive
                  ? AppColors.controlCenterBlue
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20.r,
                  color: isActive
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.7),
                ),
                SizedBox(width: 12.w),
                Text(
                  label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isActive
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.8),
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
