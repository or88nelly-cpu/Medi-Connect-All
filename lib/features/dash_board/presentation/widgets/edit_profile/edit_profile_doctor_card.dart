import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';

class EditProfileDoctorCard extends StatefulWidget {
  final UserModel user;

  const EditProfileDoctorCard({super.key, required this.user});

  @override
  State<EditProfileDoctorCard> createState() => _EditProfileDoctorCardState();
}

class _EditProfileDoctorCardState extends State<EditProfileDoctorCard> {
  void _simulatePhotoUpload() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profile photo updated successfully!")),
    );
  }

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

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          // Avatar with camera icon overlay
          Stack(
            children: [
              CircleAvatar(
                radius: 40.r,
                backgroundColor: isDark
                    ? AppColors.terminalDarkBorder
                    : Colors.grey.shade200,
                backgroundImage: widget.user.profileImage != null
                    ? NetworkImage(widget.user.profileImage!)
                    : null,
                child: widget.user.profileImage == null
                    ? Icon(Icons.person, size: 40.r, color: labelColor)
                    : null,
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _simulatePhotoUpload,
                  child: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 14.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 16.w),
          // Metadata
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.user.name ?? "Doctor Name",
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.sp,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F9F58).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20.r),
                        border: Border.all(
                          color: const Color(0xFF0F9F58),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        widget.user.availabilityStatus ?? "Active",
                        style: TextStyle(
                          color: const Color(0xFF0F9F58),
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  widget.user.specialization ?? "General Physician",
                  style: TextStyle(color: labelColor, fontSize: 11.sp),
                ),
                SizedBox(height: 2.h),
                Text(
                  widget.user.department ?? "Cardiology",
                  style: TextStyle(color: labelColor, fontSize: 11.sp),
                ),
                SizedBox(height: 6.h),
                Text(
                  "Emp ID: ${widget.user.employeeId ?? 'EMP-2026-9812'}",
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 10.sp,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
