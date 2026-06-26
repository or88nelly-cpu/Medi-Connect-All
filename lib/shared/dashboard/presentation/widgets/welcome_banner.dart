import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/constants/app_assets.dart';
import 'package:medi_connect/core/functions/profile_image_helper.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/common/dashboard_tab_cubit.dart';

import 'package:shimmer/shimmer.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final baseColor = isDark
              ? const Color(0xFF2C2C2C)
              : const Color(0xFFE5E7EB);
          final highlightColor = isDark
              ? const Color(0xFF3C3C3C)
              : const Color(0xFFF3F4F6);

          return Shimmer.fromColors(
            baseColor: baseColor,
            highlightColor: highlightColor,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20.r),
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80.w,
                          height: 12.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          width: 160.w,
                          height: 20.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Container(
                          width: 120.w,
                          height: 16.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Column(
                    children: [
                      Container(
                        width: 64.r,
                        height: 64.r,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Container(
                        width: 70.w,
                        height: 18.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }

        String name = "Administrator";
        String? profileImage;
        String accessLevel = "Super Admin";
        String? gender;

        if (state is Authenticated) {
          final user = state.user;
          name =
              user.name ??
              (user.firstName != null
                  ? "${user.firstName} ${user.lastName ?? ''}".trim()
                  : "Administrator");
          profileImage = user.profileImage;
          accessLevel =
              user.accessLevel ??
              (user.role == 'admin' ? "Super Admin" : user.role.toUpperCase());
          gender = user.gender;
        }

        final initials = name.isNotEmpty ? name[0].toUpperCase() : "A";

        if (profileImage == null && gender != null) {
          profileImage = gender == "Male"
              ? AppAssets.maleAdminAvatarPng
              : AppAssets.femaleAvatarPng;
        }

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.primary, AppColors.secondary],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha(38),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.welcomeUser,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textLight.withAlpha(179),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      name,
                      style: AppTextStyles.headingMedium.copyWith(
                        color: AppColors.textLight,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.textLight.withAlpha(61),
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        "Access Level: $accessLevel",
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textLight,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Column(
                children: [
                  Container(
                    width: 64.r,
                    height: 64.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.textLight.withAlpha(50),
                        width: 2,
                      ),
                    ),
                    child: CustomImageView(
                      imagePath: ProfileImageHelper.resolveImagePath(
                        profileImage,
                        state is Authenticated ? state.user.role : 'admin',
                        state is Authenticated ? state.user.gender : null,
                      ),
                      borderRadius: 32.r,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  InkWell(
                    onTap: () => context.read<DashboardTabCubit>().setTab(4),
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.textLight.withAlpha(30),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: AppColors.textLight.withAlpha(80),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.edit_outlined,
                            size: 12.r,
                            color: AppColors.textLight,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "Edit Profile",
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textLight,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
