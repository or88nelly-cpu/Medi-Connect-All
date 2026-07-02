import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class CommonButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutline;
  final bool isGradient;
  final double? width;
  final double? height;
  final double? borderRadius;
  final Color? color;
  final Color? textColor;
  final Widget? icon;
  final Widget? child;
  final EdgeInsetsGeometry? padding;

  const CommonButton({
    super.key,
    this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutline = false,
    this.isGradient = false,
    this.width,
    this.height,
    this.borderRadius,
    this.color,
    this.textColor,
    this.icon,
    this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = color ?? AppColors.primary;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final resolvedBorderRadius = BorderRadius.circular(borderRadius ?? 12.r);
    final resolvedHeight = height ?? 50.h;
    
    if (isOutline) {
      return SizedBox(
        width: width ?? double.infinity,
        height: resolvedHeight,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: themeColor, width: 1.5),
            shape: RoundedRectangleBorder(borderRadius: resolvedBorderRadius),
            padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
          ),
          child: _buildContent(context, themeColor),
        ),
      );
    }

    if (isGradient && onPressed != null) {
      final gradientColors = [
        themeColor,
        themeColor.withValues(alpha: 0.8),
      ];

      return Container(
        width: width ?? double.infinity,
        height: resolvedHeight,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: resolvedBorderRadius,
          boxShadow: [
            BoxShadow(
              color: themeColor.withValues(alpha: 0.3),
              blurRadius: 8.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: resolvedBorderRadius,
            child: Center(
              child: _buildContent(context, Colors.white),
            ),
          ),
        ),
      );
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: resolvedHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: themeColor,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: resolvedBorderRadius),
          padding: padding ?? EdgeInsets.symmetric(horizontal: 16.w),
        ),
        child: _buildContent(context, textColor ?? Colors.white),
      ),
    );
  }

  Widget _buildContent(BuildContext context, Color contentColor) {
    if (isLoading) {
      return SizedBox(
        width: 20.r,
        height: 20.r,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(contentColor),
        ),
      );
    }

    if (child != null) {
      return child!;
    }

    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon!,
          SizedBox(width: 8.w),
          Text(
            text ?? '',
            style: AppTextStyles.bodyMedium.copyWith(
              color: contentColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
    }

    return Text(
      text ?? '',
      style: AppTextStyles.bodyMedium.copyWith(
        color: contentColor,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
