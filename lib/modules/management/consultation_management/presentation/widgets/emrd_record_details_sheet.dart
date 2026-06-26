import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/routes/route_names.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/widgets/emrd_general_info_card.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/widgets/emrd_prescribed_medicines_card.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/widgets/emrd_investigations_card.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/widgets/emrd_consultation_notes_card.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/widgets/emrd_billing_payment_card.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/helpers/emrd_pdf_helper.dart';

void showEmrdRecordDetailsSheet(
  BuildContext context,
  Map<String, dynamic> record,
) {
  final isCustomerCare = record['specialty'] == 'Customer Care';
  if (isCustomerCare) {
    context.push(RouteNames.patientRegistrationRecordDetail, extra: record);
    return;
  }
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final dateStr = record['recorded_at'] ?? record['created_at'] ?? '';
  String formattedDate = 'N/A';
  if (dateStr.isNotEmpty) {
    try {
      final dt = DateTime.parse(dateStr);
      formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(dt);
    } catch (_) {}
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) {
      return DraggableScrollableSheet(
        initialChildSize: 0.85,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (sheetCtx, scrollCtrl) {
          return Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.terminalDarkCard : Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                // Handle
                SizedBox(height: 12.h),
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white24 : Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 16.h),
                // Header
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Consultation EMR Record",
                              style: AppTextStyles.titleLarge.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              "Date: $formattedDate",
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isDark
                                    ? Colors.white54
                                    : AppColors.textSecondary(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
                const Divider(),
                Expanded(
                  child: ListView(
                    controller: scrollCtrl,
                    padding: EdgeInsets.all(20.r),
                    children: [
                      EmrdGeneralInfoCard(record: record, isDark: isDark),
                      SizedBox(height: 16.h),
                      EmrdPrescribedMedicinesCard(
                        record: record,
                        isDark: isDark,
                      ),
                      SizedBox(height: 16.h),
                      EmrdInvestigationsCard(record: record, isDark: isDark),
                      SizedBox(height: 16.h),
                      EmrdConsultationNotesCard(record: record, isDark: isDark),
                      SizedBox(height: 16.h),
                      EmrdBillingPaymentCard(record: record, isDark: isDark),
                      SizedBox(height: 24.h),

                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => EmrdPdfHelper.downloadFile(
                                context: context,
                                record: record,
                                isPrescription: true,
                              ),
                              icon: const Icon(
                                Icons.picture_as_pdf,
                                color: Colors.white,
                              ),
                              label: const Text(
                                "Prescription",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => EmrdPdfHelper.downloadFile(
                                context: context,
                                record: record,
                                isPrescription: false,
                              ),
                              icon: const Icon(
                                Icons.picture_as_pdf,
                                color: Colors.white,
                              ),
                              label: const Text(
                                "Consultation Inv",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.r),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
