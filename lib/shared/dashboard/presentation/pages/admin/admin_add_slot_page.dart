import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_event.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/add_slot/add_slot_header.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/add_slot/additional_options_card.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/add_slot/slot_information_card.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/add_slot/slot_status_card.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/add_slot/slot_type_card.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/manage_slots/manage_slots_doctor_card.dart';

class AdminAddSlotPage extends StatefulWidget {
  final UserModel user;
  const AdminAddSlotPage({super.key, required this.user});

  @override
  State<AdminAddSlotPage> createState() => _AdminAddSlotPageState();
}

class _AdminAddSlotPageState extends State<AdminAddSlotPage> {
  // Config state bubbled up for final submit
  String _date = "20 May 2025";
  String _session = "Morning";
  String _start = "09:00 AM";
  String _end = "01:00 PM";
  String _duration = "10 Minutes";
  String _gap = "0 Minutes";
  int _count = 24;

  String _type = "Regular Slot";
  String _status = "Available";
  bool _isRecurring = false;
  String _note = "";

  void _onCreateSlots() {
    final int minutes = _duration.contains("10")
        ? 10
        : _duration.contains("15")
        ? 15
        : 30;

    int startHour = _session.toLowerCase() == "morning" ? 9 : 14;
    int endHour = _session.toLowerCase() == "morning" ? 13 : 18;

    try {
      final startParts = _start.split(" ");
      final startHm = startParts[0].split(":");
      int h = int.parse(startHm[0]);
      int m = int.parse(startHm[1]);
      if (startParts[1].toUpperCase() == "PM" && h != 12) h += 12;
      if (startParts[1].toUpperCase() == "AM" && h == 12) h = 0;
      startHour = h;
    } catch (_) {}

    try {
      final endParts = _end.split(" ");
      final endHm = endParts[0].split(":");
      int h = int.parse(endHm[0]);
      int m = int.parse(endHm[1]);
      if (endParts[1].toUpperCase() == "PM" && h != 12) h += 12;
      if (endParts[1].toUpperCase() == "AM" && h == 12) h = 0;
      endHour = h;
    } catch (_) {}

    final List<Map<String, dynamic>> generatedList = [];
    int currentMin = startHour * 60;
    int endMin = endHour * 60;

    while (currentMin < endMin) {
      final hour = currentMin ~/ 60;
      final min = currentMin % 60;
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      final amPm = hour >= 12 ? "PM" : "AM";
      final timeStr =
          "${displayHour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')} $amPm";

      generatedList.add({"time": timeStr, "status": _status});
      currentMin += minutes;
    }

    final updatedMetadata = Map<String, dynamic>.from(
      widget.user.metadata ?? {},
    );
    final slotsByDate = Map<String, dynamic>.from(
      updatedMetadata['slots_by_date'] ?? {},
    );
    final dateData = Map<String, dynamic>.from(slotsByDate[_date] ?? {});
    final durationData = Map<String, dynamic>.from(dateData[_duration] ?? {});

    if (_session.toLowerCase() == "morning") {
      durationData['morning'] = generatedList;
    } else {
      durationData['afternoon'] = generatedList;
    }

    dateData[_duration] = durationData;
    slotsByDate[_date] = dateData;
    updatedMetadata['slots_by_date'] = slotsByDate;

    final updatedUser = widget.user.copyWith(metadata: updatedMetadata);

    context.read<DoctorStaffBloc>().add(UpdateDoctorStaffMember(updatedUser));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Successfully created ${generatedList.length} $_type slots on $_date for ${widget.user.name ?? 'Doctor'}.",
        ),
      ),
    );
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
                child: const AddSlotHeader(),
              ),
              // Form Content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    children: [
                      // Doctor strip info card
                      ManageSlotsDoctorCard(user: widget.user),
                      SizedBox(height: 12.h),

                      // Slot Information timings configuration
                      SlotInformationCard(
                        onConfigChanged:
                            (date, session, start, end, duration, gap, count) {
                              _date = date;
                              _session = session;
                              _start = start;
                              _end = end;
                              _duration = duration;
                              _gap = gap;
                              _count = count;
                            },
                      ),
                      SizedBox(height: 12.h),

                      // Slot Type configuration
                      SlotTypeCard(
                        onTypeChanged: (type) {
                          _type = type;
                        },
                      ),
                      SizedBox(height: 12.h),

                      // Slot Status configuration
                      SlotStatusCard(
                        onStatusChanged: (status) {
                          _status = status;
                        },
                      ),
                      SizedBox(height: 12.h),

                      // Additional Options configurations
                      AdditionalOptionsCard(
                        onOptionsChanged: (isRecurring, note) {
                          _isRecurring = isRecurring;
                          _note = note;
                        },
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ),
              // Bottom Action button bar
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _onCreateSlots,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          "Create Slots",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: isDark
                                ? AppColors.terminalDarkBorder
                                : AppColors.terminalLightBorder,
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: Text(
                          "Cancel",
                          style: TextStyle(
                            color: isDark ? Colors.white70 : Colors.black87,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
