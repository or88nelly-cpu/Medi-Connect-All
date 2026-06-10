import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/common_app_bar.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class AdminPharmacyPage extends StatelessWidget {
  const AdminPharmacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> items = [
      {
        'name': 'Paracetamol 500mg',
        'stock': 120,
        'category': 'Analgesic',
        'status': 'In Stock',
      },
      {
        'name': 'Amoxicillin 250mg',
        'stock': 8,
        'category': 'Antibiotic',
        'status': 'Low Stock',
      },
      {
        'name': 'Ibuprofen 400mg',
        'stock': 45,
        'category': 'Analgesic',
        'status': 'In Stock',
      },
      {
        'name': 'Metformin 850mg',
        'stock': 0,
        'category': 'Antidiabetic',
        'status': 'Out of Stock',
      },
      {
        'name': 'Atorvastatin 10mg',
        'stock': 3,
        'category': 'Antihypertensive',
        'status': 'Low Stock',
      },
      {
        'name': 'Omeprazole 20mg',
        'stock': 230,
        'category': 'Antacid',
        'status': 'In Stock',
      },
    ];

    return CustomScaffold(
      customAppbar: const CommonAppBar(title: "Pharmacy Inventory"),
      body: ListView.builder(
        padding: EdgeInsets.all(20.r),
        itemCount: items.length,
        itemBuilder: (context, idx) {
          final item = items[idx];
          Color badgeColor;
          switch (item['status']) {
            case 'In Stock':
              badgeColor = AppColors.success;
              break;
            case 'Low Stock':
              badgeColor = AppColors.warning;
              break;
            default:
              badgeColor = AppColors.error;
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
                      color: badgeColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.medication_outlined, color: badgeColor),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name'],
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 15.sp,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text("Category: ${item['category']}"),
                        Text("Current Stock: ${item['stock']} units"),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      item['status'],
                      style: TextStyle(
                        color: badgeColor,
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
