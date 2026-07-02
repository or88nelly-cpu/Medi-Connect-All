import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/constants/app_enum.dart';
import 'package:medi_connect/core/functions/app_responsive.dart';
import 'package:medi_connect/core/routes/route_names.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/core/widgets/dialogs/dialogs.dart';

import 'package:medi_connect/core/constants/app_assets.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/shared/auth/presentation/widgets/signup_form.dart';

// Separate design widgets
import 'package:medi_connect/shared/auth/presentation/widgets/signup_branding.dart';
import 'package:medi_connect/shared/auth/presentation/widgets/signup_welcome_text.dart';
import 'package:medi_connect/shared/auth/presentation/widgets/signup_security_footer.dart';
import 'package:medi_connect/shared/auth/presentation/widgets/floating_doctor_image.dart';
import 'package:medi_connect/shared/auth/presentation/widgets/heartbeat_pulse_line.dart';

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
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  final _isAgreedNotifier = ValueNotifier<bool>(false);
  final UserRole _selectedUserRole = UserRole.patient;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _isAgreedNotifier.dispose();
    super.dispose();
  }

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
    final isDesktop = AppResponsive.isDesktop(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return CustomScaffold(
      appBarNeeded: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [
                    Colors.black.withValues(alpha: 0.65),
                    Colors.black.withValues(alpha: 0.40),
                    Colors.black.withValues(alpha: 0.70),
                  ]
                : [
                    Colors.black.withValues(alpha: 0.25),
                    Colors.black.withValues(alpha: 0.10),
                    Colors.black.withValues(alpha: 0.30),
                  ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // DESKTOP LAYOUT (Branding left, form right, doctor image center-aligned)
  // ─────────────────────────────────────────────────────────
  Widget _buildDesktopLayout() {
    final screenH = MediaQuery.sizeOf(context).height;
    return Container(
      height: screenH - 60.h,
      padding: EdgeInsets.symmetric(horizontal: 60.w),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left column: branding + welcome text
              Expanded(
                flex: 7,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SignupBranding(),
                    SizedBox(height: 48.h),
                    const SignupWelcomeText(),
                  ],
                ),
              ),

              // Right column: signup form
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildFormCard(),
                    SizedBox(height: 24.h),
                    const SignupSecurityFooter(),
                  ],
                ),
              ),
            ],
          ),

          // Doctor lady image overlay (bottom center) with premium floating animation
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(right: 120.w),
              child: FloatingDoctorImage(
                height: screenH * 0.70,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout() {
    final screenH = MediaQuery.sizeOf(context).height;
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SignupBranding(),
              SizedBox(height: 12.h),

              Stack(
                children: [
                  Row(
                    children: [
                      FloatingDoctorImage(height: screenH * 0.25),
                      SizedBox(width: 12.w),
                      const Expanded(child: SignupWelcomeText()),
                    ],
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: screenH * 0.20),
                    child: _buildFormCard(),
                  ),
                ],
              ),
              SizedBox(height: 28.h),
              const SignupSecurityFooter(),
              SizedBox(height: 12.h),
            ],
          ),
        ],
      ),
    );
  }

  /// The signup form wrapped in a styled card (Premium Glassmorphic container with Heartbeat ECG)
  Widget _buildFormCard() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = AppResponsive.isDesktop(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16.r, sigmaY: 16.r),
        child: SizedBox(
          width: isDesktop ? 400.w : double.infinity,
          child: Stack(
            children: [
              // Heartbeat ECG pulse line animating inside glass card
              Positioned(
                bottom: 24.h,
                left: 0,
                right: 0,
                child: Opacity(
                  opacity: isDark ? 0.15 : 0.25,
                  child: const HeartbeatPulseLine(height: 50),
                ),
              ),
              
              // Actual Form Card Contents
              Container(
                padding: EdgeInsets.all(24.r),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.black.withValues(alpha: 0.40)
                      : Colors.white.withValues(alpha: 0.50),
                  borderRadius: BorderRadius.circular(24.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.25),
                    width: 1.5.r,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.12),
                      blurRadius: 30,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _isAgreedNotifier,
                    builder: (context, isAgreed, _) {
                      return SignUpForm(
                        nameController: _nameController,
                        emailController: _emailController,
                        phoneController: _phoneController,
                        passwordController: _passwordController,
                        selectedRole: _selectedUserRole,
                        isAgreed: isAgreed,
                        onAgreedChanged: (agreed) => _isAgreedNotifier.value = agreed,
                        onRegisterPressed: _onRegisterPressed,
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onRegisterPressed() {
    if (_formKey.currentState?.validate() ?? false) {
      if (!_isAgreedNotifier.value) {
        showDialog(
          context: context,
          builder: (_) => const ErrorDialog(
            message: 'Please agree to the Terms of Service & Privacy Policy.',
          ),
        );
        return;
      }
      context.read<AuthBloc>().add(
        RegisterRequested(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          password: _passwordController.text,
          role: _selectedUserRole,
        ),
      );
    }
  }
}
