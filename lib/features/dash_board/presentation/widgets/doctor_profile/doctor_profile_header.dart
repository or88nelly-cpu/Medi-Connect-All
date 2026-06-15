import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class DoctorProfileHeader extends StatelessWidget {
  const DoctorProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.terminalDarkText
        : AppColors.terminalLightText;
    final labelColor = isDark
        ? AppColors.terminalDarkLabel
        : AppColors.terminalLightLabel;
    final borderColor = isDark
        ? AppColors.terminalDarkBorder
        : AppColors.terminalLightBorder;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Back Button
        IconButton(
          onPressed: () => context.pop(),
          icon: Icon(Icons.arrow_back, color: textColor, size: 24.sp),
          style: IconButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size(40.r, 40.r),
          ),
        ),
        SizedBox(width: 8.w),
        // Title and Subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Doctor Profile",
                style: AppTextStyles.titleLarge.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.sp,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                "View and manage doctor details, slots & consultations",
                style: AppTextStyles.bodySmall.copyWith(
                  color: labelColor,
                  fontSize: 11.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        SizedBox(width: 12.w),
        // Action buttons
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Redirecting to Public Profile..."),
                  ),
                );
              },
              icon: Icon(
                Icons.visibility_outlined,
                size: 14.sp,
                color: isDark ? Colors.white : AppColors.primary,
              ),
              label: Text(
                "View Public Profile",
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.primary,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: BorderSide(
                  color: isDark ? borderColor : AppColors.primary,
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6.r),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            // More Button
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: IconButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("More Options Clicked")),
                  );
                },
                icon: Icon(Icons.more_horiz, color: textColor, size: 16.sp),
                style: IconButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(36.r, 36.r),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
