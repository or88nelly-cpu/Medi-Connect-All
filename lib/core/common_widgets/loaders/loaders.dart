/// Custom loader and feedback widgets.
/// Implements: AppLoader, ShimmerLoader, EmptyStateWidget.
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/buttons/buttons.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:shimmer/shimmer.dart';


/// Central standard activity progress spinner.
class AppLoader extends StatelessWidget {
  final String? message;

  const AppLoader({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 3.w,
          ),
          if (message != null) ...[
            SizedBox(height: 16.h),
            Text(
              message!,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

/// Dynamic shimmer placeholder loading skeleton cards.
class ShimmerLoader extends StatelessWidget {
  final int count;

  const ShimmerLoader({super.key, this.count = 3});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor =
        isDark ? const Color(0xFF2C2C2C) : const Color(0xFFE5E7EB);
    final highlightColor =
        isDark ? const Color(0xFF3C3C3C) : const Color(0xFFF3F4F6);

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: count,
      separatorBuilder: (context, index) => SizedBox(height: 12.h),
      itemBuilder: (context, index) => Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: baseColor,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 150.w,
                      height: 16.h,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: 100.w,
                      height: 12.h,
                      color: Colors.white,
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: double.infinity,
                      height: 12.h,
                      color: Colors.white,
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
}

/// Generic feedback view displayed when list queries return empty.
class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final String? actionText;
  final VoidCallback? onActionPressed;

  const EmptyStateWidget({
    super.key,
    this.icon = Icons.hourglass_empty,
    required this.title,
    required this.description,
    this.actionText,
    this.onActionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 72.r,
              color: AppColors.textSecondary.withOpacity(0.5),
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              style: AppTextStyles.titleLarge,
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              description,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onActionPressed != null) ...[
              SizedBox(height: 24.h),
              SizedBox(
                width: 180.w,
                child: PrimaryButton(
                  text: actionText!,
                  onPressed: onActionPressed,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
