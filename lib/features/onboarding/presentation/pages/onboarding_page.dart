/// Onboarding screen displaying features walkthrough slides.
/// Leads the user into the Login or Registration flows.
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/common_widgets/background_wrapper.dart';
import 'package:medi_connect/core/common_widgets/buttons/buttons.dart';
import 'package:medi_connect/core/router/route_names.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

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
      'icon': 'healing',
    },
    {
      'title': AppStrings.onboardingTitle2,
      'desc': AppStrings.onboardingDesc2,
      'icon': 'calendar_month',
    },
    {
      'title': AppStrings.onboardingTitle3,
      'desc': AppStrings.onboardingDesc3,
      'icon': 'description',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return BackgroundWrapper(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () => context.go(RouteNames.login),
                    child: Text(
                      "Skip",
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
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
                          CircleAvatar(
                            radius: 70.r,
                            backgroundColor: AppColors.primary.withOpacity(
                              0.08,
                            ),
                            child: Icon(
                              _getIconData(slide['icon']!),
                              size: 72.r,
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(height: 48.h),
                          Text(
                            slide['title']!,
                            style: AppTextStyles.headingMedium,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            slide['desc']!,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _slides.length,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      width: _currentIndex == index ? 24.w : 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: _currentIndex == index
                            ? AppColors.primary
                            : AppColors.border,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 48.h),
                PrimaryButton(
                  text: _currentIndex == _slides.length - 1
                      ? AppStrings.getStarted
                      : AppStrings.next,
                  onPressed: () {
                    if (_currentIndex == _slides.length - 1) {
                      context.go(RouteNames.login);
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    }
                  },
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String key) {
    switch (key) {
      case 'healing':
        return Icons.healing_outlined;
      case 'calendar_month':
        return Icons.calendar_month_outlined;
      case 'description':
      default:
        return Icons.description_outlined;
    }
  }
}
