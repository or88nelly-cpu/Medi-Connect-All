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
  final _isPasswordObscured = ValueNotifier<bool>(true);

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
    final bgColor1 = isDark ? AppColors.terminalDarkBgGrad1 : AppColors.terminalLightBgGrad1;
    final bgColor2 = isDark ? AppColors.terminalDarkBgGrad2 : AppColors.terminalLightBgGrad2;
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
              painter: _BackgroundAccentPainter(
                lineColor: isDark ? Colors.white.withOpacity(0.03) : Colors.black.withOpacity(0.02),
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

                        // SELECT YOUR ROLE Label
                        Text(
                          AppStrings.selectYourRole,
                          style: TextStyle(
                            color: labelColor,
                            fontSize: 11.sp,
                            fontFamily: 'monospace',
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                          ),
                        ),
                        SizedBox(height: 12.h),

                        // 2x2 Grid of Roles
                        ValueListenableBuilder<String>(
                          valueListenable: _selectedRoleNotifier,
                          builder: (context, selectedRole, _) {
                            return _buildRoleGrid(selectedRole, labelColor);
                          },
                        ),
                        SizedBox(height: 24.h),

                        // Input fields
                        _buildTextField(
                          labelText: AppStrings.legalNameLabel,
                          controller: _nameController,
                          hintText: AppStrings.legalNameHint,
                          labelColor: labelColor,
                          textColor: textColor,
                          bgColor: textfieldBgColor,
                          borderColor: textfieldBorderColor,
                          hintColor: textfieldHintColor,
                          prefixIcon: Icons.person_outline,
                          validator: (val) => ValidationUtils.validateRequired(
                            val,
                            AppStrings.requiredField,
                          ),
                        ),
                        SizedBox(height: 16.h),

                        _buildTextField(
                          labelText: AppStrings.clinicalEmailLabel,
                          controller: _emailController,
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
                            return _buildTextField(
                              labelText: AppStrings.securityPasswordLabel,
                              controller: _passwordController,
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
                        ValueListenableBuilder<bool>(
                          valueListenable: _isAgreedNotifier,
                          builder: (context, isAgreed, _) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Theme(
                                  data: ThemeData(
                                    unselectedWidgetColor: textfieldBorderColor,
                                  ),
                                  child: SizedBox(
                                    width: 20.r,
                                    height: 20.r,
                                    child: Checkbox(
                                      value: isAgreed,
                                      activeColor: AppColors.terminalAccentCyan,
                                      checkColor: isDark ? AppColors.terminalDarkBg : Colors.white,
                                      side: BorderSide(
                                        color: textfieldBorderColor,
                                        width: 1.5,
                                      ),
                                      onChanged: (val) {
                                        _isAgreedNotifier.value = val ?? false;
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
                            );
                          },
                        ),
                        SizedBox(height: 24.h),

                        // Finalize Registration Button
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            final isLoading = state is AuthLoading;
                            return InkWell(
                              onTap: isLoading ? null : _onRegisterPressed,
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
                                          Text(
                                            AppStrings.finalizeRegistration,
                                            style: TextStyle(
                                              color: isDark ? AppColors.terminalDarkBg : Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15.sp,
                                            ),
                                          ),
                                          SizedBox(width: 8.w),
                                          Icon(
                                            Icons.arrow_forward,
                                            color: isDark ? AppColors.terminalDarkBg : Colors.white,
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
                                style: TextStyle(
                                  color: footerTextColor,
                                  fontSize: 11.sp,
                                  fontFamily: 'monospace',
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                AppStrings.secureEncryptedEnv,
                                style: TextStyle(
                                  color: footerTextColor,
                                  fontSize: 9.sp,
                                  fontFamily: 'monospace',
                                  letterSpacing: 0.8,
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
            style:  TextStyle(
              color: AppColors.terminalAccentCyan,
              fontSize: 12.sp,
              fontFamily: 'monospace',
              fontWeight: FontWeight.bold,
              letterSpacing: 1.0,
            ),
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
              onTap: () => _selectedRoleNotifier.value = 'staff',
            ),
            SizedBox(width: 12.w),
            _buildRoleCard(
              label: "Patient",
              subtext: "Health Records",
              icon: Icons.person_search_outlined,
              isSelected: selectedRole == 'patient',
              labelColor: labelColor,
              onTap: () => _selectedRoleNotifier.value = 'patient',
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
              onTap: () => _selectedRoleNotifier.value = 'doctor',
            ),
            SizedBox(width: 12.w),
            _buildRoleCard(
              label: "Admin",
              subtext: "System Control",
              icon: Icons.security_outlined,
              isSelected: selectedRole == 'admin',
              labelColor: labelColor,
              onTap: () => _selectedRoleNotifier.value = 'admin',
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
    final cardBgColor = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final cardBorderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final cardTextColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 80.h,
          decoration: BoxDecoration(
            color: cardBgColor,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color: isSelected ? AppColors.terminalAccentCyan : cardBorderColor,
              width: isSelected ? 1.5 : 1.0,
            ),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.03),
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
                      color: isSelected ? AppColors.terminalAccentCyan : labelColor,
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
    FormFieldValidator<String>? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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

  void _onRegisterPressed() {
    if (!_isAgreedNotifier.value) {
      showDialog(
        context: context,
        builder: (_) => const ErrorDialog(
          message: AppStrings.hipaaAgreementError,
        ),
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
    _isPasswordObscured.dispose();
    super.dispose();
  }
}

class _BackgroundAccentPainter extends CustomPainter {
  final Color lineColor;
  final Color dotColor;

  _BackgroundAccentPainter({
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
  bool shouldRepaint(covariant _BackgroundAccentPainter oldDelegate) {
    return oldDelegate.lineColor != lineColor || oldDelegate.dotColor != dotColor;
  }
}
