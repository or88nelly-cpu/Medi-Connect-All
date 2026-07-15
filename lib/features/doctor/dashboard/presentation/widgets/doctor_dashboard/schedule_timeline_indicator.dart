import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';

class ScheduleTimelineIndicator extends StatelessWidget {
  final Color color;
  final int index;
  final int totalCount;

  const ScheduleTimelineIndicator({
    super.key,
    required this.color,
    required this.index,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Vertical Line
          if (totalCount > 1)
            Positioned(
              top: index == 0 ? 24.h : 0,
              bottom: index == totalCount - 1 ? 24.h : 0,
              child: Container(
                width: 2.w,
                color: AppColors.border(context).withValues(alpha: 0.5),
              ),
            ),
          // Dot
          Positioned(
            top: 24.h,
            child: Container(
              width: 10.r,
              height: 10.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
