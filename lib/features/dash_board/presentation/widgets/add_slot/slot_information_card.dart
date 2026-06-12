import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class SlotInformationCard extends StatefulWidget {
  final Function(String date, String session, String start, String end, String duration, String gap, int count)? onConfigChanged;

  const SlotInformationCard({super.key, this.onConfigChanged});

  @override
  State<SlotInformationCard> createState() => _SlotInformationCardState();
}

class _SlotInformationCardState extends State<SlotInformationCard> {
  String _selectedDate = "20 May 2025";
  String _selectedSession = "Morning"; // Morning, Afternoon
  String _startTime = "09:00 AM";
  String _endTime = "01:00 PM";
  String _slotDuration = "10 Minutes";
  String _gapDuration = "0 Minutes";

  final List<String> _timesMorning = ["09:00 AM", "09:30 AM", "10:00 AM", "10:30 AM", "11:00 AM", "11:30 AM", "12:00 PM", "12:30 PM", "01:00 PM"];
  final List<String> _timesAfternoon = ["02:00 PM", "02:30 PM", "03:00 PM", "03:30 PM", "04:00 PM", "04:30 PM", "05:00 PM", "05:30 PM", "06:00 PM"];
  final List<String> _durations = ["10 Minutes", "15 Minutes", "20 Minutes", "30 Minutes", "45 Minutes", "60 Minutes"];
  final List<String> _gaps = ["0 Minutes", "5 Minutes", "10 Minutes", "15 Minutes", "20 Minutes"];

  @override
  void initState() {
    super.initState();
  }

  int _calculateTotalSlots() {
    try {
      // Parse start time
      final startParts = _startTime.split(" ");
      final startHMs = startParts[0].split(":");
      int startHour = int.parse(startHMs[0]);
      int startMin = int.parse(startHMs[1]);
      if (startParts[1] == "PM" && startHour != 12) startHour += 12;
      if (startParts[1] == "AM" && startHour == 12) startHour = 0;

      // Parse end time
      final endParts = _endTime.split(" ");
      final endHMs = endParts[0].split(":");
      int endHour = int.parse(endHMs[0]);
      int endMin = int.parse(endHMs[1]);
      if (endParts[1] == "PM" && endHour != 12) endHour += 12;
      if (endParts[1] == "AM" && endHour == 12) endHour = 0;

      final startTotalMins = startHour * 60 + startMin;
      final endTotalMins = endHour * 60 + endMin;

      if (endTotalMins <= startTotalMins) return 0;

      // Parse duration
      final durationVal = int.parse(_slotDuration.split(" ")[0]);
      final gapVal = int.parse(_gapDuration.split(" ")[0]);

      final slotBlock = durationVal + gapVal;
      if (slotBlock <= 0) return 0;

      return (endTotalMins - startTotalMins) ~/ slotBlock;
    } catch (_) {
      return 24;
    }
  }

