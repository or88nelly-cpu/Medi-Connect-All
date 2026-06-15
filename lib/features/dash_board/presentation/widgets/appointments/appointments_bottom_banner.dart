import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class AppointmentsBottomBanner extends StatelessWidget {
  final VoidCallback onBookNew;

  const AppointmentsBottomBanner({super.key, required this.onBookNew});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    Widget buildIllustration() {
      return SizedBox(
        width: 54.r,
        height: 54.r,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Calendar Body Card
            Positioned(
              top: 4.h,
              left: 4.w,
              child: Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Calendar Top blue bar
                    Container(
                      height: 10.h,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B82F6), // Blue top bar
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(8.r),
                        ),
                      ),
                    ),
                    // Grid Dots
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.all(4.r),
                        child: GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 3,
                                mainAxisSpacing: 3,
                              ),
                          itemCount: 9,
                          itemBuilder: (context, index) {
                            return Container(
                              decoration: const BoxDecoration(
                                color: Color(0xFFDBEAFE),
                                shape: BoxShape.circle,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Green Check Badge on top right of calendar
            Positioned(
              top: 0,
              right: 2.w,
              child: Container(
                padding: EdgeInsets.all(1.r),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 16.r,
                ),
              ),
            ),
            // Blue notification Bell hanging off bottom left
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                padding: EdgeInsets.all(2.r),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.notifications,
                  color: Colors.blue,
                  size: 14.r,
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget buildTextColumn() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Stay Organized,\nDeliver Better Care",
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
              height: 1.2,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            "Quickly book, manage, and track all patient appointments in one place.",
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 10.sp,
              color: isDark ? Colors.white54 : AppColors.textSecondary,
            ),
          ),
        ],
      );
    }

    Widget buildBookButton() {
      return ElevatedButton(
        onPressed: onBookNew,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Book New Appointment",
              style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 4.w),
            Icon(Icons.arrow_forward, size: 12.r),
          ],
        ),
      );
    }

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E2D4A) : const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? const Color(0xFF2E3E5C) : const Color(0xFFDBEAFE),
          width: 1,
        ),
      ),
      child: isTablet
          ? Row(
              children: [
                buildIllustration(),
                SizedBox(width: 14.w),
                Expanded(child: buildTextColumn()),
                SizedBox(width: 12.w),
                buildBookButton(),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    buildIllustration(),
                    SizedBox(width: 12.w),
                    Expanded(child: buildTextColumn()),
                  ],
                ),
                SizedBox(height: 12.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: buildBookButton(),
                ),
              ],
            ),
    );
  }
}
