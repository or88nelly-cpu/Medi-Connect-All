import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class TerminalTextField extends StatelessWidget {
  final String labelText;
  final TextEditingController? controller;
  final String hintText;
  final Color labelColor;
  final Color textColor;
  final Color bgColor;
  final Color borderColor;
  final Color hintColor;
  final IconData? prefixIcon;
  final bool isPassword;
  final bool isPasswordObscured;
  final VoidCallback? onToggleVisibility;
  final Widget? rightLabelWidget;
  final FormFieldValidator<String>? validator;

  const TerminalTextField({
    super.key,
    required this.labelText,
    required this.controller,
    required this.hintText,
    required this.labelColor,
    required this.textColor,
    required this.bgColor,
    required this.borderColor,
    required this.hintColor,
    this.prefixIcon,
    this.isPassword = false,
    this.isPasswordObscured = false,
    this.onToggleVisibility,
    this.rightLabelWidget,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (prefixIcon != null) ...[
                  Icon(prefixIcon, color: labelColor, size: 12.r),
                  SizedBox(width: 4.w),
                ],
                Text(
                  labelText,
                  style: AppTextStyles.terminalMonospaceLabel.copyWith(
                    color: labelColor,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
            ?rightLabelWidget,
          ],
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          obscureText: isPassword && isPasswordObscured,
          validator: validator,
          style: AppTextStyles.terminalBodyMedium.copyWith(
            color: textColor,
            fontSize: 14.sp,
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTextStyles.terminalBodyMedium.copyWith(
              color: hintColor,
              fontSize: 14.sp,
            ),
            filled: true,
            fillColor: bgColor,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 14.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor, width: 1.0),
              borderRadius: BorderRadius.circular(6.r),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.terminalAccentCyan,
                width: 1.2,
              ),
              borderRadius: BorderRadius.circular(6.r),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.0),
              borderRadius: BorderRadius.circular(6.r),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
              borderRadius: BorderRadius.circular(6.r),
            ),
            suffixIcon: isPassword
                ? GestureDetector(
                    onTap: onToggleVisibility,
                    child: Icon(
                      isPasswordObscured
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: hintColor,
                      size: 20.r,
                    ),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}
