import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';

class SlotsGridSection extends StatefulWidget {
  final List<Map<String, dynamic>> morningSlots;
  final List<Map<String, dynamic>> afternoonSlots;
  final Function(
    List<Map<String, dynamic>> morningSlots,
    List<Map<String, dynamic>> afternoonSlots,
  )?
  onSlotsChanged;

  const SlotsGridSection({
    super.key,
    required this.morningSlots,
    required this.afternoonSlots,
    this.onSlotsChanged,
  });

  @override
  State<SlotsGridSection> createState() => _SlotsGridSectionState();
}

class _SlotsGridSectionState extends State<SlotsGridSection> {
  bool _morningExpanded = true;
  bool _afternoonExpanded = true;

  void _toggleSlot(Map<String, dynamic> slot) {
    String newStatus;
    switch (slot["status"]) {
      case "Available":
        newStatus = "Booked";
        break;
      case "Booked":
        newStatus = "On Hold";
        break;
      case "On Hold":
        newStatus = "Blocked";
        break;
      case "Blocked":
        newStatus = "Available";
        break;
      default:
        newStatus = "Available";
    }

    final morningIdx = widget.morningSlots.indexWhere(
      (item) => item['time'] == slot['time'],
    );
    if (morningIdx != -1) {
      setState(() {
        widget.morningSlots[morningIdx]['status'] = newStatus;
      });
    } else {
      final afternoonIdx = widget.afternoonSlots.indexWhere(
        (item) => item['time'] == slot['time'],
      );
      if (afternoonIdx != -1) {
        setState(() {
          widget.afternoonSlots[afternoonIdx]['status'] = newStatus;
        });
      }
    }

    if (widget.onSlotsChanged != null) {
      widget.onSlotsChanged!(widget.morningSlots, widget.afternoonSlots);
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

    return Column(
      children: [
        // Morning Panel
        _buildExpandablePanel(
          title: "MORNING",
          timeRange: "(09:00 AM - 01:00 PM)",
          isExpanded: _morningExpanded,
          slots: widget.morningSlots,
          onToggleExpand: () =>
              setState(() => _morningExpanded = !_morningExpanded),
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
          slots: widget.afternoonSlots,
          onToggleExpand: () =>
              setState(() => _afternoonExpanded = !_afternoonExpanded),
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
                    style: TextStyle(color: labelColor, fontSize: 10.sp),
                  ),
                  const Spacer(),
                  Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
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
                        color: statusColor.withValues(
                          alpha: isDark ? 0.05 : 0.1,
                        ),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.4),
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
