import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/dashboard/domain/entities/activity_log_entity.dart';
import 'package:intl/intl.dart';

class RecentActivityItem extends StatelessWidget {
  final ActivityLogEntity log;
  final bool isDark;

  const RecentActivityItem({
    super.key,
    required this.log,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    IconData iconData = Icons.info_outline;
    Color color = Colors.grey;

    // Simple mapping based on category if available
    final cat = log.category.toLowerCase();
    if (cat.contains('alert') || cat.contains('emergency')) {
      iconData = Icons.warning_amber_rounded;
      color = Colors.orange;
    } else if (cat.contains('success') || cat.contains('resolved')) {
      iconData = Icons.check_circle_outline;
      color = Colors.green;
    } else if (cat.contains('error') || cat.contains('critical')) {
      iconData = Icons.error_outline;
      color = Colors.red;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(iconData, color: color, size: 20.sp),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                log.message,
                style: AppTextStyles.labelMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                DateFormat('MMM dd, hh:mm a').format(log.createdAt),
                style: AppTextStyles.labelSmall.copyWith(
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
