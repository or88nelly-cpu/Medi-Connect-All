import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class EmrdListItemCard extends StatelessWidget {
  final Map<String, dynamic> record;
  final VoidCallback onTap;

  const EmrdListItemCard({
    super.key,
    required this.record,
    required this.onTap,
  });

  Color _getAvatarColor(String name) {
    final colors = [Colors.blue, Colors.green, Colors.purple, Colors.orange];
    final index = name.hashCode.abs() % colors.length;
    return colors[index];
  }

  String _cleanDoctorName(String? raw) {
    if (raw == null) return 'Unknown Doctor';
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
    final patientName = record['patient_name'] ?? 'Unknown Patient';
    final doctorName = _cleanDoctorName(record['doctor_name']);
    final specialty = record['specialty'] ?? 'General';
    final dateStr = record['recorded_at'] ?? record['created_at'] ?? '';

    String formattedDate = 'N/A';
    if (dateStr.isNotEmpty) {
      try {
        final dt = DateTime.parse(dateStr);
        formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(dt);
      } catch (_) {}
    }

    final avatarBgColor = _getAvatarColor(patientName);
    final initials = patientName.isNotEmpty
        ? patientName[0].toUpperCase()
        : 'P';

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.terminalDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12.r),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Row(
              children: [
                // Patient Avatar (Initials with color backgrounds matching mockups)
                CircleAvatar(
                  radius: 24.r,
                  backgroundColor: avatarBgColor.withValues(alpha: 0.12),
                  child: Text(
                    initials,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: avatarBgColor,
                    ),
                  ),
                ),
                SizedBox(width: 14.w),
                // Text details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        patientName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : AppColors.textPrimary(context),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        '$doctorName · $specialty',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isDark
                              ? Colors.white54
                              : AppColors.textSecondary(context),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            size: 11.r,
                            color: isDark
                                ? Colors.white30
                                : AppColors.textSecondary(
                                    context,
                                  ).withValues(alpha: 0.5),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            formattedDate,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 10.sp,
                              color: isDark
                                  ? Colors.white30
                                  : AppColors.textSecondary(
                                      context,
                                    ).withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 6.h),
                      Row(
                        children: [
                          // Completed badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1E3A20)
                                  : const Color(0xFFE8F5E9),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.check,
                                  size: 10.r,
                                  color: Colors.green,
                                ),
                                SizedBox(width: 2.w),
                                Text(
                                  "Completed",
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          // EMR Created badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1E2D3E)
                                  : const Color(0xFFE0F2FE),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              "EMR Created",
                              style: TextStyle(
                                fontSize: 9.sp,
                                color: Colors.blue,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Folder button on right
                GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      Icons.folder_open_outlined,
                      color: AppColors.primary,
                      size: 20.r,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                // Chevron icon
                Icon(
                  Icons.arrow_forward_ios,
                  size: 12.r,
                  color: isDark
                      ? Colors.white24
                      : AppColors.textSecondary(context).withValues(alpha: 0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
