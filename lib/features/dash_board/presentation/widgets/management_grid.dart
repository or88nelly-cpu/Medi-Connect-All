import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/utils/constants/app_assets.dart';

class ManagementGrid extends StatelessWidget {
  const ManagementGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 1,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.h,
      childAspectRatio: MediaQuery.of(context).size.width > 600 ? 2.5 : 3.5,
      children: const [
        _NavCard(
          title: AppStrings.doctorsDirectory,
          subtitle: AppStrings.doctorsDirectoryDesc,
          icon: AppAssets.femaleDoctorAvatarPng,
          route: '/admin/doctors',
        ),
        _NavCard(
          title: AppStrings.staffDirectory,
          subtitle: AppStrings.staffDirectoryDesc,
          icon: AppAssets.femaleStaffAvatarPng,
          route: '/admin/staff',
        ),
        _NavCard(
          title: AppStrings.patientsDirectory,
          subtitle: AppStrings.patientsDirectoryDesc,
          icon:AppAssets.femaleAvatarPng,
          route: '/admin/patients',
        ),
      ],
    );
  }
}

class _NavCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String icon;
  final String route;

  const _NavCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: () => context.push(route),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              CircleAvatar(
                radius: 28.r,
                backgroundColor: AppColors.primary.withAlpha(20),

                child: CustomImageView(imagePath: icon,),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold,fontSize: 14.sp),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 12.sp,height: 1),
                      maxLines: 2,

                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 14.r, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
