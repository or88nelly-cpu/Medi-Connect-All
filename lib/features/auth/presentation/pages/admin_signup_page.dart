import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/common_widgets/dialogs/dialogs.dart';
import 'package:medi_connect/core/router/route_names.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/auth/presentation/widgets/background_accent_painter.dart';
import 'package:medi_connect/features/auth/presentation/widgets/signup_form.dart';

class AdminSignUpPage extends StatefulWidget {
  final bool showBackButton;

  const AdminSignUpPage({super.key, this.showBackButton = true});

  @override
  State<AdminSignUpPage> createState() => _AdminSignUpPageState();
}

class _AdminSignUpPageState extends State<AdminSignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // Use ValueNotifier for local, widget-only state — no setState for page state.
  final _isAgreedNotifier = ValueNotifier<bool>(false);
  final _selectedRoleNotifier = ValueNotifier<String>('staff');

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          context.go(
            RouteNames.otpVerification,
            extra: _emailController.text.trim(),
          );
        } else if (state is AuthError) {
          showDialog(
            context: context,
            builder: (_) => ErrorDialog(message: state.failure.message),
          );
        }
      },
      child: _contents(),
    );
  }

  Widget _contents() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Theme-based colors from AppColors
    final bgColor1 = isDark
        ? AppColors.terminalDarkBgGrad1
        : AppColors.terminalLightBgGrad1;
    final bgColor2 = isDark
        ? AppColors.terminalDarkBgGrad2
        : AppColors.terminalLightBgGrad2;
    final textColor = isDark
        ? AppColors.terminalDarkText
        : AppColors.terminalLightText;
    final checkboxTextColor = isDark
        ? AppColors.terminalDarkCheckboxText
        : AppColors.terminalLightCheckboxText;
    final ornamentColor = isDark
        ? Colors.white.withValues(alpha: 0.1)
        : Colors.black.withValues(alpha: 0.04);
    final crossColor = isDark
        ? Colors.white.withValues(alpha: 0.05)
        : Colors.black.withValues(alpha: 0.02);

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.terminalDarkBg
          : AppColors.terminalLightBg,
      body: Stack(
        children: [
          // 1. Background Gradient Ornaments
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.center,
                  radius: 1.5,
                  colors: [bgColor1, bgColor2],
                ),
              ),
            ),
          ),

          // Top Left Dot Grid
          Positioned(
            top: 40.h,
            left: 24.w,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(
                6,
                (r) => Padding(
                  padding: EdgeInsets.only(bottom: 6.h),
                  child: Row(
                    children: List.generate(
                      6,
                      (c) => Padding(
                        padding: EdgeInsets.only(right: 6.w),
                        child: Container(
                          width: 3.r,
                          height: 3.r,
                          decoration: BoxDecoration(
                            color: ornamentColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Top Right Accent Arc & Dot
          Positioned.fill(
            child: CustomPaint(
              painter: BackgroundAccentPainter(
                lineColor: isDark
                    ? Colors.white.withValues(alpha: 0.03)
                    : Colors.black.withValues(alpha: 0.02),
                dotColor: AppColors.terminalAccentCyan,
              ),
            ),
          ),

          // Right middle Cross Grid decoration
          Positioned(
            top: 320.h,
            right: 24.w,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 30.r,
                  height: 10.r,
                  decoration: BoxDecoration(
                    color: crossColor,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                Container(
                  width: 10.r,
                  height: 30.r,
                  decoration: BoxDecoration(
                    color: crossColor,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ],
            ),
          ),

          // 2. Signup Form Container
          Center(
            child: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.r, vertical: 24.r),
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(maxWidth: 420.w),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Header
                        _buildHeader(textColor),
                        SizedBox(height: 32.h),

                        // Title & Subtitle
                        Text(
                          AppStrings.createAccountTitle,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          AppStrings.registerSubtitleTerminal,
                          style: TextStyle(
                            color: checkboxTextColor,
                            fontSize: 14.sp,
                            height: 1.4,
                          ),
                        ),
                        SizedBox(height: 24.h),

                        // Render separated SignUpForm
                        ValueListenableBuilder<String>(
                          valueListenable: _selectedRoleNotifier,
                          builder: (context, selectedRole, _) {
                            return ValueListenableBuilder<bool>(
                              valueListenable: _isAgreedNotifier,
                              builder: (context, isAgreed, _) {
                                return SignUpForm(
                                  nameController: _nameController,
                                  emailController: _emailController,
                                  passwordController: _passwordController,
                                  selectedRole: selectedRole,
                                  isAgreed: isAgreed,
                                  onRoleChanged: (role) =>
                                      _selectedRoleNotifier.value = role,
                                  onAgreedChanged: (agreed) =>
                                      _isAgreedNotifier.value = agreed,
                                  onRegisterPressed: _onRegisterPressed,
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.assignment_ind_outlined,
              color: AppColors.terminalAccentCyan,
              size: 24.r,
            ),
            SizedBox(width: 8.w),
            Text(
              "Clinical Operations",
              style: TextStyle(
                color: textColor,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: () => context.go(RouteNames.login),
          child: Text(
            "LOGIN",
            style: AppTextStyles.terminalMonospaceLabel.copyWith(
              color: textColor,
              fontSize: 12.sp,
            ),
          ),
        ),
      ],
    );
  }

  void _onRegisterPressed() {
    if (!_isAgreedNotifier.value) {
      showDialog(
        context: context,
        builder: (_) =>
            const ErrorDialog(message: AppStrings.hipaaAgreementError),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        RegisterRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          name: _nameController.text.trim(),
          role: _selectedRoleNotifier.value,
          phoneNumber: null,
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _isAgreedNotifier.dispose();
    _selectedRoleNotifier.dispose();
    super.dispose();
  }
}
