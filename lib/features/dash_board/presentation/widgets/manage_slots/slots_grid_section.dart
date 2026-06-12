import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';

class SlotsGridSection extends StatefulWidget {
  final Function(List<Map<String, dynamic>> morningSlots, List<Map<String, dynamic>> afternoonSlots)? onSlotsChanged;

  const SlotsGridSection({super.key, this.onSlotsChanged});

  @override
  State<SlotsGridSection> createState() => _SlotsGridSectionState();
}

class _SlotsGridSectionState extends State<SlotsGridSection> {
  bool _morningExpanded = true;
  bool _afternoonExpanded = true;

  late List<Map<String, dynamic>> _morningSlots;
  late List<Map<String, dynamic>> _afternoonSlots;

  @override
  void initState() {
    super.initState();
    _initializeSlots();
  }

  void _initializeSlots() {
    _morningSlots = [
      {"time": "09:00 AM", "status": "Available"},
      {"time": "09:10 AM", "status": "Available"},
      {"time": "09:20 AM", "status": "Available"},
      {"time": "09:30 AM", "status": "Available"},
      {"time": "09:40 AM", "status": "Available"},
      {"time": "09:50 AM", "status": "Available"},

      {"time": "10:00 AM", "status": "Available"},
      {"time": "10:10 AM", "status": "Available"},
      {"time": "10:20 AM", "status": "Available"},
      {"time": "10:30 AM", "status": "Booked"},
      {"time": "10:40 AM", "status": "Available"},
      {"time": "10:50 AM", "status": "Available"},

      {"time": "11:00 AM", "status": "Available"},
      {"time": "11:10 AM", "status": "Available"},
      {"time": "11:20 AM", "status": "Available"},
      {"time": "11:30 AM", "status": "Blocked"},
      {"time": "11:40 AM", "status": "Available"},
      {"time": "11:50 AM", "status": "Available"},

      {"time": "12:00 PM", "status": "Available"},
      {"time": "12:10 PM", "status": "Available"},
      {"time": "12:20 PM", "status": "On Hold"},
      {"time": "12:30 PM", "status": "Available"},
      {"time": "12:40 PM", "status": "Available"},
      {"time": "12:50 PM", "status": "Available"},
    ];

    _afternoonSlots = [
      {"time": "02:00 PM", "status": "Available"},
      {"time": "02:10 PM", "status": "Available"},
      {"time": "02:20 PM", "status": "Booked"},
      {"time": "02:30 PM", "status": "Available"},
      {"time": "02:40 PM", "status": "Available"},
      {"time": "02:50 PM", "status": "Available"},

      {"time": "03:00 PM", "status": "Available"},
      {"time": "03:10 PM", "status": "Available"},
      {"time": "03:20 PM", "status": "On Hold"},
      {"time": "03:30 PM", "status": "Available"},
      {"time": "03:40 PM", "status": "Available"},
      {"time": "03:50 PM", "status": "Blocked"},

      {"time": "04:00 PM", "status": "Available"},
      {"time": "04:10 PM", "status": "Available"},
      {"time": "04:20 PM", "status": "Available"},
      {"time": "04:30 PM", "status": "Booked"},
      {"time": "04:40 PM", "status": "Available"},
      {"time": "04:50 PM", "status": "Available"},

      {"time": "05:00 PM", "status": "Available"},
      {"time": "05:10 PM", "status": "Available"},
      {"time": "05:20 PM", "status": "Available"},
      {"time": "05:30 PM", "status": "Available"},
      {"time": "05:40 PM", "status": "Available"},
      {"time": "05:50 PM", "status": "Available"},
    ];
  }

  void _toggleSlot(Map<String, dynamic> slot) {
    setState(() {
      switch (slot["status"]) {
        case "Available":
          slot["status"] = "Booked";
          break;
        case "Booked":
          slot["status"] = "On Hold";
          break;
        case "On Hold":
          slot["status"] = "Blocked";
          break;
        case "Blocked":
          slot["status"] = "Available";
          break;
        default:
          slot["status"] = "Available";
      }
    });

    if (widget.onSlotsChanged != null) {
      widget.onSlotsChanged!(_morningSlots, _afternoonSlots);
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Available":
        return const Color(0xFF0F9F58);
      case "Booked":
        return AppColors.primary;
      case "On Hold":
        return AppColors.warning;
      case "Blocked":
        return AppColors.error;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final borderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final textColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;

    return Column(
      children: [
        // Morning Panel
        _buildExpandablePanel(
          title: "MORNING",
          timeRange: "(09:00 AM - 01:00 PM)",
          isExpanded: _morningExpanded,
          slots: _morningSlots,
          onToggleExpand: () => setState(() => _morningExpanded = !_morningExpanded),
          textColor: textColor,
          labelColor: labelColor,
          borderColor: borderColor,
          cardBg: cardBg,
          isDark: isDark,
        ),
        SizedBox(height: 12.h),
        // Afternoon Panel
        _buildExpandablePanel(
          title: "AFTERNOON",
          timeRange: "(02:00 PM - 06:00 PM)",
          isExpanded: _afternoonExpanded,
          slots: _afternoonSlots,
          onToggleExpand: () => setState(() => _afternoonExpanded = !_afternoonExpanded),
          textColor: textColor,
          labelColor: labelColor,
          borderColor: borderColor,
          cardBg: cardBg,
          isDark: isDark,
        ),
      ],
    );
  }

  Widget _buildExpandablePanel({
    required String title,
    required String timeRange,
    required bool isExpanded,
    required List<Map<String, dynamic>> slots,
    required VoidCallback onToggleExpand,
    required Color textColor,
    required Color labelColor,
    required Color borderColor,
    required Color cardBg,
    required bool isDark,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          // Header
          InkWell(
            onTap: onToggleExpand,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
              child: Row(
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    timeRange,
                    style: TextStyle(
                      color: labelColor,
                      fontSize: 10.sp,
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                    color: labelColor,
                    size: 16.sp,
                  ),
                ],
              ),
            ),
          ),
          if (isExpanded) ...[
            Divider(color: borderColor, height: 1),
            Padding(
              padding: EdgeInsets.all(12.r),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: slots.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8.w,
                  mainAxisSpacing: 8.h,
                  childAspectRatio: 2.3,
                ),
                itemBuilder: (context, idx) {
                  final slot = slots[idx];
                  final status = slot["status"] as String;
                  final statusColor = _getStatusColor(status);

                  return InkWell(
                    onTap: () => _toggleSlot(slot),
                    borderRadius: BorderRadius.circular(6.r),
                    child: Container(
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(isDark ? 0.05 : 0.1),
                        border: Border.all(
                          color: statusColor.withOpacity(0.4),
                          width: 1.r,
                        ),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 6.r,
                            height: 6.r,
                            decoration: BoxDecoration(
                              color: statusColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            slot["time"] as String,
                            style: TextStyle(
                              color: isDark ? Colors.white : Colors.black87,
                              fontWeight: FontWeight.w600,
                              fontSize: 10.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
