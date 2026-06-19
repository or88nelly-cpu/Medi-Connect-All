import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/router/route_names.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/department/domain/entities/department_entity.dart';
import 'package:medi_connect/features/department/data/models/department_model.dart';

class AdminDepartmentStyle {
  final IconData icon;
  final List<Color> gradient;
  final Color lightCardBg;
  final Color darkCardBg;

  const AdminDepartmentStyle({
    required this.icon,
    required this.gradient,
    required this.lightCardBg,
    required this.darkCardBg,
  });

  static AdminDepartmentStyle getStyle(String departmentName) {
    final name = departmentName.toLowerCase().trim();

    if (name.contains('customer') || name.contains('care')) {
      return const AdminDepartmentStyle(
        icon: Icons.headset_mic_rounded,
        gradient: AppColors.blueGradient,
        lightCardBg: AppColors.lightBlueCard,
        darkCardBg: AppColors.darkBlueCard,
      );
    } else if (name.contains('finance')) {
      return const AdminDepartmentStyle(
        icon: Icons.account_balance_wallet_rounded,
        gradient: AppColors.greenGradient,
        lightCardBg: AppColors.lightGreenCard,
        darkCardBg: AppColors.darkGreenCard,
      );
    } else if (name.contains('nurse') || name.contains('nursing')) {
      return const AdminDepartmentStyle(
        icon: Icons.medical_services_rounded,
        gradient: AppColors.purpleGradient,
        lightCardBg: AppColors.lightPurpleCard,
        darkCardBg: AppColors.darkPurpleCard,
      );
    } else if (name.contains('pharmacy')) {
      return const AdminDepartmentStyle(
        icon: Icons.medication_rounded,
        gradient: AppColors.pinkGradient,
        lightCardBg: AppColors.lightPinkCard,
        darkCardBg: AppColors.darkPinkCard,
      );
    } else if (name.contains('radiology')) {
      return const AdminDepartmentStyle(
        icon: Icons
            .bubble_chart_rounded, // Approximation of chest scan pattern / cells
        gradient: AppColors.blueGradient,
        lightCardBg: AppColors.lightBlueCard,
        darkCardBg: AppColors.darkBlueCard,
      );
    } else if (name.contains('lab') || name.contains('laboratory')) {
      return const AdminDepartmentStyle(
        icon: Icons.science_rounded,
        gradient: AppColors.orangeGradient,
        lightCardBg: AppColors.lightOrangeCard,
        darkCardBg: AppColors.darkOrangeCard,
      );
    } else if (name.contains('physio') ||
        name.contains('physical') ||
        name.contains('physiotherapy')) {
      return const AdminDepartmentStyle(
        icon: Icons.accessibility_new_rounded,
        gradient: AppColors.greenGradient,
        lightCardBg: AppColors.lightTealCard,
        darkCardBg: AppColors.darkTealCard,
      );
    } else if (name.contains('purchase')) {
      return const AdminDepartmentStyle(
        icon: Icons.shopping_cart_rounded,
        gradient: AppColors.purpleGradient,
        lightCardBg: AppColors.lightPurpleCard,
        darkCardBg: AppColors.darkPurpleCard,
      );
    } else if (name.contains('store') || name.contains('general')) {
      return const AdminDepartmentStyle(
        icon: Icons.storefront_rounded,
        gradient: AppColors.blueGradient,
        lightCardBg: AppColors.lightBlueCard,
        darkCardBg: AppColors.darkBlueCard,
      );
    } else if (name.contains('human') ||
        name.contains('resource') ||
        name.contains('hr')) {
      return const AdminDepartmentStyle(
        icon: Icons.groups_rounded,
        gradient: AppColors.greenGradient,
        lightCardBg: AppColors.lightGreenCard,
        darkCardBg: AppColors.darkGreenCard,
      );
    } else if (name.contains('marketing')) {
      return const AdminDepartmentStyle(
        icon: Icons.campaign_rounded,
        gradient: AppColors.pinkGradient,
        lightCardBg: AppColors.lightPinkCard,
        darkCardBg: AppColors.darkPinkCard,
      );
    } else if (name.contains('casual') ||
        name.contains('casuality') ||
        name.contains('casualty')) {
      return const AdminDepartmentStyle(
        icon: Icons.emergency_rounded,
        gradient: AppColors.redGradient,
        lightCardBg: AppColors.lightRedCard,
        darkCardBg: AppColors.darkRedCard,
      );
    } else if (name.contains('operation') ||
        name.contains('theatre') ||
        name.contains('ot')) {
      return const AdminDepartmentStyle(
        icon: Icons.airline_seat_flat_angled_rounded,
        gradient: AppColors.purpleGradient,
        lightCardBg: AppColors.lightPurpleCard,
        darkCardBg: AppColors.darkPurpleCard,
      );
    } else if (name.contains('nutrition') || name.contains('diet')) {
      return const AdminDepartmentStyle(
        icon: Icons.apple_rounded,
        gradient: AppColors.greenGradient,
        lightCardBg: AppColors.lightGreenCard,
        darkCardBg: AppColors.darkGreenCard,
      );
    } else if (name.contains('emrd')) {
      return const AdminDepartmentStyle(
        icon: Icons.assignment_rounded,
        gradient: AppColors.blueGradient,
        lightCardBg: AppColors.lightBlueCard,
        darkCardBg: AppColors.darkBlueCard,
      );
    } else if (name.contains('biomedical') || name.contains('bio')) {
      return const AdminDepartmentStyle(
        icon: Icons.settings_suggest_rounded,
        gradient: AppColors.purpleGradient,
        lightCardBg: AppColors.lightPurpleCard,
        darkCardBg: AppColors.darkPurpleCard,
      );
    } else if (name.contains('mep')) {
      return const AdminDepartmentStyle(
        icon: Icons.handyman_rounded,
        gradient: AppColors.orangeGradient,
        lightCardBg: AppColors.lightOrangeCard,
        darkCardBg: AppColors.darkOrangeCard,
      );
    } else if (name.contains('fire') || name.contains('safety')) {
      return const AdminDepartmentStyle(
        icon: Icons.local_fire_department_rounded,
        gradient: AppColors.redGradient,
        lightCardBg: AppColors.lightRedCard,
        darkCardBg: AppColors.darkRedCard,
      );
    } else if (name.contains('information') ||
        name.contains('technology') ||
        name.contains('it')) {
      return const AdminDepartmentStyle(
        icon: Icons.computer_rounded,
        gradient: AppColors.blueGradient,
        lightCardBg: AppColors.lightBlueCard,
        darkCardBg: AppColors.darkBlueCard,
      );
    } else if (name.contains('management') ||
        name.contains('mis') ||
        name.contains('system')) {
      return const AdminDepartmentStyle(
        icon: Icons.bar_chart_rounded,
        gradient: AppColors.greenGradient,
        lightCardBg: AppColors.lightGreenCard,
        darkCardBg: AppColors.darkGreenCard,
      );
    } else if (name.contains('dialysis') || name.contains('dyalisis')) {
      return const AdminDepartmentStyle(
        icon: Icons.water_drop_rounded,
        gradient: AppColors.pinkGradient,
        lightCardBg: AppColors.lightPinkCard,
        darkCardBg: AppColors.darkPinkCard,
      );
    } else if (name.contains('icu')) {
      return const AdminDepartmentStyle(
        icon: Icons.favorite_rounded,
        gradient: AppColors.pinkGradient,
        lightCardBg: AppColors.lightPinkCard,
        darkCardBg: AppColors.darkPinkCard,
      );
    } else if (name.contains('ward')) {
      return const AdminDepartmentStyle(
        icon: Icons.hotel_rounded,
        gradient: AppColors.greenGradient,
        lightCardBg: AppColors.lightGreenCard,
        darkCardBg: AppColors.darkGreenCard,
      );
    } else if (name.contains('cssd')) {
      return const AdminDepartmentStyle(
        icon: Icons.vaccines_rounded,
        gradient: AppColors.blueGradient,
        lightCardBg: AppColors.lightBlueCard,
        darkCardBg: AppColors.darkBlueCard,
      );
    }

    // Default Fallback
    return const AdminDepartmentStyle(
      icon: Icons.local_hospital_rounded,
      gradient: AppColors.blueGradient,
      lightCardBg: AppColors.lightBlueCard,
      darkCardBg: AppColors.darkBlueCard,
    );
  }
}

class AdminDepartmentCard extends StatelessWidget {
  final DepartmentEntity department;

  const AdminDepartmentCard({super.key, required this.department});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final style = AdminDepartmentStyle.getStyle(department.name);

    final cardBg = isDark ? style.darkCardBg : style.lightCardBg;
    final borderCol = isDark
        ? Colors.white.withValues(alpha: 0.03)
        : Colors.black.withValues(alpha: 0.02);

    return InkWell(
      onTap: () {
        final model = department is DepartmentModel
            ? department
            : DepartmentModel.fromEntity(department);
        context.push(RouteNames.departmentDetail, extra: model);
      },
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: borderCol, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.01),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 62.r,
              height: 62.r,
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                gradient: LinearGradient(
                  colors: style.gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: style.gradient.last.withValues(alpha: 0.25),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: CustomImageView(
                  imagePath: department.imageUrl ?? "",
                  color: Colors.white,
                  //width: 26.r,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            Expanded(
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  department.name,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textDarkNavy,
                    height: 1.1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
