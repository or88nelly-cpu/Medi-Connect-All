import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';

// Sub-widgets
import 'package:medi_connect/shared/dashboard/presentation/widgets/manage_slots/manage_slots_header.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/manage_slots/manage_slots_doctor_card.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/manage_slots/working_hours_card.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/manage_slots/date_selector_strip.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/manage_slots/slots_grid_section.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/manage_slots/slots_summary_row.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/manage_slots/manage_slots_actions.dart';

class AdminManageSlotsPage extends StatefulWidget {
  final UserModel user;
  const AdminManageSlotsPage({super.key, required this.user});

  @override
  State<AdminManageSlotsPage> createState() => _AdminManageSlotsPageState();
}

class _AdminManageSlotsPageState extends State<AdminManageSlotsPage> {
  String _selectedDate = "20 May 2025";
  final String _slotDuration = "10 Minutes";

  late List<Map<String, dynamic>> _morningSlots;
  late List<Map<String, dynamic>> _afternoonSlots;

  // Stats tracked dynamically
  int _totalSlots = 48;
  int _bookedSlots = 6;
  int _onHoldSlots = 2;
  int _blockedSlots = 2;

  @override
  void initState() {
    super.initState();
    _loadSlots();
  }

  void _loadSlots() {
    final slotsByDate =
         {};
    final dateData = slotsByDate[_selectedDate] as Map<dynamic, dynamic>? ?? {};
    final durationData =
        dateData[_slotDuration] as Map<dynamic, dynamic>? ?? {};

    final morningList = durationData['morning'] as List<dynamic>?;
    if (morningList != null) {
      _morningSlots = morningList
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } else {
      _morningSlots = _generateDefaultSlots("morning", _slotDuration);
    }

    final afternoonList = durationData['afternoon'] as List<dynamic>?;
    if (afternoonList != null) {
      _afternoonSlots = afternoonList
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } else {
      _afternoonSlots = _generateDefaultSlots("afternoon", _slotDuration);
    }

    _updateStats(_morningSlots, _afternoonSlots);
  }

  List<Map<String, dynamic>> _generateDefaultSlots(
    String session,
    String durationStr,
  ) {
    final int minutes = durationStr.contains("10")
        ? 10
        : durationStr.contains("15")
        ? 15
        : 30;

    final List<Map<String, dynamic>> list = [];
    int startHour = session == "morning" ? 9 : 14;
    int endHour = session == "morning" ? 13 : 18;

    int currentMin = startHour * 60;
    int endMin = endHour * 60;

    int idx = 0;
    while (currentMin < endMin) {
      final hour = currentMin ~/ 60;
      final min = currentMin % 60;
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      final amPm = hour >= 12 ? "PM" : "AM";
      final timeStr =
          "${displayHour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')} $amPm";

      String status = "Available";
      if (idx % 6 == 1) status = "Booked";
      if (idx % 8 == 2) status = "On Hold";
      if (idx % 10 == 3) status = "Blocked";

      list.add({"time": timeStr, "status": status});
      currentMin += minutes;
      idx++;
    }
    return list;
  }

  void _updateStats(
    List<Map<String, dynamic>> morning,
    List<Map<String, dynamic>> afternoon,
  ) {
    int total = morning.length + afternoon.length;
    int booked = 0;
    int onHold = 0;
    int blocked = 0;

    for (var s in morning) {
      if (s["status"] == "Booked") booked++;
      if (s["status"] == "On Hold") onHold++;
      if (s["status"] == "Blocked") blocked++;
    }

    for (var s in afternoon) {
      if (s["status"] == "Booked") booked++;
      if (s["status"] == "On Hold") onHold++;
      if (s["status"] == "Blocked") blocked++;
    }

    setState(() {
      _morningSlots = morning;
      _afternoonSlots = afternoon;
      _totalSlots = total;
      _bookedSlots = booked;
      _onHoldSlots = onHold;
      _blockedSlots = blocked;
    });
  }

  void _saveChanges() {
    // final updatedMetadata = Map<String, dynamic>.from(
    //   widget.user.metadata ?? {},
    // );
    final slotsByDate = Map<String, dynamic>.from(
      {},// updatedMetadata['slots_by_date'] ?? {},
    );
    final dateData = Map<String, dynamic>.from(
      slotsByDate[_selectedDate] ?? {},
    );
    final durationData = Map<String, dynamic>.from(
      dateData[_slotDuration] ?? {},
    );

    durationData['morning'] = _morningSlots;
    durationData['afternoon'] = _afternoonSlots;
    dateData[_slotDuration] = durationData;
    slotsByDate[_selectedDate] = dateData;
    //updatedMetadata['slots_by_date'] = slotsByDate;

    //updatedMetadata['slots_morning'] = _morningSlots;
    //updatedMetadata['slots_afternoon'] = _afternoonSlots;

    // final updatedUser = widget.user.copyWith(metadata: updatedMetadata);

    // context.read<DoctorStaffBloc>().add(UpdateDoctorStaffMember(updatedUser));

    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(content: Text("Changes saved successfully!")),
    // );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgGradient = isDark
        ? const LinearGradient(
            colors: [Color(0xFF03070E), Color(0xFF091629), Color(0xFF030914)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Color(0xFFF4F7FA), Color(0xFFE2EAF4), Color(0xFFF3F7FD)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: bgGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: const ManageSlotsHeader(),
              ),
              // Main content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      // Doctor details
                      ManageSlotsDoctorCard(user: widget.user),
                      SizedBox(height: 12.h),

                      // Shift times
                      const WorkingHoursCard(),
                      SizedBox(height: 12.h),

                      // Week strip
                      DateSelectorStrip(
                        initialDate: _selectedDate,
                        onDateChanged: (dateStr) {
                          setState(() {
                            _selectedDate = dateStr;
                            _loadSlots();
                          });
                        },
                      ),
                      SizedBox(height: 12.h),

                      // Expansions Morning / Afternoon with slots
                      SlotsGridSection(
                        morningSlots: _morningSlots,
                        afternoonSlots: _afternoonSlots,
                        onSlotsChanged: _updateStats,
                      ),
                      SizedBox(height: 12.h),

                      // Summary Row
                      SlotsSummaryRow(
                        totalSlots: _totalSlots,
                        bookedSlots: _bookedSlots,
                        onHoldSlots: _onHoldSlots,
                        blockedSlots: _blockedSlots,
                      ),
                      SizedBox(height: 12.h),

                      // Tool Actions Row
                      ManageSlotsActions(user: widget.user),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
              // Save changes bottom bar
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.terminalDarkCard : Colors.white,
                  border: Border(
                    top: BorderSide(
                      color: isDark
                          ? AppColors.terminalDarkBorder
                          : AppColors.terminalLightBorder,
                    ),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: _saveChanges,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    "Save Changes",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
