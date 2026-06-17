import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/features/dash_board/domain/entities/appointment_entity.dart';

class VitalsGridSection extends StatelessWidget {
  final AppointmentEntity? recentApt;
  final VoidCallback? onViewAll;

  const VitalsGridSection({super.key, required this.recentApt, this.onViewAll});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bp = recentApt?.bp ?? "N/A";
    final weight = recentApt?.weight ?? "N/A";
    final height = recentApt?.height ?? "N/A";
    final temp = recentApt?.fever ?? "N/A";
    final hc = recentApt?.headCircumference ?? "N/A";
    final status = recentApt?.status ?? "N/A";

    final titleColor = isDark ? Colors.white : AppColors.textDarkNavy;
    final borderCol = AppColors.border(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.recentVitals,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: titleColor,
                fontSize: 16.sp,
              ),
            ),
            GestureDetector(
              onTap: onViewAll,
              child: Row(
                children: [
                  Text(
                    AppStrings.viewAll,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 10.r,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // 3x2 Grid
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 10.w,
          mainAxisSpacing: 10.h,
          childAspectRatio: 1.15,
          children: [
            _buildVitalCard(
              context: context,
              label: AppStrings.bloodPressure,
              value: bp,
              icon: Icons.favorite,
              iconColor: const Color(0xFFEF4444),
              isDark: isDark,
              borderCol: borderCol,
            ),
            _buildVitalCard(
              context: context,
              label: AppStrings.weightLabel,
              value: weight.contains("kg") || weight == "N/A"
                  ? weight
                  : "$weight kg",
              icon: Icons.monitor_weight_outlined,
              iconColor: const Color(0xFF0F6FFF),
              isDark: isDark,
              borderCol: borderCol,
            ),
            _buildVitalCard(
              context: context,
              label: AppStrings.heightLabel,
              value: height.contains("cm") || height == "N/A"
                  ? height
                  : "$height cm",
              icon: Icons.height,
              iconColor: const Color(0xFF10B981),
              isDark: isDark,
              borderCol: borderCol,
            ),
            _buildVitalCard(
              context: context,
              label: AppStrings.temperature,
              value: temp.contains("F") || temp.contains("C") || temp == "N/A"
                  ? temp
                  : "$temp°F",
              icon: Icons.thermostat,
              iconColor: const Color(0xFFF59E0B),
              isDark: isDark,
              borderCol: borderCol,
            ),
            _buildVitalCard(
              context: context,
              label: "Head Circ.",
              value: hc.isEmpty || hc == "N/A" ? "N/A" : hc,
              icon: Icons.psychology,
              iconColor: const Color(0xFF8B5CF6),
              isDark: isDark,
              borderCol: borderCol,
            ),
            _buildVitalCard(
              context: context,
              label: "Status",
              value: status,
              icon: Icons.check_circle,
              iconColor: const Color(0xFF10B981),
              isDark: isDark,
              borderCol: borderCol,
              isStatus: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVitalCard({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required Color iconColor,
    required bool isDark,
    required Color borderCol,
    bool isStatus = false,
  }) {
    final textCol =  AppColors.textPrimary(context);
    final subTextCol = isDark
        ? Colors.white38
        : AppColors.textSecondary(context);
    final cardBg = isDark ? const Color(0xFF0F172A) : Colors.white;

    final displayVal =
        value == "N/A kg" || value == "N/A cm" || value == "N/A°F"
        ? "N/A"
        : value;
    final isNA = displayVal == "N/A";

    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderCol),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Icon Container
              Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: iconColor.withValues(alpha: 0.1),
                ),
                child: Icon(icon, color: iconColor, size: 16.r),
              ),

              // Indicator Dot
              Container(
                width: 6.r,
                height: 6.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isNA ? const Color(0xFF94A3B8) : iconColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            displayVal,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: isStatus && !isNA ? iconColor : textCol,
              fontSize: 12.sp,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(
              color: subTextCol,
              fontSize: 8.sp,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
