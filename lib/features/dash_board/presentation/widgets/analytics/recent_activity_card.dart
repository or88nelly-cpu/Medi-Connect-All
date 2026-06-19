import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class ActivityItem {
  final String message;
  final String time;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;

  const ActivityItem({
    required this.message,
    required this.time,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });
}

class RecentActivityCard extends StatelessWidget {
  final List<dynamic> activities;
  final VoidCallback? onViewAll;

  const RecentActivityCard({
    super.key,
    required this.activities,
    this.onViewAll,
  });

  ActivityItem _parseActivity(dynamic act) {
    if (act is ActivityItem) return act;

    final Map<String, dynamic> data = act is Map
        ? Map<String, dynamic>.from(act)
        : {};
    final msg = data['message'] as String? ?? '';
    final time = data['time'] as String? ?? '';
    final msgLower = msg.toLowerCase();

    IconData icon = Icons.notifications_none_rounded;
    Color color = AppColors.primary;
    Color bg = AppColors.primary.withValues(alpha: 0.08);

    if (msgLower.contains('patient') || msgLower.contains('registered')) {
      icon = Icons.person_outline_rounded;
      color = AppColors.green;
      bg = AppColors.lightGreenCard;
    } else if (msgLower.contains('doctor') || msgLower.contains('added')) {
      icon = Icons.person_add_alt_1_rounded;
      color = AppColors.blue;
      bg = AppColors.lightBlueCard;
    } else if (msgLower.contains('department') ||
        msgLower.contains('updated')) {
      icon = Icons.business_rounded;
      color = AppColors.orange;
      bg = AppColors.lightOrangeCard;
    } else if (msgLower.contains('role') || msgLower.contains('changed')) {
      icon = Icons.shield_outlined;
      color = AppColors.purple;
      bg = AppColors.lightPurpleCard;
    } else if (msgLower.contains('billing') ||
        msgLower.contains('invoice') ||
        msgLower.contains('configuration')) {
      icon = Icons.credit_card_rounded;
      color = AppColors.green;
      bg = AppColors.lightGreenCard;
    } else if (msgLower.contains('backup') || msgLower.contains('system')) {
      icon = Icons.cloud_done_outlined;
      color = AppColors.blue;
      bg = AppColors.lightBlueCard;
    }

    return ActivityItem(
      message: msg,
      time: time,
      icon: icon,
      iconColor: color,
      iconBgColor: bg,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = MediaQuery.of(context).size.width > 950;

    final cardBg = isDark ? AppColors.darkCard : Colors.white;
    final borderCol = isDark
        ? Colors.white.withValues(alpha: 0.04)
        : Colors.black.withValues(alpha: 0.03);

    final rawActivities = activities.isNotEmpty
        ? activities
        : [
            {'message': AppStrings.newPatientRegistered, 'time': ''},
            {'message': AppStrings.doctorAddedSuccessfully, 'time': ''},
            {'message': AppStrings.departmentUpdatedActivity, 'time': ''},
            {'message': AppStrings.userRoleChanged, 'time': '10:30 AM'},
            {'message': AppStrings.billingConfigUpdated, 'time': '08:15 AM'},
            {'message': AppStrings.systemBackupCompleted, 'time': '07:30 AM'},
          ];

    final parsedList = rawActivities.map((act) => _parseActivity(act)).toList();

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: borderCol, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
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
                    Icons.history,
                    color: isDark ? Colors.white : AppColors.textDarkNavy,
                    size: 20.r,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    AppStrings.recentActivity,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textDarkNavy,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: onViewAll,
                child: Row(
                  children: [
                    Text(
                      AppStrings.viewAll,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 12.sp,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 10.r,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          if (isDesktop && parsedList.length >= 6) ...[
            Column(
              children: [
                _buildCenterTimelineRow(
                  parsedList[0],
                  parsedList[3],
                  true,
                  false,
                  context,
                ),
                _buildCenterTimelineRow(
                  parsedList[1],
                  parsedList[4],
                  false,
                  false,
                  context,
                ),
                _buildCenterTimelineRow(
                  parsedList[2],
                  parsedList[5],
                  false,
                  true,
                  context,
                ),
              ],
            ),
          ] else ...[
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: parsedList.length,
              itemBuilder: (context, idx) {
                final isLast = idx == parsedList.length - 1;
                return _buildMobileTimelineRow(
                  parsedList[idx],
                  isLast,
                  context,
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCenterTimelineRow(
    ActivityItem left,
    ActivityItem right,
    bool isFirst,
    bool isLast,
    BuildContext context,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderCol = AppColors.border(context);

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 24.w, bottom: 22.h),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? left.iconColor.withValues(alpha: 0.15)
                          : left.iconBgColor,
                    ),
                    child: Icon(left.icon, color: left.iconColor, size: 18.r),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      left.message,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : AppColors.textDarkNavy,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              if (!isFirst)
                Expanded(
                  child: Container(width: 1.5.w, color: borderCol),
                )
              else
                SizedBox(height: 14.h),
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
                  child: Container(width: 1.5.w, color: borderCol),
                )
              else
                SizedBox(height: 14.h),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 24.w, bottom: 22.h),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? right.iconColor.withValues(alpha: 0.15)
                          : right.iconBgColor,
                    ),
                    child: Icon(right.icon, color: right.iconColor, size: 18.r),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      right.message,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : AppColors.textDarkNavy,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                  if (right.time.isNotEmpty) ...[
                    SizedBox(width: 8.w),
                    Text(
                      right.time,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 11.sp,
                        color: isDark ? Colors.white38 : Colors.black38,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileTimelineRow(
    ActivityItem item,
    bool isLast,
    BuildContext context,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderCol = AppColors.border(context);

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
                  child: Container(width: 1.5.w, color: borderCol),
                )
              else
                SizedBox(height: 12.h),
            ],
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isDark
                          ? item.iconColor.withValues(alpha: 0.15)
                          : item.iconBgColor,
                    ),
                    child: Icon(item.icon, color: item.iconColor, size: 16.r),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      item.message,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark ? Colors.white70 : AppColors.textDarkNavy,
                        fontSize: 13.sp,
                      ),
                    ),
                  ),
                  if (item.time.isNotEmpty) ...[
                    SizedBox(width: 8.w),
                    Text(
                      item.time,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 11.sp,
                        color: isDark ? Colors.white38 : Colors.black38,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
