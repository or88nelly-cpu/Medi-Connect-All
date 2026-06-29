import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/constants/app_enum.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/functions/profile_image_helper.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';

class DoctorHeroCard extends StatelessWidget {
  final UserModel user;
  const DoctorHeroCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark
        ? AppColors.terminalDarkCard
        : AppColors.terminalLightCard;
    final borderColor = isDark
        ? AppColors.terminalDarkBorder
        : AppColors.terminalLightBorder;
    final textColor = isDark
        ? AppColors.terminalDarkText
        : AppColors.terminalLightText;
    final labelColor = isDark
        ? AppColors.terminalDarkLabel
        : AppColors.terminalLightLabel;

    final imgPath = ProfileImageHelper.resolveImagePath(
      user.profilePhoto,
      user.role.value,
      user.gender,
    );

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;

          final profileSection = Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Doctor Image with Active status badge
              Stack(
                alignment: Alignment.bottomCenter,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 76.r,
                    height: 76.r,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        width: 2.r,
                      ),
                    ),
                    child: CustomImageView(
                      imagePath: imgPath,
                      borderRadius: 38.r,
                    ),
                  ),
                  Positioned(
                    bottom: -6.h,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF07271F)
                            : const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF0F9F58)
                              : const Color(0xFF81C784),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6.r,
                            height: 6.r,
                            decoration: const BoxDecoration(
                              color: Color(0xFF0F9F58),
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            user.status??"",
                            style: TextStyle(
                              color: const Color(0xFF0F9F58),
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
              SizedBox(width: 16.w),
              // Doctor Main Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            user.fullName  
                                ,
                            style: AppTextStyles.titleMedium.copyWith(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.verified,
                          color: AppColors.primary,
                          size: 16.sp,
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "Consultant Cardiologist",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        Icon(
                          Icons.local_hospital_outlined,
                          size: 12.sp,
                          color: labelColor,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                           "Cardiology Department",
                          style: TextStyle(color: labelColor, fontSize: 11.sp),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "EMP ID: DOC1001  •  Reg. No: CARD/2012/2456",
                      style: TextStyle(
                        color: labelColor.withValues(alpha: 0.8),
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );

          final contactSection = Padding(
            padding: EdgeInsets.only(top: isWide ? 0 : 16.h),
            child: Wrap(
              spacing: 16.w,
              runSpacing: 10.h,
              children: [
                _buildInfoTile(
                  context,
                  icon: Icons.email_outlined,
                  title: user.email ?? "",
                  isDark: isDark,
                  labelColor: labelColor,
                  textColor: textColor,
                ),
                _buildInfoTile(
                  context,
                  icon: Icons.phone_outlined,
                  title: user.phone ?? "+91 98765 43210",
                  isDark: isDark,
                  labelColor: labelColor,
                  textColor: textColor,
                ),
                _buildInfoTile(
                  context,
                  icon: Icons.calendar_today_outlined,
                  title: "Joined on 15 Jan 2018",
                  isDark: isDark,
                  labelColor: labelColor,
                  textColor: textColor,
                ),
                _buildInfoTile(
                  context,
                  icon: Icons.location_on_outlined,
                  title: "New Delhi, India",
                  isDark: isDark,
                  labelColor: labelColor,
                  textColor: textColor,
                ),
              ],
            ),
          );

          if (isWide) {
            return Row(
              children: [
                Expanded(flex: 3, child: profileSection),
                Container(
                  width: 1.w,
                  height: 60.h,
                  color: borderColor,
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                ),
                Expanded(flex: 3, child: contactSection),
              ],
            );
          } else {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                profileSection,
                SizedBox(height: 12.h),
                Divider(color: borderColor),
                contactSection,
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool isDark,
    required Color labelColor,
    required Color textColor,
  }) {
    return SizedBox(
      width: 190.w,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: labelColor),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: textColor, fontSize: 11.sp),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
