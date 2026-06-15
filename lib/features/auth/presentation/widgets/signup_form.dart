import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/utils/validation_utils.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/auth/presentation/widgets/terminal_text_field.dart';

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
  final String selectedRole;
  final ValueChanged<String> onRoleChanged;

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
    required this.onRoleChanged,
  });

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _isPasswordObscured = ValueNotifier<bool>(true);

  @override
  void dispose() {
    _isPasswordObscured.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Theme-based colors from AppColors
    final textColor = isDark
        ? AppColors.terminalDarkText
        : AppColors.terminalLightText;
    final labelColor = isDark
        ? AppColors.terminalDarkLabel
        : AppColors.terminalLightLabel;
    final textfieldBgColor = isDark
        ? AppColors.terminalDarkFieldFill
        : AppColors.terminalLightFieldFill;
    final textfieldBorderColor = isDark
        ? AppColors.terminalDarkFieldBorder
        : AppColors.terminalLightFieldBorder;
    final textfieldHintColor = isDark
        ? AppColors.terminalDarkFieldHint
        : AppColors.terminalLightFieldHint;
    final checkboxTextColor = isDark
        ? AppColors.terminalDarkCheckboxText
        : AppColors.terminalLightCheckboxText;
    final footerTextColor = isDark
        ? AppColors.terminalDarkFooterText
        : AppColors.terminalLightFooterText;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // SELECT YOUR ROLE Label
        Text(
          AppStrings.selectYourRole,
          style: AppTextStyles.terminalMonospaceLabel.copyWith(
            color: labelColor,
            fontSize: 11.sp,
          ),
        ),
        SizedBox(height: 12.h),

        // 2x2 Grid of Roles
        _buildRoleGrid(widget.selectedRole, labelColor),
        SizedBox(height: 24.h),

        // Input fields
        TerminalTextField(
          labelText: AppStrings.legalNameLabel,
          controller: widget.nameController,
          hintText: AppStrings.legalNameHint,
          labelColor: labelColor,
          textColor: textColor,
          bgColor: textfieldBgColor,
          borderColor: textfieldBorderColor,
          hintColor: textfieldHintColor,
          prefixIcon: Icons.person_outline,
          validator: (val) =>
              ValidationUtils.validateRequired(val, AppStrings.requiredField),
        ),
        SizedBox(height: 16.h),

        TerminalTextField(
          labelText: AppStrings.clinicalEmailLabel,
          controller: widget.emailController,
          hintText: AppStrings.clinicalEmailHint,
          labelColor: labelColor,
          textColor: textColor,
          bgColor: textfieldBgColor,
          borderColor: textfieldBorderColor,
          hintColor: textfieldHintColor,
          prefixIcon: Icons.email_outlined,
          validator: ValidationUtils.validateEmail,
        ),
        SizedBox(height: 16.h),

        ValueListenableBuilder<bool>(
          valueListenable: _isPasswordObscured,
          builder: (context, passwordObscured, _) {
            return TerminalTextField(
              labelText: AppStrings.securityPasswordLabel,
              controller: widget.passwordController,
              hintText: AppStrings.passwordHintDots,
              isPassword: true,
              isPasswordObscured: passwordObscured,
              labelColor: labelColor,
              textColor: textColor,
              bgColor: textfieldBgColor,
              borderColor: textfieldBorderColor,
              hintColor: textfieldHintColor,
              prefixIcon: Icons.lock_outline,
              onToggleVisibility: () {
                _isPasswordObscured.value = !_isPasswordObscured.value;
              },
              validator: ValidationUtils.validatePassword,
            );
          },
        ),
        SizedBox(height: 20.h),

        // Agreement checkbox
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Theme(
              data: ThemeData(unselectedWidgetColor: textfieldBorderColor),
              child: SizedBox(
                width: 20.r,
                height: 20.r,
                child: Checkbox(
                  value: widget.isAgreed,
                  activeColor: AppColors.terminalAccentCyan,
                  checkColor: isDark ? AppColors.terminalDarkBg : Colors.white,
                  side: BorderSide(color: textfieldBorderColor, width: 1.5),
                  onChanged: (val) {
                    widget.onAgreedChanged(val ?? false);
                  },
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: TextStyle(
                    color: checkboxTextColor,
                    fontSize: 12.sp,
                    height: 1.4,
                  ),
                  children: const [
                    TextSpan(text: AppStrings.hipaaAcknowledgePrefix),
                    TextSpan(
                      text: AppStrings.hipaaComplianceTerms,
                      style: TextStyle(
                        color: AppColors.terminalAccentCyan,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: AppStrings.andGeneral),
                    TextSpan(
                      text: AppStrings.privacyProtocol,
                      style: TextStyle(
                        color: AppColors.terminalAccentCyan,
                        decoration: TextDecoration.underline,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(text: AppStrings.forMedicalDataHandling),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 24.h),

        // Finalize Registration Button
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return InkWell(
              onTap: isLoading ? null : widget.onRegisterPressed,
              borderRadius: BorderRadius.circular(6.r),
              child: Container(
                width: double.infinity,
                height: 50.h,
                decoration: BoxDecoration(
                  color: AppColors.terminalAccentCyan,
                  borderRadius: BorderRadius.circular(6.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.terminalAccentCyan.withValues(
                        alpha: 0.3,
                      ),
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
                          color: isDark
                              ? AppColors.terminalDarkBg
                              : Colors.white,
                          strokeWidth: 2.0,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppStrings.finalizeRegistration,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: isDark
                                  ? AppColors.terminalDarkBg
                                  : Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15.sp,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Icon(
                            Icons.arrow_forward,
                            color: isDark
                                ? AppColors.terminalDarkBg
                                : Colors.white,
                            size: 18.r,
                          ),
                        ],
                      ),
              ),
            );
          },
        ),
        SizedBox(height: 32.h),

        // Footer System Warning details
        Center(
          child: Column(
            children: [
              Text(
                AppStrings.clinicalOpsVersion,
                style: AppTextStyles.terminalBodySmall.copyWith(
                  color: footerTextColor,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                AppStrings.secureEncryptedEnv,
                style: AppTextStyles.terminalMonospaceLabel.copyWith(
                  color: footerTextColor,
                  fontSize: 9.sp,
                  letterSpacing: 0.8,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRoleGrid(String selectedRole, Color labelColor) {
    return Column(
      children: [
        Row(
          children: [
            _buildRoleCard(
              label: "Staff",
              subtext: "Operational Access",
              icon: Icons.badge_outlined,
              isSelected: selectedRole == 'staff',
              labelColor: labelColor,
              onTap: () => widget.onRoleChanged('staff'),
            ),
            SizedBox(width: 12.w),
            _buildRoleCard(
              label: "Patient",
              subtext: "Health Records",
              icon: Icons.person_search_outlined,
              isSelected: selectedRole == 'patient',
              labelColor: labelColor,
              onTap: () => widget.onRoleChanged('patient'),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            _buildRoleCard(
              label: "Doctor",
              subtext: "Clinical Tools",
              icon: Icons.medical_services_outlined,
              isSelected: selectedRole == 'doctor',
              labelColor: labelColor,
              onTap: () => widget.onRoleChanged('doctor'),
            ),
            SizedBox(width: 12.w),
            _buildRoleCard(
              label: "Admin",
              subtext: "System Control",
              icon: Icons.security_outlined,
              isSelected: selectedRole == 'admin',
              labelColor: labelColor,
              onTap: () => widget.onRoleChanged('admin'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRoleCard({
    required String label,
    required String subtext,
    required IconData icon,
    required bool isSelected,
    required Color labelColor,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBgColor = isDark
        ? AppColors.terminalDarkCard
        : AppColors.terminalLightCard;
    final cardBorderColor = isDark
        ? AppColors.terminalDarkBorder
        : AppColors.terminalLightBorder;
    final cardTextColor = isDark
        ? AppColors.terminalDarkText
        : AppColors.terminalLightText;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 130.r,
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isSelected
                  ? AppColors.terminalAccentCyan
                  : cardBorderColor,
              width: isSelected ? 1.5 : 1.0,
            ),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
          ),
          child: Stack(
            children: [
              if (isSelected)
                Positioned(
                  left: 0,
                  top: 20.h,
                  bottom: 20.h,
                  child: Container(
                    width: 4.w,
                    decoration: BoxDecoration(
                      color: AppColors.terminalAccentCyan,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(2.r),
                        bottomRight: Radius.circular(2.r),
                      ),
                    ),
                  ),
                ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      color: isSelected
                          ? AppColors.terminalAccentCyan
                          : labelColor,
                      size: 20.r,
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      label,
                      style: TextStyle(
                        color: cardTextColor,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtext,
                      style: TextStyle(
                        color: AppColors.terminalDarkFooterText,
                        fontSize: 10.sp,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
