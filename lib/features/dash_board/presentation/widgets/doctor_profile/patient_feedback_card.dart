import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

import 'package:medi_connect/features/auth/data/models/user_model.dart';

class PatientFeedbackCard extends StatefulWidget {
  final UserModel user;
  const PatientFeedbackCard({super.key, required this.user});

  @override
  State<PatientFeedbackCard> createState() => _PatientFeedbackCardState();
}

class _PatientFeedbackCardState extends State<PatientFeedbackCard> {
  String _selectedRange = "This Month";

  final List<Map<String, dynamic>> _ratingDistribution = [
    {"stars": "5 Stars", "count": 98, "pct": "76%", "val": 0.76, "color": const Color(0xFF0F9F58)},
    {"stars": "4 Stars", "count": 22, "pct": "17%", "val": 0.17, "color": const Color(0xFF0F9F58)},
    {"stars": "3 Stars", "count": 6, "pct": "05%", "val": 0.05, "color": const Color(0xFF00C2A8)},
    {"stars": "2 Stars", "count": 2, "pct": "02%", "val": 0.02, "color": AppColors.warning},
    {"stars": "1 Star", "count": 0, "pct": "00%", "val": 0.0, "color": AppColors.error},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final borderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final textColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;

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
                "Patient Feedback",
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
                  icon: Icon(Icons.arrow_drop_down, color: labelColor, size: 14.sp),
                  style: TextStyle(color: textColor, fontSize: 10.sp, fontWeight: FontWeight.bold),
                  onChanged: (val) => setState(() => _selectedRange = val!),
                  items: ["This Month", "This Week", "Today"].map((val) {
                    return DropdownMenuItem<String>(value: val, child: Text(val));
                  }).toList(),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Content Layout: Left rating summary, Right bar chart distribution
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left side
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "4.8",
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 28.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(5, (index) {
                        return Icon(
                          Icons.star,
                          color: index < 4 ? Colors.amber : Colors.grey.shade400,
                          size: 14.sp,
                        );
                      }),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      "Based on 128 reviews",
                      style: TextStyle(
                        color: labelColor,
                        fontSize: 9.sp,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              // Right side progress distribution
              Expanded(
                flex: 3,
                child: Column(
                  children: _ratingDistribution.map((item) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 4.h),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 36.w,
                            child: Text(
                              item["stars"] as String,
                              style: TextStyle(color: labelColor, fontSize: 8.sp),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(2.r),
                              child: SizedBox(
                                height: 4.h,
                                child: LinearProgressIndicator(
                                  value: item["val"] as double,
                                  backgroundColor: borderColor,
                                  valueColor: AlwaysStoppedAnimation<Color>(item["color"] as Color),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 6.w),
                          SizedBox(
                            width: 38.w,
                            child: Text(
                              "${item["count"]} (${item["pct"]})",
                              style: TextStyle(color: labelColor, fontSize: 8.sp),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // View link
          Center(
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Loading all patient feedback reviews...")),
                );
              },
              child: Text(
                "View All Feedback",
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
}
