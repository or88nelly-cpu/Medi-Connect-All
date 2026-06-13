import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/common_widgets/common_app_bar.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/departments/emrd/presentation/bloc/emrd_bloc.dart';

class EmrdDetailPage extends StatefulWidget {
  const EmrdDetailPage({super.key});

  @override
  State<EmrdDetailPage> createState() => _EmrdDetailPageState();
}

class _EmrdDetailPageState extends State<EmrdDetailPage> {
  Future<void> _downloadFile({
    required Map<String, dynamic> record,
    required bool isPrescription,
  }) async {
    try {
      final userProfile = Platform.environment['USERPROFILE'];
      final downloadsDirPath = userProfile != null ? '$userProfile\\Downloads' : Directory.current.path;
      final typeStr = isPrescription ? 'prescription' : 'invoice';
      final invoiceNum = record['invoice_number'] ?? 'N_A';
      final fileName = '${typeStr}_$invoiceNum.txt';
      final file = File('$downloadsDirPath\\$fileName');

      final content = StringBuffer();
      if (isPrescription) {
        content.writeln("==========================================");
        content.writeln("             MEDI-CONNECT PRESCRIPTION     ");
        content.writeln("==========================================");
        content.writeln("Date: ${record['recorded_at'] ?? record['created_at']}");
        content.writeln("Patient Name: ${record['patient_name']}");
        content.writeln("Doctor Name: ${record['doctor_name']}");
        content.writeln("Specialty: ${record['specialty']}");
        content.writeln("Invoice Number: $invoiceNum");
        content.writeln("------------------------------------------");
        content.writeln("Medicines:");
        content.writeln(record['medicines'] ?? 'None prescribed');
        content.writeln("------------------------------------------");
        content.writeln("Lab Tests / Scanning:");
        content.writeln(record['lab_tests'] ?? 'None scheduled');
        content.writeln("------------------------------------------");
        content.writeln("Prescription Notes:");
        content.writeln(record['prescription_notes'] ?? 'None');
        content.writeln("==========================================");
      } else {
        content.writeln("==========================================");
        content.writeln("             MEDI-CONNECT INVOICE          ");
        content.writeln("==========================================");
        content.writeln("Date: ${record['recorded_at'] ?? record['created_at']}");
        content.writeln("Patient Name: ${record['patient_name']}");
        content.writeln("Doctor Name: ${record['doctor_name']}");
        content.writeln("Specialty: ${record['specialty']}");
        content.writeln("Invoice Number: $invoiceNum");
        content.writeln("------------------------------------------");
        content.writeln("Consultation Fee: ₹${(record['amount'] ?? 0.0).toStringAsFixed(2)}");
        content.writeln("Payment Method: ${record['payment_method'] ?? 'Cash'}");
        content.writeln("Payment Status: PAID");
        content.writeln("==========================================");
      }

      await file.writeAsString(content.toString());

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${isPrescription ? "Prescription" : "Invoice"} downloaded to Downloads folder.'),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'OPEN',
              textColor: Colors.white,
              onPressed: () {
                try {
                  Process.run('explorer.exe', [file.path]);
                } catch (e) {
                  debugPrint("Could not open file: $e");
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
            content: Text('Failed to download: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
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
                            if (record['medicines'] != null && record['medicines'].toString().trim().isNotEmpty)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.h),
                                child: Text(
                                  record['medicines'],
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    height: 1.4,
                                    color: isDark ? Colors.white70 : AppColors.textPrimary,
                                  ),
                                ),
                              )
                            else
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
                          title: "Scheduled Lab Tests",
                          icon: Icons.biotech_outlined,
                          iconColor: Colors.orange,
                          isDark: isDark,
                          children: [
                            if (record['lab_tests'] != null && record['lab_tests'].toString().trim().isNotEmpty)
                              Padding(
                                padding: EdgeInsets.symmetric(vertical: 4.h),
                                child: Text(
                                  record['lab_tests'],
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    height: 1.4,
                                    color: isDark ? Colors.white70 : AppColors.textPrimary,
                                  ),
                                ),
                              )
                            else
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
                              "Amount Paid",
                              "₹${(record['amount'] ?? 0.0).toStringAsFixed(2)}",
                              isDark,
                              valueColor: Colors.green,
                              valueFontWeight: FontWeight.bold,
                            ),
                            _buildInfoRow("Payment Method", record['payment_method'] ?? 'Cash', isDark),
                            _buildInfoRow("Payment Status", "PAID", isDark, valueColor: AppColors.success, valueFontWeight: FontWeight.bold),
                          ],
                        ),
                        SizedBox(height: 24.h),

                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () => _downloadFile(record: record, isPrescription: true),
                                icon: const Icon(Icons.download, color: Colors.white),
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
                                icon: const Icon(Icons.download, color: Colors.white),
                                label: const Text(
                                  "Invoice",
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
