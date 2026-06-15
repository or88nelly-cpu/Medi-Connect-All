import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

import 'package:medi_connect/features/auth/data/models/user_model.dart';

class ConsultationSummaryCard extends StatefulWidget {
  final UserModel user;
  const ConsultationSummaryCard({super.key, required this.user});

  @override
  State<ConsultationSummaryCard> createState() =>
      _ConsultationSummaryCardState();
}

class _ConsultationSummaryCardState extends State<ConsultationSummaryCard> {
  String _selectedRange = "This Month";

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

    final metadataConsultations =
        widget.user.metadata?['consultations'] as List<dynamic>?;
    final List<Map<String, dynamic>> consultations = [];
    if (metadataConsultations != null) {
      for (var item in metadataConsultations) {
        if (item is Map) {
          consultations.add({
            'status': (item['status'] ?? '').toString(),
            'mode': (item['mode'] ?? '').toString(),
          });
        }
      }
    } else {
      consultations.addAll([
        {"status": "Completed", "mode": "Video"},
        {"status": "Completed", "mode": "Audio"},
        {"status": "Completed", "mode": "Video"},
        {"status": "Booked", "mode": "Video"},
        {"status": "Pending", "mode": "Audio"},
        {"status": "Booked", "mode": "Video"},
        {"status": "Pending", "mode": "Audio"},
      ]);
    }

    final totalCount = consultations.length;
    final completedCount = consultations
        .where((c) => c['status'] == 'Completed')
        .length;
    final videoCount = consultations.where((c) => c['mode'] == 'Video').length;
    final audioCount = consultations.where((c) => c['mode'] == 'Audio').length;

    int totalVal;
    int completedVal;
    int videoVal;
    int audioVal;

    if (_selectedRange == "Today") {
      totalVal = totalCount;
      completedVal = completedCount;
      videoVal = videoCount;
      audioVal = audioCount;
    } else if (_selectedRange == "This Week") {
      totalVal = totalCount * 5;
      completedVal = completedCount * 4;
      videoVal = videoCount * 5;
      audioVal = audioCount * 5;
    } else {
      // This Month
      totalVal = totalCount * 20;
      completedVal = completedCount * 18;
      videoVal = videoCount * 20;
      audioVal = audioCount * 20;
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
                "Consultation Summary",
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
                  items: ["This Month", "This Week", "Today"].map((val) {
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
            Icons.people_outline,
            "Total Consultations",
            "$totalVal",
            const Color(0xFF9C27B0),
            labelColor,
            textColor,
          ),
          _buildDivider(borderColor),
          _buildStatRow(
            Icons.check_circle_outline,
            "Completed",
            "$completedVal",
            const Color(0xFF0F9F58),
            labelColor,
            textColor,
          ),
          _buildDivider(borderColor),
          _buildStatRow(
            Icons.videocam_outlined,
            "Video Consultations",
            "$videoVal",
            AppColors.primary,
            labelColor,
            textColor,
          ),
          _buildDivider(borderColor),
          _buildStatRow(
            Icons.phone_outlined,
            "Audio Consultations",
            "$audioVal",
            const Color(0xFF00C2A8),
            labelColor,
            textColor,
          ),
          SizedBox(height: 16.h),
          // View link
          Center(
            child: InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Loading consultation detailed report..."),
                  ),
                );
              },
              child: Text(
                "View Detailed Report",
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
