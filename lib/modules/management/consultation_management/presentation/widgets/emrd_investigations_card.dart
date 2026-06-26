import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/widgets/emrd_detail_card.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/widgets/emrd_payment_dialog.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/helpers/emrd_pdf_helper.dart';

class EmrdInvestigationsCard extends StatelessWidget {
  final Map<String, dynamic> record;
  final bool isDark;

  const EmrdInvestigationsCard({
    super.key,
    required this.record,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final labPaid = record['lab_payment_status'] == 'Paid';
    final double labAmount = record['lab_amount'] != null
        ? (record['lab_amount'] as num).toDouble()
        : 0.0;
    final labInvoice = record['lab_invoice_number'] ?? '';

    return EmrdDetailCard(
      title: "Investigations Advised",
      icon: Icons.biotech_outlined,
      iconColor: Colors.orange,
      isDark: isDark,
      children: [
        if (record['lab_tests'] != null &&
            record['lab_tests'].toString().trim().isNotEmpty) ...[
          ...record['lab_tests'].toString().split(',').map((test) {
            return Padding(
              padding: EdgeInsets.only(bottom: 6.h),
              child: Row(
                children: [
                  const Icon(
                    Icons.science_outlined,
                    size: 14,
                    color: Colors.orange,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    test.trim(),
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                ],
              ),
            );
          }),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Lab Test Total: ₹${labAmount.toStringAsFixed(2)}",
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (labPaid)
                    Text(
                      "Invoice: $labInvoice",
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 10.sp,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                ],
              ),
              if (labPaid)
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
                        customTitle: "Lab Invoice",
                      ),
                      icon: const Icon(
                        Icons.download,
                        size: 16,
                        color: Colors.orange,
                      ),
                      tooltip: "Download Lab Invoice PDF",
                    ),
                  ],
                )
              else
                ElevatedButton(
                  onPressed: () => showEmrdPaymentDialog(
                    context: context,
                    record: record,
                    isMedicine: false,
                    amount: labAmount,
                    invoiceNum: labInvoice,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
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
        ] else
          Text(
            "No lab tests scheduled.",
            style: AppTextStyles.bodySmall.copyWith(
              fontStyle: FontStyle.italic,
              color: isDark ? Colors.white38 : AppColors.textSecondary(context),
            ),
          ),
      ],
    );
  }
}
