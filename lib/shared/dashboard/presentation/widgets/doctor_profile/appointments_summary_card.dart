import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

import 'package:medi_connect/shared/auth/data/models/user_model.dart';

class AppointmentsSummaryCard extends StatefulWidget {
  final UserModel user;
  const AppointmentsSummaryCard({super.key, required this.user});

  @override
  State<AppointmentsSummaryCard> createState() =>
      _AppointmentsSummaryCardState();
}

class _AppointmentsSummaryCardState extends State<AppointmentsSummaryCard> {
  String _selectedRange = "Today";

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark
        ? AppColors.terminalDarkCard
        : AppColors.terminalLightCard;
    final borderColor = isDark
        ? AppColors.terminalDarkBorder
        : AppColors.terminalLightBorder;
    final textColor = isDark
        ? AppColors.terminalDarkText
        : AppColors.terminalLightText;
    final labelColor = isDark
        ? AppColors.terminalDarkLabel
        : AppColors.terminalLightLabel;

    final List<Map<String, dynamic>> consultations = [];

    consultations.addAll([
      {"status": "Completed"},
      {"status": "Completed"},
      {"status": "Completed"},
      {"status": "Booked"},
      {"status": "Pending"},
      {"status": "Booked"},
      {"status": "Pending"},
    ]);

    final completedCount = consultations
        .where((c) => c['status'] == 'Completed')
        .length;
    final pendingCount = consultations
        .where((c) => c['status'] == 'Pending' || c['status'] == 'Booked')
        .length;
    final totalToday = consultations.length;

    int totalVal;
    int upcomingVal;
    int cancelledVal = 0;
    int noShowVal = 0;

    if (_selectedRange == "Today") {
      totalVal = totalToday;
      upcomingVal = pendingCount;
    } else if (_selectedRange == "This Week") {
      totalVal = totalToday * 5;
      upcomingVal = pendingCount * 4;
      cancelledVal = 1;
      noShowVal = 1;
    } else {
      // This Month
      totalVal = totalToday * 20;
      upcomingVal = pendingCount * 15;
      cancelledVal = 3;
      noShowVal = 2;
    }

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Appointments Summary",
                style: AppTextStyles.titleMedium.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 13.sp,
                ),
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedRange,
                  dropdownColor: cardBg,
                  icon: Icon(
                    Icons.arrow_drop_down,
                    color: labelColor,
                    size: 14.sp,
                  ),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  onChanged: (val) => setState(() => _selectedRange = val!),
                  items: ["Today", "This Week", "This Month"].map((val) {
                    return DropdownMenuItem<String>(
                      value: val,
                      child: Text(val),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Stats list
          _buildStatRow(
            Icons.calendar_today_outlined,
            "Today's Appointments",
            "$totalVal",
            AppColors.primary,
            labelColor,
            textColor,
          ),
          _buildDivider(borderColor),
          _buildStatRow(
            Icons.double_arrow,
            "Upcoming",
            "$upcomingVal",
            const Color(0xFF00C2A8),
            labelColor,
            textColor,
          ),
          _buildDivider(borderColor),
          _buildStatRow(
            Icons.cancel_outlined,
            "Cancelled",
            "$cancelledVal",
            AppColors.error,
            labelColor,
            textColor,
          ),
          _buildDivider(borderColor),
          _buildStatRow(
            Icons.person_off_outlined,
            "No Show",
            "$noShowVal",
            AppColors.warning,
            labelColor,
            textColor,
          ),
          SizedBox(height: 16.h),
          // View link
          Center(
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Loading Appointments Page...")),
                );
              },
              child: Text(
                "View All Appointments",
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 11.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider(Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Divider(color: color, height: 1),
    );
  }

  Widget _buildStatRow(
    IconData icon,
    String label,
    String value,
    Color iconColor,
    Color labelColor,
    Color textColor,
  ) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: iconColor),
        SizedBox(width: 8.w),
        Text(
          label,
          style: TextStyle(color: labelColor, fontSize: 11.sp),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }
}
