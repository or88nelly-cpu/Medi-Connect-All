import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class PendingMrdBanner extends StatelessWidget {
  final String count;
  final VoidCallback onViewDetailsTap;

  const PendingMrdBanner({
    super.key,
    required this.count,
    required this.onViewDetailsTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: 110.h,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF881337), const Color(0xFF4C0519)]
              : [const Color(0xFFFFF1F2), const Color(0xFFFFE4E6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFE11D48).withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Content Row
          Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                // Icon Container
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE11D48),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    Icons.assignment_turned_in_rounded,
                    color: Colors.white,
                    size: 26.r,
                  ),
                ),
                SizedBox(width: 16.w),
                // Text details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Pending MRD",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: const Color(0xFFE11D48),
                          fontWeight: FontWeight.bold,
                          fontSize: 12.sp,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            count,
                            style: AppTextStyles.headingMedium.copyWith(
                              color: isDark ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w900,
                              fontSize: 22.sp,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            "Pending Records",
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isDark ? Colors.white38 : Colors.grey[500],
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      // View Details Link
                      GestureDetector(
                        onTap: onViewDetailsTap,
                        child: Row(
                          children: [
                            Text(
                              "View Details",
                              style: TextStyle(
                                color: const Color(0xFFE11D48),
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: const Color(0xFFE11D48),
                              size: 8.r,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Stacked document graphics on the right side
          Positioned(
            right: 16.w,
            bottom: -10.h,
            child: SizedBox(
              width: 90.w,
              height: 100.h,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  // Back document
                  Positioned(
                    bottom: 12.h,
                    right: 4.w,
                    child: Transform.rotate(
                      angle: 0.15,
                      child: _buildMockDocPage(isDark, const Color(0xFFFDA4AF)),
                    ),
                  ),
                  // Middle document
                  Positioned(
                    bottom: 6.h,
                    right: 12.w,
                    child: Transform.rotate(
                      angle: -0.08,
                      child: _buildMockDocPage(isDark, const Color(0xFFFECDD3)),
                    ),
                  ),
                  // Front document
                  Positioned(
                    bottom: 0,
                    right: 20.w,
                    child: Transform.rotate(
                      angle: 0.0,
                      child: _buildMockDocPage(isDark, Colors.white, hasStamp: true),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMockDocPage(bool isDark, Color baseBgColor, {bool hasStamp = false}) {
    final bgColor = isDark && baseBgColor == Colors.white ? const Color(0xFF334155) : baseBgColor;
    final lineColor = isDark ? Colors.white24 : Colors.grey[200]!;

    return Container(
      width: 42.w,
      height: 56.h,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey[200]!,
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header lines
          Container(width: 14.w, height: 2.h, color: lineColor),
          SizedBox(height: 3.h),
          Container(width: 28.w, height: 2.h, color: lineColor),
          SizedBox(height: 3.h),
          Container(width: 24.w, height: 2.h, color: lineColor),
          SizedBox(height: 3.h),
          Container(width: 20.w, height: 2.h, color: lineColor),
          const Spacer(),
          if (hasStamp)
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 10.r,
                height: 10.r,
                decoration: const BoxDecoration(
                  color: Color(0xFFF43F5E),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.white, size: 6.r),
              ),
            )
          else
            Container(width: 10.w, height: 2.h, color: lineColor),
        ],
      ),
    );
  }
}
