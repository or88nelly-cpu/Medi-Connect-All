import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/department/data/models/department_model.dart';

IconData getDepartmentIcon(String name) {
  final lower = name.toLowerCase();
  if (lower.contains('cardio')) return Icons.favorite_border;
  if (lower.contains('neuro')) return Icons.psychology_outlined;
  if (lower.contains('radio')) return Icons.settings_overscan_outlined;
  if (lower.contains('pharma')) return Icons.medication_outlined;
  if (lower.contains('ward')) return Icons.single_bed_outlined;
  if (lower.contains('icu')) return Icons.medical_services_outlined;
  if (lower.contains('casuality') || lower.contains('emerg')) return Icons.emergency_outlined;
  if (lower.contains('lab')) return Icons.science_outlined;
  if (lower.contains('finance')) return Icons.monetization_on_outlined;
  if (lower.contains('human') || lower.contains('resource')) return Icons.people_outline;
  if (lower.contains('information') || lower.contains('tech') || lower.contains('it')) return Icons.computer_outlined;
  if (lower.contains('nutrition') || lower.contains('diabet')) return Icons.restaurant_outlined;
  if (lower.contains('operation') || lower.contains('theatre') || lower.contains('ot')) return Icons.biotech_outlined;
  if (lower.contains('biomedical') || lower.contains('engine')) return Icons.build_outlined;
  if (lower.contains('cssd')) return Icons.clean_hands_outlined;
  if (lower.contains('customer')) return Icons.support_agent_outlined;
  if (lower.contains('dyalisis') || lower.contains('dialysis')) return Icons.water_drop_outlined;
  if (lower.contains('emrd')) return Icons.folder_shared_outlined;
  if (lower.contains('fire')) return Icons.fire_extinguisher_outlined;
  if (lower.contains('store')) return Icons.store_outlined;
  if (lower.contains('market')) return Icons.campaign_outlined;
  if (lower.contains('nursing')) return Icons.health_and_safety_outlined;
  if (lower.contains('purchase')) return Icons.shopping_cart_outlined;
  return Icons.local_hospital_outlined;
}

class SectionDetailHeader extends StatelessWidget {
  final DepartmentModel department;
  final VoidCallback? onSearchTap;
  final VoidCallback? onFilterTap;
  final VoidCallback? onMoreTap;

  const SectionDetailHeader({
    super.key,
    required this.department,
    this.onSearchTap,
    this.onFilterTap,
    this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;
    final subtitleColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;
    final iconColor = isDark ? Colors.white : AppColors.primary;
    final actionBg = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final actionBorder = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;

    return Row(
      children: [
        // Back Button
        InkWell(
          onTap: () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(30.r),
          child: Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: actionBg,
              border: Border.all(color: actionBorder),
            ),
            child: Icon(
              Icons.arrow_back_ios_new,
              size: 16.r,
              color: textColor,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        // Dynamic Icon
        Container(
          width: 44.r,
          height: 44.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary.withValues(alpha: 0.15),
            border: Border.all(
              color: AppColors.primary.withValues(alpha: 0.25),
              width: 1.5,
            ),
          ),
          child: Icon(
            getDepartmentIcon(department.name),
            color: isDark ? Colors.white : AppColors.primary,
            size: 22.r,
          ),
        ),
        SizedBox(width: 12.w),
        // Title and Subtitle
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                department.name,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: textColor,
                  fontSize: 18.sp,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                "Department",
                style: AppTextStyles.bodySmall.copyWith(
                  color: subtitleColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        // Action Buttons
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (onSearchTap != null)
              _buildActionButton(
                icon: Icons.search,
                color: iconColor,
                onTap: onSearchTap!,
                bg: actionBg,
                border: actionBorder,
              ),
            if (onSearchTap != null) SizedBox(width: 8.w),
            if (onFilterTap != null)
              _buildActionButton(
                icon: Icons.tune,
                color: iconColor,
                onTap: onFilterTap!,
                bg: actionBg,
                border: actionBorder,
              ),
            if (onFilterTap != null) SizedBox(width: 8.w),
            _buildActionButton(
              icon: Icons.more_vert,
              color: iconColor,
              onTap: onMoreTap,
              bg: actionBg,
              border: actionBorder,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback? onTap,
    required Color bg,
    required Color border,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30.r),
      child: Container(
        width: 38.r,
        height: 38.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bg,
          border: Border.all(color: border),
        ),
        child: Icon(icon, size: 18.r, color: color),
      ),
    );
  }
}
