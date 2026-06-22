import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/dashboard/domain/entities/appointment_entity.dart';

class AppointmentsOverviewSection extends StatelessWidget {
  final List<AppointmentEntity> appointments;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateChanged;

  const AppointmentsOverviewSection({
    super.key,
    required this.appointments,
    required this.selectedDate,
    required this.onDateChanged,
  });

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Filter appointments for the selected date
    final targetDateApts = appointments
        .where((a) => _isSameDay(a.appointmentDate, selectedDate))
        .toList();

    final total = targetDateApts.length;
    final confirmed = targetDateApts
        .where((a) => a.status == 'Confirmed')
        .length;
    final pending = targetDateApts.where((a) => a.status == 'Pending').length;
    final completed = targetDateApts
        .where((a) => a.status == 'Completed')
        .length;

    final formattedDate = DateFormat('dd MMM yyyy').format(selectedDate);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Selector Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Today's Overview",
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
                color: isDark ? Colors.white : AppColors.textPrimary(context),
              ),
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.chevron_left, size: 16.r),
                  onPressed: () {
                    onDateChanged(
                      selectedDate.subtract(const Duration(days: 1)),
                    );
                  },
                ),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) {
                      onDateChanged(picked);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.terminalDarkCard : Colors.white,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: AppColors.border(context)),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.calendar_today,
                          size: 12.r,
                          color: AppColors.primary,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          formattedDate,
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? Colors.white70
                                : AppColors.textPrimary(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.chevron_right, size: 16.r),
                  onPressed: () {
                    onDateChanged(selectedDate.add(const Duration(days: 1)));
                  },
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 8.h),

        // Overview Cards Row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              _buildOverviewCard(
                context,
                title: "Appointments",
                value: total.toString(),
                icon: Icons.calendar_today_outlined,
                color: Colors.blue,
                isDark: isDark,
              ),
              _buildOverviewCard(
                context,
                title: "Confirmed",
                value: confirmed.toString(),
                icon: Icons.check_circle_outline,
                color: Colors.green,
                isDark: isDark,
              ),
              _buildOverviewCard(
                context,
                title: "Pending",
                value: pending.toString(),
                icon: Icons.access_time,
                color: Colors.orange,
                isDark: isDark,
              ),
              _buildOverviewCard(
                context,
                title: "Completed",
                value: completed.toString(),
                icon: Icons.check_circle,
                color: Colors.purple,
                isDark: isDark,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      width: 120.w,
      margin: EdgeInsets.only(right: 12.w),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.terminalDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border(context)),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 18.r, color: color),
              ),
              Text(
                value,
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: isDark ? Colors.white : AppColors.terminalLightText,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            title,
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 10.sp,
              color: isDark
                  ? AppColors.terminalDarkLabel
                  : AppColors.terminalLightLabel,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
