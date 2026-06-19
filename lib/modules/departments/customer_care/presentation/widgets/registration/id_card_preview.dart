import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class IdCardPreview extends StatelessWidget {
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
  final String selectedTab;
  final Function(String) onTabChanged;

  const IdCardPreview({
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
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF09121F) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF16253B)
        : const Color(0xFFD3E0EE);

    final String displayName =
        (firstName.trim().isEmpty && lastName.trim().isEmpty)
        ? "Ramesh Kumar"
        : "${firstName.trim()} ${lastName.trim()}";

    final String displayPhone = phone.trim().isEmpty
        ? "98765 43210"
        : phone.trim();
    final String displayDob = dob.trim().isEmpty ? "15/06/1990" : dob.trim();
    final String displaySex = sex;
    final String displayBlood = bloodGroup;
    final String displayAddress = address.trim().isEmpty
        ? "#45, MG Road, Bengaluru, Karnataka - 560001"
        : address.trim();

    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.badge_outlined, color: AppColors.primary, size: 22.r),
              SizedBox(width: 10.w),
              Text(
                "ID Card Preview",
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F2C59),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // Tabs
          Row(
            children: [
              _buildTabButton(
                "Front Side",
                selectedTab == 'front',
                () => onTabChanged('front'),
                isDark,
              ),
              SizedBox(width: 8.w),
              _buildTabButton(
                "Back Side",
                selectedTab == 'back',
                () => onTabChanged('back'),
                isDark,
              ),
            ],
          ),
          SizedBox(height: 20.h),

          // ID Card Content Container
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: selectedTab == 'front'
                ? _buildFrontSide(
                    context,
                    displayName,
                    displayDob,
                    displaySex,
                    displayBlood,
                    displayPhone,
                    isDark,
                  )
                : _buildBackSide(context, displayBlood, displayAddress, isDark),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(
    String text,
    bool isActive,
    VoidCallback onTap,
    bool isDark,
  ) {
    final bgActive = AppColors.primary;
    final bgInactive = isDark
        ? const Color(0xFF0D182A)
        : const Color(0xFFEDF2F7);
    final textActive = Colors.white;
    final textInactive = isDark
        ? const Color(0xFF5E98C7)
        : const Color(0xFF3F6D94);

    return Expanded(
      child: Container(
        height: 38.h,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r)),
        child: Material(
          color: isActive ? bgActive : bgInactive,
          borderRadius: BorderRadius.circular(8.r),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8.r),
            child: Center(
              child: Text(
                text,
                style: AppTextStyles.buttonMedium.copyWith(
                  color: isActive ? textActive : textInactive,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFrontSide(
    BuildContext context,
    String name,
    String dobVal,
    String sexVal,
    String bloodVal,
    String phoneVal,
    bool isDark,
  ) {
    return Container(
      key: const ValueKey('front_side'),
      height: 220.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF0F1E36), const Color(0xFF070F1C)]
              : [const Color(0xFFE2EAF8), const Color(0xFFC7D7F3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
            blurRadius: 15.r,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background decorative waves
          Positioned(
            bottom: -50.h,
            right: -50.w,
            child: Opacity(
              opacity: 0.1,
              child: Container(
                width: 180.w,
                height: 180.h,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header (Logo + City Care)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(4.r),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.local_hospital_rounded,
                            color: Colors.white,
                            size: 14.r,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "City Care",
                              style: AppTextStyles.titleMedium.copyWith(
                                color: isDark
                                    ? Colors.white
                                    : const Color(0xFF0F2C59),
                                fontWeight: FontWeight.bold,
                                height: 1.1,
                              ),
                            ),
                            Text(
                              "Multi Speciality Hospital",
                              style: AppTextStyles.bodyXSmall.copyWith(
                                color: isDark
                                    ? const Color(0xFF5E98C7)
                                    : const Color(0xFF3F6D94),
                                fontSize: 8.sp,
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
                          style: AppTextStyles.bodyXSmall.copyWith(
                            color: isDark
                                ? const Color(0xFF5E98C7)
                                : const Color(0xFF3F6D94),
                            fontSize: 7.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          uhid.isNotEmpty ? uhid : "CCH25-0001147",
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isDark
                                ? Colors.white
                                : const Color(0xFF0F2C59),
                            fontWeight: FontWeight.bold,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const Spacer(),

                // Patient Info Body
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Photo
                    CircleAvatar(
                      radius: 36.r,
                      backgroundColor: isDark ? Colors.white12 : Colors.black12,
                      child: ClipOval(
                        child: photoPath.isNotEmpty
                            ? (kIsWeb ||
                                      photoPath.startsWith('http') ||
                                      photoPath.startsWith('blob:')
                                  ? Image.network(
                                      photoPath,
                                      width: 72.r,
                                      height: 72.r,
                                      fit: BoxFit.cover,
                                      errorBuilder: (ctx, err, stack) =>
                                          Image.network(
                                            "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150",
                                            width: 72.r,
                                            height: 72.r,
                                            fit: BoxFit.cover,
                                          ),
                                    )
                                  : Image.file(
                                      File(photoPath),
                                      width: 72.r,
                                      height: 72.r,
                                      fit: BoxFit.cover,
                                      errorBuilder: (ctx, err, stack) =>
                                          Image.network(
                                            "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150",
                                            width: 72.r,
                                            height: 72.r,
                                            fit: BoxFit.cover,
                                          ),
                                    ))
                            : Image.network(
                                "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?auto=format&fit=crop&w=150",
                                width: 72.r,
                                height: 72.r,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                    SizedBox(width: 14.w),

                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: AppTextStyles.titleMedium.copyWith(
                              color: isDark
                                  ? Colors.white
                                  : const Color(0xFF0F2C59),
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            "$dobVal  |  $sexVal  |  $bloodVal",
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isDark
                                  ? const Color(0xFF8FA2B6)
                                  : const Color(0xFF4A5568),
                              fontSize: 10.sp,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Row(
                            children: [
                              Icon(
                                Icons.phone_android_rounded,
                                color: AppColors.primary,
                                size: 12.r,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                phoneVal,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF0F2C59),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // QR Code
                    Container(
                      width: 60.r,
                      height: 60.r,
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: CustomPaint(
                        painter: QrCodePainter(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                const Spacer(),

                // Slogan/Footer
                Center(
                  child: Text(
                    "Your Health, Our Priority",
                    style: AppTextStyles.bodyXSmall.copyWith(
                      color: isDark
                          ? const Color(0xFF5E98C7)
                          : const Color(0xFF3F6D94),
                      fontSize: 8.sp,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackSide(
    BuildContext context,
    String bloodVal,
    String addressVal,
    bool isDark,
  ) {
    final displayEmergency = (emergencyName.trim().isEmpty)
        ? "Sita Kumar"
        : emergencyName.trim();

    final displayRelation = emergencyRelationship;
    final displayEmergencyPhone = emergencyPhone.trim().isEmpty
        ? "+91 91234 56789"
        : emergencyPhone.trim();

    final cardTextTitleColor = isDark
        ? const Color(0xFF5E98C7)
        : const Color(0xFF3F6D94);
    final cardTextValueColor = isDark ? Colors.white : const Color(0xFF0C192E);

    return Container(
      key: const ValueKey('back_side'),
      height: 220.h,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.r),
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF0F1E36), const Color(0xFF070F1C)]
              : [const Color(0xFFE2EAF8), const Color(0xFFC7D7F3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
            blurRadius: 15.r,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // EMR back header
            Text(
              "ID Card Back Preview",
              style: AppTextStyles.bodySmall.copyWith(
                color: cardTextTitleColor,
                fontWeight: FontWeight.bold,
                fontSize: 10.sp,
              ),
            ),
            SizedBox(height: 12.h),

            // Content grids
            Expanded(
              child: Row(
                children: [
                  // Left col: Emergency & Address
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Emergency Contact",
                          style: AppTextStyles.bodyXSmall.copyWith(
                            color: cardTextTitleColor,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "$displayEmergency ($displayRelation)",
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: cardTextValueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.sp,
                          ),
                        ),
                        Text(
                          displayEmergencyPhone,
                          style: AppTextStyles.bodyXSmall.copyWith(
                            color: cardTextValueColor,
                            fontSize: 9.sp,
                          ),
                        ),
                        SizedBox(height: 10.h),

                        Text(
                          "Address",
                          style: AppTextStyles.bodyXSmall.copyWith(
                            color: cardTextTitleColor,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          addressVal,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.bodyXSmall.copyWith(
                            color: cardTextValueColor,
                            fontSize: 9.sp,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12.w),

                  // Right col: Blood group & Issued Date
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Blood Group",
                          style: AppTextStyles.bodyXSmall.copyWith(
                            color: cardTextTitleColor,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Row(
                          children: [
                            Icon(
                              Icons.bloodtype,
                              color: AppColors.error,
                              size: 12.r,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              bloodVal,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: cardTextValueColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),

                        Text(
                          "Issued On",
                          style: AppTextStyles.bodyXSmall.copyWith(
                            color: cardTextTitleColor,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          DateFormat('dd MMM yyyy').format(DateTime.now()),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: cardTextValueColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 10.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),

            // Back Disclaimer footer
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
              decoration: BoxDecoration(
                color: isDark ? Colors.black26 : Colors.white24,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Center(
                child: Text(
                  "In case of emergency, please contact your nearest hospital.",
                  style: AppTextStyles.bodyXSmall.copyWith(
                    color: isDark
                        ? const Color(0xFF94A3B8)
                        : const Color(0xFF4A5568),
                    fontSize: 8.sp,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Simulated QR code painter using CustomPainter
class QrCodePainter extends CustomPainter {
  final Color color;
  const QrCodePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Helper to draw a square
    void drawSquare(double x, double y, double w) {
      canvas.drawRect(Rect.fromLTWH(x, y, w, w), paint);
    }

    // Helper to draw alignment finder patterns (3 corners)
    void drawFinderPattern(double x, double y, double w) {
      final outer = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      final innerBg = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      final innerSquare = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      // Outer block
      canvas.drawRect(Rect.fromLTWH(x, y, w, w), outer);
      // Inner background
      final margin1 = w / 7;
      canvas.drawRect(
        Rect.fromLTWH(
          x + margin1,
          y + margin1,
          w - 2 * margin1,
          w - 2 * margin1,
        ),
        innerBg,
      );
      // Inner square
      final margin2 = w * 2 / 7;
      canvas.drawRect(
        Rect.fromLTWH(
          x + margin2,
          y + margin2,
          w - 2 * margin2,
          w - 2 * margin2,
        ),
        innerSquare,
      );
    }

    final w = size.width;
    final finderSize = w * 0.28;

    // 1. Top-Left Finder
    drawFinderPattern(0, 0, finderSize);

    // 2. Top-Right Finder
    drawFinderPattern(w - finderSize, 0, finderSize);

    // 3. Bottom-Left Finder
    drawFinderPattern(0, w - finderSize, finderSize);

    // 4. Random QR Blocks (Simulated with fixed seed)
    final rand = Random(42);
    final gridCount = 18;
    final cellSize = w / gridCount;

    for (int r = 0; r < gridCount; r++) {
      for (int c = 0; c < gridCount; c++) {
        // Skip finder areas
        final inTopLeft = r < 6 && c < 6;
        final inTopRight = r < 6 && c >= gridCount - 6;
        final inBottomLeft = r >= gridCount - 6 && c < 6;

        if (inTopLeft || inTopRight || inBottomLeft) continue;

        if (rand.nextBool()) {
          drawSquare(c * cellSize, r * cellSize, cellSize);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
