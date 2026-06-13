import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/common_app_bar.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/dash_board/domain/entities/attendance_entity.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/admin_attendance_bloc.dart';

class AdminStaffAttendancePage extends StatefulWidget {
  const AdminStaffAttendancePage({super.key});

  @override
  State<AdminStaffAttendancePage> createState() => _AdminStaffAttendancePageState();
}

class _AdminStaffAttendancePageState extends State<AdminStaffAttendancePage> {
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }

  void _loadAttendance() {
    context.read<AdminAttendanceBloc>().add(
          LoadStaffAttendance(date: _selectedDate),
        );
  }

  void _showStatusDialog(AttendanceEntity staff) {
    showDialog(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: Text("Mark Attendance: ${staff.staffName}"),
          children: ["Present", "Absent", "On Leave"].map((status) {
            return SimpleDialogOption(
              onPressed: () {
                context.read<AdminAttendanceBloc>().add(
                      UpdateAttendanceStatus(
                        staff.id,
                        status,
                        date: _selectedDate,
                      ),
                    );
                Navigator.pop(ctx);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Row(
                  children: [
                    Icon(
                      status == "Present"
                          ? Icons.check_circle_outline
                          : status == "On Leave"
                              ? Icons.watch_later_outlined
                              : Icons.cancel_outlined,
                      color: status == "Present"
                          ? AppColors.success
                          : status == "On Leave"
                              ? AppColors.warning
                              : AppColors.error,
                    ),
                    SizedBox(width: 12.w),
                    Text(status, style: AppTextStyles.bodyLarge),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
      _loadAttendance();
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateStr = "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}";

    return CustomScaffold(
      customAppbar: CommonAppBar(
        title: "Staff Attendance",
        actions: [
          TextButton.icon(
            onPressed: () => _selectDate(context),
            icon: const Icon(Icons.calendar_today, size: 16, color: AppColors.primary),
            label: Text(
              dateStr,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<AdminAttendanceBloc, AdminAttendanceState>(
        builder: (context, state) {
          if (state is AdminAttendanceLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AdminAttendanceError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: AppColors.error),
                  ),
                  SizedBox(height: 12.h),
                  ElevatedButton(
                    onPressed: _loadAttendance,
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          if (state is AdminAttendanceLoaded) {
            final list = state.logs;
            if (list.isEmpty) {
              return const Center(child: Text("No attendance records found."));
            }

            return ListView.builder(
              padding: EdgeInsets.all(20.r),
              itemCount: list.length,
              itemBuilder: (context, idx) {
                final staff = list[idx];
                Color statusColor;
                switch (staff.status) {
                  case 'Present':
                    statusColor = AppColors.success;
                    break;
                  case 'On Leave':
                    statusColor = AppColors.warning;
                    break;
                  default:
                    statusColor = AppColors.error;
                }

                return Card(
                  margin: EdgeInsets.only(bottom: 12.h),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(12.r),
                    onTap: () => _showStatusDialog(staff),
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10.r),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.badge_outlined, color: statusColor),
                          ),
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  staff.staffName,
                                  style: AppTextStyles.titleMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.sp,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text("Role: ${staff.role}"),
                                if (staff.status == 'Present' && staff.checkInTime != null)
                                  Text("Check In: ${staff.checkInTime}"),
                              ],
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Text(
                              staff.status,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
