/// Custom reusable button widgets complying with design systems.
/// Implements: PrimaryButton, SecondaryButton, OutlinedButton, IconButton, LoadingButton.
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';


/// Primary filled button.
class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          elevation: 0,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 24.h,
                width: 24.w,
                child: CircularProgressIndicator(
                  color: AppColors.textLight,
                  strokeWidth: 2.w,
                ),
              )
            : Text(
                text,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textLight,
                  fontSize: 16.sp,
                ),
              ),
      ),
    );
  }
}

/// Secondary filled button.
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;

  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: AppColors.textLight,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          elevation: 0,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SizedBox(
                height: 24.h,
                width: 24.w,
                child: CircularProgressIndicator(
                  color: AppColors.textLight,
                  strokeWidth: 2.w,
                ),
              )
            : Text(
                text,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.textLight,
                  fontSize: 16.sp,
                ),
              ),
      ),
    );
  }
}

/// Outlined action button.
class AppOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;

  const AppOutlinedButton({
    super.key,
    required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: AppColors.primary, width: 1.5.w),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.primary,
            fontSize: 16.sp,
          ),
        ),
      ),
    );
  }
}

/// Standard circular icon button.
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, size: 24.r),
      color: color ?? AppColors.primary,
      onPressed: onPressed,
    );
  }
}

/// Reusable loading state button.
class LoadingButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final VoidCallback? onPressed;

  const LoadingButton({
    super.key,
    required this.text,
    required this.isLoading,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return PrimaryButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
    );
  }
}
