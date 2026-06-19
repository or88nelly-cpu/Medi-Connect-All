import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class UhidDisplayCard extends StatelessWidget {
  final String uhid;

  const UhidDisplayCard({super.key, required this.uhid});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardBg = isDark ? const Color(0xFF09121F) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF16253B)
        : const Color(0xFFD3E0EE);
    final labelColor = isDark
        ? const Color(0xFF5E98C7)
        : const Color(0xFF3F6D94);
    final valueColor = isDark ? Colors.white : const Color(0xFF0F2C59);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor, width: 1.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.verified_user_rounded,
              color: AppColors.success,
              size: 20.r,
            ),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "UHID (Unique Health ID)",
                style: AppTextStyles.bodySmall.copyWith(
                  color: labelColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 10.sp,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                uhid.isNotEmpty ? uhid : "Generating...",
                style: AppTextStyles.titleMedium.copyWith(
                  color: valueColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
          SizedBox(width: 16.w),
          IconButton(
            icon: Icon(Icons.copy_rounded, color: labelColor, size: 18.r),
            onPressed: () {
              if (uhid.isNotEmpty) {
                Clipboard.setData(ClipboardData(text: uhid));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('UHID $uhid copied to clipboard'),
                    backgroundColor: AppColors.primary,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
