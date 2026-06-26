import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/modules/management/customer_care/presentation/widgets/qr_registration/qr_code_display.dart';
import 'package:medi_connect/modules/management/customer_care/presentation/widgets/qr_registration/registration_steps_timeline.dart';
import 'package:medi_connect/modules/management/customer_care/presentation/widgets/qr_registration/qr_action_buttons.dart';

class QrRegistrationPage extends StatefulWidget {
  const QrRegistrationPage({super.key});

  @override
  State<QrRegistrationPage> createState() => _QrRegistrationPageState();
}

class _QrRegistrationPageState extends State<QrRegistrationPage> {
  late String _currentRegistrationId;

  @override
  void initState() {
    super.initState();
    _generateNewId();
  }

  void _generateNewId() {
    final rand = Random();
    final num = rand.nextInt(900000) + 100000; // 6-digit number
    setState(() {
      _currentRegistrationId = "PAT-2026-$num";
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return CustomScaffold(
      appBarNeeded: true,
      customAppbar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: isDark ? Colors.white : const Color(0xFF1E293B),
            size: 20.r,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Customer Care",
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
                fontSize: 16.sp,
              ),
            ),
            Text(
              "Staff App",
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 11.sp,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16.w : 40.w,
          vertical: 20.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title & Header section
            Text(
              "Scan to Register",
              textAlign: TextAlign.center,
              style: AppTextStyles.headingMedium.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 26.sp,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              "Let patients easily register through our official Patient App",
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark ? Colors.white54 : Colors.grey[600],
                fontSize: 13.sp,
              ),
            ),
            SizedBox(height: 12.h),

            // Trusted Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shield_outlined,
                    color: const Color(0xFF10B981),
                    size: 14.r,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    "Secure  •  Fast  •  Trusted",
                    style: TextStyle(
                      color: const Color(0xFF10B981),
                      fontSize: 11.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),

            // QR Display Card
            QrCodeDisplay(registrationId: _currentRegistrationId),
            SizedBox(height: 24.h),

            // Share Actions
            QrActionButtons(
              registrationId: _currentRegistrationId,
              onGenerateNew: _generateNewId,
            ),
            SizedBox(height: 32.h),

            // Steps Info
            const RegistrationStepsTimeline(),
            SizedBox(height: 32.h),

            // Safety Notice footer
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.02)
                    : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: isDark ? Colors.white10 : const Color(0xFFDBEAFE),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.verified_user_outlined,
                    color: AppColors.primary,
                    size: 20.r,
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      "By scanning this QR code, patients will be redirected to the official app store. Your data is safe with us.",
                      style: AppTextStyles.bodyXSmall.copyWith(
                        color: isDark
                            ? Colors.white54
                            : const Color(0xFF1E3A8A),
                        fontSize: 10.sp,
                        height: 1.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),
          ],
        ),
      ),
    );
  }
}
