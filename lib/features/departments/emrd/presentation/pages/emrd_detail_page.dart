import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:medi_connect/core/common_widgets/common_app_bar.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/core/storage/secure_storage_service.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/departments/emrd/presentation/bloc/emrd_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/admin_billing_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/admin_pharmacy_bloc.dart';

class EmrdDetailPage extends StatefulWidget {
  const EmrdDetailPage({super.key});

  @override
  State<EmrdDetailPage> createState() => _EmrdDetailPageState();
}

class _EmrdDetailPageState extends State<EmrdDetailPage> {
  Future<void> _downloadFile({
    required Map<String, dynamic> record,
    required bool isPrescription,
    String? customTitle,
  }) async {
    try {
      final userProfile = Platform.environment['USERPROFILE'];
      final downloadsDirPath = userProfile != null ? '$userProfile\\Downloads' : Directory.current.path;
      final typeStr = isPrescription ? 'prescription' : 'invoice';
      final invoiceNum = isPrescription
          ? (record['invoice_number'] ?? 'N_A')
          : (customTitle?.contains("Medicine") == true
              ? (record['medicine_invoice_number'] ?? record['invoice_number'] ?? 'N_A')
              : (customTitle?.contains("Lab") == true
                  ? (record['lab_invoice_number'] ?? record['invoice_number'] ?? 'N_A')
                  : (record['invoice_number'] ?? 'N_A')));

      final fileName = '${typeStr}_$invoiceNum.pdf';
      final file = File('$downloadsDirPath\\$fileName');

      final dateStr = record['recorded_at'] ?? record['created_at'] ?? '';
      String formattedDate = 'N/A';
      if (dateStr.isNotEmpty) {
        try {
          final dt = DateTime.parse(dateStr);
          formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(dt);
        } catch (_) {}
      }

      final doc = pw.Document();

      if (isPrescription) {
        // Prescription PDF Layout
        doc.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(32),
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Row(
                        children: [
                          pw.Container(
                            width: 36,
                            height: 36,
                            decoration: const pw.BoxDecoration(
                              color: PdfColor.fromInt(0xff0f766e), // Teal
                              shape: pw.BoxShape.circle,
                            ),
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              "+",
                              style: pw.TextStyle(
                                color: PdfColors.white,
                                fontSize: 24,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          pw.SizedBox(width: 10),
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                "MEDI-CONNECT",
                                style: pw.TextStyle(
                                  fontSize: 20,
                                  fontWeight: pw.FontWeight.bold,
                                  color: const PdfColor.fromInt(0xff0f766e),
                                ),
                              ),
                              pw.Text(
                                "Electronic Medical Record System",
                                style: const pw.TextStyle(
                                  fontSize: 9,
                                  color: PdfColors.grey600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            "PRESCRIPTION",
                            style: pw.TextStyle(
                              fontSize: 18,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.grey800,
                            ),
                          ),
                          pw.Text(
                            "Ref No: $invoiceNum",
                            style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.Divider(thickness: 2, color: const PdfColor.fromInt(0xff0f766e)),
                  pw.SizedBox(height: 12),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey100,
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                    ),
                    child: pw.Column(
                      children: [
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.start,
                              children: [
                                pw.Text("PATIENT DETAILS", style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.grey600)),
                                pw.Text(record['patient_name'] ?? 'N/A', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                                pw.Text("Patient ID: ${record['patient_id'] ?? 'N/A'}", style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                              ],
                            ),
                            pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.end,
                              children: [
                                pw.Text("CONSULTANT", style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.grey600)),
                                pw.Text("Dr. ${record['doctor_name'] ?? 'N/A'}", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                                pw.Text(record['specialty'] ?? 'N/A', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                              ],
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 8),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text("Date: $formattedDate", style: const pw.TextStyle(fontSize: 10)),
                            pw.Text("Status: Active", style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: PdfColors.blue)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    "Rx (Prescribed Medicines)",
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: const PdfColor.fromInt(0xff0f766e),
                    ),
                  ),
                  pw.Divider(thickness: 1, color: PdfColors.grey300),
                  pw.SizedBox(height: 6),
                  if (record['medicines'] != null && record['medicines'].toString().trim().isNotEmpty)
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: (record['medicines'] as String).split('\n').map((med) {
                        return pw.Padding(
                          padding: const pw.EdgeInsets.symmetric(vertical: 4),
                          child: pw.Text("• $med", style: const pw.TextStyle(fontSize: 11)),
                        );
                      }).toList(),
                    )
                  else
                    pw.Text("No medicines prescribed.", style: pw.TextStyle(fontSize: 11, fontStyle: pw.FontStyle.italic)),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    "Scheduled Lab Tests / Diagnostics",
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: const PdfColor.fromInt(0xff0f766e),
                    ),
                  ),
                  pw.Divider(thickness: 1, color: PdfColors.grey300),
                  pw.SizedBox(height: 6),
                  if (record['lab_tests'] != null && record['lab_tests'].toString().trim().isNotEmpty)
                    pw.Text(
                      record['lab_tests'],
                      style: pw.TextStyle(fontSize: 11),
                    )
                  else
                    pw.Text("No lab tests scheduled.", style: pw.TextStyle(fontSize: 11, fontStyle: pw.FontStyle.italic)),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    "Instructions & Notes",
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: const PdfColor.fromInt(0xff0f766e),
                    ),
                  ),
                  pw.Divider(thickness: 1, color: PdfColors.grey300),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    record['prescription_notes'] != null && record['prescription_notes'].toString().trim().isNotEmpty
                        ? record['prescription_notes']
                        : 'None',
                    style: pw.TextStyle(fontSize: 11, color: PdfColors.grey800),
                  ),
                  pw.Spacer(),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Container(
                            width: 60,
                            height: 60,
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: PdfColors.green, width: 1.5),
                              shape: pw.BoxShape.circle,
                            ),
                            alignment: pw.Alignment.center,
                            child: pw.Column(
                              mainAxisAlignment: pw.MainAxisAlignment.center,
                              children: [
                                pw.Text("VERIFIED", style: pw.TextStyle(fontSize: 7, fontWeight: pw.FontWeight.bold, color: PdfColors.green)),
                                pw.Text("Medi-Connect", style: const pw.TextStyle(fontSize: 5, color: PdfColors.grey500)),
                              ],
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text("Hospital Digital Seal", style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey500)),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            "Dr. ${record['doctor_name'] ?? 'N/A'}",
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: const PdfColor.fromInt(0xff0f766e),
                            ),
                          ),
                          pw.Text(
                            "Authorized Signature",
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontStyle: pw.FontStyle.italic,
                              color: PdfColors.grey600,
                            ),
                          ),
                          pw.SizedBox(height: 6),
                          pw.Container(
                            width: 100,
                            height: 1,
                            color: PdfColors.grey400,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      } else {
        // Invoice PDF Layout
        final isMedicine = customTitle?.contains("Medicine") == true;
        final isLab = customTitle?.contains("Lab") == true;
        final amountVal = isMedicine 
            ? (record['medicine_amount'] ?? 0.0) 
            : (isLab ? (record['lab_amount'] ?? 0.0) : (record['amount'] ?? 0.0));
        final itemDesc = isMedicine
            ? "Prescription Medicines Payment"
            : (isLab ? "CBC and Diagnostics Lab Tests" : "Doctor Consultation Fee");

        doc.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.all(32),
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Row(
                        children: [
                          pw.Container(
                            width: 36,
                            height: 36,
                            decoration: const pw.BoxDecoration(
                              color: PdfColor.fromInt(0xff16a34a), // Green
                              shape: pw.BoxShape.circle,
                            ),
                            alignment: pw.Alignment.center,
                            child: pw.Text(
                              "₹",
                              style: pw.TextStyle(
                                color: PdfColors.white,
                                fontSize: 20,
                                fontWeight: pw.FontWeight.bold,
                              ),
                            ),
                          ),
                          pw.SizedBox(width: 10),
                          pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                "MEDI-CONNECT",
                                style: pw.TextStyle(
                                  fontSize: 20,
                                  fontWeight: pw.FontWeight.bold,
                                  color: const PdfColor.fromInt(0xff16a34a),
                                ),
                              ),
                              pw.Text(
                                "Billing & Accounts Department",
                                style: const pw.TextStyle(
                                  fontSize: 9,
                                  color: PdfColors.grey600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            "OFFICIAL INVOICE",
                            style: pw.TextStyle(
                              fontSize: 18,
                              fontWeight: pw.FontWeight.bold,
                              color: PdfColors.grey800,
                            ),
                          ),
                          pw.Text(
                            "Invoice No: $invoiceNum",
                            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.Divider(thickness: 2, color: const PdfColor.fromInt(0xff16a34a)),
                  pw.SizedBox(height: 12),
                  pw.Container(
                    padding: const pw.EdgeInsets.all(12),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey100,
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                    ),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text("BILLED TO", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.grey600)),
                            pw.Text(record['patient_name'] ?? 'N/A', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                            pw.Text("Patient ID: ${record['patient_id'] ?? 'N/A'}", style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                          ],
                        ),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text("INVOICE DATE", style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: PdfColors.grey600)),
                            pw.Text(formattedDate, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                            pw.Text("Payment Mode: ${record['payment_method'] ?? 'Cash'}", style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Table(
                    border: const pw.TableBorder(
                      bottom: pw.BorderSide(color: PdfColors.grey300, width: 1),
                      horizontalInside: pw.BorderSide(color: PdfColors.grey200, width: 1),
                    ),
                    children: [
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(color: PdfColor.fromInt(0xfff3f4f6)),
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text("Item Description", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text("Price", style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10), textAlign: pw.TextAlign.right),
                          ),
                        ],
                      ),
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(10),
                            child: pw.Text(itemDesc, style: const pw.TextStyle(fontSize: 10)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(10),
                            child: pw.Text("₹${amountVal.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.right),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 12),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Row(
                            children: [
                              pw.Text("Subtotal:  ", style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
                              pw.Text("₹${amountVal.toStringAsFixed(2)}", style: const pw.TextStyle(fontSize: 10)),
                            ],
                          ),
                          pw.SizedBox(height: 4),
                          pw.Row(
                            children: [
                              pw.Text("Grand Total:  ", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: const PdfColor.fromInt(0xff16a34a))),
                              pw.Text("₹${amountVal.toStringAsFixed(2)}", style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: const PdfColor.fromInt(0xff16a34a))),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.Spacer(),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Container(
                            padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: pw.BoxDecoration(
                              border: pw.Border.all(color: PdfColors.green, width: 1.5),
                              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
                            ),
                            child: pw.Text("PAID & STAMPED", style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold, color: PdfColors.green)),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text("Medi-Connect Accounts Division", style: const pw.TextStyle(fontSize: 7, color: PdfColors.grey500)),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          pw.Text(
                            "Dr. ${record['doctor_name'] ?? 'N/A'}",
                            style: pw.TextStyle(
                              fontSize: 12,
                              fontWeight: pw.FontWeight.bold,
                              color: const PdfColor.fromInt(0xff16a34a),
                            ),
                          ),
                          pw.Text(
                            "Authorized Signature",
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontStyle: pw.FontStyle.italic,
                              color: PdfColors.grey600,
                            ),
                          ),
                          pw.SizedBox(height: 6),
                          pw.Container(
                            width: 100,
                            height: 1,
                            color: PdfColors.grey400,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        );
      }

      await file.writeAsBytes(await doc.save());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${customTitle ?? (isPrescription ? "Prescription" : "Invoice")} PDF generated in Downloads folder.'),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'OPEN',
              textColor: Colors.white,
              onPressed: () {
                try {
                  Process.run('explorer.exe', [file.path]);
                } catch (e) {
                  debugPrint("Could not open PDF file: $e");
                }
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate PDF: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _processDepartmentPayment({
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
                style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Invoice: $invoiceNum', style: AppTextStyles.bodySmall),
                  SizedBox(height: 8.h),
                  Text(
                    'Total Amount: ₹${amount.toStringAsFixed(2)}',
                    style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  SizedBox(height: 16.h),
                  if (!paymentDone) ...[
                    Text('Select Payment Method:', style: AppTextStyles.bodySmall),
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
                              if (val) setDialogState(() => payMethod = 'Online');
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
                            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                          ),
                          child: Icon(Icons.qr_code_scanner, size: 100.r, color: Colors.black),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Center(
                        child: Text(
                          'Scan to Pay ₹${amount.toStringAsFixed(2)}',
                          style: AppTextStyles.bodySmall.copyWith(fontSize: 10.sp),
                        ),
                      ),
                    ],
                  ] else ...[
                    Center(
                      child: Column(
                        children: [
                          const Icon(Icons.check_circle, color: AppColors.success, size: 48),
                          SizedBox(height: 8.h),
                          Text('Payment Confirmed!', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
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
                        final fieldToUpdate = isMedicine ? 'medicine_payment_status' : 'lab_payment_status';
                        await supabase.from('emr_records').update({
                          fieldToUpdate: 'Paid',
                          'payment_method': payMethod == 'Online' ? 'UPI/QR' : 'Cash',
                        }).eq('appointment_id', record['appointment_id']);

                        if (isMedicine) {
                          // Decrement stock in pharmacy_inventory
                          try {
                            final medicinesText = record['medicines'] as String?;
                            if (medicinesText != null && medicinesText.trim().isNotEmpty) {
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
                            debugPrint("Failed to update pharmacy stock from EMRD payment: $e");
                          }
                        }

                        if (mounted) {
                          billingBloc.add(RecordInvoice({
                            'patient_name': record['patient_name'],
                            'amount': amount,
                            'status': 'Paid',
                            'payment_method': payMethod == 'Online' ? 'UPI/QR' : 'Cash',
                          }));
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
                              item['payment_method'] = payMethod == 'Online' ? 'UPI/QR' : 'Cash';
                            }
                          }
                          await storage.write('emr_records', jsonEncode(list));
                        }
                      } catch (e) {
                        debugPrint("Local storage payment update failed: $e");
                      }

                      if (mounted) {
                        emrdBloc.add(LoadEmrdStats());
                        Navigator.pop(dialogCtx);
                        navigator.pop();

                        messenger.showSnackBar(
                          SnackBar(
                            content: Text('Payment of ₹${amount.toStringAsFixed(2)} confirmed for ${record['patient_name']}'),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                    ),
                    child: const Text('Confirm Pay', style: TextStyle(color: Colors.white)),
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

  Widget _buildInvoiceSignature(String doctorName, bool isDark) {
    return Container(
      margin: EdgeInsets.only(top: 16.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.terminalDarkBg : Colors.grey[50],
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: isDark ? AppColors.terminalDarkBorder : AppColors.border,
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
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.verified_user, color: Colors.green, size: 18),
              ),
              SizedBox(width: 8.w),
              Text(
                "Authorized invoice",
                style: AppTextStyles.bodySmall.copyWith(
                  fontStyle: FontStyle.italic,
                  color: isDark ? Colors.white54 : AppColors.textSecondary,
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
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                "Authorized Signature",
                style: AppTextStyles.bodySmall.copyWith(
                  fontSize: 9.sp,
                  color: isDark ? Colors.white30 : AppColors.textSecondary.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showRecordDetailsSheet(BuildContext context, Map<String, dynamic> record) {
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
    final double medAmount = record['medicine_amount'] != null ? (record['medicine_amount'] as num).toDouble() : 0.0;
    final double labAmount = record['lab_amount'] != null ? (record['lab_amount'] as num).toDouble() : 0.0;
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
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
                                  color: isDark ? Colors.white54 : AppColors.textSecondary,
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
                          title: "General Information",
                          icon: Icons.person_outline,
                          iconColor: AppColors.primary,
                          isDark: isDark,
                          children: [
                            _buildInfoRow("Patient Name", record['patient_name'] ?? 'N/A', isDark),
                            _buildInfoRow("Doctor Name", 'Dr. ${record['doctor_name'] ?? "N/A"}', isDark),
                            _buildInfoRow("Specialty", record['specialty'] ?? 'N/A', isDark),
                            _buildInfoRow("Invoice Number", record['invoice_number'] ?? 'N/A', isDark),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        // Prescription Medicines
                        _buildDetailCard(
                          title: "Prescribed Medicines",
                          icon: Icons.medication_outlined,
                          iconColor: Colors.teal,
                          isDark: isDark,
                          children: [
                            if (record['medicines'] != null && record['medicines'].toString().trim().isNotEmpty) ...[
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.h),
                                child: Text(
                                  record['medicines'],
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    height: 1.4,
                                    color: isDark ? Colors.white70 : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              const Divider(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Medicine Total: ₹${medAmount.toStringAsFixed(2)}",
                                        style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      if (medPaid)
                                        Text(
                                          "Invoice: $medInvoice",
                                          style: AppTextStyles.bodySmall.copyWith(fontSize: 10.sp, color: AppColors.textSecondary),
                                        ),
                                    ],
                                  ),
                                  if (medPaid)
                                    Row(
                                      children: [
                                        const Icon(Icons.check_circle, color: AppColors.success, size: 16),
                                        SizedBox(width: 4.w),
                                        Text("Paid", style: AppTextStyles.bodySmall.copyWith(color: AppColors.success, fontWeight: FontWeight.bold)),
                                        SizedBox(width: 8.w),
                                        IconButton(
                                          onPressed: () => _downloadFile(record: record, isPrescription: false, customTitle: "Medicine Invoice"),
                                          icon: const Icon(Icons.download, size: 16, color: Colors.teal),
                                          tooltip: "Download Medicine Invoice PDF",
                                        ),
                                      ],
                                    )
                                  else
                                    ElevatedButton(
                                      onPressed: () => _processDepartmentPayment(
                                        record: record,
                                        isMedicine: true,
                                        amount: medAmount,
                                        invoiceNum: medInvoice,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal,
                                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text("Pay Now", style: AppTextStyles.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                                    ),
                                ],
                              ),
                            ] else
                              Text(
                                "No medicines prescribed.",
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: isDark ? Colors.white38 : AppColors.textSecondary,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        // Lab Tests
                        _buildDetailCard(
                          title: "Scheduled Lab Tests (CBC)",
                          icon: Icons.biotech_outlined,
                          iconColor: Colors.orange,
                          isDark: isDark,
                          children: [
                            if (record['lab_tests'] != null && record['lab_tests'].toString().trim().isNotEmpty) ...[
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.h),
                                child: Text(
                                  record['lab_tests'],
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    height: 1.4,
                                    color: isDark ? Colors.white70 : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                              const Divider(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Lab Test Total: ₹${labAmount.toStringAsFixed(2)}",
                                        style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold),
                                      ),
                                      if (labPaid)
                                        Text(
                                          "Invoice: $labInvoice",
                                          style: AppTextStyles.bodySmall.copyWith(fontSize: 10.sp, color: AppColors.textSecondary),
                                        ),
                                    ],
                                  ),
                                  if (labPaid)
                                    Row(
                                      children: [
                                        const Icon(Icons.check_circle, color: AppColors.success, size: 16),
                                        SizedBox(width: 4.w),
                                        Text("Paid", style: AppTextStyles.bodySmall.copyWith(color: AppColors.success, fontWeight: FontWeight.bold)),
                                        SizedBox(width: 8.w),
                                        IconButton(
                                          onPressed: () => _downloadFile(record: record, isPrescription: false, customTitle: "Lab Invoice"),
                                          icon: const Icon(Icons.download, size: 16, color: Colors.orange),
                                          tooltip: "Download Lab Invoice PDF",
                                        ),
                                      ],
                                    )
                                  else
                                    ElevatedButton(
                                      onPressed: () => _processDepartmentPayment(
                                        record: record,
                                        isMedicine: false,
                                        amount: labAmount,
                                        invoiceNum: labInvoice,
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.orange,
                                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                        minimumSize: Size.zero,
                                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                      ),
                                      child: Text("Pay Now", style: AppTextStyles.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                                    ),
                                ],
                              ),
                            ] else
                              Text(
                                "No lab tests scheduled.",
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: isDark ? Colors.white38 : AppColors.textSecondary,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        // Notes
                        _buildDetailCard(
                          title: "Consultation Notes",
                          icon: Icons.sticky_note_2_outlined,
                          iconColor: Colors.blueGrey,
                          isDark: isDark,
                          children: [
                            if (record['prescription_notes'] != null && record['prescription_notes'].toString().trim().isNotEmpty)
                              Text(
                                record['prescription_notes'],
                                style: AppTextStyles.bodyMedium.copyWith(
                                  height: 1.4,
                                  color: isDark ? Colors.white70 : AppColors.textPrimary,
                                ),
                              )
                            else
                              Text(
                                "No additional notes.",
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: isDark ? Colors.white38 : AppColors.textSecondary,
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 16.h),

                        // Billing
                        _buildDetailCard(
                          title: "Billing & Payment",
                          icon: Icons.receipt_long_outlined,
                          iconColor: Colors.green,
                          isDark: isDark,
                          children: [
                            _buildInfoRow(
                              "Consultation Fee",
                              "₹${(record['amount'] ?? 0.0).toStringAsFixed(2)}",
                              isDark,
                              valueColor: Colors.green,
                              valueFontWeight: FontWeight.bold,
                            ),
                            _buildInfoRow("Payment Method", record['payment_method'] ?? 'Cash', isDark),
                            _buildInfoRow("Payment Status", "PAID", isDark, valueColor: AppColors.success, valueFontWeight: FontWeight.bold),
                            _buildInvoiceSignature(record['doctor_name'] ?? 'Authorized Doctor', isDark),
                          ],
                        ),
                        SizedBox(height: 24.h),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _downloadFile(record: record, isPrescription: true),
                                icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                                label: const Text(
                                  "Prescription",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  padding: EdgeInsets.symmetric(vertical: 14.h),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _downloadFile(record: record, isPrescription: false),
                                icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                                label: const Text(
                                  "Consultation Inv",
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(vertical: 14.h),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
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

  Widget _buildDetailCard({
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
        border: Border.all(
          color: isDark ? AppColors.terminalDarkBorder : AppColors.border,
        ),
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
                  color: isDark ? Colors.white70 : AppColors.textPrimary,
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
    String label,
    String value,
    bool isDark, {
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
              color: isDark ? Colors.white38 : AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: valueFontWeight ?? FontWeight.w500,
              color: valueColor ?? (isDark ? Colors.white70 : AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => GetIt.I<EmrdBloc>()..add(LoadEmrdStats()),
      child: CustomScaffold(
        customAppbar: const CommonAppBar(title: "EMRD Department"),
        body: BlocBuilder<EmrdBloc, EmrdState>(
          builder: (context, state) {
            if (state is EmrdLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EmrdError) {
              return Center(
                child: Text(
                  state.message,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
                ),
              );
            } else if (state is EmrdLoaded) {
              final stats = state.stats;
              final emrRecords = state.emrRecords;

              return SingleChildScrollView(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Operational Insights",
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16.w,
                        mainAxisSpacing: 16.h,
                        childAspectRatio: 1.3,
                      ),
                      itemCount: stats.length,
                      itemBuilder: (context, index) {
                        final key = stats.keys.elementAt(index);
                        final val = stats[key];
                        final displayKey = key.split('_').map((word) {
                          if (word == 'pct') return '%';
                          if (word == 'min' || word == 'mins') return 'Mins';
                          return word[0].toUpperCase() + word.substring(1);
                        }).join(' ');

                        return Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            side: const BorderSide(color: AppColors.border),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12.r),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  displayKey,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  val.toString(),
                                  style: AppTextStyles.titleLarge.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 24.h),
                    Row(
                      children: [
                        Icon(Icons.history_edu_outlined, color: AppColors.primary, size: 22.r),
                        SizedBox(width: 8.w),
                        Text(
                          "Completed Consultations (EMR)",
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    if (emrRecords.isEmpty)
                      Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          side: const BorderSide(color: AppColors.border),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 16.w),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.assignment_outlined, size: 48.r, color: AppColors.textSecondary.withOpacity(0.4)),
                                SizedBox(height: 12.h),
                                Text(
                                  "No EMR Records Found",
                                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  "Completed consultations will be recorded and listed here.",
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: emrRecords.length,
                        itemBuilder: (context, index) {
                          final record = emrRecords[index];
                          final dateStr = record['recorded_at'] ?? record['created_at'] ?? '';
                          String formattedDate = 'N/A';
                          if (dateStr.isNotEmpty) {
                            try {
                              final dt = DateTime.parse(dateStr);
                              formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(dt);
                            } catch (_) {}
                          }

                          return Container(
                            margin: EdgeInsets.only(bottom: 12.h),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.terminalDarkCard : Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: isDark ? AppColors.terminalDarkBorder : AppColors.border,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.02),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12.r),
                                onTap: () => _showRecordDetailsSheet(context, record),
                                child: Padding(
                                  padding: EdgeInsets.all(16.r),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(10.r),
                                        decoration: BoxDecoration(
                                          color: AppColors.primary.withOpacity(0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.folder_shared_outlined,
                                          color: AppColors.primary,
                                          size: 24.r,
                                        ),
                                      ),
                                      SizedBox(width: 14.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              record['patient_name'] ?? 'Unknown Patient',
                                              style: AppTextStyles.bodyMedium.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: 4.h),
                                            Text(
                                              'Dr. ${record['doctor_name'] ?? "Unknown"} · ${record['specialty'] ?? "General"}',
                                              style: AppTextStyles.bodySmall.copyWith(
                                                color: isDark ? Colors.white54 : AppColors.textSecondary,
                                              ),
                                            ),
                                            SizedBox(height: 2.h),
                                            Text(
                                              formattedDate,
                                              style: AppTextStyles.bodySmall.copyWith(
                                                fontSize: 10.sp,
                                                color: isDark ? Colors.white30 : AppColors.textSecondary.withOpacity(0.6),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Icon(
                                        Icons.arrow_forward_ios,
                                        size: 14.r,
                                        color: isDark ? Colors.white24 : AppColors.textSecondary.withOpacity(0.4),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
