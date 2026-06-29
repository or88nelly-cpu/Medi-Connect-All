import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/dashboard/domain/entities/appointment_entity.dart';

class ConsultationListItem extends StatelessWidget {
  final AppointmentEntity appointment;
  final VoidCallback onRecordVitals;
  final VoidCallback onComplete;
  final VoidCallback onViewDetails;

  const ConsultationListItem({
    super.key,
    required this.appointment,
    required this.onRecordVitals,
    required this.onComplete,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = _getStatusColor(appointment.status);

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Header / Status / Patient Name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  appointment.patientName,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.sp,
                    color: isDark
                        ? Colors.white
                        : AppColors.textPrimary(context),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  appointment.status,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 10.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),

          // Row 2: Doctor info
          Row(
            children: [
              Icon(
                Icons.person_outline_rounded,
                size: 16.r,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
              SizedBox(width: 6.w),
              Text(
                appointment.doctorName,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w500,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              Text(
                " | ${appointment.specialty}",
                style: AppTextStyles.bodySmall.copyWith(
                  color: isDark ? Colors.white38 : Colors.black45,
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),

          // Row 3: Slot Time
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 16.r,
                color: isDark ? Colors.white60 : Colors.black54,
              ),
              SizedBox(width: 6.w),
              Text(
                appointment.appointmentTime,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(width: 14.w),
              Icon(
                Icons.calendar_today_outlined,
                size: 14.r,
                color: isDark ? Colors.white38 : Colors.black45,
              ),
              SizedBox(width: 4.w),
              Text(
                "${appointment.appointmentDate.day}/${appointment.appointmentDate.month}/${appointment.appointmentDate.year}",
                style: AppTextStyles.bodySmall.copyWith(
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
            ],
          ),

          // Divider
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            child: Divider(color: AppColors.border(context), height: 1),
          ),

          // Vitals Summary Section
          _buildVitalsSummary(context, isDark),

          SizedBox(height: 14.h),

          // Action Buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: onViewDetails,
                icon: Icon(Icons.info_outline, size: 16.r),
                label: const Text("Details"),
                style: TextButton.styleFrom(
                  foregroundColor: isDark ? Colors.white70 : Colors.black87,
                ),
              ),
              const Spacer(),
              if (appointment.status.toLowerCase() != 'completed' &&
                  appointment.status.toLowerCase() != 'cancelled') ...[
                OutlinedButton.icon(
                  onPressed: onRecordVitals,
                  icon: Icon(Icons.monitor_heart_outlined, size: 16.r),
                  label: const Text("Vitals"),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                ElevatedButton.icon(
                  onPressed: onComplete,
                  icon: Icon(
                    Icons.check_circle_outline,
                    size: 16.r,
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Complete",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981), // success green
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVitalsSummary(BuildContext context, bool isDark) {
    final hasVitals =
        appointment.bp != null ||
        appointment.weight != null ||
        appointment.height != null ||
        appointment.fever != null;

    if (!hasVitals) {
      return Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.05)
                  : Colors.black.withValues(alpha: 0.04),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.monitor_heart_outlined,
                  size: 14.r,
                  color: isDark ? Colors.white38 : Colors.black45,
                ),
                SizedBox(width: 4.w),
                Text(
                  "No Vitals Recorded",
                  style: TextStyle(
                    fontSize: 10.sp,
                    color: isDark ? Colors.white38 : Colors.black45,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    }

    final List<String> parts = [];
    if (appointment.bp != null && appointment.bp!.isNotEmpty)
      parts.add("BP: ${appointment.bp}");
    if (appointment.weight != null && appointment.weight!.isNotEmpty)
      parts.add("Wt: ${appointment.weight}");
    if (appointment.height != null && appointment.height!.isNotEmpty)
      parts.add("Ht: ${appointment.height}");
    if (appointment.fever != null && appointment.fever!.isNotEmpty)
      parts.add("Temp: ${appointment.fever}");

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Vitals Summary",
            style: TextStyle(
              fontSize: 10.sp,
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 4.h,
            children: parts.map((vital) {
              return Text(
                vital,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 11.sp,
                  color: isDark ? Colors.white70 : Colors.black87,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF10B981);
      case 'scheduled':
        return const Color(0xFF3B5BFF);
      case 'cancelled':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFFF59E0B);
    }
  }
}
