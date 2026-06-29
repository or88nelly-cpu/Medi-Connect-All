import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/constants/app_enum.dart';
import 'package:medi_connect/core/functions/app_responsive.dart';
import 'package:medi_connect/core/routes/route_names.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/functions/validators.dart';
import 'package:medi_connect/core/widgets/textfields/text_fields.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';

class SignUpForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController? phoneController;
  final TextEditingController? usernameController;
  final TextEditingController passwordController;
  final TextEditingController? confirmPasswordController;
  final bool isAgreed;
  final ValueChanged<bool> onAgreedChanged;
  final VoidCallback onRegisterPressed;
  final UserRole selectedRole;

  const SignUpForm({
    super.key,
    required this.nameController,
    required this.emailController,
    this.phoneController,
    this.usernameController,
    required this.passwordController,
    this.confirmPasswordController,
    required this.isAgreed,
    required this.onAgreedChanged,
    required this.onRegisterPressed,
    required this.selectedRole,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _isPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // ── Role selection title ──
        SizedBox(height: 24.h),

        // ── Email field ──
        _buildTextField(
          controller: widget.emailController,
          label: 'Email Address',
          hint: 'Enter your email address',
          prefixIcon: Icons.mail_outline_rounded,
          validator: ValidationUtils.validateEmail,
        ),
        SizedBox(height: 14.h),

        // ── Phone Number field ──
        if (widget.phoneController != null) ...[
          _buildTextField(
            controller: widget.phoneController,
            label: 'Phone Number',
            hint: 'Enter your phone number',
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            validator: ValidationUtils.validatePhone,
          ),
          SizedBox(height: 14.h),
        ],

        // ── Password field ──
        _buildTextField(
          controller: widget.passwordController,
          label: 'Password',
          hint: 'Create a password',
          prefixIcon: Icons.lock_outline_rounded,
          isPassword: true,
          validator: ValidationUtils.validatePassword,
        ),
        SizedBox(height: 22.h),

        // ── Create Account Button ──
        _buildCreateAccountButton(),

        SizedBox(height: 24.h),

        // ── Login link ──
        _buildLoginLink(),
      ],
    );
  }

  // ──────────────────────────────────────────
  // ROLE SELECTOR
  // ──────────────────────────────────────────

  // TEXT FIELD
  // ──────────────────────────────────────────
  Widget _buildTextField({
    required TextEditingController? controller,
    required String label,
    required String hint,
    required IconData prefixIcon,
    bool isPassword = false,
    TextInputType? keyboardType,
    FormFieldValidator<String>? validator,
  }) {
    final borderColor = AppColors.border(context);
    bool isDesktop = AppResponsive.isDesktop(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextField(
          labelText: label,
          controller: controller,
          obscureText: isPassword && _isPasswordObscured,
          keyboardType: keyboardType ?? TextInputType.text,
          validator: validator,
          suffixIcon: isPassword
              ? GestureDetector(
                  onTap: () => setState(
                    () => _isPasswordObscured = !_isPasswordObscured,
                  ),
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
          prefixIcon: Padding(
            padding: EdgeInsets.only(
              left: isDesktop ? 14.w : 10.w,
              right: isDesktop ? 10.w : 6.w,
            ),
            child: Icon(
              prefixIcon,
              color: AppColors.textSecondary(context).withValues(alpha: 0.5),
              size: isDesktop ? 20.r : 18.r,
            ),
          ),
          prefixIconConstraints: BoxConstraints(minWidth: 44.w),
          suffixIconConstraints: isPassword
              ? BoxConstraints(minWidth: 44.w)
              : null,
        ),
        TextFormField(
          controller: controller,
          obscureText: isPassword && _isPasswordObscured,
          keyboardType: keyboardType,
          validator: validator,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary(context),
            fontSize: 14.sp,
          ),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary(context),
              fontSize: isDesktop ? 12.sp : 10.sp,
              fontWeight: FontWeight.w600,
            ),
            hintText: hint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary(context).withValues(alpha: 0.5),
              fontSize: isDesktop ? 13.sp : 11.5.sp,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            prefixIcon: Padding(
              padding: EdgeInsets.only(
                left: isDesktop ? 14.w : 10.w,
                right: isDesktop ? 10.w : 6.w,
              ),
              child: Icon(
                prefixIcon,
                color: AppColors.textSecondary(context).withValues(alpha: 0.5),
                size: isDesktop ? 20.r : 18.r,
              ),
            ),
            prefixIconConstraints: BoxConstraints(minWidth: 44.w),
            suffixIcon: isPassword
                ? GestureDetector(
                    onTap: () => setState(
                      () => _isPasswordObscured = !_isPasswordObscured,
                    ),
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
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
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
        ),
      ],
    );
  }

  // ──────────────────────────────────────────
  // CREATE ACCOUNT BUTTON
  // ──────────────────────────────────────────
  Widget _buildCreateAccountButton() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final isLoading = state is AuthLoading;
        return GestureDetector(
          onTap: isLoading ? null : widget.onRegisterPressed,
          child: Container(
            width: double.infinity,
            height: 52.h,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF4F6EFF), Color(0xFF7B61FF)],
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
                    'Create Account',
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

  // ──────────────────────────────────────────
  // LOGIN LINK
  // ──────────────────────────────────────────
  Widget _buildLoginLink() {
    return Center(
      child: GestureDetector(
        onTap: () => context.go(RouteNames.login),
        child: RichText(
          text: TextSpan(
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary(context),
              fontSize: 13.sp,
            ),
            children: [
              const TextSpan(text: 'Already have an account?  '),
              TextSpan(
                text: 'Login',
                style: TextStyle(
                  color: AppColors.primary,
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

class _RoleData {
  final String key;
  final String label;
  final String subtitle;
  final IconData icon;
  const _RoleData(this.key, this.label, this.subtitle, this.icon);
}
