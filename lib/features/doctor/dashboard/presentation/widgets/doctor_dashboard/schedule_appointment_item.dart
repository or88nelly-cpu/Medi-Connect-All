import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/functions/profile_image_helper.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/features/common/dashboard/domain/entities/appointment_entity.dart';
import 'package:medi_connect/features/doctor/dashboard/presentation/widgets/doctor_dashboard/schedule_timeline_indicator.dart';

class ScheduleAppointmentItem extends StatelessWidget {
  final AppointmentEntity appointment;
  final int index;
  final int totalCount;
  final bool isDark;
  final VoidCallback onTap;
  final VoidCallback onCancel;
  final VoidCallback onComplete;
  final String? patientPhoto;
  final String? patientGender;

  const ScheduleAppointmentItem({
    super.key,
    required this.appointment,
    required this.index,
    required this.totalCount,
    required this.isDark,
    required this.onTap,
    required this.onCancel,
    required this.onComplete,
    this.patientPhoto,
    this.patientGender,
  });

  @override
  Widget build(BuildContext context) {
    final timeParts = appointment.appointmentTime.split(" ");
    final timeVal = timeParts[0];
    final timePeriod = timeParts.length > 1 ? timeParts[1] : "";
    final textCol = isDark ? Colors.white : AppColors.textDarkNavy;

    final isBlocked = appointment.status == 'Blocked' || appointment.type == 'Blocked';

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Time Column
          SizedBox(
            width: 60.w,
            child: Padding(
              padding: EdgeInsets.only(top: 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    timeVal,
                    style: TextStyle(
                      color: textCol,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    timePeriod,
                    style: TextStyle(
                      color: isDark ? Colors.white38 : Colors.grey[500],
                      fontSize: 9.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // 2. Timeline vertical indicator
          ScheduleTimelineIndicator(
            color: isBlocked
                ? const Color(0xFFEF4444)
                : _getStatusColor(appointment.status),
            index: index,
            totalCount: totalCount,
          ),

          // 3. Card Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: isBlocked
                  ? _buildBlockedSlotCard(context)
                  : _buildPatientAppointmentCard(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlockedSlotCard(BuildContext context) {
    final bg = isDark
        ? const Color(0xFF881337).withValues(alpha: 0.1)
        : const Color(0xFFFFF1F2);
    final border = isDark ? Colors.white10 : const Color(0xFFFDA4AF);

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          // Doctor Unavailable Sign Mock Illustration
          Container(
            width: 52.r,
            height: 52.r,
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFFCA5A5)),
            ),
            child: Icon(Icons.block, color: const Color(0xFFEF4444), size: 24.r),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "DOCTOR UNAVAILABLE",
                  style: TextStyle(
                    color: const Color(0xFFEF4444),
                    fontSize: 8.5.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "Slot blocked by Doctor",
                  style: TextStyle(
                    color: isDark ? Colors.white : AppColors.textDarkNavy,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  "Doctor is not available at this time. Please choose another slot.",
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.grey[500],
                    fontSize: 9.sp,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFCA5A5).withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Text(
              "Blocked",
              style: TextStyle(color: const Color(0xFFB91C1C), fontSize: 9.sp, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientAppointmentCard(BuildContext context) {
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textCol = isDark ? Colors.white : AppColors.textDarkNavy;
    final secondaryTextCol = isDark ? Colors.white38 : Colors.grey[500];

    // Map status colors/badges
    Color statusBadgeBg = const Color(0xFFFFF7ED);
    Color statusBadgeText = const Color(0xFFC2410C);
    if (appointment.status.toLowerCase() == 'completed') {
      statusBadgeBg = const Color(0xFFF0FDF4);
      statusBadgeText = const Color(0xFF15803D);
    } else if (appointment.status.toLowerCase() == 'confirmed') {
      statusBadgeBg = const Color(0xFFEFF6FF);
      statusBadgeText = const Color(0xFF1D4ED8);
    }

    final token = appointment.token ?? 'SPA716';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
        ),
        child: Row(
          children: [
            // Patient Avatar
            CircleAvatar(
              radius: 20.r,
              backgroundColor: isDark ? Colors.white10 : Colors.grey[100],
              backgroundImage: ProfileImageHelper.getAvatarImage(
                patientPhoto,
                'patient',
                patientGender,
              ),
            ),
            SizedBox(width: 12.w),
            // Middle Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    appointment.patientName,
                    style: TextStyle(
                      color: textCol,
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Row(
                    children: [
                      Icon(Icons.dashboard_customize_outlined, size: 10.r, color: const Color(0xFF8B5CF6)),
                      SizedBox(width: 4.w),
                      Text(
                        appointment.specialty,
                        style: TextStyle(color: secondaryTextCol, fontSize: 9.sp),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.person_outline, size: 10.r, color: Colors.grey),
                      SizedBox(width: 4.w),
                      Text(
                        appointment.doctorName,
                        style: TextStyle(color: secondaryTextCol, fontSize: 9.sp),
                      ),
                    ],
                  ),
                  SizedBox(height: 6.h),
                  Row(
                    children: [
                      // OPD Token Badge
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          "OPD - $token",
                          style: TextStyle(color: const Color(0xFF1D4ED8), fontSize: 8.5.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(width: 6.w),
                      // Status Badge
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: statusBadgeBg,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          appointment.status,
                          style: TextStyle(color: statusBadgeText, fontSize: 8.5.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Right Side
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 16),
                  onSelected: (val) {
                    if (val == 'cancel') onCancel();
                    if (val == 'complete') onComplete();
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'complete', child: Text("Complete")),
                    const PopupMenuItem(value: 'cancel', child: Text("Cancel")),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      appointment.status.toLowerCase() == 'completed'
                          ? Icons.check_circle
                          : Icons.access_time,
                      size: 11.r,
                      color: appointment.status.toLowerCase() == 'completed'
                          ? const Color(0xFF10B981)
                          : const Color(0xFFF59E0B),
                    ),
                    SizedBox(width: 2.w),
                    Text(
                      appointment.appointmentTime,
                      style: TextStyle(
                        color: textCol,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF10B981);
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'cancelled':
        return const Color(0xFFEF4444);
      case 'confirmed':
        return const Color(0xFF3B82F6);
      default:
        return const Color(0xFF8B5CF6);
    }
  }
}
