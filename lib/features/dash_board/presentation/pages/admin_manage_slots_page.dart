import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';

// Sub-widgets
import '../widgets/manage_slots/manage_slots_header.dart';
import '../widgets/manage_slots/manage_slots_doctor_card.dart';
import '../widgets/manage_slots/working_hours_card.dart';
import '../widgets/manage_slots/date_selector_strip.dart';
import '../widgets/manage_slots/slots_grid_section.dart';
import '../widgets/manage_slots/slots_summary_row.dart';
import '../widgets/manage_slots/manage_slots_actions.dart';

class AdminManageSlotsPage extends StatefulWidget {
  final UserModel user;
  const AdminManageSlotsPage({super.key, required this.user});

  @override
  State<AdminManageSlotsPage> createState() => _AdminManageSlotsPageState();
}

class _AdminManageSlotsPageState extends State<AdminManageSlotsPage> {
  // Stats tracked dynamically
  int _totalSlots = 48;
  int _bookedSlots = 6;
  int _onHoldSlots = 2;
  int _blockedSlots = 2;

  void _updateStats(List<Map<String, dynamic>> morning, List<Map<String, dynamic>> afternoon) {
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
      _totalSlots = total;
      _bookedSlots = booked;
      _onHoldSlots = onHold;
      _blockedSlots = blocked;
    });
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
                        initialDate: "20 May 2025",
                        onDateChanged: (dateStr) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Selected Date changed to: $dateStr")),
                          );
                        },
                      ),
                      SizedBox(height: 12.h),

                      // Expansions Morning / Afternoon with slots
                      SlotsGridSection(onSlotsChanged: _updateStats),
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
                    top: BorderSide(color: isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Changes saved successfully!")),
                    );
                    Navigator.pop(context);
                  },
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
