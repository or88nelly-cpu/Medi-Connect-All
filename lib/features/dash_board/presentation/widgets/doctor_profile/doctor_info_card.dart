import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';

class DoctorInfoCard extends StatelessWidget {
  final UserModel user;
  final VoidCallback? onEdit;

  const DoctorInfoCard({
    super.key,
    required this.user,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final borderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final textColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;

    // Derived values
    final dob = user.dateOfBirth ?? "12 Apr 1985";
    final ageStr = user.age != null ? " (${user.age} Y)" : " (39 Y)";
    final gender = user.gender ?? "Male";
    final bloodGroup = user.bloodGroup ?? "O+";
    final phone = user.phoneNumber ?? "+91 98765 43210";
    final address = user.address ?? "New Delhi, India";

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Edit
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Doctor Information",
                style: AppTextStyles.titleMedium.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
              TextButton(
                onPressed: onEdit,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  "Edit",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Info list
          _buildDetailRow(context, Icons.cake_outlined, "Date of Birth", "$dob$ageStr", labelColor, textColor),
          _buildDivider(borderColor),
          _buildDetailRow(context, Icons.person_outline, "Gender", gender, labelColor, textColor),
          _buildDivider(borderColor),
          _buildDetailRow(context, Icons.translate_outlined, "Languages", "English, Hindi", labelColor, textColor),
          _buildDivider(borderColor),
          _buildDetailRow(context, Icons.bloodtype_outlined, "Blood Group", bloodGroup, labelColor, textColor),
          _buildDivider(borderColor),
          _buildDetailRow(context, Icons.phone_outlined, "Contact", phone, labelColor, textColor),
          _buildDivider(borderColor),
          _buildDetailRow(context, Icons.email_outlined, "Email", user.email, labelColor, textColor),
          _buildDivider(borderColor),
          _buildDetailRow(context, Icons.location_on_outlined, "Address", address, labelColor, textColor),
          SizedBox(height: 16.h),
          // View More
          Center(
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Expanding Doctor Details...")),
                );
              },
              child: Text(
                "View More",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Divider(color: color, height: 1),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color labelColor,
    Color textColor,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          icon,
          size: 14.sp,
          color: labelColor,
        ),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: 12.sp,
          ),
        ),
        const Spacer(),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            maxLines: 2,
          ),
        ),
      ],
    );
  }
}
