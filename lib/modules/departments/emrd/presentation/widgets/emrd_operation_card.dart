import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

// --- OPERATIONS MODULE CARD ---
class EmrdOperationCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final bool isDark;
  final VoidCallback? onTap;
  final int? badgeCount;

  const EmrdOperationCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.isDark,
    this.onTap,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.terminalDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? Colors.white10 : AppColors.border(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(
                            icon,
                            color: accentColor,
                            size: 20.r,
                          ),
                        ),
                        if (badgeCount != null && badgeCount! > 0)
                          Positioned(
                            top: -4.h,
                            right: -4.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                              decoration: const BoxDecoration(
                                color: Color(0xFFDC2626),
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Text(
                                "$badgeCount",
                                style: TextStyle(
                                  fontSize: 8.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        size: 14.r,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  value,
                  style: AppTextStyles.headingSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: isDark ? Colors.white : AppColors.textPrimary(context),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 10.sp,
                    color: isDark ? Colors.white54 : AppColors.textSecondary(context),
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
