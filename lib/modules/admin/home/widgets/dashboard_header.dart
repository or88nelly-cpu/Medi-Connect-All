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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          radius: 100.r,
          onTap: () => Scaffold.of(context).openDrawer(),
          child: Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: AppColors.adminPrimary.withValues(alpha: 0.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 12,
                  offset: Offset(0, 6),
                ),
              ],
              borderRadius: BorderRadius.circular(100.r),
            ),
            child: Icon(Icons.menu_outlined, size: 32.r, color: Colors.white),
          ),
        ),
        ClipRRect(
          borderRadius: BorderRadius.circular(22.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              height: 136.h,
              width: 1408.w,
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22.r),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF2028D5), Color(0xFF6116E9)],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x332028D5),
                    blurRadius: 30,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Row(
                children: [
                  _hospitalInfo(),

                  SizedBox(width: 28.w),

                  Container(width: 1.2, height: 82.h, color: Colors.white24),

                  SizedBox(width: 28.w),

                  Expanded(child: _welcomeInfo()),

                  _dateCard(),

                  SizedBox(width: 20.w),

                  _dateInfo(),

                  SizedBox(width: 24.w),

                  _profileWidget(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _hospitalInfo() {
    return Row(
      children: [
        Container(
          width: 62.r,
          height: 62.r,
          padding: EdgeInsets.all(5.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 12)],
          ),
          child: CustomImageView(imagePath: AppAssets.logoIconPng),
        ),

        SizedBox(width: 14.w),

        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "MediConnect",
              style: AppTextStyles.bodyLarge.copyWith(
                color: Colors.white,
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),

            SizedBox(height: 4.h),

            Text(
              "Multi Speciality Hospital",
              style: AppTextStyles.bodyMedium.copyWith(
                color: const Color(0xFFE8E8FF),
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _welcomeInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _greetingMessage(),
          style: AppTextStyles.bodyLarge.copyWith(
            color: const Color(0xFFF4F4FF),
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),

        Text(
          "Super Admin 👋",
          style: AppTextStyles.headingLarge.copyWith(
            color: Colors.white,
            fontSize: 28.sp,
            fontWeight: FontWeight.w700,
            height: 1.05,
          ),
        ),

        Text(
          "Welcome back to Hospital Management System",
          style: AppTextStyles.bodyMedium.copyWith(
            color: const Color(0xFFE0DFFF),
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _dateCard() {
    return SizedBox(
      width: 130.r,
      height: 130.r,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 110.r,
            height: 110.r,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0x33FFFFFF),
            ),
          ),

          DynamicCalendar3D(date: DateTime.now(), size: 120.r),
        ],
      ),
    );
  }

  Widget _dateInfo() {
    final now = DateTime.now();

    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    const days = [
      '',
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "${now.day} ${months[now.month]} ${now.year}",
          style: TextStyle(
            color: Colors.white,
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
          ),
        ),

        Text(
          days[now.weekday],
          style: TextStyle(
            color: Colors.white70,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _profileWidget() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 92.r,
          height: 92.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(color: Colors.white.withOpacity(0.8), width: 3),
          ),
          child: Padding(
            padding: EdgeInsets.all(2.r),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.r),
              child: CustomImageView(
                width: 88.r,
                height: 88.r,
                imagePath: ProfileImageHelper.resolveImagePath(
                  user?.profileImage,
                  user?.role ?? "admin",
                  user?.gender,
                ),
              ),
            ),
          ),
        ),

        Positioned(
          bottom: 6.h,
          right: -2.w,
          child: Container(
            width: 34.r,
            height: 34.r,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: Icon(
              Icons.edit_rounded,
              size: 18.r,
              color: Color(0xFF2028D5),
            ),
          ),
        ),
      ],
    );
  }

  String _greetingMessage() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    } else {
      return "Good Evening";
    }
  }
}
