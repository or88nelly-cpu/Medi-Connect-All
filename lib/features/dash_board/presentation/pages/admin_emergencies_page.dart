import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/common_app_bar.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class AdminEmergenciesPage extends StatelessWidget {
  const AdminEmergenciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> alerts = [
      {
        'id': '1',
        'message': 'Code Blue in Emergency Ward - Room 108',
        'level': 'Critical',
        'time': '2m ago',
      },
      {
        'id': '2',
        'message': 'Intense Patient Influx in ICU - Staff assistance requested',
        'level': 'High',
        'time': '15m ago',
      },
      {
        'id': '3',
        'message':
            'Power Generator Failure - Emergency Backup Active in Block B',
        'level': 'High',
        'time': '40m ago',
      },
      {
        'id': '4',
        'message': 'Ambulance Out of Service - Unit AMB-04 reported flat tire',
        'level': 'Medium',
        'time': '1h ago',
      },
    ];

    return CustomScaffold(
      customAppbar: const CommonAppBar(title: "Active Emergencies"),
      body: ListView.builder(
        padding: EdgeInsets.all(20.r),
        itemCount: alerts.length,
        itemBuilder: (context, idx) {
          final alert = alerts[idx];
          Color levelColor;
          switch (alert['level']) {
            case 'Critical':
              levelColor = AppColors.error;
              break;
            case 'High':
              levelColor = AppColors.warning;
              break;
            default:
              levelColor = AppColors.primary;
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
                      color: levelColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.warning_amber_rounded, color: levelColor),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          alert['message'],
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text("Triggered: ${alert['time']}"),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: levelColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      alert['level'],
                      style: TextStyle(
                        color: levelColor,
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
