import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class DoctorKeyStatisticsCard extends StatefulWidget {
  const DoctorKeyStatisticsCard({super.key});

  @override
  State<DoctorKeyStatisticsCard> createState() => _DoctorKeyStatisticsCardState();
}

class _DoctorKeyStatisticsCardState extends State<DoctorKeyStatisticsCard> {
  String _selectedRange = "This Month";

  final List<String> _ranges = ["This Month", "This Week", "Today"];

  // Hardcoded mockup data for demo ranges
  final Map<String, Map<String, dynamic>> _mockData = {
    "This Month": {
      "total": "1,250",
      "totalTrend": "12% from last month",
      "today": "32",
      "todayTrend": "8% from yesterday",
      "completed": "28",
      "completedSub": "88% of today",
      "pending": "4",
      "pendingSub": "12% of today",
    },
    "This Week": {
      "total": "320",
      "totalTrend": "5% from last week",
      "today": "30",
      "todayTrend": "4% from yesterday",
      "completed": "25",
      "completedSub": "83% of today",
      "pending": "5",
      "pendingSub": "17% of today",
    },
    "Today": {
      "total": "32",
      "totalTrend": "0% change",
      "today": "32",
      "todayTrend": "0% change",
      "completed": "28",
      "completedSub": "88% of today",
      "pending": "4",
      "pendingSub": "12% of today",
    }
  };

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final borderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final textColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;

    final data = _mockData[_selectedRange]!;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with dropdown filter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Key Statistics",
                style: AppTextStyles.titleMedium.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                ),
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedRange,
                  dropdownColor: cardBg,
                  icon: Icon(Icons.keyboard_arrow_down, color: labelColor, size: 16.sp),
                  style: TextStyle(
                    color: textColor,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedRange = newValue;
                      });
                    }
                  },
                  items: _ranges.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // 2x2 Grid of stats
          Row(
            children: [
              Expanded(
                child: _buildStatTile(
                  title: "Total Patients",
                  value: data["total"] as String,
                  trendText: data["totalTrend"] as String,
                  trendColor: const Color(0xFF0F9F58),
                  isPositive: true,
                  labelColor: labelColor,
                  textColor: textColor,
                  borderColor: borderColor,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStatTile(
                  title: "Today's Patients",
                  value: data["today"] as String,
                  trendText: data["todayTrend"] as String,
                  trendColor: const Color(0xFF0F9F58),
                  isPositive: true,
                  labelColor: labelColor,
                  textColor: textColor,
                  borderColor: borderColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _buildStatTile(
                  title: "Completed",
                  value: data["completed"] as String,
                  trendText: data["completedSub"] as String,
                  trendColor: const Color(0xFF0F9F58),
                  isPositive: true,
                  isSubtextOnly: true,
                  labelColor: labelColor,
                  textColor: textColor,
                  borderColor: borderColor,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildStatTile(
                  title: "Pending",
                  value: data["pending"] as String,
                  trendText: data["pendingSub"] as String,
                  trendColor: AppColors.warning,
                  isPositive: false,
                  isSubtextOnly: true,
                  labelColor: labelColor,
                  textColor: textColor,
                  borderColor: borderColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatTile({
    required String title,
    required String value,
    required String trendText,
    required Color trendColor,
    required bool isPositive,
    bool isSubtextOnly = false,
    required Color labelColor,
    required Color textColor,
    required Color borderColor,
  }) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: labelColor,
              fontSize: 11.sp,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            value,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            children: [
              if (!isSubtextOnly) ...[
                Icon(
                  isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                  color: trendColor,
                  size: 10.sp,
                ),
                SizedBox(width: 2.w),
              ],
              Expanded(
                child: Text(
                  trendText,
                  style: TextStyle(
                    color: trendColor,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
