import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class CommonOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? borderColor;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? borderRadius;
  final TextStyle? textStyle;

  const CommonOutlineButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.borderColor,
    this.textColor,
    this.width,
    this.height,
    this.borderRadius,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = borderColor ?? AppColors.primary;
    final effectiveTextColor = textColor ?? AppColors.primary;

    final isButtonEnabled = onPressed != null && !isLoading;

    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 52.h,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isButtonEnabled ? effectiveBorderColor : AppColors.border((context)),
            width: 1.5.w,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 12.r),
          ),
          foregroundColor: effectiveTextColor,
          disabledForegroundColor: AppColors.textSecondary(context),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
        ),
        onPressed: isButtonEnabled ? onPressed : null,
        child: isLoading
            ? SizedBox(
                height: 24.h,
                width: 24.w,
                child: CircularProgressIndicator(
                  color: effectiveTextColor,
                  strokeWidth: 2.w,
                ),
              )
            : Text(
                text,
                style:
                    textStyle ??
                    AppTextStyles.labelMedium.copyWith(
                      fontSize: AppTextStyles.s16,
                      color: isButtonEnabled
                          ? effectiveTextColor
                          : AppColors.textSecondary(context),
                    ),
              ),
      ),
    );
  }
}
