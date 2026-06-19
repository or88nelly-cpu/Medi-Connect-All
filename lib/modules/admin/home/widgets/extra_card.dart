import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/analytics/recent_activity_card.dart';

class ExtraCard extends StatelessWidget {
  const ExtraCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 950;

    final margin = isDesktop
        ? EdgeInsets.only(left: 58.r)
        : EdgeInsets.symmetric(horizontal: 16.r);

    final List<Widget> children = [
      _buildSpecialityCard(context),
      _buildSettingsCard(context),
      const RecentActivityCard(activities: []),
    ];

    if (isDesktop) {
      return Padding(
        padding: margin,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 1, child: children[0]),
            SizedBox(width: 24.w),
            Expanded(flex: 1, child: children[1]),
            SizedBox(width: 24.w),
            Expanded(flex: 2, child: children[2]),
          ],
        ),
      );
    } else {
      return Padding(
        padding: margin,
        child: Column(
          children: [
            children[0],
            SizedBox(height: 16.h),
            children[1],
            SizedBox(height: 16.h),
            children[2],
          ],
        ),
      );
    }
  }

  Widget _buildSpecialityCard(BuildContext context) {
    return _buildCustomCommonCard(
      title: AppStrings.specialityManagement,
      subTitle: AppStrings.specialityManagementDesc,
      icon: Icons.shield_outlined,
      gradient: AppColors.purpleGradient,
      context: context,
      onTap: () {
        context.push("/sections");
        // Specialty management navigation action placeholder
      },
    );
  }

  Widget _buildSettingsCard(BuildContext context) {
    return _buildCustomCommonCard(
      title: AppStrings.settings,
      subTitle: AppStrings.settingsDesc,
      icon: Icons.settings_outlined,
      gradient: AppColors.blueGradient,
      context: context,
      onTap: () {
        // Settings navigation action placeholder
      },
    );
  }

  Widget _buildCustomCommonCard({
    required String title,
    required String subTitle,
    required IconData icon,
    required List<Color> gradient,
    required BuildContext context,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.darkCard : Colors.white;
    final borderCol = isDark
        ? Colors.white.withValues(alpha: 0.04)
        : Colors.black.withValues(alpha: 0.03);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: borderCol, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyLarge.copyWith(
              fontSize: 16.sp,
              color: isDark ? Colors.white : AppColors.textDarkNavy,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 60.r,
                height: 60.r,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: gradient.last.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Center(
                  child: Icon(icon, color: Colors.white, size: 28.r),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Text(
                  subTitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 13.sp,
                    color: isDark
                        ? Colors.white70
                        : AppColors.textDarkNavy.withValues(alpha: 0.8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(100.r),
                child: Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.05)
                        : AppColors.primary.withValues(alpha: 0.06),
                    border: Border.all(
                      color: isDark
                          ? Colors.white.withValues(alpha: 0.1)
                          : AppColors.primary.withValues(alpha: 0.15),
                      width: 1,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: isDark ? Colors.white : AppColors.primary,
                    size: 14.r,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
