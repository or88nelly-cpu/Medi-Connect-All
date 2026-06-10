import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/common_app_bar.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class AdminRecentActivityPage extends StatelessWidget {
  const AdminRecentActivityPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> logs = [
      {'time': '10 mins ago', 'message': 'Dr. Sarah Chen updated patient medical record', 'category': 'Record'},
      {'time': '32 mins ago', 'message': 'New patient registered: John Doe', 'category': 'Patient'},
      {'time': '1 hour ago', 'message': 'Lab report uploaded for Cardiology department', 'category': 'Lab'},
      {'time': '2 hours ago', 'message': 'Appointment booked with Dr. Sarah Chen', 'category': 'Appointment'},
      {'time': '4 hours ago', 'message': 'Inventory reordered: Amoxicillin (50 units)', 'category': 'Pharmacy'},
      {'time': '6 hours ago', 'message': 'Doctor schedule updated: Dr. James Wilson', 'category': 'Doctor'},
      {'time': '1 day ago', 'message': 'Admin settings modified: Biometrics enabled', 'category': 'System'},
    ];

    return CustomScaffold(
      customAppbar: const CommonAppBar(title: "Recent Activity"),
      body: ListView.builder(
        padding: EdgeInsets.all(20.r),
        itemCount: logs.length,
        itemBuilder: (context, idx) {
          final log = logs[idx];
          Color iconColor;
          IconData icon;
          switch (log['category']) {
            case 'Record':
              icon = Icons.folder_shared_outlined;
              iconColor = AppColors.primary;
              break;
            case 'Patient':
              icon = Icons.person_add_outlined;
              iconColor = AppColors.secondary;
              break;
            case 'Lab':
              icon = Icons.science_outlined;
              iconColor = AppColors.accent;
              break;
            case 'Pharmacy':
              icon = Icons.medication_outlined;
              iconColor = AppColors.error;
              break;
            case 'Appointment':
              icon = Icons.calendar_month_outlined;
              iconColor = AppColors.success;
              break;
            default:
              icon = Icons.info_outline;
              iconColor = AppColors.textSecondary;
          }

          return Card(
            margin: EdgeInsets.only(bottom: 12.h),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
              side: const BorderSide(color: AppColors.border),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.all(16.r),
              leading: Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: iconColor),
              ),
              title: Text(
                log['message'],
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text(
                "${log['category']} | ${log['time']}",
                style: AppTextStyles.bodySmall,
              ),
            ),
          );
        },
      ),
    );
  }
}
