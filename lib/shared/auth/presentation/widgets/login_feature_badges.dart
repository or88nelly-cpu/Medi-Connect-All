import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/functions/app_responsive.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class LoginFeatureBadges extends StatelessWidget {
  const LoginFeatureBadges({super.key});

  @override
  Widget build(BuildContext context) {
    final badges = [
      const _BadgeData(Icons.verified_rounded, 'Secure', AppColors.primary),
      const _BadgeData(
        Icons.people_alt_rounded,
        'Personalized',
        AppColors.adminPrimary,
      ),
      const _BadgeData(
        Icons.auto_awesome_rounded,
        'Seamless',
        Color(0xFF00B8A9),
      ),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: badges
          .map(
            (b) => Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppResponsive.isDesktop(context) ? 8.w : 6.w,
              ),
              child: _buildBadge(context, b),
            ),
          )
          .toList(),
    );
  }

  Widget _buildBadge(BuildContext context, _BadgeData data) {
    bool isDesktop = AppResponsive.isDesktop(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: isDesktop ? 52.r : 40.r,
          height: isDesktop ? 52.r : 40.r,
          decoration: BoxDecoration(
            color: data.color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(isDesktop ? 14.r : 8.r),
            border: Border.all(
              color: data.color.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Icon(
            data.icon,
            color: data.color,
            size: isDesktop ? 24.r : 18.r,
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          data.label,
          style: AppTextStyles.bodyXSmall.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary(context),
            fontSize: isDesktop ? 10.sp : 8.sp,
          ),
        ),
      ],
    );
  }
}

class _BadgeData {
  final IconData icon;
  final String label;
  final Color color;
  const _BadgeData(this.icon, this.label, this.color);
}
