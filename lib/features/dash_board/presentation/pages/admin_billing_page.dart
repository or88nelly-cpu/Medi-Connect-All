import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class AdminBillingPage extends StatelessWidget {
  const AdminBillingPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> invoices = [
      {
        'id': 'INV-1024',
        'patient': 'John Doe',
        'amount': '₹ 1,500.00',
        'status': 'Paid',
        'date': 'June 10, 2026',
        'method': 'UPI',
      },
      {
        'id': 'INV-1025',
        'patient': 'Alice Smith',
        'amount': '₹ 800.00',
        'status': 'Pending',
        'date': 'June 10, 2026',
        'method': 'Card',
      },
      {
        'id': 'INV-1026',
        'patient': 'Robert Johnson',
        'amount': '₹ 2,400.00',
        'status': 'Paid',
        'date': 'June 09, 2026',
        'method': 'Cash',
      },
      {
        'id': 'INV-1027',
        'patient': 'Emily Davis',
        'amount': '₹ 500.00',
        'status': 'Failed',
        'date': 'June 09, 2026',
        'method': 'Net Banking',
      },
    ];

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Billing & Invoices",
            style: AppTextStyles.headingMedium.copyWith(fontSize: 22.sp),
          ),
          SizedBox(height: 16.h),
          // Stats Row
          Row(
            children: [
              _buildStatCard("Total Revenue", "₹ 4,700.00", AppColors.primary),
              SizedBox(width: 12.w),
              _buildStatCard("Pending Bills", "₹ 800.00", AppColors.warning),
            ],
          ),
          SizedBox(height: 24.h),
          Text(
            "Recent Invoices",
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: invoices.length,
            itemBuilder: (context, idx) {
              final inv = invoices[idx];
              Color statusColor;
              switch (inv['status']) {
                case 'Paid':
                  statusColor = AppColors.success;
                  break;
                case 'Pending':
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
                        child: Icon(Icons.receipt, color: statusColor),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              inv['patient']!,
                              style: AppTextStyles.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text("Invoice: ${inv['id']!} | ${inv['method']!}"),
                            Text(inv['date']!, style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            inv['amount']!,
                            style: AppTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.sp,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(4.r),
                            ),
                            child: Text(
                              inv['status']!,
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.bold,
                              ),
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
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: AppTextStyles.headingMedium.copyWith(
                color: color,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
