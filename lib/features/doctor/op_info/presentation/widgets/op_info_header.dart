import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/functions/profile_image_helper.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/features/authentication/domain/entities/user_entity.dart';

class OpInfoHeader extends StatelessWidget {
  final UserEntity doctor;
  final VoidCallback onSearchTap;
  final VoidCallback onNotificationsTap;

  const OpInfoHeader({
    super.key,
    required this.doctor,
    required this.onSearchTap,
    required this.onNotificationsTap,
  });

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return AppStrings.goodMorning;
    if (hour < 17) return AppStrings.goodAfternoon;
    return AppStrings.goodEvening;
  }

  String _displayName() {
    if (doctor.fullName.startsWith(
      RegExp(r'^(dr\.|dr|Dr\.|Dr)\s+', caseSensitive: false),
    )) {
      return doctor.fullName;
    }
    return 'Dr. ${doctor.fullName}';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 0),
      child: Row(
        children: [
          Expanded(
            child: RichText(
              text: TextSpan(
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
                children: [
                  TextSpan(text: '${_greeting()}, '),
                  TextSpan(
                    text: _displayName(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const TextSpan(text: ' 👋'),
                ],
              ),
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.search_rounded,
              size: 22.r,
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
            onPressed: onSearchTap,
          ),
          Stack(
            children: [
              IconButton(
                icon: Icon(
                  Icons.notifications_none_rounded,
                  size: 22.r,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
                onPressed: onNotificationsTap,
              ),
              Positioned(
                top: 10.h,
                right: 10.w,
                child: Container(
                  padding: EdgeInsets.all(3.r),
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '3',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textLight,
                      fontSize: 8.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: 32.r,
            height: 32.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.lightBorder),
            ),
            child: ClipOval(
              child: CustomImageView(
                imagePath: ProfileImageHelper.resolveImagePath(
                  doctor.profilePhoto,
                  'doctor',
                  doctor.gender,
                ),
                width: 32.r,
                height: 32.r,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
