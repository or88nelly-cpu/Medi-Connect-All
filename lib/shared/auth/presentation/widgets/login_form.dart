import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/functions/validators.dart';
import 'package:medi_connect/core/routes/route_names.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';

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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Title ──
        Text(
          'Login to your account',
          style: AppTextStyles.headingSmall.copyWith(
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary(context),
          ),
        ),
        SizedBox(height: 24.h),

        // ── Email / Mobile Field ──
        _buildTextField(
          controller: widget.email,
          hint: 'Email or Mobile Number',
          prefixIcon: Icons.mail_outline_rounded,
          validator: (val) =>
              ValidationUtils.validateRequired(val, 'This field is required'),
        ),
        SizedBox(height: 14.h),

        // ── Password Field ──
        _buildTextField(
          controller: widget.password,
          hint: 'Password',
          prefixIcon: Icons.lock_outline_rounded,
          isPassword: true,
          validator: ValidationUtils.validatePassword,
        ),
        SizedBox(height: 8.h),

        // ── Forgot Password ──
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () => context.push(RouteNames.forgotPassword),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Forgot Password?',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                fontSize: 12.sp,
              ),
            ),
          ),
        ),
        SizedBox(height: 20.h),

        // ── Login Button ──
        _buildLoginButton(),

        SizedBox(height: 24.h),

        // ── Sign Up Link ──
        _buildSignUpLink(),
      ],
    );
  }

  // ──────────────────────────────────────────
  // TEXT FIELD
  // ──────────────────────────────────────────
  Widget _buildTextField({
    required TextEditingController? controller,
    required String hint,
    required IconData prefixIcon,
    bool isPassword = false,
    FormFieldValidator<String>? validator,
  }) {
    final borderColor = AppColors.border(context);

    return TextFormField(
      controller: controller,
      obscureText: isPassword && _isPasswordObscured,
      validator: validator,
      style: AppTextStyles.bodyMedium.copyWith(
        color: AppColors.textPrimary(context),
        fontSize: 12.sp,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary(context).withValues(alpha: 0.6),
          fontSize: 12.sp,
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.only(left: 14.w, right: 10.w),
          child: Icon(
            prefixIcon,
            color: AppColors.textSecondary(context).withValues(alpha: 0.5),
            size: 20.r,
          ),
        ),
        prefixIconConstraints: BoxConstraints(minWidth: 44.w),
        suffixIcon: isPassword
            ? GestureDetector(
                onTap: () =>
                    setState(() => _isPasswordObscured = !_isPasswordObscured),
                child: Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: Icon(
                    _isPasswordObscured
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: AppColors.textSecondary(
                      context,
                    ).withValues(alpha: 0.5),
                    size: 20.r,
                  ),
                ),
              )
            : null,
        suffixIconConstraints: isPassword
            ? BoxConstraints(minWidth: 44.w)
            : null,
        filled: true,
        fillColor: AppColors.background(context),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: borderColor, width: 1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.primary, width: 1.5),
          borderRadius: BorderRadius.circular(12.r),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.error, width: 1),
          borderRadius: BorderRadius.circular(12.r),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.error, width: 1.5),
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────
  // LOGIN BUTTON
  // ──────────────────────────────────────────
  Widget _buildLoginButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return GestureDetector(
          onTap: isLoading ? null : widget.onLoginPressed,
          child: Container(
            width: double.infinity,
            height: 52.h,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4F6EFF), Color(0xFF3B5BFD)],
              ),
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            alignment: Alignment.center,
            child: isLoading
                ? SizedBox(
                    width: 22.r,
                    height: 22.r,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2.5,
                    ),
                  )
                : Text(
                    'Login',
                    style: AppTextStyles.buttonLarge.copyWith(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
          ),
        );
      },
    );
  }

  // SIGN UP LINK
  // ──────────────────────────────────────────
  Widget _buildSignUpLink() {
    return Center(
      child: GestureDetector(
        onTap: () => context.push(RouteNames.register),
        child: RichText(
          text: TextSpan(
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary(context),
              fontSize: 13.sp,
            ),
            children: [
              const TextSpan(text: "Don't have an account?  "),
              TextSpan(
                text: 'Sign Up',
                style: TextStyle(
                  color: AppColors.textPrimary(context),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
