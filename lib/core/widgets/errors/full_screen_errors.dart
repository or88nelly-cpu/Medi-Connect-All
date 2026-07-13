import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';

class FullScreenErrorPage extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onRetry;
  final String buttonText;

  const FullScreenErrorPage({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.onRetry,
    this.buttonText = 'Retry',
  });

  factory FullScreenErrorPage.noInternet({VoidCallback? onRetry}) {
    return FullScreenErrorPage(
      title: 'No Internet Connection',
      description: 'Please check your network settings and try again.',
      icon: Icons.wifi_off_rounded,
      onRetry: onRetry,
      buttonText: 'Try Again',
    );
  }

  factory FullScreenErrorPage.serverError({VoidCallback? onRetry}) {
    return FullScreenErrorPage(
      title: 'Server Unavailable',
      description:
          'We are experiencing technical difficulties. Please try again later.',
      icon: Icons.cloud_off_rounded,
      onRetry: onRetry,
    );
  }

  factory FullScreenErrorPage.maintenance({VoidCallback? onRetry}) {
    return FullScreenErrorPage(
      title: 'Under Maintenance',
      description:
          'We are currently upgrading our systems to serve you better. We will be back shortly.',
      icon: Icons.build_circle_outlined,
      onRetry: onRetry,
      buttonText: 'Refresh',
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.r),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spacer(),
              Icon(
                icon,
                size: 80.r,
                color: isDark
                    ? AppColors.statusCancelledTextDark
                    : AppColors.statusCancelledTextLight,
              ),
              SizedBox(height: 32.h),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  height: 1.5,
                ),
              ),
              Spacer(),
              if (onRetry != null)
                ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
