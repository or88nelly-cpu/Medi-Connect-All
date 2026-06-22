import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/modules/staff/patient/widgets/digital_id_card.dart';

class ReviewConfirmStep extends StatefulWidget {
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
  final VoidCallback onEditPressed;

  const ReviewConfirmStep({
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
    required this.onEditPressed,
  });

  @override
  State<ReviewConfirmStep> createState() => _ReviewConfirmStepState();
}

class _ReviewConfirmStepState extends State<ReviewConfirmStep> {
  bool _isFront = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = AppColors.card(context);
    final borderColor = AppColors.border(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top banner: Please review info
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isDark ? const Color(0xFF334155) : const Color(0xFFBFDBFE),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.shield_outlined, color: AppColors.primary, size: 20.r),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Please review your information",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary(context),
                        fontWeight: FontWeight.bold,
                        fontSize: 10.5.sp,
                      ),
                    ),
                    Text(
                      "Verify all details before generating your ID card.",
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary(context),
                        fontSize: 8.5.sp,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton.icon(
                onPressed: widget.onEditPressed,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                icon: Icon(Icons.edit, size: 12.r, color: AppColors.primary),
                label: Text(
                  "Edit Information",
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 9.sp,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20.h),

        // Digital ID Card Preview Area
        Center(
          child: Column(
            children: [
              Text(
                "Your Digital Patient ID Card",
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary(context),
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 12.h),

              // Side Toggle Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSideToggleButton("Front Side", _isFront, () => setState(() => _isFront = true), isDark),
                  SizedBox(width: 12.w),
                  _buildSideToggleButton("Back Side", !_isFront, () => setState(() => _isFront = false), isDark),
                ],
              ),
              SizedBox(height: 16.h),

              // ID Card Widget
              DigitalIdCard(
                firstName: widget.firstName,
                lastName: widget.lastName,
                dob: widget.dob,
                sex: widget.sex,
                bloodGroup: widget.bloodGroup,
                phone: widget.phone,
                uhid: widget.uhid,
                photoPath: widget.photoPath,
                address: widget.address,
                emergencyName: widget.emergencyName,
                emergencyRelationship: widget.emergencyRelationship,
                emergencyPhone: widget.emergencyPhone,
                isFront: _isFront,
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),

        // Review Information details list
        Text(
          "Review Information",
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: [
              _buildReviewRow("Name", "${widget.firstName} ${widget.lastName}", context),
              _buildReviewDivider(context),
              _buildReviewRow("UHID", widget.uhid.isNotEmpty ? widget.uhid : "Generating...", context),
              _buildReviewDivider(context),
              _buildReviewRow("Date of Birth", widget.dob, context),
              _buildReviewDivider(context),
              _buildReviewRow("Mobile Number", widget.phone, context),
              _buildReviewDivider(context),
              _buildReviewRow("Blood Group", widget.bloodGroup, context),
              _buildReviewDivider(context),
              _buildReviewRow("Place", widget.address, context),
            ],
          ),
        ),
        SizedBox(height: 24.h),

        // Registration Fee Details Box
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF131D33) : const Color(0xFFF8FAFD),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(10.r),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5E3BFF).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.receipt_long_outlined, color: const Color(0xFF5E3BFF), size: 20.r),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Registration Fee",
                        style: TextStyle(
                          color: AppColors.textPrimary(context),
                          fontWeight: FontWeight.bold,
                          fontSize: 11.sp,
                        ),
                      ),
                      Text(
                        "Inclusive of all taxes",
                        style: TextStyle(
                          color: AppColors.textSecondary(context),
                          fontSize: 8.5.sp,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                "₹50",
                style: TextStyle(
                  color: AppColors.textPrimary(context),
                  fontWeight: FontWeight.w900,
                  fontSize: 20.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSideToggleButton(String text, bool isSelected, VoidCallback onTap, bool isDark) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF5E3BFF)
              : isDark
                  ? const Color(0xFF1E293B)
                  : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : isDark
                    ? Colors.white60
                    : Colors.black54,
            fontWeight: FontWeight.bold,
            fontSize: 9.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildReviewRow(String label, String value, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary(context),
              fontSize: 10.sp,
            ),
          ),
          Text(
            value.isNotEmpty ? value : "Not Set",
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary(context),
              fontWeight: FontWeight.bold,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewDivider(BuildContext context) {
    return Divider(
      color: AppColors.border(context).withValues(alpha: 0.5),
      height: 12.h,
    );
  }
}
