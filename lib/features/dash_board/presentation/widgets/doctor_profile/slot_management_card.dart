import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';

class SlotManagementCard extends StatefulWidget {
  final UserModel user;
  const SlotManagementCard({super.key, required this.user});

  @override
  State<SlotManagementCard> createState() => _SlotManagementCardState();
}

class _SlotManagementCardState extends State<SlotManagementCard> {
  String _selectedDate = "20 May 2025";
  String _slotDuration = "10 Minutes";
  String _selectedView = "Day View";

  // In-memory representation of slots
  late List<Map<String, dynamic>> _morningSlots;
  late List<Map<String, dynamic>> _afternoonSlots;

  @override
  void initState() {
    super.initState();
    _resetSlots();
  }

  void _resetSlots() {
    _morningSlots = [
      {"time": "09:00 AM", "status": "Available"},
      {"time": "09:10 AM", "status": "Booked"},
      {"time": "09:20 AM", "status": "Available"},
      {"time": "09:30 AM", "status": "Available"},
      {"time": "09:40 AM", "status": "Available"},
      {"time": "09:50 AM", "status": "Blocked"},
      {"time": "10:00 AM", "status": "Available"},
      {"time": "10:10 AM", "status": "Available"},
      {"time": "10:20 AM", "status": "Available"},
    ];

    _afternoonSlots = [
      {"time": "02:00 PM", "status": "Available"},
      {"time": "02:10 PM", "status": "Available"},
      {"time": "02:20 PM", "status": "On Hold"},
      {"time": "02:30 PM", "status": "Available"},
      {"time": "02:40 PM", "status": "Available"},
      {"time": "02:50 PM", "status": "Available"},
      {"time": "03:00 PM", "status": "Booked"},
      {"time": "03:10 PM", "status": "Available"},
      {"time": "03:20 PM", "status": "Available"},
    ];
  }

