import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/analytics/recent_activity_card.dart';

class ExtraCard extends StatelessWidget {
  const ExtraCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 58.r),
      child: Row(
        spacing: 24.w,
        children: [
          Expanded(
            flex: 1,
            child: card(
              child: _commonCard(
                title: "Speciality Management",
                subTitle: "Manage all Hospital Specialities in one place",
                icon: Icons.admin_panel_settings,
                context: context,
              ),
              context: context,
            ),
          ),
          Expanded(
            flex: 1,
            child: card(
              child: _commonCard(
                title: "Settings",
                subTitle: "Configure system settings and preferences",
                icon: Icons.settings,
                context: context,
              ),
              context: context,
            ),
          ),
          Expanded(
            flex: 2,
            child: card(
              child: RecentActivityCard(activities: []),
              context: context,
            ),
          ),
        ],
      ),
    );
  }

  Widget card({required Widget child, required BuildContext context}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(24.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
      child: child,
    );
  }

  Widget _commonCard({
    required String title,
    required String subTitle,
    required IconData icon,
    required BuildContext context,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.bodyLarge.copyWith(
            fontSize: 18.sp,
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          children: [
            Icon(icon, size: 72.r, color: AppColors.primary),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                subTitle,
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 14.sp,
                  color: AppColors.textPrimary(context),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              padding: EdgeInsets.all(12.r),
              child: Icon(
                Icons.arrow_forward_outlined,
                color: AppColors.textPrimary(context),
                size: 30.r,
              ),
              decoration: BoxDecoration(
                color: AppColors.textPrimary(context).withOpacity(0.1),
                borderRadius: BorderRadius.circular(100.r),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
