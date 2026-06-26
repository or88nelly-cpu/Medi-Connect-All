/// Custom reusable input text fields complying with design systems.
/// Implements: AppTextField, PasswordField, SearchField, PhoneField, OtpField.
library;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

/// Standard custom text input field.
class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final bool obscureText;

  const AppTextField({
    super.key,
    this.controller,
    required this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      readOnly: readOnly,
      onTap: onTap,
      obscureText: obscureText,
      style: AppTextStyles.bodyLarge.copyWith(
        color: isDark
            ? AppColors.terminalDarkText
            : AppColors.terminalLightText,
      ),
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: isDark
            ? AppColors.terminalDarkFieldFill
            : AppColors.terminalLightFieldFill,
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        labelStyle: AppTextStyles.bodyMedium.copyWith(
          color: isDark
              ? AppColors.terminalDarkLabel
              : AppColors.terminalLightLabel,
        ),
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: isDark
              ? AppColors.terminalDarkFieldHint
              : AppColors.terminalLightFieldHint,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isDark
                ? AppColors.terminalDarkFieldBorder
                : AppColors.terminalLightFieldBorder,
            width: 1.w,
          ),
          borderRadius: BorderRadius.circular(8.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 1.5.w),
          borderRadius: BorderRadius.circular(8.r),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.error, width: 1.w),
          borderRadius: BorderRadius.circular(8.r),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.error, width: 1.5.w),
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
    );
  }
}

/// Password input field with visibility toggling.
class PasswordField extends StatefulWidget {
  final TextEditingController? controller;
  final String labelText;
  final String? hintText;
  final FormFieldValidator<String>? validator;

  const PasswordField({
    super.key,
    this.controller,
    required this.labelText,
    this.hintText,
    this.validator,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: widget.controller,
      labelText: widget.labelText,
      hintText: widget.hintText,
      keyboardType: TextInputType.visiblePassword,
      validator: widget.validator,
      obscureText: _obscureText,
      prefixIcon: Icon(
        Icons.lock_outline,
        size: 24.r,
        color: AppColors.textSecondary(context),
      ),
      suffixIcon: IconButton(
        icon: Icon(
          _obscureText
              ? Icons.visibility_off_outlined
              : Icons.visibility_outlined,
          size: 24.r,
          color: AppColors.textSecondary(context),
        ),
        onPressed: () {
          setState(() {
            _obscureText = !_obscureText;
          });
        },
      ),
    );
  }
}

/// Specialized Search text field.
class SearchField extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final ValueChanged<String>? onChanged;

  const SearchField({
    super.key,
    this.controller,
    required this.hintText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      labelText: hintText,
      hintText: hintText,
      prefixIcon: Icon(
        Icons.search,
        size: 24.r,
        color: AppColors.textSecondary(context),
      ),
      suffixIcon: controller?.text.isNotEmpty == true
          ? IconButton(
              icon: Icon(
                Icons.clear,
                size: 24.r,
                color: AppColors.textSecondary(context),
              ),
              onPressed: () => controller?.clear(),
            )
          : null,
      onTap: () {},
    );
  }
}

/// Phone number input field.
class PhoneField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final FormFieldValidator<String>? validator;

  const PhoneField({
    super.key,
    this.controller,
    required this.labelText,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      controller: controller,
      labelText: labelText,
      hintText: "Enter phone number",
      keyboardType: TextInputType.phone,
      validator: validator,
      prefixIcon: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
        child: Text(
          "+1",
          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

/// OTP digit boxes field.
class OtpField extends StatelessWidget {
  final List<TextEditingController> controllers;
  final int length;

  const OtpField({super.key, required this.controllers, this.length = 6})
    : assert(controllers.length == length);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        length,
        (index) => SizedBox(
          width: 45.w,
          height: 55.h,
          child: TextFormField(
            controller: controllers[index],
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            style: AppTextStyles.headingMedium.copyWith(
              fontSize: 20.sp,
              color: isDark
                  ? AppColors.terminalDarkText
                  : AppColors.terminalLightText,
            ),
            maxLength: 1,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              counterText: "",
              filled: true,
              fillColor: isDark
                  ? AppColors.terminalDarkFieldFill
                  : AppColors.terminalLightFieldFill,
              contentPadding: EdgeInsets.zero,
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: isDark
                      ? AppColors.terminalDarkFieldBorder
                      : AppColors.terminalLightFieldBorder,
                  width: 1.w,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary, width: 1.5.w),
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            onChanged: (value) {
              if (value.isNotEmpty && index < length - 1) {
                FocusScope.of(context).nextFocus();
              } else if (value.isEmpty && index > 0) {
                FocusScope.of(context).previousFocus();
              }
            },
          ),
        ),
      ),
    );
  }
}
