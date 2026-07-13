import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class CustomerCareRecentActivity extends StatelessWidget {
  final List<dynamic> activities;
  final VoidCallback? onViewAll;

  const CustomerCareRecentActivity({
    super.key,
    required this.activities,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final widgetBg = AppColors.dashboardCardBg(context);
    final borderColor = AppColors.dashboardCardBorder(context);
    final textColor = AppColors.dashboardTextPrimary(context);
    final labelColor = AppColors.dashboardTextSecondary(context);

    final rawActivities = activities.isNotEmpty
        ? activities
        : [
            {
              'message': 'New patient registered: John Doe (UHID: 8932)',
              'time': '10 mins ago',
              'type': 'registration',
            },
            {
              'message': 'Appointment booked with General Medicine',
              'time': '1 hour ago',
              'type': 'appointment',
            },
            {
              'message': 'Feedback received: 5/5 from Patient Alice',
              'time': '2 hours ago',
              'type': 'feedback',
            },
            {
              'message': 'Emergency Ward admission: Room 502',
              'time': '3 hours ago',
              'type': 'admission',
            },
            {
              'message': 'QR Registration scanned successfully',
              'time': '4 hours ago',
              'type': 'qr',
            },
            {
              'message': 'Billing configuration updated by admin',
              'time': '6 hours ago',
              'type': 'system',
            },
          ];

    return Container(
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: widgetBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.02),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.history_rounded,
                    color: isDark ? AppColors.primaryLight : AppColors.primary,
                    size: 20.r,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    AppStrings.recentActivity,
                    style: AppTextStyles.dashboardCardTitle.copyWith(
                      color: textColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  onViewAll?.call();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Viewing all recent activities'),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Text(
                      AppStrings.viewAll,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.primaryLight
                            : AppColors.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 10.r,
                      color: isDark
                          ? AppColors.primaryLight
                          : AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 18.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: rawActivities.length,
            itemBuilder: (context, index) {
              final activity = rawActivities[index];
              final isLast = index == rawActivities.length - 1;
              return _buildActivityRow(
                context,
                activity,
                isLast,
                labelColor,
                textColor,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActivityRow(
    BuildContext context,
    dynamic activity,
    bool isLast,
    Color labelColor,
    Color textColor,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final String message = activity['message'] ?? '';
    final String time = activity['time'] ?? '';
    final String type = activity['type'] ?? '';

    IconData icon = Icons.notifications_none_rounded;
    Color color = AppColors.primary;

    if (type == 'registration' || type == 'qr') {
      icon = Icons.person_add_alt_1_rounded;
      color = const Color(0xFF0F6FFF);
    } else if (type == 'appointment') {
      icon = Icons.edit_calendar_rounded;
      color = const Color(0xFF7B61FF);
    } else if (type == 'feedback') {
      icon = Icons.star_rounded;
      color = const Color(0xFFFF8A26);
    } else if (type == 'admission') {
      icon = Icons.hotel_rounded;
      color = const Color(0xFF22C55E);
    } else if (type == 'system') {
      icon = Icons.settings_rounded;
      color = const Color(0xFFEC4899);
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Container(
                width: 9.r,
                height: 9.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isDark ? Colors.white24 : Colors.black12,
                  border: Border.all(
                    color: isDark ? Colors.white60 : Colors.black26,
                    width: 1.5,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1.5.w,
                    color: AppColors.dashboardCardBorder(context),
                  ),
                )
              else
                SizedBox(height: 12.h),
            ],
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 14.h),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color.withValues(alpha: isDark ? 0.15 : 0.08),
                    ),
                    child: Icon(icon, color: color, size: 14.r),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      message,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: textColor,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    time,
                    style: AppTextStyles.bodyXSmall.copyWith(
                      color: labelColor,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
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
}
