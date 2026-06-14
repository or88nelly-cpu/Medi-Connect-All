import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/dash_board/domain/entities/appointment_entity.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/utils/profile_image_helper.dart';
import 'package:medi_connect/core/common_widgets/buttons/gradient_button.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentEntity appointment;
  final VoidCallback onCancel;
  final VoidCallback onComplete;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onCancel,
    required this.onComplete,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Completed':
        return Colors.purple;
      case 'Cancelled':
      default:
        return Colors.red;
    }
  }

  Color _getChipBgColor(String patientId, bool isDark) {
    final colors = [Colors.blue, Colors.green, Colors.orange, Colors.purple];
    final index = patientId.hashCode.abs() % colors.length;
    final baseColor = colors[index];
    return isDark ? baseColor.withOpacity(0.15) : baseColor.withOpacity(0.08);
  }

  Color _getChipTextColor(String patientId) {
    final colors = [
      Colors.blue[700]!,
      Colors.green[700]!,
      Colors.orange[700]!,
      Colors.purple[700]!,
    ];
    final index = patientId.hashCode.abs() % colors.length;
    return colors[index];
  }

  String _cleanDoctorName(String raw) {
    String cleaned = raw.trim();
    if (cleaned.toLowerCase().startsWith('dr.')) {
      cleaned = cleaned.substring(3).trim();
    } else if (cleaned.toLowerCase().startsWith('dr')) {
      cleaned = cleaned.substring(2).trim();
    }
    return 'Dr. $cleaned';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = _getStatusColor(appointment.status);
    final formattedDate = DateFormat(
      'dd MMM yyyy',
    ).format(appointment.appointmentDate);
    final shortId = (appointment.patientId?.length ?? 0) > 8
        ? appointment.patientId?.substring(0, 8).toUpperCase()
        : appointment.patientId?.toUpperCase();

    final docName = _cleanDoctorName(appointment.doctorName);

    // Status text styles
    final badgeBgColor = statusColor.withOpacity(0.1);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.terminalDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? AppColors.terminalDarkBorder : AppColors.border,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Vertical Left Status Bar Indicator
              Container(width: 4.w, color: statusColor),
              Expanded(
                child: Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    childrenPadding: EdgeInsets.fromLTRB(16.r, 0, 16.r, 16.r),
                    tilePadding: EdgeInsets.symmetric(
                      horizontal: 16.r,
                      vertical: 8.r,
                    ),
                    leading: CircleAvatar(
                      radius: 22.r,
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      child: ClipOval(
                        child: CustomImageView(
                          imagePath: ProfileImageHelper.resolveImagePath(
                            'https://api.dicebear.com/7.x/adventurer/png?seed=${Uri.encodeComponent(appointment.patientName)}',
                            'patient',
                            null,
                          ),
                          width: 44.r,
                          height: 44.r,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Patient name and ID tag
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appointment.patientName,
                                style: AppTextStyles.titleMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              // Patient ID Chip
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: _getChipBgColor(
                                    appointment?.patientId ?? "",
                                    isDark,
                                  ),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  "Patient ID: PAT-$shortId",
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    color: _getChipTextColor(
                                      appointment.patientId ?? "",
                                    ),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Status Badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: badgeBgColor,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            appointment.status,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 6.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (appointment.token != null &&
                              appointment.token!.isNotEmpty) ...[
                            Text(
                              "Token No:- ${appointment.token}",
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.accent
                                    : AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(height: 4.h),
                          ],
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                size: 12.r,
                                color: isDark
                                    ? Colors.white54
                                    : AppColors.textSecondary,
                              ),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: Text(
                                  "$docName (${appointment.specialty})",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: isDark
                                        ? Colors.white70
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          // Date / Time block
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 11.r,
                                color: isDark
                                    ? Colors.white30
                                    : AppColors.textSecondary.withOpacity(0.5),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: isDark
                                      ? Colors.white54
                                      : AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Icon(
                                Icons.access_time,
                                size: 11.r,
                                color: isDark
                                    ? Colors.white30
                                    : AppColors.textSecondary.withOpacity(0.5),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                appointment.appointmentTime,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: isDark
                                      ? Colors.white54
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    children: [
                      const Divider(height: 16),
                      // Consultation type
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                appointment.type == 'Video'
                                    ? Icons.video_call
                                    : Icons.local_hospital_outlined,
                                size: 14.r,
                                color: isDark
                                    ? Colors.white54
                                    : AppColors.textSecondary,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                appointment.type,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.white70
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          // Outlined Call Button
                          OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Calling ${appointment.patientName} at +91 9495123456...',
                                  ),
                                  backgroundColor: AppColors.primary,
                                ),
                              );
                            },
                            icon: const Icon(Icons.phone_outlined, size: 14),
                            label: const Text(
                              'Call',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary),
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 6.h,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      // Expandable actions based on status
                      if (appointment.status != 'Cancelled' &&
                          appointment.status != 'Completed')
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton.icon(
                              onPressed: onCancel,
                              icon: const Icon(
                                Icons.cancel_outlined,
                                size: 14,
                                color: AppColors.error,
                              ),
                              label: const Text(
                                'Cancel',
                                style: TextStyle(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 8.h,
                                ),
                                side: const BorderSide(color: AppColors.error),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6.r),
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            GradientButton(
                              text: 'Complete Consultation',
                              onPressed: onComplete,
                              width: 180.w,
                              height: 38.h,
                              borderRadius: 6.r,
                              gradientColors: const [
                                AppColors.success,
                                Color(0xFF2E7D32),
                              ],
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11.sp,
                              ),
                            ),
                          ],
                        ),
                      if (appointment.status == 'Completed')
                        Align(
                          alignment: Alignment.centerRight,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  size: 14,
                                  color: AppColors.success,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'Consultation Completed',
                                  style: TextStyle(
                                    color: AppColors.success,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
