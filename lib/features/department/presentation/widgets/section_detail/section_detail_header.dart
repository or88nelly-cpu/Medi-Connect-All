import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/department/data/models/department_model.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';

String? getDepartmentImageAsset(String name) {
  final lower = name.toLowerCase().trim();
  if (lower.contains('human') || lower.contains('resource')) {
    return 'assets/images/department/human-resource.png';
  }
  if (lower.contains('cardio')) {
    return 'assets/images/department/cardiology.png';
  }
  if (lower.contains('neuro')) {
    return 'assets/images/department/neurology.png';
  }
  if (lower.contains('radio')) {
    return 'assets/images/department/radiology.png';
  }
  if (lower.contains('pharma')) {
    return 'assets/images/department/pharmacy.png';
  }
  if (lower.contains('ward')) {
    return 'assets/images/department/ward.png';
  }
  if (lower.contains('icu')) {
    return 'assets/images/department/icu.png';
  }
  if (lower.contains('casuality') || lower.contains('emerg')) {
    return 'assets/images/department/casuality.png';
  }
  if (lower.contains('lab')) {
    return 'assets/images/department/laboratory.png';
  }
  if (lower.contains('finance')) {
    return 'assets/images/department/finance.png';
  }
  if (lower.contains('information') ||
      lower.contains('tech') ||
      lower.contains('it')) {
    return 'assets/images/department/it.png';
  }
  if (lower.contains('nutrition') || lower.contains('diabet')) {
    return 'assets/images/department/nutrition.png';
  }
  if (lower.contains('operation') ||
      lower.contains('theatre') ||
      lower.contains('ot')) {
    return 'assets/images/department/operation-theater.png';
  }
  if (lower.contains('biomedical') || lower.contains('engine')) {
    return 'assets/images/department/bio-medical.png';
  }
  if (lower.contains('cssd')) {
    return 'assets/images/department/cssd.png';
  }
  if (lower.contains('customer') || lower.contains('care')) {
    return 'assets/images/department/customer-care.png';
  }
  if (lower.contains('dyalisis') || lower.contains('dialysis')) {
    return 'assets/images/department/dialysis.png';
  }
  if (lower.contains('emrd')) {
    return 'assets/images/department/emrd.png';
  }
  if (lower.contains('fire')) {
    return 'assets/images/department/fire-safety.png';
  }
  if (lower.contains('store')) {
    return 'assets/images/department/general-store.png';
  }
  if (lower.contains('market')) {
    return 'assets/images/department/marketing.png';
  }
  if (lower.contains('nursing')) {
    return 'assets/images/department/nursing.png';
  }
  if (lower.contains('purchase')) {
    return 'assets/images/department/purchase.png';
  }
  if (lower.contains('mep')) {
    return 'assets/images/department/mep.png';
  }
  if (lower.contains('mis') || lower.contains('management info')) {
    return 'assets/images/department/mis.png';
  }
  if (lower.contains('physio')) {
    return 'assets/images/department/physio-therapy.png';
  }
  if (lower.contains('general medicine')) {
    return 'assets/images/department/general-medicine.png';
  }
  if (lower.contains('insurance')) {
    return 'assets/images/department/insurance.png';
  }
  if (lower.contains('ent')) {
    return 'assets/images/department/ent.png';
  }
  if (lower.contains('pediatric')) {
    return 'assets/images/department/pediatrics.png';
  }
  if (lower.contains('ortho')) {
    return 'assets/images/department/orthopaedic.png';
  }
  if (lower.contains('pulmon')) {
    return 'assets/images/department/pulmonology.png';
  }
  return null;
}

IconData getDepartmentIcon(String name) {
  final lower = name.toLowerCase();
  if (lower.contains('cardio')) return Icons.favorite_border;
  if (lower.contains('neuro')) return Icons.psychology_outlined;
  if (lower.contains('radio')) return Icons.settings_overscan_outlined;
  if (lower.contains('pharma')) return Icons.medication_outlined;
  if (lower.contains('ward')) return Icons.single_bed_outlined;
  if (lower.contains('icu')) return Icons.medical_services_outlined;
  if (lower.contains('casuality') || lower.contains('emerg')) {
    return Icons.emergency_outlined;
  }
  if (lower.contains('lab')) return Icons.science_outlined;
  if (lower.contains('finance')) return Icons.monetization_on_outlined;
  if (lower.contains('human') || lower.contains('resource')) {
    return Icons.people_outline;
  }
  if (lower.contains('information') ||
      lower.contains('tech') ||
      lower.contains('it')) {
    return Icons.computer_outlined;
  }
  if (lower.contains('nutrition') || lower.contains('diabet')) {
    return Icons.restaurant_outlined;
  }
  if (lower.contains('operation') ||
      lower.contains('theatre') ||
      lower.contains('ot')) {
    return Icons.biotech_outlined;
  }
  if (lower.contains('biomedical') || lower.contains('engine')) {
    return Icons.build_outlined;
  }
  if (lower.contains('cssd')) return Icons.clean_hands_outlined;
  if (lower.contains('customer')) return Icons.support_agent_outlined;
  if (lower.contains('dyalisis') || lower.contains('dialysis')) {
    return Icons.water_drop_outlined;
  }
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
    final subtitleColor = isDark
        ? AppColors.terminalDarkLabel
        : AppColors.terminalLightLabel;
    final iconColor = isDark ? Colors.white : AppColors.primary;
    final actionBg = isDark
        ? AppColors.terminalDarkCard
        : AppColors.terminalLightCard;
    final actionBorder = isDark
        ? AppColors.terminalDarkBorder
        : AppColors.terminalLightBorder;

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
            child: Icon(Icons.arrow_back_ios_new, size: 16.r, color: textColor),
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
          child: Builder(
            builder: (context) {
              final imageAsset = getDepartmentImageAsset(department.name);
              if (imageAsset != null) {
                return Padding(
                  padding: EdgeInsets.all(8.r),
                  child: CustomImageView(
                    imagePath: imageAsset,
                    fit: BoxFit.contain,
                    color: isDark ? Colors.white : AppColors.primary,
                  ),
                );
              }
              return Icon(
                getDepartmentIcon(department.name),
                color: isDark ? Colors.white : AppColors.primary,
                size: 22.r,
              );
            },
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
