import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:medi_connect/core/theme/app_colors.dart';

class EmrdPdfHelper {
  static Future<void> downloadFile({
    required BuildContext context,
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

      if (context.mounted) {
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
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to generate PDF: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
