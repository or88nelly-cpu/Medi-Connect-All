import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_dimensions.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/features/admin/home/presentation/bloc/admin_home_bloc.dart';
import 'package:medi_connect/features/admin/home/presentation/bloc/admin_home_event.dart';
import 'package:medi_connect/features/authentication/domain/entities/user_entity.dart';

/// Control Center hero header featuring welcome greeting, search field, top app bar actions, and hospital artwork.
class AdminControlCenterHeader extends StatefulWidget {
  final UserEntity? user;

  const AdminControlCenterHeader({super.key, this.user});

  @override
  State<AdminControlCenterHeader> createState() =>
      _AdminControlCenterHeaderState();
}

class _AdminControlCenterHeaderState extends State<AdminControlCenterHeader> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isMobile = MediaQuery.of(context).size.width < 768;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top App Bar Action Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.welcomeBackAdmin,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white70 : Colors.grey.shade700,
              ),
            ),

            // Right utility buttons: Notifications, Search, Admin Profile
            Row(
              children: [
                // Notification Bell with Badge
                Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(10.r),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.04),
                            blurRadius: 10,
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
                        padding: EdgeInsets.all(4.r),
                        decoration: const BoxDecoration(
                          color: AppColors.badgeRed,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          AppStrings.notificationCountDefault,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: AppDimensions.spaceWS),

                // Profile Avatar Badge
                Row(
                  children: [
                    CircleAvatar(
                      radius: 18.r,
                      backgroundColor: AppColors.primary.withValues(
                        alpha: 0.15,
                      ),
                      child: Icon(
                        Icons.admin_panel_settings,
                        size: 20.r,
                        color: AppColors.primary,
                      ),
                    ),
                    if (!isMobile) ...[
                      SizedBox(width: 8.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.user?.fullName ?? AppStrings.login,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.textDarkNavy,
                            ),
                          ),
                          Text(
                            AppStrings.superAdmin,
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: AppDimensions.spaceM),

        // Main Title & Subtitle Banner
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.hospitalControlCenter,
                    style: AppTextStyles.headingLarge.copyWith(
                      fontSize: isMobile ? 26.sp : 34.sp,
                      fontWeight: FontWeight.w900,
                      height: 1.1,
                      color: isDark ? Colors.white : AppColors.textDarkNavy,
                    ),
                  ),
                  SizedBox(height: AppDimensions.spaceS),
                  Text(
                    AppStrings.controlCenterSubtitle,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 13.sp,
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.65)
                          : Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: AppDimensions.spaceL),

                  // Search Bar Input
                  Container(
                    width: isMobile ? double.infinity : 400.w,
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : Colors.white,
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.08)
                            : Colors.black.withValues(alpha: 0.06),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        context.read<AdminHomeBloc>().add(
                          FilterAdminDashboardModules(val),
                        );
                      },
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isDark ? Colors.white : AppColors.textDarkNavy,
                      ),
                      decoration: InputDecoration(
                        icon: Icon(
                          Icons.search_rounded,
                          color: Colors.grey.shade400,
                          size: 20.r,
                        ),
                        hintText: AppStrings.searchModulesPlaceholder,
                        hintStyle: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 13.sp,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Artwork Illustration Container (on Desktop/Tablet)
            if (!isMobile) ...[
              SizedBox(width: AppDimensions.spaceL),
              Container(
                height: 140.h,
                width: 220.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.08),
                      AppColors.controlCenterPurple.withValues(alpha: 0.12),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Center(
                  child: Icon(
                    Icons.apartment_rounded,
                    size: 80.r,
                    color: AppColors.primary.withValues(alpha: 0.6),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }
}
