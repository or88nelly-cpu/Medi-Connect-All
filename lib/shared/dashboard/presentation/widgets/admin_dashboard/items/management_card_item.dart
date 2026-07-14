import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

/// A compact horizontal card for a management action.
/// Layout: [Icon circle] → [Title + Subtitle] → [Arrow circle]
/// All colors are passed as params — no hardcoded colors inside.
class ManagementCardItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData iconData;

  /// Accent color for the icon and arrow. Should come from [AppColors].
  final Color accentColor;
  final VoidCallback onTap;

  const ManagementCardItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.iconData,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: AppColors.card(context),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: accentColor.withValues(alpha: 0.15)),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: accentColor.withValues(alpha: 0.07),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _ManagementIconCircle(
                iconData: iconData,
                accentColor: accentColor,
                isDark: isDark,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _ManagementCardText(
                  title: title,
                  subtitle: subtitle,
                  context: context,
                ),
              ),
              SizedBox(width: 8.w),
              _ManagementArrow(accentColor: accentColor, isDark: isDark),
            ],
          ),
        ),
      ),
    );
  }
}

class _ManagementIconCircle extends StatelessWidget {
  final IconData iconData;
  final Color accentColor;
  final bool isDark;

  const _ManagementIconCircle({
    required this.iconData,
    required this.accentColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.r,
      height: 40.r,
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: isDark ? 0.15 : 0.10),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(iconData, color: accentColor, size: 20.sp),
      ),
    );
  }
}

class _ManagementCardText extends StatelessWidget {
  final String title;
  final String subtitle;
  final BuildContext context;

  const _ManagementCardText({
    required this.title,
    required this.subtitle,
    required this.context,
  });

  @override
  Widget build(BuildContext _) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: AppTextStyles.labelMedium.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary(context),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 2.h),
        Text(
          subtitle,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.textSecondary(context),
            height: 1.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _ManagementArrow extends StatelessWidget {
  final Color accentColor;
  final bool isDark;

  const _ManagementArrow({required this.accentColor, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28.r,
      height: 28.r,
      decoration: BoxDecoration(
        color: accentColor.withValues(alpha: isDark ? 0.15 : 0.08),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          Icons.arrow_forward_ios_rounded,
          color: accentColor,
          size: 12.sp,
        ),
      ),
    );
  }
}
