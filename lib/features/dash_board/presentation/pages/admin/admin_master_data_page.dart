import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/common_app_bar.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class AdminMasterDataPage extends StatelessWidget {
  const AdminMasterDataPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> specializations = [
      {'code': 'SPEC-CARDIO', 'name': 'Cardiology', 'dept': 'Clinical'},
      {'code': 'SPEC-NEURO', 'name': 'Neurology', 'dept': 'Clinical'},
      {'code': 'SPEC-PEDIAT', 'name': 'Pediatrics', 'dept': 'Clinical'},
      {'code': 'SPEC-ORTHO', 'name': 'Orthopedics', 'dept': 'Clinical'},
      {'code': 'SPEC-DERMAT', 'name': 'Dermatology', 'dept': 'Clinical'},
      {'code': 'ROLE-NURSE', 'name': 'General Nursing', 'dept': 'Nursing'},
      {'code': 'ROLE-PHARM', 'name': 'Pharmacology', 'dept': 'Pharmacy'},
    ];

    return CustomScaffold(
      customAppbar: const CommonAppBar(title: "Master Data Management"),
      body: ListView.builder(
        padding: EdgeInsets.all(20.r),
        itemCount: specializations.length,
        itemBuilder: (context, idx) {
          final item = specializations[idx];
          return Card(
            margin: EdgeInsets.only(bottom: 12.h),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
              side: const BorderSide(color: AppColors.border),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 8.h,
              ),
              leading: Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: const Icon(
                  Icons.dataset_outlined,
                  color: AppColors.primary,
                ),
              ),
              title: Text(
                item['name']!,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              subtitle: Text("Department Area: ${item['dept']!}"),
              trailing: Text(
                item['code']!,
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
