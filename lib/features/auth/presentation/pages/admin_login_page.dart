import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/app_responsive.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/common_widgets/dialogs/dialogs.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/utils/constants/app_assets.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';
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
    final isDesktop = AppResponsive.isDesktop(context);
    return CustomScaffold(
      appBarNeeded: false,
      body: SingleChildScrollView(
        child: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // DESKTOP LAYOUT
  // ─────────────────────────────────────────────────────────
  Widget _buildDesktopLayout() {
    final screenH = MediaQuery.sizeOf(context).height;
    return Container(
      height: screenH,
      padding: EdgeInsets.only(left: 60.w, right: 60.w, top: 40.h, bottom: 0.h),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left column: branding + welcome + badges
              Expanded(
                flex: 8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBranding(),
                    SizedBox(height: 50.h),
                    _buildWelcomeText(),
                    SizedBox(height: 30.h),
                    _buildFeatureBadges(),
                  ],
                ),
              ),

              // Center: person image (anchored to bottom)

              // Right column: login form
              Expanded(
                flex: 4,
                child: Padding(
                  padding: EdgeInsets.only(top: 30.h),
                  child: Column(
                    children: [
                      _buildFormCard(),
                      SizedBox(height: 24.h),
                      _buildSecurityFooter(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.only(right: 100.w),
              child: CustomImageView(
                imagePath: AppAssets.ladyImagePng,
                height: screenH * 0.72,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────
  // MOBILE LAYOUT
  // ─────────────────────────────────────────────────────────
  Widget _buildMobileLayout() {
    return Column(
      children: [
        // Top hero section with branding + image
        Stack(
          children: [
            // Light sky-blue gradient background for the hero section
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 24.h,
                bottom: 0,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.04),
                    AppColors.background(context),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBranding(),
                  SizedBox(height: 24.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Left: welcome text + badges
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildWelcomeText(),
                            SizedBox(height: 16.h),
                            _buildFeatureBadges(),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                      // Right: lady image
                      CustomImageView(
                        imagePath: AppAssets.ladyImagePng,
                        height: 220.h,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),

        // Form section
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Transform.translate(
            offset: Offset(0, -16.h),
            child: _buildFormCard(),
          ),
        ),

        SizedBox(height: 16.h),
        _buildSecurityFooter(),
        SizedBox(height: 24.h),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────
  // SHARED COMPONENTS
  // ─────────────────────────────────────────────────────────

  /// Logo + "MediConnect" + "Multi Speciality Hospital"
  Widget _buildBranding() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppColors.background(context),
            borderRadius: BorderRadius.circular(14.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: CustomImageView(
            imagePath: AppAssets.logoIconPng,
            width: 42.r,
            height: 42.r,
          ),
        ),
        SizedBox(width: 12.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Medi',
                    style: AppTextStyles.headingMedium.copyWith(
                      fontSize: 22.sp,
                      color: AppColors.primary,
                    ),
                  ),
                  TextSpan(
                    text: 'Connect',
                    style: AppTextStyles.headingMedium.copyWith(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDarkNavy,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'Multi Speciality Hospital',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary(context),
                fontSize: 11.sp,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// "Welcome Back!" + subtitle
  Widget _buildWelcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome Back!',
          style: AppTextStyles.headingLarge.copyWith(
            fontSize: AppResponsive.isDesktop(context) ? 32.sp : 26.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary(context),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Login to access your\nhealthcare services',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary(context),
            height: 1.4,
            fontSize: AppResponsive.isDesktop(context) ? 14.sp : 13.sp,
          ),
        ),
      ],
    );
  }

  /// Three rounded badges: Secure, Personalized, Seamless
  Widget _buildFeatureBadges() {
    final badges = [
      _BadgeData(Icons.verified_rounded, 'Secure', AppColors.primary),
      _BadgeData(
        Icons.people_alt_rounded,
        'Personalized',
        AppColors.adminPrimary,
      ),
      _BadgeData(
        Icons.auto_awesome_rounded,
        'Seamless',
        const Color(0xFF00B8A9),
      ),
    ];

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: badges
          .map(
            (b) => Padding(
              padding: EdgeInsets.only(
                right: AppResponsive.isDesktop(context) ? 12.w : 10.w,
              ),
              child: _buildBadge(b),
            ),
          )
          .toList(),
    );
  }

  Widget _buildBadge(_BadgeData data) {
    bool isDesktop = AppResponsive.isDesktop(context);
    return Column(
      children: [
        Container(
          width: isDesktop ? 52.r : 40.r,
          height: isDesktop ? 52.r : 40.r,
          decoration: BoxDecoration(
            color: data.color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(isDesktop ? 14.r : 8.r),
            border: Border.all(
              color: data.color.withValues(alpha: 0.15),
              width: 1,
            ),
          ),
          child: Icon(
            data.icon,
            color: data.color,
            size: isDesktop ? 24.r : 18.r,
          ),
        ),
        SizedBox(height: 6.h),
        SizedBox(
          child: Text(
            data.label,
            style: AppTextStyles.bodyXSmall.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary(context),
              fontSize: AppResponsive.isDesktop(context) ? 10.sp : 8.sp,
            ),
          ),
        ),
      ],
    );
  }

  /// The login form wrapped in a styled card
  Widget _buildFormCard() {
    return Container(
      constraints: BoxConstraints(
        maxWidth: AppResponsive.isDesktop(context) ? 380.w : double.infinity,
      ),
      padding: EdgeInsets.all(28.r),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: AppColors.border(context).withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow(context),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: LoginForm(
          email: _usernameController,
          password: _passwordController,
          onLoginPressed: _onLoginPressed,
        ),
      ),
    );
  }

  /// Security footer badge
  Widget _buildSecurityFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(4.r),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.verified_user_rounded,
            color: AppColors.primary,
            size: 16.r,
          ),
        ),
        SizedBox(width: 8.w),
        Text(
          'Your health data is safe and secure with us.',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary(context),
            fontSize: 12.sp,
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

class _BadgeData {
  final IconData icon;
  final String label;
  final Color color;
  const _BadgeData(this.icon, this.label, this.color);
}
