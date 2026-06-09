import 'package:medi_connect/core/common_widgets/buttons/gradient_button.dart';
import 'package:medi_connect/core/common_widgets/form_tab.dart';
import 'package:medi_connect/core/common_widgets/text_fields/text_fields.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/utils/validation_utils.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';

/// Available signup roles.
const _kRoles = [
  (
    label: AppStrings.roleAdmin,
    value: 'admin',
    icon: Icons.admin_panel_settings_outlined,
  ),
  (
    label: AppStrings.roleDoctor,
    value: 'doctor',
    icon: Icons.local_hospital_outlined,
  ),
  (label: AppStrings.roleStaff, value: 'staff', icon: Icons.badge_outlined),
  (label: AppStrings.rolePatient, value: 'patient', icon: Icons.person_outline),
];

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
  final String selectedRole;
  final ValueChanged<String> onRoleChanged;

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
    required this.selectedRole,
    required this.onRoleChanged,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  // Use ValueNotifier for purely local, widget-contained UI toggles (not page state).
  final _isPasswordObscured = ValueNotifier<bool>(true);
  final _isConfirmPasswordObscured = ValueNotifier<bool>(true);

  @override
  void dispose() {
    _isPasswordObscured.dispose();
    _isConfirmPasswordObscured.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormTab(
      tilte: AppStrings.createAccount,
      subTitle: AppStrings.registerSubtitle,
      children: [
        // ── Role Selector ──────────────────────────────────
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            AppStrings.selectRole,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: 13.sp,
            ),
          ),
        ),
        SizedBox(height: 8.h),
        _RoleSelector(
          selectedRole: widget.selectedRole,
          onRoleChanged: widget.onRoleChanged,
        ),
        SizedBox(height: 16.h),

        // ── Personal Info ──────────────────────────────────
        AppTextField(
          controller: widget.nameController,
          labelText: AppStrings.fullName,
          hintText: AppStrings.enterFullName,
          prefixIcon: const Icon(
            Icons.person_outline,
            color: AppColors.textSecondary,
          ),
          validator: (val) =>
              ValidationUtils.validateRequired(val, AppStrings.requiredField),
        ),
        SizedBox(height: 12.r),
        AppTextField(
          controller: widget.emailController,
          labelText: AppStrings.emailAddress,
          hintText: AppStrings.enterEmail,
          prefixIcon: const Icon(
            Icons.email_outlined,
            color: AppColors.textSecondary,
          ),
          validator: ValidationUtils.validateEmail,
        ),
        SizedBox(height: 12.r),
        AppTextField(
          controller: widget.phoneController,
          labelText: AppStrings.phoneNumber,
          hintText: AppStrings.enterPhone,
          keyboardType: TextInputType.phone,
          prefixIcon: const Icon(
            Icons.phone_outlined,
            color: AppColors.textSecondary,
          ),
          validator: ValidationUtils.validatePhone,
        ),
        SizedBox(height: 12.r),
        AppTextField(
          controller: widget.usernameController,
          labelText: AppStrings.adminUsername,
          hintText: AppStrings.chooseUsername,
          prefixIcon: const Icon(
            Icons.account_box_outlined,
            color: AppColors.textSecondary,
          ),
          validator: (val) =>
              ValidationUtils.validateRequired(val, AppStrings.requiredField),
        ),
        SizedBox(height: 12.r),

        // ── Password ───────────────────────────────────────
        ValueListenableBuilder<bool>(
          valueListenable: _isPasswordObscured,
          builder: (context, obscured, _) => AppTextField(
            controller: widget.passwordController,
            labelText: AppStrings.password,
            hintText: AppStrings.createPasswordLabel,
            obscureText: obscured,
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: AppColors.textSecondary,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscured
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.textSecondary,
              ),
              onPressed: () =>
                  _isPasswordObscured.value = !_isPasswordObscured.value,
            ),
            validator: ValidationUtils.validatePassword,
          ),
        ),
        SizedBox(height: 12.r),
        ValueListenableBuilder<bool>(
          valueListenable: _isConfirmPasswordObscured,
          builder: (context, obscured, _) => AppTextField(
            controller: widget.confirmPasswordController,
            labelText: AppStrings.confirmPasswordLabel,
            hintText: AppStrings.confirmPasswordHint,
            obscureText: obscured,
            prefixIcon: const Icon(
              Icons.lock_outline,
              color: AppColors.textSecondary,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                obscured
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: AppColors.textSecondary,
              ),
              onPressed: () => _isConfirmPasswordObscured.value =
                  !_isConfirmPasswordObscured.value,
            ),
            validator: (val) {
              if (val != widget.passwordController.text) {
                return AppStrings.passwordMismatch;
              }
              return null;
            },
          ),
        ),
        SizedBox(height: 12.r),

        // ── Terms ──────────────────────────────────────────
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
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    "${AppStrings.termsOfService} ",
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    AppStrings.agreeToTermsAnd,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    AppStrings.privacyPolicy,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 16.r),

        // ── Submit ─────────────────────────────────────────
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return GradientButton(
              isLoading: state is AuthLoading,
              text: AppStrings.createAccount,
              onPressed: () =>
                  state is AuthLoading ? null : widget.onRegisterPressed(),
            );
          },
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Role selector widget — stateless, driven by parent's selectedRole value.
// ---------------------------------------------------------------------------
class _RoleSelector extends StatelessWidget {
  final String selectedRole;
  final ValueChanged<String> onRoleChanged;

  const _RoleSelector({
    required this.selectedRole,
    required this.onRoleChanged,
  });

  Color _gradientStart(String role) {
    switch (role) {
      case 'admin':
        return AppColors.adminGradient[0];
      case 'doctor':
        return AppColors.doctorGradient[0];
      case 'staff':
        return AppColors.staffGradient[0];
      case 'patient':
        return AppColors.patientGradient[0];
      default:
        return AppColors.primary;
    }
  }

  Color _gradientEnd(String role) {
    switch (role) {
      case 'admin':
        return AppColors.adminGradient[1];
      case 'doctor':
        return AppColors.doctorGradient[1];
      case 'staff':
        return AppColors.staffGradient[1];
      case 'patient':
        return AppColors.patientGradient[1];
      default:
        return AppColors.secondary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _kRoles.map((role) {
        final isSelected = selectedRole == role.value;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: role.value != 'patient' ? 6.w : 0),
            child: GestureDetector(
              onTap: () => onRoleChanged(role.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(vertical: 10.h),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            _gradientStart(role.value),
                            _gradientEnd(role.value),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isSelected ? null : AppColors.background,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: isSelected ? Colors.transparent : AppColors.border,
                    width: 1.5,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: _gradientStart(role.value).withAlpha(60),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      role.icon,
                      size: 18.r,
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      role.label,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isSelected
                            ? Colors.white
                            : AppColors.textSecondary,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
