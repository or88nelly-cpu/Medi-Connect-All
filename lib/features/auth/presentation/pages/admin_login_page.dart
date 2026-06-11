import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/common_widgets/dialogs/dialogs.dart';
import 'package:medi_connect/core/router/route_names.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/utils/validation_utils.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';

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
  bool _isPasswordObscured = true;
  bool _rememberMe = false;

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
    final bgColor1 = isDark ? AppColors.terminalDarkBgGrad1 : AppColors.terminalLightBgGrad1;
    final bgColor2 = isDark ? AppColors.terminalDarkBgGrad2 : AppColors.terminalLightBgGrad2;
    final cardBgColor = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final cardBorderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final textColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;
    final textfieldBgColor = isDark ? AppColors.terminalDarkFieldFill : AppColors.terminalLightFieldFill;
    final textfieldBorderColor = isDark ? AppColors.terminalDarkFieldBorder : AppColors.terminalLightFieldBorder;
    final textfieldHintColor = isDark ? AppColors.terminalDarkFieldHint : AppColors.terminalLightFieldHint;
    final checkboxTextColor = isDark ? AppColors.terminalDarkCheckboxText : AppColors.terminalLightCheckboxText;
    final footerTextColor = isDark ? AppColors.terminalDarkFooterText : AppColors.terminalLightFooterText;
    final ornamentColor = isDark ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.04);
    final crossColor = isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.02);

    return Scaffold(
      backgroundColor: isDark ? AppColors.terminalDarkBg : AppColors.terminalLightBg,
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
                lineColor: isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.02),
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

                      // Card Containment
                      Container(
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
                              style: TextStyle(
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
                            _buildTextField(
                              labelText: AppStrings.terminalIdLabel,
                              controller: _usernameController,
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
                            _buildTextField(
                              labelText: AppStrings.accessKeyLabel,
                              prefixIcon: Icons.lock_outline,
                              controller: _passwordController,
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
                                  style: TextStyle(
                                    color: labelColor,
                                    fontSize: 11.sp,
                                    fontFamily: 'monospace',
                                    fontWeight: FontWeight.bold,
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
                                  style: TextStyle(
                                    color: checkboxTextColor,
                                    fontSize: 13.sp,
                                    fontFamily: 'monospace',
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
                                  onTap: isLoading ? null : _onLoginPressed,
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
                                                style: TextStyle(
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
                                style: TextStyle(
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
                                    style: TextStyle(
                                      color: footerTextColor,
                                      fontSize: 12.sp,
                                      fontFamily: 'monospace',
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
                      style: TextStyle(
                        color: const Color(0xFF22C55E),
                        fontSize: 11.sp,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Icon(
                  Icons.language,
                  color: footerTextColor,
                  size: 18.r,
                ),
                SizedBox(width: 16.w),
                Icon(
                  Icons.help_outline,
                  color: footerTextColor,
                  size: 18.r,
                ),
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
                  style: TextStyle(
                    color: textColor,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  " Operations",
                  style: TextStyle(
                    color: AppColors.terminalAccentCyan,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              "SECURE PERSONNEL TERMINAL",
              style: TextStyle(
                color: AppColors.terminalDarkFooterText,
                fontSize: 9.sp,
                letterSpacing: 2.0,
                fontFamily: 'monospace',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required String labelText,
    required TextEditingController? controller,
    required String hintText,
    required Color labelColor,
    required Color textColor,
    required Color bgColor,
    required Color borderColor,
    required Color hintColor,
    IconData? prefixIcon,
    bool isPassword = false,
    bool isPasswordObscured = false,
    VoidCallback? onToggleVisibility,
    Widget? rightLabelWidget,
    FormFieldValidator<String>? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                if (prefixIcon != null) ...[
                  Icon(
                    prefixIcon,
                    color: labelColor,
                    size: 12.r,
                  ),
                  SizedBox(width: 4.w),
                ],
                Text(
                  labelText,
                  style: TextStyle(
                    color: labelColor,
                    fontSize: 11.sp,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
            if (rightLabelWidget != null) rightLabelWidget,
          ],
        ),
        SizedBox(height: 8.h),
        TextFormField(
          controller: controller,
          obscureText: isPassword && isPasswordObscured,
          validator: validator,
          style: TextStyle(
            color: textColor,
            fontSize: 14.sp,
            fontFamily: 'monospace',
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: hintColor,
              fontSize: 14.sp,
              fontFamily: 'monospace',
            ),
            filled: true,
            fillColor: bgColor,
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor, width: 1.0),
              borderRadius: BorderRadius.circular(6.r),
            ),
            focusedBorder:  OutlineInputBorder(
              borderSide: BorderSide(color: AppColors.terminalAccentCyan, width: 1.2),
              borderRadius: BorderRadius.circular(6.r),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.0),
              borderRadius: BorderRadius.circular(6.r),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
              borderRadius: BorderRadius.circular(6.r),
            ),
            suffixIcon: isPassword
                ? GestureDetector(
                    onTap: onToggleVisibility,
                    child: Icon(
                      isPasswordObscured
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: hintColor,
                      size: 20.r,
                    ),
                  )
                : null,
          ),
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

class BackgroundAccentPainter extends CustomPainter {
  final Color lineColor;
  final Color dotColor;

  BackgroundAccentPainter({
    required this.lineColor,
    required this.dotColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final center = Offset(size.width * 0.9, size.height * 0.08);
    final radius = 220.w;

    canvas.drawCircle(center, radius, paint);

    final dotPaint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;

    const double angle = 210 * math.pi / 180;
    final dotCenter = Offset(
      center.dx + radius * math.cos(angle),
      center.dy + radius * math.sin(angle),
    );

    canvas.drawCircle(dotCenter, 4.w, dotPaint);
  }

  @override
  bool shouldRepaint(covariant BackgroundAccentPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor || oldDelegate.dotColor != dotColor;
  }
}
