import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/core/constants/app_assets.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_dimensions.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/features/authentication/presentation/bloc/auth_bloc.dart';

class BookingSelectPatientSection extends StatelessWidget {
  final bool isDark;
  final Color cardBg;
  final Color textColor;

  const BookingSelectPatientSection({
    super.key,
    required this.isDark,
    required this.cardBg,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Patient',
          style: TextStyle(
            fontSize: AppTextStyles.s14,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0F172A),
          ),
        ),
        SizedBox(height: AppDimensions.spaceS + 2), // 10

        // Patient Card
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            String patientName = 'Likhin Nelliyotan';
            String gender = 'Male';
            String? photo;
            if (authState is Authenticated) {
              patientName = authState.user.fullName;
              gender = authState.user.gender ?? 'Male';
              photo = authState.user.profilePhoto;
            }

            return Container(
              padding: EdgeInsets.all(AppDimensions.paddingM),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(AppDimensions.radiusL),
                border: Border.all(color: const Color(0xFF3B5BFD)),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CustomImageView(
                      imagePath: photo ?? "",
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorWidget: Image.asset(
                        gender == 'Male'
                            ? AppAssets.maleAvatarPng
                            : AppAssets.femaleAvatarPng,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: AppDimensions.spaceWM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patientName,
                          style: TextStyle(
                            fontSize: AppTextStyles.s12,
                            fontWeight: FontWeight.w900,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: AppDimensions.spaceXS),
                        Text(
                          '$gender • 31 Years • AB+',
                          style: TextStyle(
                            fontSize: AppTextStyles.s10 - 1, // 9
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.check_circle_rounded,
                    color: Color(0xFF3B5BFD),
                    size: 20,
                  ),
                ],
              ),
            );
          },
        ),

        SizedBox(height: AppDimensions.spaceS + 2), // 10

        // Dashed Add Another
        Container(
          width: double.infinity,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusM),
            border: Border.all(
              color: Colors.grey.shade400,
              style: BorderStyle.none,
            ),
          ),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              color: Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: AppColors.primary, size: 16),
                SizedBox(width: AppDimensions.spaceWXS),
                Text(
                  'Add Another Patient',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: AppTextStyles.s12 - 1, // 11
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
