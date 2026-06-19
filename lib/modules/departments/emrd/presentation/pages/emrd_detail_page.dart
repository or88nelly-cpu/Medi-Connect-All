import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/router/route_names.dart';
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
import 'package:medi_connect/modules/departments/emrd/presentation/bloc/emrd_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/admin/admin_billing_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/admin/admin_pharmacy_bloc.dart';
import 'package:medi_connect/modules/departments/emrd/presentation/widgets/emrd_list_item_card.dart';
import 'package:medi_connect/modules/departments/emrd/presentation/widgets/emrd_bottom_banner.dart';

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
      final downloadsDirPath = userProfile != null
          ? '$userProfile\\Downloads'
          : Directory.current.path;
      final typeStr = isPrescription ? 'prescription' : 'invoice';
      final invoiceNum = isPrescription
          ? (record['invoice_number'] ?? 'N_A')
          : (customTitle?.contains("Medicine") == true
                ? (record['medicine_invoice_number'] ??
                      record['invoice_number'] ??
                      'N_A')
                : (customTitle?.contains("Lab") == true
                      ? (record['lab_invoice_number'] ??
                            record['invoice_number'] ??
                            'N_A')
                      : (record['invoice_number'] ?? 'N_A')));

      final fileName = '${typeStr}_$invoiceNum.pdf';
      final file = File('$downloadsDirPath\\$fileName');

      final dateStr = record['recorded_at'] ?? record['created_at'] ?? '';
      String formattedDate = 'N/A';
      if (dateStr.isNotEmpty) {
        try {
          final dt = DateTime.parse(dateStr);
          formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(dt);
        } catch (_) {}
      }

      final doc = pw.Document();

      // Common styling tokens
      const primaryColor = PdfColor.fromInt(0xff0284c7); // Aster Sky Blue/Teal
      const textColor = PdfColor.fromInt(0xff1f2937); // Dark gray
      const grayLabelColor = PdfColor.fromInt(0xff6b7280); // Light gray
      const borderColor = PdfColor.fromInt(0xffe5e7eb); // Table borders

      if (isPrescription) {
        // --- High-Fidelity PRESCRIPTION Layout (Aster MIMS Hospital style) ---
        final List<Map<String, String>> medicinesList = [];
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
              if (parts.isNotEmpty) dosage = parts[0].trim();
              if (parts.length > 1) {
                final freq = parts[1].trim();
                instructions = "After Food\n(Freq: $freq)";
              }
              if (parts.length > 2) duration = parts[2].trim();
            }
            medicinesList.add({
              'name': name,
              'dosage': dosage,
              'duration': duration,
              'instructions': instructions,
            });
          }
        }

        doc.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Header Block
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "Aster",
                            style: pw.TextStyle(
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          pw.Text(
                            "MIMS HOSPITAL",
                            style: pw.TextStyle(
                              fontSize: 11,
                              fontWeight: pw.FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          pw.Text(
                            "CALICUT",
                            style: pw.TextStyle(
                              fontSize: 7,
                              color: grayLabelColor,
                            ),
                          ),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.SizedBox(height: 4),
                          pw.Text(
                            "PRESCRIPTION",
                            style: pw.TextStyle(
                              fontSize: 18,
                              fontWeight: pw.FontWeight.bold,
                              color: textColor,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                      // QR Code placeholder on right
                      pw.Container(
                        width: 44,
                        height: 44,
                        padding: const pw.EdgeInsets.all(3),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(
                            color: PdfColors.black,
                            width: 1,
                          ),
                        ),
                        child: pw.BarcodeWidget(
                          barcode: pw.Barcode.qrCode(),
                          data: 'Prescription-$invoiceNum',
                          width: 38,
                          height: 38,
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Divider(thickness: 1.5, color: primaryColor),
                  pw.SizedBox(height: 8),

                  // Patient & Doctor Details Grid
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: borderColor, width: 1),
                      borderRadius: const pw.BorderRadius.all(
                        pw.Radius.circular(6),
                      ),
                    ),
                    child: pw.Table(
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(
                                vertical: 2,
                              ),
                              child: pw.RichText(
                                text: pw.TextSpan(
                                  children: [
                                    pw.TextSpan(
                                      text: "Patient Name : ",
                                      style: pw.TextStyle(
                                        color: grayLabelColor,
                                        fontSize: 8.5,
                                      ),
                                    ),
                                    pw.TextSpan(
                                      text: record['patient_name'] ?? 'N/A',
                                      style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 8.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(
                                vertical: 2,
                              ),
                              child: pw.RichText(
                                text: pw.TextSpan(
                                  children: [
                                    pw.TextSpan(
                                      text: "Bill No : ",
                                      style: pw.TextStyle(
                                        color: grayLabelColor,
                                        fontSize: 8.5,
                                      ),
                                    ),
                                    pw.TextSpan(
                                      text: 'OP-$invoiceNum',
                                      style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 8.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(
                                vertical: 2,
                              ),
                              child: pw.RichText(
                                text: pw.TextSpan(
                                  children: [
                                    pw.TextSpan(
                                      text: "Aster ID : ",
                                      style: pw.TextStyle(
                                        color: grayLabelColor,
                                        fontSize: 8.5,
                                      ),
                                    ),
                                    pw.TextSpan(
                                      text: record['patient_id'] != null
                                          ? record['patient_id']
                                                .toString()
                                                .substring(0, 8)
                                                .toUpperCase()
                                          : 'N/A',
                                      style: const pw.TextStyle(fontSize: 8.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(
                                vertical: 2,
                              ),
                              child: pw.RichText(
                                text: pw.TextSpan(
                                  children: [
                                    pw.TextSpan(
                                      text: "Bill Date : ",
                                      style: pw.TextStyle(
                                        color: grayLabelColor,
                                        fontSize: 8.5,
                                      ),
                                    ),
                                    pw.TextSpan(
                                      text: formattedDate,
                                      style: const pw.TextStyle(fontSize: 8.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(
                                vertical: 2,
                              ),
                              child: pw.RichText(
                                text: pw.TextSpan(
                                  children: [
                                    pw.TextSpan(
                                      text: "Age / Gender : ",
                                      style: pw.TextStyle(
                                        color: grayLabelColor,
                                        fontSize: 8.5,
                                      ),
                                    ),
                                    const pw.TextSpan(
                                      text: "28 Y 6 M / Male",
                                      style: pw.TextStyle(fontSize: 8.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(
                                vertical: 2,
                              ),
                              child: pw.RichText(
                                text: pw.TextSpan(
                                  children: [
                                    pw.TextSpan(
                                      text: "Doctor : ",
                                      style: pw.TextStyle(
                                        color: grayLabelColor,
                                        fontSize: 8.5,
                                      ),
                                    ),
                                    pw.TextSpan(
                                      text:
                                          'Dr. ${record['doctor_name'] ?? 'N/A'}',
                                      style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 8.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(
                                vertical: 2,
                              ),
                              child: pw.RichText(
                                text: pw.TextSpan(
                                  children: [
                                    pw.TextSpan(
                                      text: "Contact No : ",
                                      style: pw.TextStyle(
                                        color: grayLabelColor,
                                        fontSize: 8.5,
                                      ),
                                    ),
                                    const pw.TextSpan(
                                      text: "9495123456",
                                      style: pw.TextStyle(fontSize: 8.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(
                                vertical: 2,
                              ),
                              child: pw.RichText(
                                text: pw.TextSpan(
                                  children: [
                                    pw.TextSpan(
                                      text: "Address : ",
                                      style: pw.TextStyle(
                                        color: grayLabelColor,
                                        fontSize: 8.5,
                                      ),
                                    ),
                                    const pw.TextSpan(
                                      text:
                                          "12/345, West Hill, Calicut, Kerala, India - 673005",
                                      style: pw.TextStyle(fontSize: 8.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 16),

                  // Section Title
                  pw.Text(
                    "Rx (Prescribed Medicines)",
                    style: pw.TextStyle(
                      fontSize: 11,
                      fontWeight: pw.FontWeight.bold,
                      color: primaryColor,
                    ),
                  ),
                  pw.SizedBox(height: 4),

                  // Rx Table
                  pw.Table(
                    border: const pw.TableBorder(
                      bottom: pw.BorderSide(color: borderColor, width: 1),
                      horizontalInside: pw.BorderSide(
                        color: borderColor,
                        width: 0.8,
                      ),
                    ),
                    columnWidths: const {
                      0: pw.FractionColumnWidth(0.06), // SN
                      1: pw.FractionColumnWidth(0.40), // Medicine
                      2: pw.FractionColumnWidth(0.18), // Dosage
                      3: pw.FractionColumnWidth(0.16), // Duration
                      4: pw.FractionColumnWidth(0.20), // Instructions
                    },
                    children: [
                      // Header Row
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(
                          color: PdfColors.grey100,
                        ),
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              "Rx",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 8.5,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              "Medicine",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 8.5,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              "Dosage",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 8.5,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              "Duration",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 8.5,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              "Instructions",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 8.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                      // Row Items
                      if (medicinesList.isNotEmpty)
                        ...medicinesList.asMap().entries.map((entry) {
                          final idx = entry.key + 1;
                          final med = entry.value;
                          return pw.TableRow(
                            children: [
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(6),
                                child: pw.Text(
                                  "$idx.",
                                  style: const pw.TextStyle(fontSize: 8.5),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(6),
                                child: pw.Text(
                                  med['name'] ?? '',
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 8.5,
                                  ),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(6),
                                child: pw.Text(
                                  med['dosage'] ?? '',
                                  style: const pw.TextStyle(fontSize: 8.5),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(6),
                                child: pw.Text(
                                  med['duration'] ?? '',
                                  style: const pw.TextStyle(fontSize: 8.5),
                                ),
                              ),
                              pw.Padding(
                                padding: const pw.EdgeInsets.all(6),
                                child: pw.Text(
                                  med['instructions'] ?? '',
                                  style: const pw.TextStyle(fontSize: 8.5),
                                ),
                              ),
                            ],
                          );
                        })
                      else
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(""),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(
                                "No medicines prescribed.",
                                style: pw.TextStyle(
                                  fontStyle: pw.FontStyle.italic,
                                  fontSize: 8.5,
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(""),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(""),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.all(8),
                              child: pw.Text(""),
                            ),
                          ],
                        ),
                    ],
                  ),
                  pw.SizedBox(height: 16),

                  // Investigations Advised Block
                  if (record['lab_tests'] != null &&
                      record['lab_tests'].toString().trim().isNotEmpty) ...[
                    pw.Text(
                      "Investigations Advised :",
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    ...record['lab_tests'].toString().split(',').map((test) {
                      return pw.Padding(
                        padding: const pw.EdgeInsets.only(left: 10, bottom: 2),
                        child: pw.Text(
                          "• ${test.trim()}",
                          style: const pw.TextStyle(
                            fontSize: 8.5,
                            color: textColor,
                          ),
                        ),
                      );
                    }),
                    pw.SizedBox(height: 16),
                  ],

                  // Notes / Clinical Advice
                  if (record['prescription_notes'] != null &&
                      record['prescription_notes']
                          .toString()
                          .trim()
                          .isNotEmpty) ...[
                    pw.Text(
                      "Clinical Notes / Advice :",
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontWeight: pw.FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(left: 10),
                      child: pw.Text(
                        record['prescription_notes'],
                        style: const pw.TextStyle(
                          fontSize: 8.5,
                          color: PdfColors.grey800,
                        ),
                      ),
                    ),
                    pw.SizedBox(height: 16),
                  ],

                  pw.Spacer(),

                  // Bottom signature & details
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "Date : ${formattedDate.split(' ').first}",
                            style: const pw.TextStyle(fontSize: 8.5),
                          ),
                          pw.SizedBox(height: 2),
                          pw.Text(
                            "Time : ${formattedDate.contains(' ') ? formattedDate.split(' ').last : ''}",
                            style: const pw.TextStyle(fontSize: 8.5),
                          ),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.end,
                        children: [
                          // Handwritten cursive simulated signature
                          pw.Text(
                            record['doctor_name'] ?? 'Authorized Doctor',
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              fontStyle: pw.FontStyle.italic,
                              color: primaryColor,
                            ),
                          ),
                          pw.SizedBox(height: 4),
                          pw.Text(
                            "Dr. ${record['doctor_name'] ?? 'N/A'}",
                            style: pw.TextStyle(
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          pw.Text(
                            "MBBS, MD (${record['specialty'] ?? 'Specialist'})",
                            style: pw.TextStyle(
                              fontSize: 7.5,
                              color: grayLabelColor,
                            ),
                          ),
                          pw.Text(
                            "Reg. No: 56789",
                            style: pw.TextStyle(
                              fontSize: 7.5,
                              color: grayLabelColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Divider(thickness: 1, color: borderColor),
                  pw.SizedBox(height: 4),
                  pw.Center(
                    child: pw.Text(
                      "Note: Please take medicines as advised. Do not stop the medicines in between. In case of any side effects, consult your doctor.",
                      style: pw.TextStyle(
                        fontSize: 7,
                        color: grayLabelColor,
                        fontStyle: pw.FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      } else {
        // --- High-Fidelity INVOICE / BILL OF SUPPLY Layout (Aster MIMS Hospital style) ---
        final isMedicine = customTitle?.contains("Medicine") == true;
        final isLab = customTitle?.contains("Lab") == true;
        final double consultationFee = 500.00;
        final double medicineAmount = record['medicine_amount'] != null
            ? (record['medicine_amount'] as num).toDouble()
            : 0.0;
        final double labAmount = record['lab_amount'] != null
            ? (record['lab_amount'] as num).toDouble()
            : 0.0;

        final double selectedAmt = isMedicine
            ? medicineAmount
            : (isLab ? labAmount : consultationFee);
        final double grandTotal = selectedAmt;

        doc.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            margin: const pw.EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // Header Block
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "Aster",
                            style: pw.TextStyle(
                              fontSize: 24,
                              fontWeight: pw.FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          pw.Text(
                            "MIMS HOSPITAL",
                            style: pw.TextStyle(
                              fontSize: 11,
                              fontWeight: pw.FontWeight.bold,
                              color: primaryColor,
                            ),
                          ),
                          pw.Text(
                            "CALICUT",
                            style: const pw.TextStyle(
                              fontSize: 7,
                              color: grayLabelColor,
                            ),
                          ),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.SizedBox(height: 4),
                          pw.Text(
                            "BILL OF SUPPLY",
                            style: pw.TextStyle(
                              fontSize: 16,
                              fontWeight: pw.FontWeight.bold,
                              color: textColor,
                              letterSpacing: 1.2,
                            ),
                          ),
                          pw.Text(
                            "Duplicate",
                            style: pw.TextStyle(
                              fontSize: 8,
                              fontStyle: pw.FontStyle.italic,
                              color: grayLabelColor,
                            ),
                          ),
                        ],
                      ),
                      pw.SizedBox(width: 50), // alignment helper
                    ],
                  ),
                  pw.SizedBox(height: 8),

                  // GSTIN Row
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        "GSTIN : 32AACCM3480H2ZO",
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                      pw.Text(
                        "HSN Code: 9993",
                        style: pw.TextStyle(
                          fontSize: 8,
                          fontWeight: pw.FontWeight.bold,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                  pw.Divider(thickness: 1.5, color: primaryColor),
                  pw.SizedBox(height: 6),

                  // Bill Details Grid
                  pw.Container(
                    padding: const pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: borderColor, width: 1),
                      borderRadius: const pw.BorderRadius.all(
                        pw.Radius.circular(6),
                      ),
                    ),
                    child: pw.Table(
                      children: [
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(
                                vertical: 2,
                              ),
                              child: pw.RichText(
                                text: pw.TextSpan(
                                  children: [
                                    pw.TextSpan(
                                      text: "Bill No : ",
                                      style: pw.TextStyle(
                                        color: grayLabelColor,
                                        fontSize: 8.5,
                                      ),
                                    ),
                                    pw.TextSpan(
                                      text: invoiceNum,
                                      style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 8.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(
                                vertical: 2,
                              ),
                              child: pw.RichText(
                                text: pw.TextSpan(
                                  children: [
                                    pw.TextSpan(
                                      text: "Bill Date : ",
                                      style: pw.TextStyle(
                                        color: grayLabelColor,
                                        fontSize: 8.5,
                                      ),
                                    ),
                                    pw.TextSpan(
                                      text: formattedDate,
                                      style: const pw.TextStyle(fontSize: 8.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(
                                vertical: 2,
                              ),
                              child: pw.RichText(
                                text: pw.TextSpan(
                                  children: [
                                    pw.TextSpan(
                                      text: "Presc. Doctor : ",
                                      style: pw.TextStyle(
                                        color: grayLabelColor,
                                        fontSize: 8.5,
                                      ),
                                    ),
                                    pw.TextSpan(
                                      text:
                                          'Dr. ${record['doctor_name'] ?? 'N/A'}',
                                      style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 8.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(
                                vertical: 2,
                              ),
                              child: pw.RichText(
                                text: pw.TextSpan(
                                  children: [
                                    pw.TextSpan(
                                      text: "Aster ID : ",
                                      style: pw.TextStyle(
                                        color: grayLabelColor,
                                        fontSize: 8.5,
                                      ),
                                    ),
                                    pw.TextSpan(
                                      text: record['patient_id'] != null
                                          ? record['patient_id']
                                                .toString()
                                                .substring(0, 8)
                                                .toUpperCase()
                                          : 'N/A',
                                      style: const pw.TextStyle(fontSize: 8.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(
                                vertical: 2,
                              ),
                              child: pw.RichText(
                                text: pw.TextSpan(
                                  children: [
                                    pw.TextSpan(
                                      text: "Gender/Age : ",
                                      style: pw.TextStyle(
                                        color: grayLabelColor,
                                        fontSize: 8.5,
                                      ),
                                    ),
                                    const pw.TextSpan(
                                      text: "Male/28 Y 6 M",
                                      style: pw.TextStyle(fontSize: 8.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(
                                vertical: 2,
                              ),
                              child: pw.RichText(
                                text: pw.TextSpan(
                                  children: [
                                    pw.TextSpan(
                                      text: "Refered By : ",
                                      style: pw.TextStyle(
                                        color: grayLabelColor,
                                        fontSize: 8.5,
                                      ),
                                    ),
                                    const pw.TextSpan(
                                      text: "Self",
                                      style: pw.TextStyle(fontSize: 8.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(
                                vertical: 2,
                              ),
                              child: pw.RichText(
                                text: pw.TextSpan(
                                  children: [
                                    pw.TextSpan(
                                      text: "Patient Name : ",
                                      style: pw.TextStyle(
                                        color: grayLabelColor,
                                        fontSize: 8.5,
                                      ),
                                    ),
                                    pw.TextSpan(
                                      text: record['patient_name'] ?? 'N/A',
                                      style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 8.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(
                                vertical: 2,
                              ),
                              child: pw.RichText(
                                text: pw.TextSpan(
                                  children: [
                                    pw.TextSpan(
                                      text: "Contact No : ",
                                      style: pw.TextStyle(
                                        color: grayLabelColor,
                                        fontSize: 8.5,
                                      ),
                                    ),
                                    const pw.TextSpan(
                                      text: "9495123456",
                                      style: pw.TextStyle(fontSize: 8.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(
                                vertical: 2,
                              ),
                              child: pw.RichText(
                                text: pw.TextSpan(
                                  children: [
                                    pw.TextSpan(
                                      text: "Patient Address : ",
                                      style: pw.TextStyle(
                                        color: grayLabelColor,
                                        fontSize: 8.5,
                                      ),
                                    ),
                                    const pw.TextSpan(
                                      text: "West Hill, Calicut",
                                      style: pw.TextStyle(fontSize: 8.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        pw.TableRow(
                          children: [
                            pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(
                                vertical: 2,
                              ),
                              child: pw.RichText(
                                text: pw.TextSpan(
                                  children: [
                                    pw.TextSpan(
                                      text: "Payer : ",
                                      style: pw.TextStyle(
                                        color: grayLabelColor,
                                        fontSize: 8.5,
                                      ),
                                    ),
                                    pw.TextSpan(
                                      text: "SELF PAY",
                                      style: pw.TextStyle(
                                        fontWeight: pw.FontWeight.bold,
                                        fontSize: 8.5,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(
                                vertical: 2,
                              ),
                              child: pw.RichText(
                                text: pw.TextSpan(
                                  children: [
                                    pw.TextSpan(
                                      text: "State Code : ",
                                      style: pw.TextStyle(
                                        color: grayLabelColor,
                                        fontSize: 8.5,
                                      ),
                                    ),
                                    const pw.TextSpan(
                                      text: "32",
                                      style: pw.TextStyle(fontSize: 8.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            pw.Padding(
                              padding: const pw.EdgeInsets.symmetric(
                                vertical: 2,
                              ),
                              child: pw.RichText(
                                text: pw.TextSpan(
                                  children: [
                                    pw.TextSpan(
                                      text: "Payer Address : ",
                                      style: pw.TextStyle(
                                        color: grayLabelColor,
                                        fontSize: 8.5,
                                      ),
                                    ),
                                    const pw.TextSpan(
                                      text: "Calicut, Kerala",
                                      style: pw.TextStyle(fontSize: 8.5),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 14),

                  // Service Particulars Table
                  pw.Table(
                    border: const pw.TableBorder(
                      bottom: pw.BorderSide(color: borderColor, width: 1),
                      horizontalInside: pw.BorderSide(
                        color: borderColor,
                        width: 0.8,
                      ),
                    ),
                    columnWidths: const {
                      0: pw.FractionColumnWidth(0.05), // SN
                      1: pw.FractionColumnWidth(0.12), // SrCode
                      2: pw.FractionColumnWidth(0.12), // SAC
                      3: pw.FractionColumnWidth(0.35), // Service Particulars
                      4: pw.FractionColumnWidth(0.12), // Rate
                      5: pw.FractionColumnWidth(0.08), // Unit
                      6: pw.FractionColumnWidth(0.16), // Total
                    },
                    children: [
                      // Header Row
                      pw.TableRow(
                        decoration: const pw.BoxDecoration(
                          color: PdfColors.grey100,
                        ),
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              "SN",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 8.5,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              "SrCode",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 8.5,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              "SAC",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 8.5,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              "Service Particulars",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 8.5,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              "Rate (R)",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 8.5,
                              ),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              "Unit",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 8.5,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              "Net Amt",
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 8.5,
                              ),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      // Service Row
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(6),
                            child: pw.Text(
                              "1",
                              style: const pw.TextStyle(fontSize: 8.5),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(6),
                            child: pw.Text(
                              isMedicine
                                  ? "11858"
                                  : (isLab ? "11950" : "10101"),
                              style: const pw.TextStyle(fontSize: 8.5),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(6),
                            child: pw.Text(
                              "999311",
                              style: const pw.TextStyle(fontSize: 8.5),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(6),
                            child: pw.Text(
                              isMedicine
                                  ? "MEDICINE & CONSUMABLE"
                                  : (isLab
                                        ? "LAB - CBC DIAGNOSTICS"
                                        : "CONSULTATION CHARGE"),
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 8.5,
                              ),
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(6),
                            child: pw.Text(
                              selectedAmt.toStringAsFixed(2),
                              style: const pw.TextStyle(fontSize: 8.5),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(6),
                            child: pw.Text(
                              "1",
                              style: const pw.TextStyle(fontSize: 8.5),
                              textAlign: pw.TextAlign.center,
                            ),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(6),
                            child: pw.Text(
                              selectedAmt.toStringAsFixed(2),
                              style: const pw.TextStyle(fontSize: 8.5),
                              textAlign: pw.TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 12),

                  // Total & Summary Panel
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.end,
                    children: [
                      pw.Container(
                        width: 200,
                        padding: const pw.EdgeInsets.all(6),
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(color: borderColor, width: 1),
                          borderRadius: const pw.BorderRadius.all(
                            pw.Radius.circular(4),
                          ),
                        ),
                        child: pw.Column(
                          children: [
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  "Total Amount:",
                                  style: const pw.TextStyle(fontSize: 8.5),
                                ),
                                pw.Text(
                                  "R ${grandTotal.toStringAsFixed(2)}",
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 8.5,
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 3),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  "Net Amount:",
                                  style: const pw.TextStyle(fontSize: 8.5),
                                ),
                                pw.Text(
                                  "R ${grandTotal.toStringAsFixed(2)}",
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 8.5,
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 3),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  "Patient Amount:",
                                  style: const pw.TextStyle(fontSize: 8.5),
                                ),
                                pw.Text(
                                  "R ${grandTotal.toStringAsFixed(2)}",
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    fontSize: 8.5,
                                  ),
                                ),
                              ],
                            ),
                            pw.SizedBox(height: 3),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text(
                                  "Amt Received:",
                                  style: const pw.TextStyle(fontSize: 8.5),
                                ),
                                pw.Text(
                                  "R ${grandTotal.toStringAsFixed(2)}",
                                  style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold,
                                    color: primaryColor,
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 16),

                  // Transaction Method
                  pw.Text(
                    "By UPI: ${grandTotal.toStringAsFixed(2)} State Bank of India 123456789012",
                    style: pw.TextStyle(
                      fontSize: 8,
                      fontStyle: pw.FontStyle.italic,
                      color: textColor,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    "Received from ${record['patient_name'] ?? 'Mr. Rohan Kumar'}, an amount of (INR) ${NumberFormat.simpleCurrency(name: 'INR').format(grandTotal).replaceAll('₹', '')} Only",
                    style: pw.TextStyle(
                      fontSize: 8.5,
                      fontWeight: pw.FontWeight.bold,
                      color: textColor,
                    ),
                  ),

                  pw.Spacer(),

                  // Bottom footer elements
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            "Printed By: Admin",
                            style: pw.TextStyle(
                              fontSize: 7.5,
                              color: grayLabelColor,
                            ),
                          ),
                          pw.Text(
                            "Prepared By: Staff (Billing)",
                            style: pw.TextStyle(
                              fontSize: 7.5,
                              color: grayLabelColor,
                            ),
                          ),
                        ],
                      ),
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.center,
                        children: [
                          pw.Text(
                            "(Sruthi C)",
                            style: pw.TextStyle(
                              fontSize: 9,
                              fontWeight: pw.FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          pw.Text(
                            "(Signature)",
                            style: pw.TextStyle(
                              fontSize: 7.5,
                              color: grayLabelColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 10),
                  pw.Divider(thickness: 1, color: borderColor),
                  pw.SizedBox(height: 4),
                  pw.Center(
                    child: pw.Column(
                      children: [
                        pw.Text(
                          "Malabar Institute of Medical Sciences Ltd.",
                          style: pw.TextStyle(
                            fontSize: 8,
                            fontWeight: pw.FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        pw.Text(
                          "Mini By-pass Road, Govindapuram P.O, Calicut - 673 016, Kerala | E-mail: mimsclt@asterhospital.com | Tel: 91-495-2488 000",
                          style: pw.TextStyle(
                            fontSize: 6.5,
                            color: grayLabelColor,
                          ),
                        ),
                      ],
                    ),
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
            content: Text(
              '${customTitle ?? (isPrescription ? "Prescription" : "Invoice")} PDF generated in Downloads folder.',
            ),
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
              backgroundColor: isDark
                  ? AppColors.terminalDarkCard
                  : Colors.white,
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
                            final medicinesText =
                                record['medicines'] as String?;
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
                                  final currentStock =
                                      response['stock'] as int? ?? 0;
                                  final newStock = (currentStock - 1).clamp(
                                    0,
                                    999999,
                                  );
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

                        if (mounted) {
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
                            if (item['appointment_id'] ==
                                record['appointment_id']) {
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

                      if (mounted) {
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

  Widget _buildInvoiceSignature(String doctorName, bool isDark) {
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

  void _showRecordDetailsSheet(
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
                          title: "General Information",
                          icon: Icons.person_outline,
                          iconColor: AppColors.primary,
                          isDark: isDark,
                          children: [
                            _buildInfoRow(
                              "Patient Name",
                              record['patient_name'] ?? 'N/A',
                              isDark,
                            ),
                            _buildInfoRow(
                              "Doctor Name",
                              'Dr. ${record['doctor_name'] ?? "N/A"}',
                              isDark,
                            ),
                            _buildInfoRow(
                              "Specialty",
                              record['specialty'] ?? 'N/A',
                              isDark,
                            ),
                            _buildInfoRow(
                              "Invoice Number",
                              record['invoice_number'] ?? 'N/A',
                              isDark,
                            ),
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
                                                "Instructions: ${med['instructions']}",
                                                style: AppTextStyles.bodySmall
                                                    .copyWith(
                                                      fontSize: 10.sp,
                                                      color:
                                                          AppColors.textSecondary(
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
                                }).toList();
                              }(),
                              const Divider(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
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
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
                                                color: AppColors.success,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        SizedBox(width: 8.w),
                                        IconButton(
                                          onPressed: () => _downloadFile(
                                            record: record,
                                            isPrescription: false,
                                            customTitle: "Medicine Invoice",
                                          ),
                                          icon: const Icon(
                                            Icons.download,
                                            size: 16,
                                            color: Colors.teal,
                                          ),
                                          tooltip:
                                              "Download Medicine Invoice PDF",
                                        ),
                                      ],
                                    )
                                  else
                                    ElevatedButton(
                                      onPressed: () =>
                                          _processDepartmentPayment(
                                            record: record,
                                            isMedicine: true,
                                            amount: medAmount,
                                            invoiceNum: medInvoice,
                                          ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.teal,
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
                                "No medicines prescribed.",
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

                        // Lab Tests
                        _buildDetailCard(
                          title: "Scheduled Lab Tests (CBC)",
                          icon: Icons.biotech_outlined,
                          iconColor: Colors.orange,
                          isDark: isDark,
                          children: [
                            if (record['lab_tests'] != null &&
                                record['lab_tests']
                                    .toString()
                                    .trim()
                                    .isNotEmpty) ...[
                              ...() {
                                final rawLab =
                                    record['lab_tests'] as String? ?? '';
                                final List<String> tests = rawLab
                                    .split(RegExp(r'[,\n]'))
                                    .map((t) => t.trim())
                                    .where((t) => t.isNotEmpty)
                                    .toList();

                                return tests.map<Widget>((test) {
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
                                      children: [
                                        Container(
                                          padding: EdgeInsets.all(8.r),
                                          decoration: BoxDecoration(
                                            color: Colors.orange.withValues(
                                              alpha: 0.1,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Icon(
                                            Icons.biotech_outlined,
                                            color: Colors.orange,
                                            size: 18,
                                          ),
                                        ),
                                        SizedBox(width: 12.w),
                                        Expanded(
                                          child: Text(
                                            test,
                                            style: AppTextStyles.bodyMedium
                                                .copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  color: isDark
                                                      ? Colors.white
                                                      : AppColors.textPrimary(
                                                          context,
                                                        ),
                                                ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList();
                              }(),
                              const Divider(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
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
                                          style: AppTextStyles.bodySmall
                                              .copyWith(
                                                color: AppColors.success,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        SizedBox(width: 8.w),
                                        IconButton(
                                          onPressed: () => _downloadFile(
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
                                      onPressed: () =>
                                          _processDepartmentPayment(
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
                            _buildInfoRow(
                              "Payment Method",
                              record['payment_method'] ?? 'Cash',
                              isDark,
                            ),
                            _buildInfoRow(
                              "Payment Status",
                              "PAID",
                              isDark,
                              valueColor: AppColors.success,
                              valueFontWeight: FontWeight.bold,
                            ),
                            _buildInvoiceSignature(
                              record['doctor_name'] ?? 'Authorized Doctor',
                              isDark,
                            ),
                          ],
                        ),
                        SizedBox(height: 24.h),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _downloadFile(
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
                                onPressed: () => _downloadFile(
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
                  color: isDark
                      ? Colors.white70
                      : AppColors.textPrimary(context),
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

  @override
  Widget build(BuildContext context) {
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
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.error,
                  ),
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
                    Row(
                      children: [
                        Icon(
                          Icons.history_edu_outlined,
                          color: AppColors.primary,
                          size: 22.r,
                        ),
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
                          side: BorderSide(color: AppColors.border(context)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 32.h,
                            horizontal: 16.w,
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.assignment_outlined,
                                  size: 48.r,
                                  color: AppColors.textSecondary(
                                    context,
                                  ).withValues(alpha: 0.4),
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  "No EMR Records Found",
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  "Completed consultations will be recorded and listed here.",
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.textSecondary(context),
                                  ),
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
                          return EmrdListItemCard(
                            record: record,
                            onTap: () =>
                                _showRecordDetailsSheet(context, record),
                          );
                        },
                      ),
                    SizedBox(height: 20.h),
                    EmrdBottomBanner(
                      onCreateEMR: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Please complete a consultation from the Appointments page to generate a new EMR record.",
                            ),
                            backgroundColor: AppColors.primary,
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