  void _notifyChanges() {
    if (widget.onConfigChanged != null) {
      widget.onConfigChanged!(
        _selectedDate,
        _selectedSession,
        _startTime,
        _endTime,
        _slotDuration,
        _gapDuration,
        _calculateTotalSlots(),
      );
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2025, 5, 20),
      firstDate: DateTime(2025, 1, 1),
      lastDate: DateTime(2030, 12, 31),
    );
    if (picked != null) {
      final months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
      setState(() {
        _selectedDate = "${picked.day} ${months[picked.month - 1]} ${picked.year}";
      });
      _notifyChanges();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final borderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final textColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;

    final totalSlots = _calculateTotalSlots();
    final activeTimes = _selectedSession == "Morning" ? _timesMorning : _timesAfternoon;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Slot Information",
            style: AppTextStyles.titleMedium.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 14.h),
          // Select Date & Select Session
          Row(
            children: [
              // Select Date input
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Select Date", style: TextStyle(color: labelColor, fontSize: 10.sp)),
                    SizedBox(height: 6.h),
                    GestureDetector(
                      onTap: _selectDate,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                        decoration: BoxDecoration(
                          border: Border.all(color: borderColor),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_selectedDate, style: TextStyle(color: textColor, fontSize: 11.sp, fontWeight: FontWeight.w600)),
                            Icon(Icons.calendar_month_outlined, size: 14.sp, color: AppColors.primary),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              // Select Session toggle buttons
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Select Session", style: TextStyle(color: labelColor, fontSize: 10.sp)),
                    SizedBox(height: 6.h),
                    Row(
                      children: [
                        _buildSessionButton("Morning", labelColor, borderColor, cardBg),
                        SizedBox(width: 4.w),
                        _buildSessionButton("Afternoon", labelColor, borderColor, cardBg),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Start Time & End Time
          Row(
            children: [
              Expanded(
                child: _buildPickerDropdown(
                  label: "Start Time",
                  value: _startTime,
                  items: activeTimes,
                  icon: Icons.access_time_outlined,
                  cardBg: cardBg,
                  textColor: textColor,
                  labelColor: labelColor,
                  borderColor: borderColor,
                  onChanged: (val) {
                    setState(() {
                      _startTime = val!;
                    });
                    _notifyChanges();
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildPickerDropdown(
                  label: "End Time",
                  value: _endTime,
                  items: activeTimes,
                  icon: Icons.access_time_outlined,
                  cardBg: cardBg,
                  textColor: textColor,
                  labelColor: labelColor,
                  borderColor: borderColor,
                  onChanged: (val) {
                    setState(() {
                      _endTime = val!;
                    });
                    _notifyChanges();
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Duration & Gap
          Row(
            children: [
              Expanded(
                child: _buildPickerDropdown(
                  label: "Slot Duration",
                  value: _slotDuration,
                  items: _durations,
                  icon: Icons.timer_outlined,
                  cardBg: cardBg,
                  textColor: textColor,
                  labelColor: labelColor,
                  borderColor: borderColor,
                  onChanged: (val) {
                    setState(() {
                      _slotDuration = val!;
                    });
                    _notifyChanges();
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildPickerDropdown(
                  label: "Gap Between Slots (Optional)",
                  value: _gapDuration,
                  items: _gaps,
                  icon: Icons.timer_off_outlined,
                  cardBg: cardBg,
                  textColor: textColor,
                  labelColor: labelColor,
                  borderColor: borderColor,
                  onChanged: (val) {
                    setState(() {
                      _gapDuration = val!;
                    });
                    _notifyChanges();
                  },
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Purple informative banner
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF131130) : const Color(0xFFF3E5F5),
              border: Border.all(
                color: isDark ? const Color(0xFF3F2D70) : const Color(0xFFE1BEE7),
                width: 0.5.r,
              ),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.info_outline,
                  color: isDark ? const Color(0xFFB39DDB) : const Color(0xFF7B1FA2),
                  size: 16.sp,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    "Slots will be created from $_startTime to $_endTime with $_slotDuration duration.\nTotal Slots: $totalSlots",
                    style: TextStyle(
                      color: isDark ? const Color(0xFFB39DDB) : const Color(0xFF7B1FA2),
                      fontSize: 10.sp,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionButton(String session, Color labelColor, Color borderColor, Color cardBg) {
    final isSelected = _selectedSession == session;
    final activeBg = AppColors.primary;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedSession = session;
            // Update start/end fallbacks to match session
            if (session == "Morning") {
              _startTime = "09:00 AM";
              _endTime = "01:00 PM";
            } else {
              _startTime = "02:00 PM";
              _endTime = "06:00 PM";
            }
          });
          _notifyChanges();
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 11.h),
          decoration: BoxDecoration(
            color: isSelected ? activeBg : Colors.transparent,
            border: Border.all(color: isSelected ? activeBg : borderColor),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Center(
            child: Text(
              session,
              style: TextStyle(
                color: isSelected ? Colors.white : labelColor,
                fontWeight: FontWeight.bold,
                fontSize: 11.sp,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPickerDropdown({
    required String label,
    required String value,
    required List<String> items,
    required IconData icon,
    required Color cardBg,
    required Color textColor,
    required Color labelColor,
    required Color borderColor,
    required ValueChanged<String?> onChanged,
  }) {
    // Ensure value is in items to avoid dropdown crash
    final safeValue = items.contains(value) ? value : items.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: labelColor, fontSize: 10.sp)),
        SizedBox(height: 6.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          decoration: BoxDecoration(
            border: Border.all(color: borderColor),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: safeValue,
              isExpanded: true,
              dropdownColor: cardBg,
              icon: Icon(Icons.arrow_drop_down, color: labelColor, size: 14.sp),
              style: TextStyle(color: textColor, fontSize: 11.sp, fontWeight: FontWeight.w600),
              onChanged: onChanged,
              items: items.map((val) {
                return DropdownMenuItem<String>(
                  value: val,
                  child: Row(
                    children: [
                      Icon(icon, size: 12.sp, color: labelColor),
                      SizedBox(width: 6.w),
                      Expanded(child: Text(val, overflow: TextOverflow.ellipsis)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
