import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/dynamic_calender_3d.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/utils/constants/app_assets.dart';
import 'package:medi_connect/core/utils/profile_image_helper.dart';
import 'package:medi_connect/features/auth/domain/entities/user_entity.dart';

class DashboardHeader extends StatelessWidget {
  final UserEntity? user;
  const DashboardHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 14.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            gradient: LinearGradient(colors: AppColors.headerGradient(context)),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Row(
            children: [
              _hospitalInfo(),
              SizedBox(width: 16.w),

              Container(width: 1, height: 60.h, color: Colors.white12),

              SizedBox(width: 16.w),

              Expanded(child: _welcomeInfo()),

              _profileWidget(),

              SizedBox(width: 16.w),

              _dateCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileWidget() {
    return Stack(
      children: [
        CircleAvatar(
          radius: 50.r,
          backgroundColor: Colors.white,
          child: CustomImageView(
            borderRadius: 100.r,
            width: 90.r,
            height: 90.r,
            imagePath: ProfileImageHelper.resolveImagePath(
              user?.profileImage,
              user?.role ?? "admin",
              user?.gender,
            ),
          ),
        ),

        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: 20.r,
            height: 20.r,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary),
            ),
            child: Icon(Icons.edit, size: 14.r, color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _hospitalInfo() {
    return Row(
      children: [
        Container(
          width: 52.r,
          height: 52.r,
          padding: EdgeInsets.all(4.r),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: CustomImageView(imagePath: AppAssets.logoIconPng),
        ),

        SizedBox(width: 10.w),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "MediConnect",
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.surface,
                fontSize: 22.sp,
              ),
            ),

            Text(
              "Hospital",
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white70,
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _welcomeInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _greetingMessage(),
          style: AppTextStyles.bodyLarge.copyWith(
            color: Colors.white,
            fontSize: 11.sp,
          ),
        ),

        Text(
          "Super Admin 👋",
          style: AppTextStyles.headingLarge.copyWith(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
          ),
        ),

        SizedBox(height: 2.h),

        Text(
          "Welcome back to Hospital Management System",
          style: AppTextStyles.bodyMedium.copyWith(
            color: Colors.white70,
            fontSize: 11.sp,
          ),
        ),
      ],
    );
  }

  String _greetingMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  Widget _dateCard() {
    return SizedBox(
      width: 140.r,
      height: 140.r,
      child: Stack(
        children: [
          Positioned(
            child: Container(
              width: 110.r,
              height: 110.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple.withAlpha(38),
              ),
            ),
          ),

          Positioned(
            right: 0,
            top: 0,
            child: DynamicCalendar3D(date: DateTime.now(), size: 100.r),
          ),
        ],
      ),
    );
  }
}
