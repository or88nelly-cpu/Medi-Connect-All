import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class RegistrationStepsTimeline extends StatelessWidget {
  const RegistrationStepsTimeline({super.key});

  static const List<Map<String, String>> _steps = [
    {
      "step": "1",
      "title": "Scan QR Code",
      "desc": "Scan this QR code using your phone camera",
      "icon": "qr_code_scanner_rounded",
    },
    {
      "step": "2",
      "title": "Get Our App",
      "desc": "You will be redirected to Play Store / App Store",
      "icon": "play_arrow_rounded",
    },
    {
      "step": "3",
      "title": "Install Patient App",
      "desc": "Download and install our official Patient App",
      "icon": "download_rounded",
    },
    {
      "step": "4",
      "title": "Open & Register",
      "desc": "Open the app. Your registration ID will be auto applied",
      "icon": "person_outline_rounded",
    },
    {
      "step": "5",
      "title": "Complete Registration",
      "desc": "Fill your details and complete registration",
      "icon": "verified_rounded",
    },
  ];

  IconData _getIcon(String name) {
    switch (name) {
      case 'qr_code_scanner_rounded':
        return Icons.qr_code_scanner_rounded;
      case 'play_arrow_rounded':
        return Icons.play_arrow_rounded;
      case 'download_rounded':
        return Icons.download_rounded;
      case 'person_outline_rounded':
        return Icons.person_outline_rounded;
      case 'verified_rounded':
      default:
        return Icons.verified_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "How it works for patients",
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF1E293B),
            ),
          ),
          SizedBox(height: 20.h),
          isMobile
              ? Column(
                  children: List.generate(_steps.length, (idx) {
                    return _buildVerticalStep(context, idx, isDark);
                  }),
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(_steps.length, (idx) {
                    return Expanded(
                      child: _buildHorizontalStep(context, idx, isDark),
                    );
                  }),
                ),
        ],
      ),
    );
  }

  Widget _buildHorizontalStep(BuildContext context, int idx, bool isDark) {
    final step = _steps[idx];
    final isLast = idx == _steps.length - 1;
    final dotColor = AppColors.primary;
    final connectorColor = isDark ? Colors.white10 : Colors.grey[200]!;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 1,
                color: idx == 0 ? Colors.transparent : connectorColor,
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 50.r,
                  height: 50.r,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF1E293B)
                        : const Color(0xFFEEF2F6),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark
                          ? Colors.white10
                          : Colors.black.withValues(alpha: 0.05),
                    ),
                  ),
                  child: Icon(
                    _getIcon(step['icon']!),
                    size: 20.r,
                    color: AppColors.primary,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4.r),
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      step['step']!,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                height: 1,
                color: isLast ? Colors.transparent : connectorColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          child: Column(
            children: [
              Text(
                step['title']!,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 12.sp,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                step['desc']!,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodyXSmall.copyWith(
                  color: isDark ? Colors.white38 : Colors.grey[500],
                  fontSize: 10.sp,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalStep(BuildContext context, int idx, bool isDark) {
    final step = _steps[idx];
    final isLast = idx == _steps.length - 1;
    final connectorColor = isDark ? Colors.white10 : Colors.grey[200]!;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 44.r,
                    height: 44.r,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFEEF2F6),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getIcon(step['icon']!),
                      size: 18.r,
                      color: AppColors.primary,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        step['step']!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (!isLast)
                Expanded(
                  child: Container(width: 2.w, color: connectorColor),
                ),
            ],
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.h, top: 4.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step['title']!,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 13.sp,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    step['desc']!,
                    style: AppTextStyles.bodyXSmall.copyWith(
                      color: isDark ? Colors.white38 : Colors.grey[500],
                      fontSize: 11.sp,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
