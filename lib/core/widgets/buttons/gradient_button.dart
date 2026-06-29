import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class GradientButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final List<Color>? gradientColors;
  final double? width;
  final double? height;
  final double? borderRadius;
  final TextStyle? textStyle;

  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.gradientColors,
    this.width,
    this.height,
    this.borderRadius,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveColors =
        gradientColors ?? [AppColors.primary, AppColors.secondary];

    final isButtonEnabled = onPressed != null && !isLoading;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 52.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: isButtonEnabled
              ? LinearGradient(
                  colors: effectiveColors,
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                )
              : null,
          color: isButtonEnabled ? null : AppColors.border(context),
          borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
          boxShadow: isButtonEnabled
              ? [
                  BoxShadow(
                    color: effectiveColors.first.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            foregroundColor: AppColors.textPrimary(context),
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
            ),
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
          ),
          onPressed: isButtonEnabled ? onPressed : null,
          child: isLoading
              ? SizedBox(
                  height: 24.h,
                  width: 24.w,
                  child: CircularProgressIndicator(
                    color: AppColors.textPrimary(context),
                    strokeWidth: 2.w,
                  ),
                )
              : Text(
                  text,
                  style:
                      textStyle ??
                      AppTextStyles.labelMedium.copyWith(
                        color: AppColors.textPrimary(context),
                        fontSize: AppTextStyles.s16,
                      ),
                ),
        ),
      ),
    );
  }
}
