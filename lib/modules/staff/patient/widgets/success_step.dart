import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/modules/staff/patient/widgets/digital_id_card.dart';

class SuccessStep extends StatelessWidget {
  final String firstName;
  final String lastName;
  final String dob;
  final String sex;
  final String bloodGroup;
  final String phone;
  final String uhid;
  final String photoPath;
  final String address;
  final String emergencyName;
  final String emergencyRelationship;
  final String emergencyPhone;
  final VoidCallback onHomePressed;
  final VoidCallback onSharePressed;

  const SuccessStep({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.dob,
    required this.sex,
    required this.bloodGroup,
    required this.phone,
    required this.uhid,
    required this.photoPath,
    required this.address,
    required this.emergencyName,
    required this.emergencyRelationship,
    required this.emergencyPhone,
    required this.onHomePressed,
    required this.onSharePressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = AppColors.card(context);
    final borderColor = AppColors.border(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 10.h),

          // Green Success Tick Circle
          Container(
            width: 60.r,
            height: 60.r,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline_rounded,
              color: Colors.white,
              size: 34.r,
            ),
          ),
          SizedBox(height: 16.h),

          // Titles
          Text(
            "ID Card Generated",
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.textPrimary(context),
              fontWeight: FontWeight.w900,
              fontSize: 20.sp,
            ),
          ),
          Text(
            "Successfully!",
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.success,
              fontWeight: FontWeight.w900,
              fontSize: 20.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Text(
              "Your Digital Patient ID Card has been created and saved to your profile.",
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary(context),
                fontSize: 10.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 24.h),

          // ID Card preview
          DigitalIdCard(
            firstName: firstName,
            lastName: lastName,
            dob: dob,
            sex: sex,
            bloodGroup: bloodGroup,
            phone: phone,
            uhid: uhid,
            photoPath: photoPath,
            address: address,
            emergencyName: emergencyName,
            emergencyRelationship: emergencyRelationship,
            emergencyPhone: emergencyPhone,
            isFront: true,
          ),
          SizedBox(height: 24.h),

          // Registration details row (Fee + Payment success)
          Row(
            children: [
              Expanded(
                child: _buildDetailsCard(
                  context,
                  isDark,
                  icon: Icons.receipt_long_outlined,
                  iconColor: AppColors.primary,
                  title: "Registration Fee",
                  value: "₹50",
                  subValue: "Paid",
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildDetailsCard(
                  context,
                  isDark,
                  icon: Icons.check_circle_outline_rounded,
                  iconColor: AppColors.success,
                  title: "Payment Status",
                  value: "Success",
                  subValue: "Completed",
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // What's next section
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "What's Next?",
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
          ),
          SizedBox(height: 12.h),

          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              children: [
                _buildNextStepRow(
                  Icons.card_membership_outlined,
                  "Use your ID card for all hospital services",
                  context,
                ),
                _buildNextStepDivider(context),
                _buildNextStepRow(
                  Icons.storefront_outlined,
                  "Show this card at the reception during visit",
                  context,
                ),
                _buildNextStepDivider(context),
                _buildNextStepRow(
                  Icons.headset_mic_outlined,
                  "Contact us anytime for assistance",
                  context,
                ),
              ],
            ),
          ),
          SizedBox(height: 32.h),

          // Bottom Action Buttons
          ElevatedButton(
            onPressed: onHomePressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              minimumSize: Size(double.infinity, 48.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.home_outlined, color: Colors.white, size: 18.r),
                SizedBox(width: 8.w),
                Text(
                  "Go to Home",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          OutlinedButton(
            onPressed: onSharePressed,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary, width: 1.5),
              minimumSize: Size(double.infinity, 48.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.share_outlined,
                  color: AppColors.primary,
                  size: 16.r,
                ),
                SizedBox(width: 8.w),
                Text(
                  "Download / Share ID Card",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildDetailsCard(
    BuildContext context,
    bool isDark, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String subValue,
  }) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF131D33) : const Color(0xFFF8FAFD),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 16.r),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textSecondary(context),
                    fontSize: 8.sp,
                  ),
                ),
                Text(
                  value,
                  style: TextStyle(
                    color: AppColors.textPrimary(context),
                    fontWeight: FontWeight.bold,
                    fontSize: 11.sp,
                  ),
                ),
                Text(
                  subValue,
                  style: TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                    fontSize: 8.sp,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextStepRow(IconData icon, String text, BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 18.r),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary(context),
              fontSize: 10.sp,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNextStepDivider(BuildContext context) {
    return Divider(
      color: AppColors.border(context).withValues(alpha: 0.5),
      height: 16.h,
    );
  }
}