  void _toggleSlotStatus(Map<String, dynamic> slot) {
    // Cycle: Available -> Booked -> On Hold -> Blocked -> Available
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

  IconData? _getStatusIcon(String status) {
    switch (status) {
      case "Booked":
        return Icons.person_outline;
      case "On Hold":
        return Icons.phone_outlined;
      case "Blocked":
        return Icons.block_flipped;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final borderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final textColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;

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
          // Header with Manage Slots / Assign Slot
          Row(
            children: [
              Expanded(
                child: Text(
                  "Slot Management",
                  style: AppTextStyles.titleMedium.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () {
                  context.push('/admin/doctor-staff/manage-slots', extra: widget.user);
                },
                icon: Icon(Icons.tune, size: 12.sp, color: Colors.white),
                label: Text(
                  "Manage Slots",
                  style: TextStyle(color: Colors.white, fontSize: 10.sp, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
              ),
              SizedBox(width: 6.w),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Opening Assign Slot Form...")),
                  );
                },
                icon: Icon(Icons.person_add_alt_1_outlined, size: 12.sp, color: const Color(0xFF9C27B0)),
                label: Text(
                  "Assign Slot",
                  style: TextStyle(color: const Color(0xFF9C27B0), fontSize: 10.sp, fontWeight: FontWeight.bold),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF9C27B0)),
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Filters row
          Row(
            children: [
              // Date picker Dropdown
              Expanded(
                child: _buildFilterDropdown(
                  value: _selectedDate,
                  items: ["20 May 2025", "21 May 2025", "22 May 2025"],
                  icon: Icons.calendar_month,
                  cardBg: cardBg,
                  textColor: textColor,
                  labelColor: labelColor,
                  borderColor: borderColor,
                  onChanged: (val) => setState(() => _selectedDate = val!),
                ),
              ),
              SizedBox(width: 8.w),
              // Slot duration
              Expanded(
                child: _buildFilterDropdown(
                  value: _slotDuration,
                  items: ["10 Minutes", "15 Minutes", "30 Minutes"],
                  icon: Icons.timer_outlined,
                  cardBg: cardBg,
                  textColor: textColor,
                  labelColor: labelColor,
                  borderColor: borderColor,
                  onChanged: (val) => setState(() => _slotDuration = val!),
                ),
              ),
              SizedBox(width: 8.w),
              // View view
              Expanded(
                child: _buildFilterDropdown(
                  value: _selectedView,
                  items: ["Day View", "Week View", "Month View"],
                  icon: Icons.view_headline,
                  cardBg: cardBg,
                  textColor: textColor,
                  labelColor: labelColor,
                  borderColor: borderColor,
                  onChanged: (val) => setState(() => _selectedView = val!),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Morning / Afternoon layout
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 550;
              final morningCol = _buildSlotColumn(
                title: "Morning",
                timeRange: "09:00 AM - 01:00 PM",
                slots: _morningSlots,
                textColor: textColor,
                labelColor: labelColor,
                borderColor: borderColor,
                isDark: isDark,
              );
              final afternoonCol = _buildSlotColumn(
                title: "Afternoon",
                timeRange: "02:00 PM - 06:00 PM",
                slots: _afternoonSlots,
                textColor: textColor,
                labelColor: labelColor,
                borderColor: borderColor,
                isDark: isDark,
              );

              if (isWide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: morningCol),
                    SizedBox(width: 16.w),
                    Expanded(child: afternoonCol),
                  ],
                );
              } else {
                return Column(
                  children: [
                    morningCol,
                    SizedBox(height: 16.h),
                    afternoonCol,
                  ],
                );
              }
            },
          ),
          SizedBox(height: 16.h),
          // Legend
          Wrap(
            spacing: 12.w,
            runSpacing: 6.h,
            alignment: WrapAlignment.center,
            children: [
              _buildLegendItem("Available", const Color(0xFF0F9F58)),
              _buildLegendItem("Booked", AppColors.primary),
              _buildLegendItem("On Hold", AppColors.warning),
              _buildLegendItem("Blocked", AppColors.error),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String value,
    required List<String> items,
    required IconData icon,
    required Color cardBg,
    required Color textColor,
    required Color labelColor,
    required Color borderColor,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          dropdownColor: cardBg,
          icon: Icon(Icons.arrow_drop_down, color: labelColor, size: 14.sp),
          style: TextStyle(color: textColor, fontSize: 10.sp, fontWeight: FontWeight.w600),
          onChanged: onChanged,
          items: items.map((val) {
            return DropdownMenuItem<String>(
              value: val,
              child: Row(
                children: [
                  Icon(icon, size: 11.sp, color: labelColor),
                  SizedBox(width: 4.w),
                  Expanded(child: Text(val, overflow: TextOverflow.ellipsis)),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSlotColumn({
    required String title,
    required String timeRange,
    required List<Map<String, dynamic>> slots,
    required Color textColor,
    required Color labelColor,
    required Color borderColor,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Column Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12.sp),
            ),
            Text(
              timeRange,
              style: TextStyle(color: labelColor, fontSize: 10.sp),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        // Slots Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: slots.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 6.w,
            mainAxisSpacing: 6.h,
            childAspectRatio: 2.2,
          ),
          itemBuilder: (context, index) {
            final slot = slots[index];
            final status = slot["status"] as String;
            final statusColor = _getStatusColor(status);
            final statusIcon = _getStatusIcon(status);

            return InkWell(
              onTap: () => _toggleSlotStatus(slot),
              borderRadius: BorderRadius.circular(6.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(isDark ? 0.05 : 0.1),
                  border: Border.all(color: statusColor.withOpacity(0.5), width: 1),
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (statusIcon != null) ...[
                        Icon(statusIcon, size: 10.sp, color: statusColor),
                        SizedBox(width: 4.w),
                      ],
                      Text(
                        slot["time"] as String,
                        style: TextStyle(
                          color: statusColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 9.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.r,
          height: 8.r,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
