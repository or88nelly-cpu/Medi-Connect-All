import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

import 'package:medi_connect/shared/auth/data/models/user_model.dart';

class RevenueSummaryCard extends StatefulWidget {
  final UserModel user;
  const RevenueSummaryCard({super.key, required this.user});

  @override
  State<RevenueSummaryCard> createState() => _RevenueSummaryCardState();
}

class _RevenueSummaryCardState extends State<RevenueSummaryCard> {
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

    final double fee = widget.user.consultationFee ?? 800.0;

    final metadataConsultations =
        widget.user.metadata?['consultations'] as List<dynamic>?;
    final List<Map<String, dynamic>> consultations = [];
    if (metadataConsultations != null) {
      for (var item in metadataConsultations) {
        if (item is Map) {
          consultations.add({'status': (item['status'] ?? '').toString()});
        }
      }
    } else {
      consultations.addAll([
        {"status": "Completed"},
        {"status": "Completed"},
        {"status": "Completed"},
        {"status": "Booked"},
        {"status": "Pending"},
        {"status": "Booked"},
        {"status": "Pending"},
      ]);
    }

    final completedCount = consultations
        .where((c) => c['status'] == 'Completed')
        .length;
    final pendingCount = consultations
        .where((c) => c['status'] == 'Pending' || c['status'] == 'Booked')
        .length;

    double todayRev = completedCount * fee;
    double monthlyRev = completedCount * fee * 20;
    double pendingRev = pendingCount * fee;

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
                "Revenue Summary",
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
            Icons.payments_outlined,
            "Consultation Fee",
            "₹${fee.toStringAsFixed(0)}",
            const Color(0xFF00C2A8),
            labelColor,
            textColor,
          ),
          _buildDivider(borderColor),
          _buildStatRow(
            Icons.monetization_on_outlined,
            "Today's Revenue",
            "₹${todayRev.toStringAsFixed(0)}",
            const Color(0xFF0F9F58),
            labelColor,
            textColor,
          ),
          _buildDivider(borderColor),
          _buildStatRow(
            Icons.account_balance_wallet_outlined,
            "Monthly Revenue",
            "₹${monthlyRev.toStringAsFixed(0)}",
            AppColors.primary,
            labelColor,
            textColor,
          ),
          _buildDivider(borderColor),
          _buildStatRow(
            Icons.history_toggle_off,
            "Pending Payments",
            "₹${pendingRev.toStringAsFixed(0)}",
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
                  const SnackBar(
                    content: Text("Loading financial statement details..."),
                  ),
                );
              },
              child: Text(
                "View Financial Report",
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
