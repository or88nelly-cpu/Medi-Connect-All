import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/common_app_bar.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class AdminNotificationsPage extends StatelessWidget {
  const AdminNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> notificationLogs = [
      {
        'recipient': 'john.doe@email.com',
        'type': 'Email',
        'subject': 'Appointment Confirmation',
        'status': 'Sent',
        'time': '5m ago',
      },
      {
        'recipient': '+91 98765 43210',
        'type': 'SMS',
        'subject': 'OTP Verification Code',
        'status': 'Sent',
        'time': '12m ago',
      },
      {
        'recipient': 'Staff Emma Watson',
        'type': 'Push',
        'subject': 'Shift roster updated',
        'status': 'Sent',
        'time': '1h ago',
      },
      {
        'recipient': 'robert.johnson@email.com',
        'type': 'Email',
        'subject': 'Monthly Billing Statement',
        'status': 'Failed',
        'time': '3h ago',
      },
    ];

    return CustomScaffold(
      customAppbar: const CommonAppBar(title: "Notification Logs"),
      body: ListView.builder(
        padding: EdgeInsets.all(20.r),
        itemCount: notificationLogs.length,
        itemBuilder: (context, idx) {
          final log = notificationLogs[idx];
          final isFailed = log['status'] == 'Failed';
          final statusColor = isFailed ? AppColors.error : AppColors.success;
          final typeIcon = log['type'] == 'Email'
              ? Icons.email_outlined
              : log['type'] == 'SMS'
              ? Icons.sms_outlined
              : Icons.notifications_active_outlined;

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
                      color: statusColor.withValues(alpha: 0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(typeIcon, color: statusColor),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          log['subject'],
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text("Recipient: ${log['recipient']}"),
                        Text("Channel: ${log['type']} | Sent: ${log['time']}"),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      log['status'],
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
