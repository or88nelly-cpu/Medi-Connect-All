import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/utils/constants/app_assets.dart';
import 'package:medi_connect/core/utils/profile_image_helper.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';

class PatientWelcomeBanner extends StatelessWidget {
  const PatientWelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String name = 'Patient';
        String? profileImage;
        String? gender;

        if (state is Authenticated) {
          final user = state.user;
          name =
              user.name ??
              (user.firstName != null
                  ? '${user.firstName} ${user.lastName ?? ''}'.trim()
                  : 'Patient');
          profileImage = user.profileImage;
          gender = user.gender;
        }

        if (profileImage == null && gender != null) {
          profileImage = gender == 'Male'
              ? AppAssets.maleAvatarPng
              : AppAssets.femaleAvatarPng;
        }

        return Container(
          width: double.infinity,
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: AppColors.patientGradient,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.15),
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
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      name,
                      style: AppTextStyles.headingMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      child: Text(
                        'Patient Portal',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Container(
                width: 64.r,
                height: 64.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white30, width: 2),
                ),
                child: CustomImageView(
                  imagePath: ProfileImageHelper.resolveImagePath(
                    profileImage,
                    'patient',
                    state is Authenticated ? state.user.gender : null,
                  ),
                  borderRadius: 32.r,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
