import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/common_app_bar.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class AdminLabsPage extends StatelessWidget {
  const AdminLabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> tests = [
      {'id': 'LAB-492', 'patient': 'John Doe', 'test': 'Lipid Profile', 'status': 'Completed', 'priority': 'Normal'},
      {'id': 'LAB-493', 'patient': 'Alice Smith', 'test': 'CBC & Hemoglobin', 'status': 'Pending', 'priority': 'High'},
      {'id': 'LAB-494', 'patient': 'Robert Johnson', 'test': 'Thyroid Panel (T3, T4, TSH)', 'status': 'Completed', 'priority': 'Normal'},
      {'id': 'LAB-495', 'patient': 'Emily Davis', 'test': 'Blood Sugar Fasting', 'status': 'Pending', 'priority': 'Critical'},
      {'id': 'LAB-496', 'patient': 'David Miller', 'test': 'Kidney Function Test', 'status': 'Completed', 'priority': 'Normal'},
    ];

    return CustomScaffold(
      customAppbar: const CommonAppBar(title: "Laboratory Tests"),
      body: ListView.builder(
        padding: EdgeInsets.all(20.r),
        itemCount: tests.length,
        itemBuilder: (context, idx) {
          final test = tests[idx];
          Color priorityColor;
          switch (test['priority']) {
            case 'Critical':
              priorityColor = AppColors.error;
              break;
            case 'High':
              priorityColor = AppColors.warning;
              break;
            default:
              priorityColor = AppColors.primary;
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
                      color: priorityColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.science_outlined, color: priorityColor),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          test['test'],
                          style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 15.sp),
                        ),
                        SizedBox(height: 4.h),
                        Text("Patient: ${test['patient']}"),
                        Text("Test ID: ${test['id']}"),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: test['status'] == 'Completed' ? AppColors.success.withOpacity(0.1) : AppColors.warning.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          test['status'],
                          style: TextStyle(
                            color: test['status'] == 'Completed' ? AppColors.success : AppColors.warning,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "${test['priority']} Priority",
                        style: TextStyle(
                          color: priorityColor,
                          fontSize: 9.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
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
