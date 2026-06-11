import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/router/route_names.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/utils/validation_utils.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/auth/presentation/widgets/terminal_text_field.dart';

class LoginForm extends StatefulWidget {
  final TextEditingController? email;
  final TextEditingController? password;
  final VoidCallback onLoginPressed;

  const LoginForm({
    super.key,
    this.email,
    this.password,
    required this.onLoginPressed,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _isPasswordObscured = true;
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Theme-based colors from AppColors
    final cardBgColor = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final cardBorderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final textColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;
    final textfieldBgColor = isDark ? AppColors.terminalDarkFieldFill : AppColors.terminalLightFieldFill;
    final textfieldBorderColor = isDark ? AppColors.terminalDarkFieldBorder : AppColors.terminalLightFieldBorder;
    final textfieldHintColor = isDark ? AppColors.terminalDarkFieldHint : AppColors.terminalLightFieldHint;
    final checkboxTextColor = isDark ? AppColors.terminalDarkCheckboxText : AppColors.terminalLightCheckboxText;
    final footerTextColor = isDark ? AppColors.terminalDarkFooterText : AppColors.terminalLightFooterText;

    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: cardBorderColor,
          width: 1.0,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.authRequired,
            style: AppTextStyles.terminalBodyLarge.copyWith(
              color: textColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            height: 1.0,
            color: cardBorderColor,
          ),
          SizedBox(height: 24.h),

          // Terminal ID (Email)
          TerminalTextField(
            labelText: AppStrings.terminalIdLabel,
            controller: widget.email,
            hintText: AppStrings.terminalIdHint,
            labelColor: labelColor,
            textColor: textColor,
            bgColor: textfieldBgColor,
            borderColor: textfieldBorderColor,
            hintColor: textfieldHintColor,
            validator: (val) => ValidationUtils.validateRequired(
              val,
              AppStrings.requiredField,
            ),
          ),
          SizedBox(height: 16.h),

          // Access Key (Password)
          TerminalTextField(
            labelText: AppStrings.accessKeyLabel,
            prefixIcon: Icons.lock_outline,
            controller: widget.password,
            hintText: AppStrings.passwordHintDots,
            isPassword: true,
            isPasswordObscured: _isPasswordObscured,
            labelColor: labelColor,
            textColor: textColor,
            bgColor: textfieldBgColor,
            borderColor: textfieldBorderColor,
            hintColor: textfieldHintColor,
            onToggleVisibility: () {
              setState(() {
                _isPasswordObscured = !_isPasswordObscured;
              });
            },
            rightLabelWidget: GestureDetector(
              onTap: () => context.push(RouteNames.forgotPassword),
              child: Text(
                AppStrings.forgotLabel,
                style: AppTextStyles.terminalMonospaceLabel.copyWith(
                  color: labelColor,
                  fontSize: 11.sp,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            validator: ValidationUtils.validatePassword,
          ),
          SizedBox(height: 20.h),

          // Checkbox
          Row(
            children: [
              Theme(
                data: ThemeData(
                  unselectedWidgetColor: textfieldBorderColor,
                ),
                child: SizedBox(
                  width: 20.r,
                  height: 20.r,
                  child: Checkbox(
                    value: _rememberMe,
                    activeColor: AppColors.terminalAccentCyan,
                    checkColor: isDark ? AppColors.terminalDarkBg : Colors.white,
                    side: BorderSide(
                      color: textfieldBorderColor,
                      width: 1.5,
                    ),
                    onChanged: (val) {
                      setState(() {
                        _rememberMe = val ?? false;
                      });
                    },
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                AppStrings.persistentSession,
                style: AppTextStyles.terminalBodyMedium.copyWith(
                  color: checkboxTextColor,
                  fontSize: 13.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Button
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              final isLoading = state is AuthLoading;
              return InkWell(
                onTap: isLoading ? null : widget.onLoginPressed,
                borderRadius: BorderRadius.circular(6.r),
                child: Container(
                  width: double.infinity,
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: AppColors.terminalAccentCyan,
                    borderRadius: BorderRadius.circular(6.r),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.terminalAccentCyan.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: isLoading
                      ? SizedBox(
                          width: 20.r,
                          height: 20.r,
                          child: CircularProgressIndicator(
                            color: isDark ? AppColors.terminalDarkBg : Colors.white,
                            strokeWidth: 2.0,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.dns_outlined,
                              color: isDark ? AppColors.terminalDarkBg : Colors.white,
                              size: 20.r,
                            ),
                            SizedBox(width: 10.w),
                            Text(
                              AppStrings.initializeAccess,
                              style: AppTextStyles.labelMedium.copyWith(
                                color: isDark ? AppColors.terminalDarkBg : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp,
                              ),
                            ),
                          ],
                        ),
                ),
              );
            },
          ),
          SizedBox(height: 24.h),

          // Card Footer details
          Center(
            child: Text(
              AppStrings.terminalLocationNode,
              textAlign: TextAlign.center,
              style: AppTextStyles.terminalBodySmall.copyWith(
                color: footerTextColor,
                fontSize: 11.sp,
                height: 1.5,
                letterSpacing: 0.5,
              ),
            ),
          ),
          SizedBox(height: 16.h),

          // Register Option
          Container(
            height: 1.0,
            color: cardBorderColor,
          ),
          SizedBox(height: 16.h),
          Center(
            child: GestureDetector(
              onTap: () => context.push(RouteNames.register),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppTextStyles.terminalBodySmall.copyWith(
                    color: footerTextColor,
                    fontSize: 12.sp,
                  ),
                  children: const [
                    TextSpan(text: AppStrings.unregistered),
                    TextSpan(
                      text: AppStrings.requestAccessSignUp,
                      style: TextStyle(
                        color: AppColors.terminalAccentCyan,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
