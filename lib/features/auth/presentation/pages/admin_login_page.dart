import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/common_widgets/dialogs/dialogs.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/auth/presentation/widgets/background_accent_painter.dart';
import 'package:medi_connect/features/auth/presentation/widgets/login_form.dart';

class AdminLoginPage extends StatefulWidget {
  final bool showBackButton;

  const AdminLoginPage({super.key, this.showBackButton = false});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is Authenticated) {
          final role = state.user.role;
          context.go('/$role/dashboard');
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
    final footerTextColor = isDark
        ? AppColors.terminalDarkFooterText
        : AppColors.terminalLightFooterText;
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
            child: Opacity(
              opacity: 1.0,
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

          // Bottom Right Cross Grid
          Positioned(
            bottom: 120.h,
            right: 24.w,
            child: Opacity(
              opacity: 1.0,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 40.r,
                    height: 12.r,
                    decoration: BoxDecoration(
                      color: crossColor,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                  Container(
                    width: 12.r,
                    height: 40.r,
                    decoration: BoxDecoration(
                      color: crossColor,
                      borderRadius: BorderRadius.circular(2.r),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Main Login Form & Header
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(maxWidth: 420.w),
                padding: EdgeInsets.symmetric(horizontal: 24.r, vertical: 24.r),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header Logo & Titles
                      _buildHeader(textColor),
                      SizedBox(height: 24.h),

                      // Card Containment (LoginForm is now separated)
                      LoginForm(
                        email: _usernameController,
                        password: _passwordController,
                        onLoginPressed: _onLoginPressed,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 3. System Page Status Footer
          Positioned(
            bottom: 20.h,
            left: 24.w,
            right: 24.w,
            child: Row(
              children: [
                Row(
                  children: [
                    Container(
                      width: 8.r,
                      height: 8.r,
                      decoration: const BoxDecoration(
                        color: Color(0xFF22C55E),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      AppStrings.opsStable,
                      style: AppTextStyles.terminalBodySmall.copyWith(
                        color: const Color(0xFF22C55E),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Icon(Icons.language, color: footerTextColor, size: 18.r),
                SizedBox(width: 16.w),
                Icon(Icons.help_outline, color: footerTextColor, size: 18.r),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.assignment_ind_outlined,
          color: AppColors.terminalAccentCyan,
          size: 32.r,
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Clinical",
                  style: AppTextStyles.terminalHeadingMedium.copyWith(
                    color: textColor,
                    fontSize: 24.sp,
                  ),
                ),
                Text(
                  " Operations",
                  style: AppTextStyles.terminalHeadingMedium.copyWith(
                    color: AppColors.terminalAccentCyan,
                    fontSize: 24.sp,
                  ),
                ),
              ],
            ),
            Text(
              "SECURE PERSONNEL TERMINAL",
              style: AppTextStyles.terminalMonospaceLabel.copyWith(
                color: AppColors.terminalDarkFooterText,
                fontSize: 9.sp,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _onLoginPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(
        LoginRequested(
          email: _usernameController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
