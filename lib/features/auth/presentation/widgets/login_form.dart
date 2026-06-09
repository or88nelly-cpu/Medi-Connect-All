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
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/utils/validation_utils.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';


class LoginForm extends StatefulWidget {
  final TextEditingController? email;
  final TextEditingController? password;
  final VoidCallback onLoginPressed;

  LoginForm({
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
    return FormTab(
        tilte: AppStrings.adminLoginTitle,
        subTitle: AppStrings.adminLoginSubtitle,
        children: [
          AppTextField(
            controller: widget.email,
            labelText: AppStrings.username,
            hintText: AppStrings.enterUsername,
            prefixIcon: const Icon(Icons.email_outlined,
                color: AppColors.textSecondary),
            validator: (val) =>
                ValidationUtils.validateRequired(val, AppStrings.requiredField),
          ),
          SizedBox(height: 8.r),
          AppTextField(
            controller: widget.password,
            labelText: AppStrings.password,
            hintText: AppStrings.enterPassword,
            obscureText: _isPasswordObscured,
            prefixIcon:
                const Icon(Icons.lock_outline, color: AppColors.textSecondary),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordObscured
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.textSecondary,
              ),
              onPressed: () =>
                  setState(() => _isPasswordObscured = !_isPasswordObscured),
            ),
            validator: ValidationUtils.validatePassword,
          ),
          SizedBox(height: 8.r),
          Row(
            children: [
              Row(
                children: [
                  Checkbox(
                    value: _rememberMe,
                    activeColor: AppColors.primary,
                    onChanged: (val) =>
                        setState(() => _rememberMe = val ?? false),
                  ),
                  Text(
                    AppStrings.rememberMe,
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ),
              Spacer(),
              GestureDetector(
                onTap: () => context.push(RouteNames.forgotPassword),
                child: Text(
                  AppStrings.forgotPasswordQuestion,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.primary,
                    fontSize: 12.sp,
                    decoration: TextDecoration.underline,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 12.r,
          ),
          BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
            return GradientButton(
              isLoading: state is AuthLoading,
              text: AppStrings.login,
              onPressed: () =>
                  state is AuthLoading ? null : widget.onLoginPressed(),
            );
          })
        ]);
  }
}
