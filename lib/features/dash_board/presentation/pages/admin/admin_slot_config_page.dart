import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/common_app_bar.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class AdminSlotConfigPage extends StatelessWidget {
  const AdminSlotConfigPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark
        ? AppColors.terminalDarkCard
        : AppColors.terminalLightCard;
    final borderColor = isDark
        ? AppColors.terminalDarkBorder
        : AppColors.terminalLightBorder;
    final textColor = isDark
        ? AppColors.terminalDarkText
        : AppColors.terminalLightText;

    return CustomScaffold(
      customAppbar: const CommonAppBar(title: "Slot Configuration"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Global Appointment Slot Settings",
              style: AppTextStyles.titleMedium.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              "Define default intervals and booking windows for all outpatient consultations.",
              style: AppTextStyles.bodySmall,
            ),
            SizedBox(height: 20.h),
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: cardBg,
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  _buildSettingRow(
                    icon: Icons.timer_outlined,
                    title: "Default Slot Duration",
                    value: "15 Minutes",
                  ),
                  const Divider(color: AppColors.border),
                  _buildSettingRow(
                    icon: Icons.hourglass_top_outlined,
                    title: "Buffer Time Between Slots",
                    value: "5 Minutes",
                  ),
                  const Divider(color: AppColors.border),
                  _buildSettingRow(
                    icon: Icons.calendar_month_outlined,
                    title: "Max Booking Window",
                    value: "30 Days",
                  ),
                  const Divider(color: AppColors.border),
                  _buildSettingRow(
                    icon: Icons.cancel_presentation_outlined,
                    title: "Cancellation Threshold",
                    value: "2 Hours Before",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 22.r),
          SizedBox(width: 16.w),
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              value,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
