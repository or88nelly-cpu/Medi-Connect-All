import 'package:flutter/material.dart';
import 'package:medi_connect/core/constants/app_assets.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_dimensions.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';

class DoctorDetailInfoCard extends StatelessWidget {
  final dynamic user;
  final dynamic doc;
  final int exp;
  final String specialityName;
  final Color cardBg;
  final Color textColor;

  const DoctorDetailInfoCard({
    super.key,
    required this.user,
    required this.doc,
    required this.exp,
    required this.specialityName,
    required this.cardBg,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXL + 4), // 20
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor Avatar
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(36),
                child: CustomImageView(
                  imagePath: user.profilePhoto ?? "",
                  width: 72,
                  height: 72,
                  fit: BoxFit.cover,
                  errorWidget: Image.asset(
                    user.gender == 'Male'
                        ? AppAssets.maleAvatarPng
                        : AppAssets.femaleAvatarPng,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: AppDimensions.spaceWXL - 6), // 14
          // Detail column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.fullName,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: AppTextStyles.s16 - 1, // 15
                        color: textColor,
                      ),
                    ),
                    SizedBox(width: AppDimensions.spaceWXS),
                    const Icon(
                      Icons.verified_rounded,
                      color: Color(0xFF3B5BFD),
                      size: 14,
                    ),
                  ],
                ),
                SizedBox(height: 3),
                Text(
                  doc?.qualification ?? 'Consultant Cardiologist',
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppDimensions.spaceS + 2), // 10
                // Badges row
                Wrap(
                  spacing: 6,
                  runSpacing: AppDimensions.spaceXS,
                  children: [
                    _buildBadge(
                      Icons.business_center_outlined,
                      '$exp+ Years Experience',
                    ),
                    _buildBadge(Icons.school_outlined, 'MBBS, MD, DM'),
                    _buildBadge(
                      Icons.star_rounded,
                      '4.9 (128 reviews)',
                      iconColor: const Color(0xFFFFB000),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: AppDimensions.spaceWS),

          // Right Category Card
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingS + 2, // 10
              vertical: AppDimensions.paddingM, // 12
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFECEF),
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
            ),
            child: Column(
              children: [
                const Icon(
                  Icons.favorite_rounded,
                  color: Color(0xFFFF296D),
                  size: 24,
                ),
                SizedBox(height: AppDimensions.spaceXS),
                Text(
                  specialityName,
                  style: const TextStyle(
                    color: Color(0xFFFF296D),
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label, {Color? iconColor}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: iconColor ?? Colors.grey.shade600),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 7.5,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class DoctorDetailStatsRow extends StatelessWidget {
  final bool isDark;

  const DoctorDetailStatsRow({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppDimensions.paddingM),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(AppDimensions.radiusL),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatBox(Icons.people_outline_rounded, '32+', 'Patients/Day'),
          _buildStatBox(Icons.calendar_today_outlined, '1200+', 'Appointments'),
          _buildStatBox(
            Icons.thumb_up_alt_outlined,
            '98%',
            'Patient Satisfaction',
          ),
          _buildStatBox(
            Icons.chat_bubble_outline_rounded,
            'Eng, Hin, Mal',
            'Languages',
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(IconData icon, String val, String title) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 18),
        SizedBox(height: AppDimensions.spaceXS),
        Text(
          val,
          style: const TextStyle(
            color: Color(0xFF1E3A8A),
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 7,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
