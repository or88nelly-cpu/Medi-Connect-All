import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/shared/dashboard/domain/entities/appointment_entity.dart';

class RecentConsultationCard extends StatelessWidget {
  final AppointmentEntity? recentApt;
  final VoidCallback? onViewAll;

  const RecentConsultationCard({
    super.key,
    required this.recentApt,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : AppColors.textDarkNavy;
    final borderCol = AppColors.border(context);
    final cardBg = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFFAF9FE); // Lavender hint bg matching mockup

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.recentConsultation,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: titleColor,
                fontSize: 16.sp,
              ),
            ),
            GestureDetector(
              onTap: onViewAll,
              child: Row(
                children: [
                  Text(
                    AppStrings.viewAll,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 10.r,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // Card Content
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: borderCol),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.02),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: recentApt == null
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Text(
                      "No consultation records found with you.",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isDark
                            ? Colors.white38
                            : AppColors.textSecondary(context),
                      ),
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Row 1: Specialty & Status
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.all(8.r),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(
                                  0xFFF3E8FF,
                                ), // Lavender circle
                              ),
                              child: Icon(
                                Icons.favorite_border_rounded,
                                color: const Color(0xFF7E22CE), // Purple icon
                                size: 20.r,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Text(
                              recentApt!.specialty,
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? Colors.white
                                    : AppColors.textDarkNavy,
                              ),
                            ),
                          ],
                        ),

                        // Status Pill
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusBgColor(recentApt!.status, isDark),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            recentApt!.status,
                            style: TextStyle(
                              color: _getStatusTextColor(
                                recentApt!.status,
                                isDark,
                              ),
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 24, thickness: 0.8),

                    // Row 2: Three columns info row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Column 1: Date
                        Expanded(
                          child: _buildColumnInfo(
                            icon: Icons.calendar_today_outlined,
                            label: AppStrings.dateLabel,
                            value: DateFormat(
                              'dd MMMM yyyy',
                            ).format(recentApt!.appointmentDate),
                            isDark: isDark,
                          ),
                        ),

                        // Column 2: Time Slot
                        Expanded(
                          child: _buildColumnInfo(
                            icon: Icons.access_time_rounded,
                            label: AppStrings.timeSlot,
                            value: recentApt!.appointmentTime,
                            isDark: isDark,
                          ),
                        ),

                        // Column 3: Type
                        Expanded(
                          child: _buildColumnInfo(
                            icon:
                                recentApt!.type.toLowerCase().contains("video")
                                ? Icons.videocam_outlined
                                : Icons.meeting_room_outlined,
                            label: AppStrings.typeLabel,
                            value: recentApt!.type,
                            isDark: isDark,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _buildColumnInfo({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Rounded Icon
        Container(
          padding: EdgeInsets.all(6.r),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFFEFF6FF), // light blue bg
          ),
          child: Icon(
            icon,
            color: AppColors.primary, // blue icon
            size: 16.r,
          ),
        ),
        SizedBox(width: 8.w),

        // Label & Value Column
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: isDark ? Colors.white30 : Colors.grey[500],
                  fontSize: 8.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  color: isDark ? Colors.white70 : AppColors.textDarkNavy,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getStatusBgColor(String status, bool isDark) {
    switch (status) {
      case 'Confirmed':
        return isDark
            ? AppColors.statusConfirmedBgDark.withValues(alpha: 0.3)
            : AppColors.statusConfirmedBgLight;
      case 'Pending':
        return isDark
            ? AppColors.statusPendingBgDark.withValues(alpha: 0.3)
            : AppColors.statusPendingBgLight;
      case 'Completed':
        return isDark
            ? AppColors.statusCompletedBgDark.withValues(alpha: 0.3)
            : AppColors.statusCompletedBgLight;
      case 'Cancelled':
      default:
        return isDark
            ? AppColors.statusCancelledBgDark.withValues(alpha: 0.3)
            : AppColors.statusCancelledBgLight;
    }
  }

  Color _getStatusTextColor(String status, bool isDark) {
    switch (status) {
      case 'Confirmed':
        return isDark
            ? AppColors.statusConfirmedTextDark
            : AppColors.statusConfirmedTextLight;
      case 'Pending':
        return isDark
            ? AppColors.statusPendingTextDark
            : AppColors.statusPendingTextLight;
      case 'Completed':
        return isDark
            ? AppColors.statusCompletedTextDark
            : AppColors.statusCompletedTextLight;
      case 'Cancelled':
      default:
        return isDark
            ? AppColors.statusCancelledTextDark
            : AppColors.statusCancelledTextLight;
    }
  }
}
