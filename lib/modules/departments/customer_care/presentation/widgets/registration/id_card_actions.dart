import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class IdCardActions extends StatelessWidget {
  final String patientName;
  final String uhid;

  const IdCardActions({
    super.key,
    required this.patientName,
    required this.uhid,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF09121F) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF16253B)
        : const Color(0xFFD3E0EE);
    final buttonTextColor = isDark
        ? const Color(0xFF5E98C7)
        : const Color(0xFF3F6D94);

    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.print_outlined, color: AppColors.primary, size: 22.r),
              SizedBox(width: 10.w),
              Text(
                "ID Card Actions",
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F2C59),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          Row(
            children: [
              // Download Button
              Expanded(
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: borderColor, width: 1.w),
                  ),
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _simulateAction(
                        context,
                        "Downloading ID Card",
                        "ID Card for $patientName ($uhid) downloaded successfully as PDF.",
                      );
                    },
                    icon: Icon(
                      Icons.download_rounded,
                      color: AppColors.primary,
                      size: 18.r,
                    ),
                    label: Text(
                      "Download ID Card",
                      style: AppTextStyles.buttonMedium.copyWith(
                        color: buttonTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),

              // Print Button
              Expanded(
                child: Container(
                  height: 48.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: borderColor, width: 1.w),
                  ),
                  child: OutlinedButton.icon(
                    onPressed: () {
                      _simulateAction(
                        context,
                        "Printing ID Card",
                        "Sending ID Card for $patientName ($uhid) to clinical printer...",
                      );
                    },
                    icon: Icon(
                      Icons.print_rounded,
                      color: AppColors.primary,
                      size: 18.r,
                    ),
                    label: Text(
                      "Print ID Card",
                      style: AppTextStyles.buttonMedium.copyWith(
                        color: buttonTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _simulateAction(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF09121F)
            : Colors.white,
        title: Row(
          children: [
            const Icon(Icons.check_circle, color: AppColors.success),
            SizedBox(width: 8.w),
            Text(title, style: AppTextStyles.titleMedium),
          ],
        ),
        content: Text(message, style: AppTextStyles.bodyMedium),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }
}
