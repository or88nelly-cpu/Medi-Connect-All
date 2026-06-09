import 'package:medi_connect/core/common_widgets/buttons/gradient_button.dart';
import 'package:medi_connect/core/common_widgets/form_tab.dart';
import 'package:medi_connect/core/common_widgets/text_fields/text_fields.dart';
import 'package:medi_connect/core/router/route_names.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/utils/validation_utils.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';


class SignUpForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final bool isAgreed;
  final ValueChanged<bool> onAgreedChanged;
  final VoidCallback onRegisterPressed;

  const SignUpForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.usernameController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isAgreed,
    required this.onAgreedChanged,
    required this.onRegisterPressed,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  bool _isPasswordObscured = true;
  bool _isConfirmPasswordObscured = true;

  @override
  Widget build(BuildContext context) {
    return FormTab(
      tilte: AppStrings.adminSignUpTitle,
      subTitle: AppStrings.adminSignUpSubtitle,
      children: [
        AppTextField(
          controller: widget.nameController,
          labelText: AppStrings.fullName,
          hintText: AppStrings.enterFullName,
          prefixIcon: const Icon(Icons.person_outline, color: AppColors.textSecondary),
          validator: (val) => ValidationUtils.validateRequired(val, AppStrings.requiredField),
        ),
        SizedBox(height: 12.r),
        AppTextField(
          controller: widget.emailController,
          labelText: AppStrings.emailAddress,
          hintText: AppStrings.enterEmail,
          prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary),
          validator: ValidationUtils.validateEmail,
        ),
        SizedBox(height: 12.r),
        AppTextField(
          controller: widget.phoneController,
          labelText: AppStrings.phoneNumber,
          hintText: AppStrings.enterPhone,
          keyboardType: TextInputType.phone,
          prefixIcon: const Icon(Icons.phone_outlined, color: AppColors.textSecondary),
          validator: ValidationUtils.validatePhone,
        ),
        SizedBox(height: 12.r),
        AppTextField(
          controller: widget.usernameController,
          labelText: AppStrings.adminUsername,
          hintText: AppStrings.chooseUsername,
          prefixIcon: const Icon(Icons.account_box_outlined, color: AppColors.textSecondary),
          validator: (val) => ValidationUtils.validateRequired(val, AppStrings.requiredField),
        ),
        SizedBox(height: 12.r),
        AppTextField(
          controller: widget.passwordController,
          labelText: AppStrings.password,
          hintText: AppStrings.createPasswordLabel,
          obscureText: _isPasswordObscured,
          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
          suffixIcon: IconButton(
            icon: Icon(
              _isPasswordObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: AppColors.textSecondary,
            ),
            onPressed: () => setState(() => _isPasswordObscured = !_isPasswordObscured),
          ),
          validator: ValidationUtils.validatePassword,
        ),
        SizedBox(height: 12.r),
        AppTextField(
          controller: widget.confirmPasswordController,
          labelText: AppStrings.confirmPasswordLabel,
          hintText: AppStrings.confirmPasswordHint,
          obscureText: _isConfirmPasswordObscured,
          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
          suffixIcon: IconButton(
            icon: Icon(
              _isConfirmPasswordObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
              color: AppColors.textSecondary,
            ),
            onPressed: () => setState(() => _isConfirmPasswordObscured = !_isConfirmPasswordObscured),
          ),
          validator: (val) {
            if (val != widget.passwordController.text) {
              return AppStrings.passwordMismatch;
            }
            return null;
          },
        ),
        SizedBox(height: 12.r),
        Row(
          children: [
            Checkbox(
              value: widget.isAgreed,
              activeColor: AppColors.primary,
              onChanged: (val) => widget.onAgreedChanged(val ?? false),
            ),
            Expanded(
              child: Wrap(
                children: [
                  Text(
                    AppStrings.agreeToTermsPrefix,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  Text(
                    "${AppStrings.termsOfService} ",
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    AppStrings.agreeToTermsAnd,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                  ),
                  Text(
                    AppStrings.privacyPolicy,
                    style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.r),
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return GradientButton(
              isLoading: state is AuthLoading,
              text: AppStrings.createAccount,
              onPressed: () => state is AuthLoading ? null : widget.onRegisterPressed(),
            );
          },
        ),
      ],
    );
  }
}
