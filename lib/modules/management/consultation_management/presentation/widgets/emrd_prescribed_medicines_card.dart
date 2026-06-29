import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/widgets/emrd_detail_card.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/widgets/emrd_payment_dialog.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/helpers/emrd_pdf_helper.dart';

class EmrdPrescribedMedicinesCard extends StatelessWidget {
  final Map<String, dynamic> record;
  final bool isDark;

  const EmrdPrescribedMedicinesCard({
    super.key,
    required this.record,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final medPaid = record['medicine_payment_status'] == 'Paid';
    final double medAmount = record['medicine_amount'] != null
        ? (record['medicine_amount'] as num).toDouble()
        : 0.0;
    final medInvoice = record['medicine_invoice_number'] ?? '';

    return EmrdDetailCard(
      title: "Prescribed Medicines",
      icon: Icons.medication_outlined,
      iconColor: Colors.teal,
      isDark: isDark,
      children: [
        if (record['medicines'] != null &&
            record['medicines'].toString().trim().isNotEmpty) ...[
          ...() {
            final List<Map<String, String>> parsedMeds = [];
            final rawMedicines = record['medicines'] as String? ?? '';
            if (rawMedicines.isNotEmpty) {
              final lines = rawMedicines.split('\n');
              for (final line in lines) {
                if (line.trim().isEmpty) continue;
                String name = line.trim();
                String dosage = '1 Tablet';
                String duration = '7 Days';
                String instructions = 'After Food';

                if (line.contains('(')) {
                  name = line.split('(').first.trim();
                  final inner = line.substring(
                    line.indexOf('(') + 1,
                    line.lastIndexOf(')'),
                  );
                  final parts = inner.split(',');
                  if (parts.isNotEmpty) {
                    dosage = parts[0].trim();
                  }
                  if (parts.length > 1) {
                    instructions = parts[1].trim();
                  }
                  if (parts.length > 2) {
                    duration = parts[2].trim();
                  }
                }
                parsedMeds.add({
                  'name': name,
                  'dosage': dosage,
                  'duration': duration,
                  'instructions': instructions,
                });
              }
            }
            return parsedMeds.map<Widget>((med) {
              return Container(
                margin: EdgeInsets.only(bottom: 8.h),
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.02)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: isDark ? Colors.white10 : Colors.grey[200]!,
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: Colors.teal.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.medication_outlined,
                        color: Colors.teal,
                        size: 18,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            med['name'] ?? '',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary(context),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.teal.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  "Dosage: ${med['dosage']}",
                                  style: AppTextStyles.bodySmall.copyWith(
                                    fontSize: 10.sp,
                                    color: Colors.teal,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withValues(alpha: 0.08),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  "Duration: ${med['duration']}",
                                  style: AppTextStyles.bodySmall.copyWith(
                                    fontSize: 10.sp,
                                    color: Colors.blue[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            "Instruction: ${med['instructions']}",
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 11.sp,
                              color: isDark
                                  ? Colors.white54
                                  : AppColors.textSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            });
          }(),
        ] else
          Text(
            "No medicines prescribed.",
            style: AppTextStyles.bodySmall.copyWith(
              fontStyle: FontStyle.italic,
              color: isDark ? Colors.white38 : AppColors.textSecondary(context),
            ),
          ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Medicine Total: ₹${medAmount.toStringAsFixed(2)}",
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (medPaid)
                  Text(
                    "Invoice: $medInvoice",
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 10.sp,
                      color: AppColors.textSecondary(context),
                    ),
                  ),
              ],
            ),
            if (medPaid)
              Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    color: AppColors.success,
                    size: 16,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    "Paid",
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.success,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  IconButton(
                    onPressed: () => EmrdPdfHelper.downloadFile(
                      context: context,
                      record: record,
                      isPrescription: false,
                      customTitle: "Medicine Invoice",
                    ),
                    icon: const Icon(
                      Icons.download,
                      size: 16,
                      color: Colors.green,
                    ),
                    tooltip: "Download Medicine Invoice PDF",
                  ),
                ],
              )
            else
              ElevatedButton(
                onPressed: () => showEmrdPaymentDialog(
                  context: context,
                  record: record,
                  isMedicine: true,
                  amount: medAmount,
                  invoiceNum: medInvoice,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  "Pay Now",
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
