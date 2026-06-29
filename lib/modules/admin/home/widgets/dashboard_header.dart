import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/constants/app_enum.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/constants/app_assets.dart';
import 'package:medi_connect/core/functions/profile_image_helper.dart';
import 'package:medi_connect/shared/auth/domain/entities/user_entity.dart';

class DashboardHeader extends StatelessWidget {
  final UserEntity? user;

  const DashboardHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final bool showFullHeader = width > 1100;
        final bool showMediumHeader = width > 750;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InkWell(
              onTap: () => Scaffold.of(context).openDrawer(),
              borderRadius: BorderRadius.circular(16.r),
              child: Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.04)
                      : AppColors.primary.withValues(alpha: 0.08),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.12)
                        : AppColors.primary.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(
                  Icons.menu_outlined,
                  size: 28.r,
                  color: isDark ? Colors.white : AppColors.primary,
                ),
              ),
            ),
            SizedBox(width: width > 800 ? 18.w : 10.w),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(22.r),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.w,
                      vertical: 16.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22.r),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: AppColors.headerGradient(context),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(
                            alpha: isDark ? 0.15 : 0.25,
                          ),
                          blurRadius: 24,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        if (showFullHeader) ...[
                          _hospitalInfo(),
                          SizedBox(width: 24.w),
                          Container(
                            width: 1.2,
                            height: 60.h,
                            color: Colors.white24,
                          ),
                          SizedBox(width: 24.w),
                        ],
                        Expanded(child: _welcomeInfo(context, width)),
                        if (showMediumHeader) ...[
                          _dateCard(),
                          SizedBox(width: 18.w),
                        ],
                        if (showFullHeader) ...[
                          _dateInfo(),
                          SizedBox(width: 20.w),
                        ],
                        _profileWidget(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _hospitalInfo() {
    return Row(
      children: [
        Container(
          width: 58.r,
          height: 58.r,
          padding: EdgeInsets.all(5.r),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)],
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
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              "Multi Speciality Hospital",
              style: AppTextStyles.bodyMedium.copyWith(
                color: const Color(0xFFE8E8FF),
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _welcomeInfo(BuildContext context, double width) {
    final isSmall = width < 600;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _greetingMessage(),
          style: AppTextStyles.bodyLarge.copyWith(
            color: const Color(0xFFF4F4FF).withValues(alpha: 0.85),
            fontSize: isSmall ? 13.sp : 15.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          "Super Admin 👋",
          style: AppTextStyles.headingLarge.copyWith(
            color: Colors.white,
            fontSize: isSmall ? 22.sp : 28.sp,
            fontWeight: FontWeight.w700,
            height: 1.05,
          ),
        ),
        if (!isSmall) ...[
          SizedBox(height: 4.h),
          Text(
            AppStrings.welcomeHms,
            style: AppTextStyles.bodyMedium.copyWith(
              color: const Color(0xFFE0DFFF).withValues(alpha: 0.9),
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ],
    );
  }

  Widget _dateCard() {
    final now = DateTime.now();
    final month = DateFormat('MMM').format(now).toUpperCase();
    final day = now.day.toString();

    return Container(
      width: 76.r,
      height: 82.r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
          width: 1.2,
        ),
        color: Colors.white.withValues(alpha: 0.12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            month,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 2.h),
          Container(
            width: 44.r,
            height: 1,
            color: Colors.white.withValues(alpha: 0.15),
          ),
          SizedBox(height: 2.h),
          Text(
            day,
            style: TextStyle(
              color: Colors.white,
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
              height: 1.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dateInfo() {
    final now = DateTime.now();
    final dateStr = DateFormat('dd MMMM yyyy').format(now);
    final dayStr = DateFormat('EEEE').format(now);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          dateStr,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          dayStr,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 13.sp,
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
          width: 82.r,
          height: 82.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.8),
              width: 2.5,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(1.r),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100.r),
              child: CustomImageView(
                width: 78.r,
                height: 78.r,
                imagePath: ProfileImageHelper.resolveImagePath(
                  user?.profilePhoto,
                  user?.role.value ?? "",
                  user?.gender,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 2.h,
          right: -2.w,
          child: Container(
            width: 28.r,
            height: 28.r,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
            ),
            child: Icon(
              Icons.edit_rounded,
              size: 15.r,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  String _greetingMessage() {
    final hour = DateTime.now().hour;

    if (hour < 12) {
      return "Good Morning,";
    } else if (hour < 17) {
      return "Good Afternoon,";
    } else {
      return "Good Evening,";
    }
  }
}
