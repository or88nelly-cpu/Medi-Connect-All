import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/common_app_bar.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class AdminStaffAttendancePage extends StatelessWidget {
  const AdminStaffAttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> staffList = [
      {
        'name': 'Nurse Emma Watson',
        'role': 'General Nurse',
        'status': 'Present',
        'time': '08:00 AM',
      },
      {
        'name': 'Nurse Clara Oswald',
        'role': 'ICU Nurse',
        'status': 'Present',
        'time': '07:45 AM',
      },
      {
        'name': 'Thomas Shelby',
        'role': 'Lab Technician',
        'status': 'On Leave',
        'time': '-',
      },
      {
        'name': 'Sherlock Holmes',
        'role': 'Pharmacist',
        'status': 'Present',
        'time': '08:15 AM',
      },
      {
        'name': 'John Watson',
        'role': 'Assistant Pharmacist',
        'status': 'Absent',
        'time': '-',
      },
      {
        'name': 'Rose Tyler',
        'role': 'Receptionist',
        'status': 'Present',
        'time': '08:00 AM',
      },
    ];

    return CustomScaffold(
      customAppbar: const CommonAppBar(title: "Staff Attendance"),
      body: ListView.builder(
        padding: EdgeInsets.all(20.r),
        itemCount: staffList.length,
        itemBuilder: (context, idx) {
          final staff = staffList[idx];
          Color statusColor;
          switch (staff['status']) {
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
                          staff['name'],
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text("Role: ${staff['role']}"),
                        if (staff['status'] == 'Present')
                          Text("Check In: ${staff['time']}"),
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
                      staff['status'],
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
          );
        },
      ),
    );
  }
}
