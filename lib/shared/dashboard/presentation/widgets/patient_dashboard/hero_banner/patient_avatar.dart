import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/functions/profile_image_helper.dart';

class PatientAvatar extends StatelessWidget {
  final String? profileImage;
  final String? gender;

  const PatientAvatar({
    super.key,
    required this.profileImage,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70.r,
      height: 70.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(
              alpha: 0.12,
            ),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipOval(
        child: CustomImageView(
          imagePath: ProfileImageHelper.resolveImagePath(
            profileImage,
            'patient',
            gender,
          ),
          borderRadius: 35.r,
        ),
      ),
    );
  }
}
