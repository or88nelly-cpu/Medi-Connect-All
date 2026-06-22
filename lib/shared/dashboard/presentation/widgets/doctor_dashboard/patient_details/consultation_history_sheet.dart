import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/shared/dashboard/domain/entities/appointment_entity.dart';

class ConsultationHistorySheet extends StatelessWidget {
  final List<AppointmentEntity> appointments;
  final String patientName;

  const ConsultationHistorySheet({
    super.key,
    required this.appointments,
    required this.patientName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Filter and sort consultations to get the recent 5
    final recentConsultations = List<AppointmentEntity>.from(appointments)
      ..sort((a, b) {
        final dateCompare = b.appointmentDate.compareTo(a.appointmentDate);
        if (dateCompare != 0) return dateCompare;
        return b.appointmentTime.compareTo(a.appointmentTime);
      });

    // Take the top 5
    final top5 = recentConsultations.take(5).toList();

    final sheetBg = isDark ? AppColors.terminalDarkCard : Colors.white;
    final primaryText = isDark ? Colors.white : AppColors.textDarkNavy;
    final secondaryText = isDark
        ? Colors.white54
        : AppColors.textSecondary(context);
    final borderCol = AppColors.border(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (ctx, scrollCtrl) {
        return Container(
          decoration: BoxDecoration(
            color: sheetBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              SizedBox(height: 12.h),
              // Grab handle
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 16.h),

              // Title and Close
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.consultationHistory,
                            style: AppTextStyles.titleLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: primaryText,
                              fontSize: 18.sp,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "Recent 5 consultations for $patientName",
                            style: AppTextStyles.bodySmall.copyWith(
                              color: secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      color: secondaryText,
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              const Divider(),

              // Consultation list
              Expanded(
                child: top5.isEmpty
                    ? Center(
                        child: Text(
                          "No consultations found.",
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: secondaryText,
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: scrollCtrl,
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        itemCount: top5.length,
                        itemBuilder: (ctx, index) {
                          final apt = top5[index];
                          final dateFormatted = DateFormat(
                            'dd MMMM yyyy',
                          ).format(apt.appointmentDate);
                          final bgCard = isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFF8FAFC);

                          return Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            padding: EdgeInsets.all(16.r),
                            decoration: BoxDecoration(
                              color: bgCard,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(color: borderCol),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(6.r),
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Color(0xFFF3E8FF),
                                          ),
                                          child: Icon(
                                            Icons.favorite_border_rounded,
                                            color: const Color(0xFF7E22CE),
                                            size: 16.r,
                                          ),
                                        ),
                                        SizedBox(width: 8.w),
                                        Text(
                                          apt.specialty,
                                          style: AppTextStyles.bodyMedium
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: isDark
                                                    ? Colors.white
                                                    : AppColors.textDarkNavy,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 8.w,
                                        vertical: 2.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getStatusBgColor(
                                          apt.status,
                                          isDark,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                      ),
                                      child: Text(
                                        apt.status,
                                        style: TextStyle(
                                          color: _getStatusTextColor(
                                            apt.status,
                                            isDark,
                                          ),
                                          fontSize: 9.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildInfoText(
                                      icon: Icons.calendar_today_outlined,
                                      label: AppStrings.dateLabel,
                                      value: dateFormatted,
                                      isDark: isDark,
                                    ),
                                    _buildInfoText(
                                      icon: Icons.access_time_rounded,
                                      label: AppStrings.timeSlot,
                                      value: apt.appointmentTime,
                                      isDark: isDark,
                                    ),
                                    _buildInfoText(
                                      icon:
                                          apt.type.toLowerCase().contains(
                                            "video",
                                          )
                                          ? Icons.videocam_outlined
                                          : Icons.meeting_room_outlined,
                                      label: AppStrings.typeLabel,
                                      value: apt.type,
                                      isDark: isDark,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoText({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: AppColors.primary, size: 14.r),
        SizedBox(width: 4.w),
        Column(
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
            ),
          ],
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
