import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/modules/management/customer_care/presentation/widgets/registration/id_card_preview.dart'
    show QrCodePainter;

class DigitalIdCard extends StatelessWidget {
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
  final bool isFront;

  const DigitalIdCard({
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
    required this.isFront,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final String displayName =
        (firstName.trim().isEmpty && lastName.trim().isEmpty)
        ? "Priya Sharma"
        : "${firstName.trim()} ${lastName.trim()}";

    final String displayPhone = phone.trim().isEmpty
        ? "+91 98765 43210"
        : phone.trim();
    final String displayDob = dob.trim().isEmpty ? "15 May 1998" : dob.trim();
    final String displaySex = sex;
    final String displayBlood = bloodGroup.trim().isEmpty ? "B+" : bloodGroup;
    final String displayAddress = address.trim().isEmpty
        ? "Indiranagar, Bangalore"
        : address.trim();

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isFront
          ? _buildFrontSide(
              context,
              displayName,
              displayDob,
              displaySex,
              displayBlood,
              displayPhone,
              displayAddress,
              isDark,
            )
          : _buildBackSide(context, isDark),
    );
  }

  Widget _buildFrontSide(
    BuildContext context,
    String name,
    String dobVal,
    String sexVal,
    String bloodVal,
    String phoneVal,
    String placeVal,
    bool isDark,
  ) {
    final cardBg = isDark ? const Color(0xFF131B2A) : Colors.white;
    final textThemeColor = isDark
        ? Colors.white
        : AppColors.textPrimary(context);

    return Container(
      key: const ValueKey('digital_card_front'),
      width: 320.w,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
            blurRadius: 20.r,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: isDark ? const Color(0xFF1E2D4A) : AppColors.border(context),
          width: 1.5.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Hospital Icon (heart with white cross)
                    Container(
                      width: 28.r,
                      height: 28.r,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add_box_rounded,
                        color: Colors.white,
                        size: 16.r,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "MediCare",
                          style: TextStyle(
                            color: textThemeColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 13.sp,
                            height: 1.0,
                          ),
                        ),
                        Text(
                          "HOSPITAL",
                          style: TextStyle(
                            color: isDark
                                ? const Color(0xFF8FA2B6)
                                : AppColors.textSecondary(context),
                            fontWeight: FontWeight.bold,
                            fontSize: 7.sp,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "UHID",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 8.sp,

                      ),
                    ),
                    Text(
                      uhid.isNotEmpty ? uhid : "MC-2024-000123",
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 9.sp,
                        
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Main Row: Image, Name, QR
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar via CustomImageView
                Container(
                  width: 68.r,
                  height: 68.r,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white10
                        : AppColors.lightCardSecondary,
                    shape: BoxShape.circle,
                  ),
                  child: CustomImageView(
                    imagePath: photoPath.isNotEmpty
                        ? photoPath
                        : "https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?auto=format&fit=crop&w=150",
                    width: 68.r,
                    height: 68.r,
                    borderRadius: 34.r,
                    fit: BoxFit.cover,
                    errorWidget: Icon(
                      Icons.person,
                      size: 34.r,
                      color: Colors.grey,
                    ),
                  ),
                ),
                SizedBox(width: 12.w),

                // Name & UHID Chip
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          color: textThemeColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          uhid.isNotEmpty ? uhid : "MC-2024-000123",
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

                // QR Code
                Container(
                  width: 54.r,
                  height: 54.r,
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: AppColors.border(context),
                      width: 1.w,
                    ),
                  ),
                  child: CustomPaint(
                    painter: QrCodePainter(color: Colors.black),
                  ),
                ),
              ],
            ),
          ),

          // Detail Grid
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        Icons.calendar_today_outlined,
                        "Date of Birth",
                        dobVal,
                        isDark,
                         context: context
                      ),
                    ),
                    Expanded(
                      child: _buildInfoItem(
                        Icons.bloodtype_outlined,
                        "Blood Group",
                        bloodVal,
                        isDark,
                        iconColor: AppColors.error,
                         context: context
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        Icons.phone_outlined,
                        "Mobile Number",
                        phoneVal,
                        isDark,
                         context: context
                      ),
                    ),
                    Expanded(
                      child: _buildInfoItem(
                        Icons.location_on_outlined,
                        "Place",
                       
                        placeVal,
                        isDark,
                         context: context
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Footer emergency contact banner
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 8.h),
            padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(18.r),
                bottomRight: Radius.circular(18.r),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.phone_in_talk_rounded,
                  color: Colors.white,
                  size: 14.r,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    emergencyName.isNotEmpty
                        ? "Emergency Contact: $emergencyName ($emergencyRelationship) - $emergencyPhone"
                        : "Emergency Contact: Rajesh Sharma (Father) - +91 98765 43211",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8.5.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackSide(BuildContext context, bool isDark) {
    final cardBg = isDark ? const Color(0xFF0F1E36) : AppColors.primary;
    final valueColor = isDark ? Colors.white : AppColors.textPrimary(context);

    return Container(
      key: const ValueKey('digital_card_back'),
      width: 320.w,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.08),
            blurRadius: 20.r,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(
          color: isDark ? const Color(0xFF1E2D4A) : AppColors.primary,
          width: 1.5.w,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24.r,
                height: 24.r,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.primary : Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add_box_rounded,
                  color: isDark ? Colors.white : AppColors.primary,
                  size: 14.r,
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                "MediCare Hospital Instructions",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Instructions list
          Text(
            "IMPORTANT INSTRUCTIONS",
            style: TextStyle(
              color: isDark ? const Color(0xFF8FA2B6) : Colors.white70,
              fontWeight: FontWeight.w800,
              fontSize: 8.5.sp,
              letterSpacing: 0.8,
            ),
          ),
          SizedBox(height: 4.h),
          _buildInstructionRow("1. This card is non-transferable."),
          _buildInstructionRow(
            "2. Please carry this card during every hospital visit.",
          ),
          _buildInstructionRow(
            "3. Show this card at the reception for faster service.",
          ),
          _buildInstructionRow(
            "4. In case of loss, please inform the hospital immediately.",
          ),
          SizedBox(height: 12.h),

          // Emergency contact card
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A263B) : AppColors.lightRedCard,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.r),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.primary : const Color(0xFFFFEAEA),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.phone_in_talk_rounded,
                    color: isDark ? Colors.white : Colors.redAccent,
                    size: 14.r,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "EMERGENCY CONTACT",
                        style: TextStyle(
                          color: isDark
                              ? const Color(0xFF5E98C7)
                              : Colors.red.shade800,
                          fontWeight: FontWeight.bold,
                          fontSize: 7.sp,
                        ),
                      ),
                      Text(
                        emergencyName.isNotEmpty
                            ? "$emergencyName ($emergencyRelationship)"
                            : "Rajesh Sharma (Father)",
                        style: TextStyle(
                          color: isDark ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 9.sp,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        emergencyPhone.isNotEmpty
                            ? emergencyPhone
                            : "+91 98765 43211",
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.black54,
                          fontSize: 8.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.h),

          // Footer info
          Center(
            child: Text(
              "This card is system generated and valid for all hospital services.",
              style: TextStyle(
                color: isDark ? const Color(0xFF8FA2B6) : Colors.white70,
                fontSize: 7.sp,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInstructionRow(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Text(
        text,
        style: TextStyle(color: Colors.white, fontSize: 8.5.sp, height: 1.2),
      ),
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String label,
    String value,
    bool isDark, {
    Color? iconColor,
    required BuildContext context,
  }) {
    final titleStyle = TextStyle(
      color: isDark
          ? const Color(0xFF8FA2B6)
          : AppColors.textSecondary(context),
      fontSize: 8.sp,
    );
    final valueStyle = TextStyle(
      color: isDark ? Colors.white : AppColors.textPrimary(context),
      fontWeight: FontWeight.bold,
      fontSize: 9.sp,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: iconColor ?? AppColors.primary, size: 12.r),
        SizedBox(width: 6.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: titleStyle),
              Text(value, style: valueStyle, overflow: TextOverflow.ellipsis),
            ],
          ),
        ),
      ],
    );
  }
}
