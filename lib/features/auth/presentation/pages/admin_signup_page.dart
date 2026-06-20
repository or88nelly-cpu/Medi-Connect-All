import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/app_responsive.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/common_widgets/dialogs/dialogs.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/router/route_names.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/utils/constants/app_assets.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';
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
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  final _isAgreedNotifier = ValueNotifier<bool>(false);
  final _selectedRoleNotifier = ValueNotifier<String>('patient');

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
          Padding(
            padding: EdgeInsets.only(top: 20.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left column: branding + welcome text
                Expanded(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildBranding(),
                      SizedBox(height: 50.h),
                      _buildWelcomeText(),
                    ],
                  ),
                ),

                // Center: person image

                // Right column: signup form
                Expanded(
                  flex: 5,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10.h),
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
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomImageView(
              imagePath: AppAssets.ladyImagePng,
              height: screenH * 0.72,
              fit: BoxFit.contain,
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
        // Top hero section
        Stack(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                left: 20.w,
                right: 20.w,
                top: 16.h,
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
                  // Back button
                  if (widget.showBackButton)
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: AppColors.card(context),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: AppColors.border(
                              context,
                            ).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16.r,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                    ),
                  SizedBox(height: 12.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildBranding(),
                            SizedBox(height: 20.h),
                            _buildWelcomeText(),
                            SizedBox(height: 20.h),
                          ],
                        ),
                      ),
                      CustomImageView(
                        imagePath: AppAssets.ladyImagePng,
                        height: 200.h,
                        fit: BoxFit.cover,
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
            offset: Offset(0, -12.h),
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

  /// Logo + "MediConnect" branding
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

  /// "Create Your Account" + subtitle
  Widget _buildWelcomeText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Create Your Account',
          style: AppTextStyles.headingLarge.copyWith(
            fontSize: AppResponsive.isDesktop(context) ? 32.sp : 26.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary(context),
          ),
        ),
        SizedBox(height: 6.h),
        Text(
          'Join us to access world-class\nhealthcare services',
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary(context),
            height: 1.4,
            fontSize: AppResponsive.isDesktop(context) ? 14.sp : 13.sp,
          ),
        ),
      ],
    );
  }

  /// The signup form wrapped in a styled card
  Widget _buildFormCard() {
    return Container(
      constraints: BoxConstraints(
        maxWidth: AppResponsive.isDesktop(context) ? 420.w : double.infinity,
      ),
      padding: EdgeInsets.all(24.r),
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
        child: ValueListenableBuilder<String>(
          valueListenable: _selectedRoleNotifier,
          builder: (context, selectedRole, _) {
            return ValueListenableBuilder<bool>(
              valueListenable: _isAgreedNotifier,
              builder: (context, isAgreed, _) {
                return SignUpForm(
                  nameController: _nameController,
                  emailController: _emailController,
                  phoneController: _phoneController,
                  passwordController: _passwordController,
                  selectedRole: selectedRole,
                  isAgreed: isAgreed,
                  onRoleChanged: (role) => _selectedRoleNotifier.value = role,
                  onAgreedChanged: (agreed) => _isAgreedNotifier.value = agreed,
                  onRegisterPressed: _onRegisterPressed,
                );
              },
            );
          },
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
          phoneNumber: _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _isAgreedNotifier.dispose();
    _selectedRoleNotifier.dispose();
    super.dispose();
  }
}
