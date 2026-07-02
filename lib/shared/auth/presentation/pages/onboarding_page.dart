/// Onboarding screen displaying features walkthrough slides.
/// Leads the user into the Login or Registration flows.
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/widgets/buttons/buttons.dart';
import 'package:medi_connect/core/routes/route_names.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

// Import separate modular widgets
import 'package:medi_connect/shared/auth/presentation/widgets/onboarding/background_painter.dart';
import 'package:medi_connect/shared/auth/presentation/widgets/onboarding/doctor_illustration.dart';
import 'package:medi_connect/shared/auth/presentation/widgets/onboarding/booking_illustration.dart';
import 'package:medi_connect/shared/auth/presentation/widgets/onboarding/security_illustration.dart';
import 'package:medi_connect/shared/auth/presentation/widgets/onboarding/animated_text.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _slides = [
    {
      'title': AppStrings.onboardingTitle1,
      'desc': AppStrings.onboardingDesc1,
    },
    {
      'title': AppStrings.onboardingTitle2,
      'desc': AppStrings.onboardingDesc2,
    },
    {
      'title': AppStrings.onboardingTitle3,
      'desc': AppStrings.onboardingDesc3,
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentIndex == _slides.length - 1;

    return OnboardingBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              children: [
                // Top Skip Action (hidden on last page for clean UX)
                AnimatedOpacity(
                  opacity: isLastPage ? 0.0 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IgnorePointer(
                      ignoring: isLastPage,
                      child: TextButton(
                        onPressed: () => context.go(RouteNames.login),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 8.h,
                          ),
                        ),
                        child: Text(
                          "Skip",
                          style: AppTextStyles.labelMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Animated Illustrations & Text Content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    itemCount: _slides.length,
                    itemBuilder: (context, index) {
                      final slide = _slides[index];
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Render the modular vector illustration for each slide
                          _buildIllustration(index),
                          SizedBox(height: 48.h),
                          
                          // Staggered animated texts (Title & Description)
                          OnboardingAnimatedText(
                            title: slide['title']!,
                            description: slide['desc']!,
                          ),
                        ],
                      );
                    },
                  ),
                ),

                // Custom Animated Page Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _slides.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      margin: EdgeInsets.symmetric(horizontal: 5.w),
                      width: _currentIndex == index ? 26.w : 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: _currentIndex == index
                            ? AppColors.primary
                            : AppColors.primary.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4.r),
                        boxShadow: _currentIndex == index
                            ? [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.35),
                                  blurRadius: 8.r,
                                  spreadRadius: 1.r,
                                )
                              ]
                            : null,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40.h),

                // Navigation Trigger Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: PrimaryButton(
                    text: isLastPage
                        ? AppStrings.getStarted
                        : AppStrings.next,
                    onPressed: () {
                      if (isLastPage) {
                        context.go(RouteNames.login);
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOutCubic,
                        );
                      }
                    },
                  ),
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIllustration(int index) {
    switch (index) {
      case 0:
        return const OnboardingDoctorIllustration();
      case 1:
        return const OnboardingBookingIllustration();
      case 2:
      default:
        return const OnboardingSecurityIllustration();
    }
  }
}
