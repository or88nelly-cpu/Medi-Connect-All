import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class CommonCard extends StatelessWidget {
  final String title;
  final Color color;
  final String subTitle;
  final IconData icon;
  final VoidCallback? onTap;

  const CommonCard({
    super.key,
    required this.title,
    required this.color,
    required this.subTitle,
    required this.icon,
    this.onTap,
  });

  // Title row: 1 line, fixed height so all cards align
  static const double _titleHeight = 22;
  // Subtitle area: max 2 lines, fixed height
  static const double _subtitleHeight = 58;

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    // Use AppColors card base, tinted with accent color
    final cardBase = AppColors.card(context);
    final cardBg = Color.lerp(cardBase, color, isDark ? 0.06 : 0.07)!;

    final borderColor = isDark
        ? color.withValues(alpha: 0.28)
        : color.withValues(alpha: 0.20);

    final shadowColor = isDark
        ? color.withValues(alpha: 0.15)
        : color.withValues(alpha: 0.10);

    final titleColor = AppColors.textPrimary(context);
    final subtitleColor = AppColors.textSecondary(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: cardBg,
          border: Border.all(color: borderColor, width: 1.5),
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 18,
              spreadRadius: 1,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // ── Decorative ghost icon (top-right) ──
            Positioned(
              right: -6,
              top: -6,
              child: Icon(
                icon,
                size: 72.r,
                color: color.withValues(alpha: isDark ? 0.07 : 0.09),
              ),
            ),

            // ── Main content ──
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Gradient icon box
                Container(
                  height: 54.r,
                  width: 54.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.r),
                    gradient: LinearGradient(
                      colors: [color, color.withValues(alpha: 0.72)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: color.withValues(alpha: 0.32),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(icon, color: Colors.white, size: 24.r),
                ),

                SizedBox(height: 12.h),

                // Title — fixed 1 line height
                SizedBox(
                  height: _titleHeight.toDouble(),
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.titleMedium.copyWith(
                      color: titleColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                SizedBox(height: 4.h),

                // Subtitle — fixed 2-line height
                SizedBox(
                  height: _subtitleHeight.toDouble(),
                  child: Text(
                    subTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: subtitleColor,
                      fontSize: 11.sp,
                      height: 1.5,
                    ),
                  ),
                ),

                SizedBox(height: 10.h),

                // Arrow button — always at the bottom-right
                Align(
                  alignment: Alignment.bottomRight,
                  child: Container(
                    height: 32.r,
                    width: 32.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: color.withValues(alpha: isDark ? 0.55 : 0.40),
                        width: 1.5,
                      ),
                      color: color.withValues(alpha: isDark ? 0.12 : 0.08),
                    ),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: color,
                      size: 15.r,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
