import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/modules/patient/dashboard/presentation/bloc/banner_bloc.dart';
import 'package:medi_connect/modules/patient/dashboard/domain/entities/banner_entity.dart';

class PatientBannerCarousel extends StatefulWidget {
  const PatientBannerCarousel({super.key});

  @override
  State<PatientBannerCarousel> createState() => _PatientBannerCarouselState();
}

class _PatientBannerCarouselState extends State<PatientBannerCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    context.read<BannerBloc>().add(LoadBanners());
  }

  void _startAutoPlay(int count) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (!mounted || count == 0) return;
      final nextPage = (_currentPage + 1) % count;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BannerBloc, BannerState>(
      builder: (context, state) {
        if (state is BannerLoading) {
          return Container(
            height: 160.h,
            alignment: Alignment.center,
            child: const CircularProgressIndicator(),
          );
        }

        if (state is BannerError) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return Container(
            height: 160.h,
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isDark ? AppColors.terminalDarkCard : Colors.red.shade50,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Failed to load banners",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 6.h),
                TextButton(
                  onPressed: () => context.read<BannerBloc>().add(LoadBanners()),
                  child: Text(
                    "Retry",
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        if (state is BannerLoaded) {
          final banners = state.banners;
          if (banners.isEmpty) {
            return const SizedBox.shrink();
          }

          // Start timer on load or state update
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_timer == null) _startAutoPlay(banners.length);
          });

          return Column(
            children: [
              SizedBox(
                height: 160.h,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (idx) {
                    setState(() {
                      _currentPage = idx;
                    });
                  },
                  itemCount: banners.length,
                  itemBuilder: (context, index) {
                    final banner = banners[index];
                    return _buildBannerCard(banner);
                  },
                ),
              ),
              SizedBox(height: 8.h),
              _buildIndicators(banners.length),
            ],
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildBannerCard(BannerEntity banner) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      elevation: 4,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomImageView(
            imagePath: banner.imageUrl,
            fit: BoxFit.cover,
            errorWidget: Container(
              color: AppColors.primary.withValues(alpha: 0.1),
              alignment: Alignment.center,
              child: Icon(
                Icons.image_outlined,
                color: AppColors.primary,
                size: 40.r,
              ),
            ),
          ),
          // Gradient Overlay for readability of possible texts
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.5),
                  Colors.transparent,
                ],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIndicators(int count) {
    if (count <= 1) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          height: 6.r,
          width: isActive ? 16.r : 6.r,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : Colors.grey.shade400,
            borderRadius: BorderRadius.circular(3.r),
          ),
        );
      }),
    );
  }
}
