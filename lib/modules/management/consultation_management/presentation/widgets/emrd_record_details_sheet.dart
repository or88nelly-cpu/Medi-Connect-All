import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/routes/route_names.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/core/services/secure_storage_service.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/bloc/emrd_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_billing_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_pharmacy_bloc.dart';
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

  final medPaid = record['medicine_payment_status'] == 'Paid';
  final labPaid = record['lab_payment_status'] == 'Paid';
  final double medAmount = record['medicine_amount'] != null
      ? (record['medicine_amount'] as num).toDouble()
      : 0.0;
  final double labAmount = record['lab_amount'] != null
      ? (record['lab_amount'] as num).toDouble()
      : 0.0;
  final medInvoice = record['medicine_invoice_number'] ?? '';
  final labInvoice = record['lab_invoice_number'] ?? '';

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
                      // Patient & Doctor Info
                      _buildDetailCard(
                        context: context,
                        title: "General Information",
                        icon: Icons.person_outline,
                        iconColor: AppColors.primary,
                        isDark: isDark,
                        children: [
                          _buildInfoRow(
                            context,
                            label: "Patient Name",
                            value: record['patient_name'] ?? 'N/A',
                            isDark: isDark,
                          ),
                          _buildInfoRow(
                            context,
                            label: "Doctor Name",
                            value: 'Dr. ${record['doctor_name'] ?? "N/A"}',
                            isDark: isDark,
                          ),
                          _buildInfoRow(
                            context,
                            label: "Specialty",
                            value: record['specialty'] ?? 'N/A',
                            isDark: isDark,
                          ),
                          _buildInfoRow(
                            context,
                            label: "Invoice Number",
                            value: record['invoice_number'] ?? 'N/A',
                            isDark: isDark,
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Prescription Medicines
                      _buildDetailCard(
                        context: context,
                        title: "Prescribed Medicines",
                        icon: Icons.medication_outlined,
                        iconColor: Colors.teal,
                        isDark: isDark,
                        children: [
                          if (record['medicines'] != null &&
                              record['medicines']
                                  .toString()
                                  .trim()
                                  .isNotEmpty) ...[
                            ...() {
                              final List<Map<String, String>> parsedMeds = [];
                              final rawMedicines =
                                  record['medicines'] as String? ?? '';
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
                                      color: isDark
                                          ? Colors.white10
                                          : Colors.grey[200]!,
                                    ),
                                  ),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(8.r),
                                        decoration: BoxDecoration(
                                          color: Colors.teal.withValues(
                                            alpha: 0.1,
                                          ),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              med['name'] ?? '',
                                              style: AppTextStyles.bodyMedium
                                                  .copyWith(
                                                    fontWeight:
                                                        FontWeight.bold,
                                                    color:
                                                        AppColors.textPrimary(
                                                          context,
                                                        ),
                                                  ),
                                            ),
                                            SizedBox(height: 4.h),
                                            Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      EdgeInsets.symmetric(
                                                        horizontal: 6.w,
                                                        vertical: 2.h,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.teal
                                                        .withValues(
                                                          alpha: 0.08,
                                                        ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4.r,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    "Dosage: ${med['dosage']}",
                                                    style: AppTextStyles
                                                        .bodySmall
                                                        .copyWith(
                                                          fontSize: 10.sp,
                                                          color: Colors.teal,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                ),
                                                SizedBox(width: 8.w),
                                                Container(
                                                  padding:
                                                      EdgeInsets.symmetric(
                                                        horizontal: 6.w,
                                                        vertical: 2.h,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.blue
                                                        .withValues(
                                                          alpha: 0.08,
                                                        ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          4.r,
                                                        ),
                                                  ),
                                                  child: Text(
                                                    "Duration: ${med['duration']}",
                                                    style: AppTextStyles
                                                        .bodySmall
                                                        .copyWith(
                                                          fontSize: 10.sp,
                                                          color: Colors
                                                              .blue[600],
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 6.h),
                                            Text(
                                              "Instruction: ${med['instructions']}",
                                              style: AppTextStyles.bodySmall
                                                  .copyWith(
                                                    fontSize: 11.sp,
                                                    color: isDark
                                                        ? Colors.white54
                                                        : AppColors
                                                            .textSecondary(
                                                              context,
                                                            ),
                                                  ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                            }()
                          ] else
                            Text(
                              "No medicines prescribed.",
                              style: AppTextStyles.bodySmall.copyWith(
                                fontStyle: FontStyle.italic,
                                color: isDark
                                    ? Colors.white38
                                    : AppColors.textSecondary(context),
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
                                        color: AppColors.textSecondary(
                                          context,
                                        ),
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
                                  onPressed: () => _processDepartmentPayment(
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
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
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
                      ),
                      SizedBox(height: 16.h),

                      // Lab Tests
                      _buildDetailCard(
                        context: context,
                        title: "Investigations Advised",
                        icon: Icons.biotech_outlined,
                        iconColor: Colors.orange,
                        isDark: isDark,
                        children: [
                          if (record['lab_tests'] != null &&
                              record['lab_tests']
                                  .toString()
                                  .trim()
                                  .isNotEmpty) ...[
                            ...record['lab_tests']
                                .toString()
                                .split(',')
                                .map((test) {
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
                                          color: AppColors.textSecondary(
                                            context,
                                          ),
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
                                        onPressed: () =>
                                            EmrdPdfHelper.downloadFile(
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
                                    onPressed: () => _processDepartmentPayment(
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
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
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
                                color: isDark
                                    ? Colors.white38
                                    : AppColors.textSecondary(context),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Notes
                      _buildDetailCard(
                        context: context,
                        title: "Consultation Notes",
                        icon: Icons.sticky_note_2_outlined,
                        iconColor: Colors.blueGrey,
                        isDark: isDark,
                        children: [
                          if (record['prescription_notes'] != null &&
                              record['prescription_notes']
                                  .toString()
                                  .trim()
                                  .isNotEmpty)
                            Text(
                              record['prescription_notes'],
                              style: AppTextStyles.bodyMedium.copyWith(
                                height: 1.4,
                                color: isDark
                                    ? Colors.white70
                                    : AppColors.textPrimary(context),
                              ),
                            )
                          else
                            Text(
                              "No additional notes.",
                              style: AppTextStyles.bodySmall.copyWith(
                                fontStyle: FontStyle.italic,
                                color: isDark
                                    ? Colors.white38
                                    : AppColors.textSecondary(context),
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Billing
                      _buildDetailCard(
                        context: context,
                        title: "Billing & Payment",
                        icon: Icons.receipt_long_outlined,
                        iconColor: Colors.green,
                        isDark: isDark,
                        children: [
                          _buildInfoRow(
                            context,
                            label: "Consultation Fee",
                            value: "₹${(record['amount'] ?? 0.0).toStringAsFixed(2)}",
                            isDark: isDark,
                            valueColor: Colors.green,
                            valueFontWeight: FontWeight.bold,
                          ),
                          _buildInfoRow(
                            context,
                            label: "Payment Method",
                            value: record['payment_method'] ?? 'Cash',
                            isDark: isDark,
                          ),
                          _buildInfoRow(
                            context,
                            label: "Payment Status",
                            value: "PAID",
                            isDark: isDark,
                            valueColor: AppColors.success,
                            valueFontWeight: FontWeight.bold,
                          ),
                          _buildInvoiceSignature(
                            context: context,
                            doctorName: record['doctor_name'] ?? 'Authorized Doctor',
                            isDark: isDark,
                          ),
                        ],
                      ),
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
                )
                ],
              ),
            );
          },
        );
      },
    );
  }

Widget _buildDetailCard({
  required BuildContext context,
  required String title,
  required IconData icon,
  required Color iconColor,
  required List<Widget> children,
  required bool isDark,
}) {
  return Container(
    padding: EdgeInsets.all(16.r),
    decoration: BoxDecoration(
      color: isDark ? AppColors.terminalDarkBg : Colors.grey[50],
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: AppColors.border(context)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 20.r),
            SizedBox(width: 8.w),
            Text(
              title,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : AppColors.textPrimary(context),
              ),
            ),
          ],
        ),
        const Divider(height: 24),
        ...children,
      ],
    ),
  );
}

Widget _buildInfoRow(
  BuildContext context, {
  required String label,
  required String value,
  required bool isDark,
  Color? valueColor,
  FontWeight? valueFontWeight,
}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 8.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isDark ? Colors.white38 : AppColors.textSecondary(context),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: valueFontWeight ?? FontWeight.w500,
            color: valueColor ?? (AppColors.textPrimary(context)),
          ),
        ),
      ],
    ),
  );
}

Widget _buildInvoiceSignature({
  required BuildContext context,
  required String doctorName,
  required bool isDark,
}) {
  return Container(
    margin: EdgeInsets.only(top: 16.h),
    padding: EdgeInsets.all(12.r),
    decoration: BoxDecoration(
      color: isDark ? const Color(0xFF1B3B22) : const Color(0xFFF0FDF4),
      borderRadius: BorderRadius.circular(10.r),
      border: Border.all(
        color: isDark
            ? const Color(0xFF2E7D32).withValues(alpha: 0.5)
            : const Color(0xFFBBF7D0),
        width: 1.5,
      ),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: Colors.green.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.verified_user,
                color: Colors.green,
                size: 18,
              ),
            ),
            SizedBox(width: 8.w),
            Text(
              "Authorized invoice",
              style: AppTextStyles.bodySmall.copyWith(
                fontStyle: FontStyle.italic,
                color: isDark ? Colors.green[200] : Colors.green[800],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              doctorName,
              style: const TextStyle(
                fontFamily: 'Cursive',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              "Authorized Signature",
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 9.sp,
                color: AppColors.textSecondary(
                  context,
                ).withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

void _processDepartmentPayment({
  required BuildContext context,
  required Map<String, dynamic> record,
  required bool isMedicine,
  required double amount,
  required String invoiceNum,
}) {
  showDialog(
    context: context,
    builder: (dialogCtx) {
      String payMethod = 'Cash';
      bool paymentDone = false;

      return StatefulBuilder(
        builder: (stCtx, setDialogState) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return AlertDialog(
            backgroundColor: isDark ? AppColors.terminalDarkCard : Colors.white,
            title: Text(
              'Payment for ${isMedicine ? "Medicines" : "Lab Tests"}',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Invoice: $invoiceNum', style: AppTextStyles.bodySmall),
                SizedBox(height: 8.h),
                Text(
                  'Total Amount: ₹${amount.toStringAsFixed(2)}',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 16.h),
                if (!paymentDone) ...[
                  Text(
                    'Select Payment Method:',
                    style: AppTextStyles.bodySmall,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('Cash'),
                          selected: payMethod == 'Cash',
                          onSelected: (val) {
                            if (val) setDialogState(() => payMethod = 'Cash');
                          },
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('Online/QR'),
                          selected: payMethod == 'Online',
                          onSelected: (val) {
                            if (val) {
                              setDialogState(() => payMethod = 'Online');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  if (payMethod == 'Online') ...[
                    SizedBox(height: 16.h),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Icon(
                          Icons.qr_code_scanner,
                          size: 100.r,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Center(
                      child: Text(
                        'Scan to Pay ₹${amount.toStringAsFixed(2)}',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ],
                ] else ...[
                  Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 48,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Payment Confirmed!',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              if (!paymentDone) ...[
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    setDialogState(() => paymentDone = true);

                    final billingBloc = context.read<AdminBillingBloc>();
                    final pharmacyBloc = context.read<AdminPharmacyBloc>();
                    final emrdBloc = context.read<EmrdBloc>();
                    final messenger = ScaffoldMessenger.of(context);
                    final navigator = Navigator.of(context);

                    await Future.delayed(const Duration(seconds: 1));

                    // 1. Update Supabase
                    try {
                      final supabase = GetIt.I<SupabaseService>().client;
                      final fieldToUpdate = isMedicine
                          ? 'medicine_payment_status'
                          : 'lab_payment_status';
                      await supabase
                          .from('emr_records')
                          .update({
                            fieldToUpdate: 'Paid',
                            'payment_method': payMethod == 'Online'
                                ? 'UPI/QR'
                                : 'Cash',
                          })
                          .eq('appointment_id', record['appointment_id']);

                      if (isMedicine) {
                        // Decrement stock in pharmacy_inventory
                        try {
                          final medicinesText = record['medicines'] as String?;
                          if (medicinesText != null &&
                              medicinesText.trim().isNotEmpty) {
                            final lines = medicinesText.split('\n');
                            for (final line in lines) {
                              if (line.trim().isEmpty) continue;
                              // Parse the medicine name before the first parenthesis
                              String medName = line;
                              if (line.contains('(')) {
                                medName = line.split('(').first.trim();
                              } else {
                                medName = line.trim();
                              }

                              // Fetch the medicine item from database to check current stock and get ID
                              final response = await supabase
                                  .from('pharmacy_inventory')
                                  .select('id, stock')
                                  .ilike('name', '%$medName%')
                                  .limit(1)
                                  .maybeSingle();

                              if (response != null) {
                                final currentStock = response['stock'] as int? ?? 0;
                                final newStock = (currentStock - 1).clamp(0, 999999);
                                await supabase
                                    .from('pharmacy_inventory')
                                    .update({'stock': newStock})
                                    .eq('id', response['id']);
                              }
                            }
                          }
                        } catch (e) {
                          debugPrint(
                            "Failed to update pharmacy stock from EMRD payment: $e",
                          );
                        }
                      }

                      if (context.mounted) {
                        billingBloc.add(
                          RecordInvoice({
                            'patient_name': record['patient_name'],
                            'amount': amount,
                            'status': 'Paid',
                            'payment_method': payMethod == 'Online'
                                ? 'UPI/QR'
                                : 'Cash',
                          }),
                        );
                        if (isMedicine) {
                          pharmacyBloc.add(LoadPharmacyItems());
                        }
                      }
                    } catch (e) {
                      debugPrint("Supabase payment update failed: $e");
                    }

                    // 2. Update Local Storage
                    try {
                      final storage = GetIt.I<SecureStorageService>();
                      final localDataStr = await storage.read('emr_records');
                      if (localDataStr != null) {
                        final List<dynamic> list = jsonDecode(localDataStr);
                        for (final item in list) {
                          if (item['appointment_id'] == record['appointment_id']) {
                            if (isMedicine) {
                              item['medicine_payment_status'] = 'Paid';
                            } else {
                              item['lab_payment_status'] = 'Paid';
                            }
                            item['payment_method'] = payMethod == 'Online'
                                ? 'UPI/QR'
                                : 'Cash';
                          }
                        }
                        await storage.write('emr_records', jsonEncode(list));
                      }
                    } catch (e) {
                      debugPrint("Local storage payment update failed: $e");
                    }

                    if (context.mounted) {
                      emrdBloc.add(LoadEmrdStats());
                      if (dialogCtx.mounted) {
                        Navigator.pop(dialogCtx);
                      }
                      navigator.pop();

                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            'Payment of ₹${amount.toStringAsFixed(2)} confirmed for ${record['patient_name']}',
                          ),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text(
                    'Confirm Pay',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ] else ...[
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: const Text('Close'),
                ),
              ],
            ],
          );
        },
      );
    },
  );
}
