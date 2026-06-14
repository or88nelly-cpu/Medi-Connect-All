import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:get_it/get_it.dart';
import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/core/storage/secure_storage_service.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/dash_board/domain/entities/appointment_entity.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/utils/profile_image_helper.dart';
import 'package:medi_connect/core/common_widgets/buttons/gradient_button.dart';

class AppointmentCard extends StatelessWidget {
  final AppointmentEntity appointment;
  final VoidCallback onCancel;
  final VoidCallback onComplete;

  const AppointmentCard({
    super.key,
    required this.appointment,
    required this.onCancel,
    required this.onComplete,
  });

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Completed':
        return Colors.purple;
      case 'Cancelled':
      default:
        return Colors.red;
    }
  }

  Color _getStatusBgColor(String status, bool isDark) {
    switch (status) {
      case 'Confirmed':
        return isDark ? const Color(0xFF064E3B) : const Color(0xFFDCFCE7);
      case 'Pending':
        return isDark ? const Color(0xFF7C2D12) : const Color(0xFFFFEDD5);
      case 'Completed':
        return isDark ? const Color(0xFF3B0764) : const Color(0xFFF3E8FF);
      case 'Cancelled':
      default:
        return isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2);
    }
  }

  Color _getStatusTextColor(String status, bool isDark) {
    switch (status) {
      case 'Confirmed':
        return isDark ? const Color(0xFF4ADE80) : const Color(0xFF15803D);
      case 'Pending':
        return isDark ? const Color(0xFFFDBA74) : const Color(0xFFC2410C);
      case 'Completed':
        return isDark ? const Color(0xFFC084FC) : const Color(0xFF7E22CE);
      case 'Cancelled':
      default:
        return isDark ? const Color(0xFFFCA5A5) : const Color(0xFFB91C1C);
    }
  }

  Color _getChipBgColor(String patientId, bool isDark) {
    return isDark ? const Color(0xFF0F2C59) : const Color(0xFFE0F2FE);
  }

  Color _getChipTextColor(String patientId, bool isDark) {
    return isDark ? const Color(0xFF38BDF8) : const Color(0xFF0369A1);
  }

  String _cleanDoctorName(String raw) {
    String cleaned = raw.trim();
    if (cleaned.toLowerCase().startsWith('dr.')) {
      cleaned = cleaned.substring(3).trim();
    } else if (cleaned.toLowerCase().startsWith('dr')) {
      cleaned = cleaned.substring(2).trim();
    }
    return 'Dr. $cleaned';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = _getStatusColor(appointment.status);
    final formattedDate = DateFormat(
      'dd MMM yyyy',
    ).format(appointment.appointmentDate);
    final shortId = (appointment.patientId?.length ?? 0) > 8
        ? appointment.patientId?.substring(0, 8).toUpperCase()
        : appointment.patientId?.toUpperCase();

    final docName = _cleanDoctorName(appointment.doctorName);

    // Status text styles
    final badgeBgColor = _getStatusBgColor(appointment.status, isDark);
    final badgeTextColor = _getStatusTextColor(appointment.status, isDark);

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.terminalDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? AppColors.terminalDarkBorder : AppColors.border,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Vertical Left Status Bar Indicator
              Container(width: 4.w, color: statusColor),
              Expanded(
                child: Theme(
                  data: Theme.of(
                    context,
                  ).copyWith(dividerColor: Colors.transparent),
                  child: ExpansionTile(
                    childrenPadding: EdgeInsets.fromLTRB(16.r, 0, 16.r, 16.r),
                    tilePadding: EdgeInsets.symmetric(
                      horizontal: 16.r,
                      vertical: 8.r,
                    ),
                    leading: CircleAvatar(
                      radius: 22.r,
                      backgroundColor: Colors.blue.withOpacity(0.1),
                      child: ClipOval(
                        child: CustomImageView(
                          imagePath: ProfileImageHelper.resolveImagePath(
                            'https://api.dicebear.com/7.x/adventurer/png?seed=${Uri.encodeComponent(appointment.patientName)}',
                            'patient',
                            null,
                          ),
                          width: 44.r,
                          height: 44.r,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Patient name and ID tag
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appointment.patientName,
                                style: AppTextStyles.titleMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              // Patient ID Chip
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 6.w,
                                  vertical: 2.h,
                                ),
                                decoration: BoxDecoration(
                                  color: _getChipBgColor(
                                    appointment.patientId ?? "",
                                    isDark,
                                  ),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  "Patient ID: PAT-$shortId",
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    color: _getChipTextColor(
                                      appointment.patientId ?? "",
                                      isDark,
                                    ),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Status Badge
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: badgeBgColor,
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            appointment.status,
                            style: TextStyle(
                              color: badgeTextColor,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(top: 6.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (appointment.token != null &&
                              appointment.token!.isNotEmpty) ...[
                            Text(
                              "Token No:- ${appointment.token}",
                              style: TextStyle(
                                color: isDark
                                    ? AppColors.accent
                                    : AppColors.primary,
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                              ),
                            ),
                            SizedBox(height: 4.h),
                          ],
                          Row(
                            children: [
                              Icon(
                                Icons.person,
                                size: 12.r,
                                color: isDark
                                    ? Colors.white54
                                    : AppColors.textSecondary,
                              ),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: Text(
                                  "$docName (${appointment.specialty})",
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: isDark
                                        ? Colors.white70
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          // Date / Time block
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today,
                                size: 11.r,
                                color: isDark
                                    ? Colors.white30
                                    : AppColors.textSecondary.withOpacity(0.5),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                formattedDate,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: isDark
                                      ? Colors.white54
                                      : AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Icon(
                                Icons.access_time,
                                size: 11.r,
                                color: isDark
                                    ? Colors.white30
                                    : AppColors.textSecondary.withOpacity(0.5),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                appointment.appointmentTime,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: isDark
                                      ? Colors.white54
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    children: [
                      const Divider(height: 16),
                      // Consultation type
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                appointment.type == 'Video'
                                    ? Icons.video_call
                                    : Icons.local_hospital_outlined,
                                size: 14.r,
                                color: isDark
                                    ? Colors.white54
                                    : AppColors.textSecondary,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                appointment.type,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.white70
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          // Outlined Call Button
                          OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Calling ${appointment.patientName} at +91 9495123456...',
                                  ),
                                  backgroundColor: AppColors.primary,
                                ),
                              );
                            },
                            icon: const Icon(Icons.phone_outlined, size: 14),
                            label: const Text(
                              'Call',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primary,
                              side: const BorderSide(color: AppColors.primary),
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 6.h,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      // Expandable actions based on status
                      if (appointment.status == 'Confirmed' || appointment.status == 'Pending')
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  _showAppointmentDetailsDialog(context);
                                },
                                icon: const Icon(Icons.info_outline, size: 16, color: Colors.blue),
                                label: const Text(
                                  'View Details',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.blue,
                                  side: const BorderSide(color: Colors.blue),
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: onComplete,
                                icon: const Icon(Icons.check_circle_outline, size: 16, color: Colors.green),
                                label: const Text(
                                  'Mark as Completed',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green.withOpacity(0.1),
                                  elevation: 0,
                                  foregroundColor: Colors.green,
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    side: const BorderSide(color: Colors.green, width: 0.5),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      if (appointment.status == 'Completed')
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              _showCompletedSummarySheet(context);
                            },
                            icon: const Icon(Icons.article_outlined, size: 16, color: Colors.purple),
                            label: const Text(
                              'View Summary',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.purple,
                              side: const BorderSide(color: Colors.purple),
                              padding: EdgeInsets.symmetric(vertical: 10.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAppointmentDetailsDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final formattedDate = DateFormat('dd MMM yyyy').format(appointment.appointmentDate);
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.terminalDarkCard : Colors.white,
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: AppColors.primary),
            SizedBox(width: 8.w),
            Text(
              "Appointment Details",
              style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow("Patient Name", appointment.patientName, isDark),
            _buildInfoRow("Patient ID", "PAT-${(appointment.patientId?.length ?? 0) > 8 ? appointment.patientId?.substring(0, 8).toUpperCase() : appointment.patientId?.toUpperCase()}", isDark),
            _buildInfoRow("Doctor Name", _cleanDoctorName(appointment.doctorName), isDark),
            _buildInfoRow("Specialty", appointment.specialty, isDark),
            _buildInfoRow("Date", formattedDate, isDark),
            _buildInfoRow("Time", appointment.appointmentTime, isDark),
            if (appointment.token != null && appointment.token!.isNotEmpty)
              _buildInfoRow("Token No", appointment.token!, isDark, valueColor: AppColors.accent, valueFontWeight: FontWeight.bold),
            const Divider(height: 20),
            Text("Vitals Information", style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: isDark ? Colors.white70 : AppColors.textPrimary)),
            SizedBox(height: 8.h),
            _buildInfoRow("Blood Pressure", appointment.bp ?? "N/A", isDark),
            _buildInfoRow("Weight", appointment.weight != null && appointment.weight!.isNotEmpty ? "${appointment.weight} kg" : "N/A", isDark),
            _buildInfoRow("Height", appointment.height != null && appointment.height!.isNotEmpty ? "${appointment.height} cm" : "N/A", isDark),
            _buildInfoRow("Temperature", appointment.fever != null && appointment.fever!.isNotEmpty ? "${appointment.fever} °F" : "N/A", isDark),
            _buildInfoRow("Head Circumference", appointment.headCircumference ?? "N/A", isDark),
            if (appointment.additionalVitals != null && appointment.additionalVitals!.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text("Additional Notes:", style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, color: isDark ? Colors.white38 : AppColors.textSecondary)),
              Text(appointment.additionalVitals!, style: AppTextStyles.bodySmall),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  void _showCompletedSummarySheet(BuildContext context) async {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    Map<String, dynamic>? emrRecord;
    try {
      final supabase = GetIt.I<SupabaseService>().client;
      final response = await supabase
          .from('emr_records')
          .select()
          .eq('appointment_id', appointment.id)
          .maybeSingle();
      if (response != null) {
        emrRecord = response as Map<String, dynamic>;
      }
    } catch (e) {
      debugPrint("Failed to fetch EMR record: $e");
    }

    if (context.mounted) {
      Navigator.pop(context); // Dismiss loading
    }

    if (emrRecord == null) {
      // Offline fallback
      try {
        final storage = GetIt.I<SecureStorageService>();
        final localDataStr = await storage.read('emr_records');
        if (localDataStr != null) {
          final List<dynamic> list = jsonDecode(localDataStr);
          final match = list.firstWhere(
            (item) => item['appointment_id'] == appointment.id,
            orElse: () => null,
          );
          if (match != null) {
            emrRecord = Map<String, dynamic>.from(match);
          }
        }
      } catch (e) {
        debugPrint("Failed to read local EMR record: $e");
      }
    }

    if (!context.mounted) return;

    if (emrRecord != null) {
      _showRecordDetailsSheet(context, emrRecord, isDark);
    } else {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: isDark ? AppColors.terminalDarkCard : Colors.white,
          title: const Text("No Summary Available"),
          content: const Text("Could not retrieve the EMR summary for this completed appointment. It might not have been recorded yet."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  void _showRecordDetailsSheet(BuildContext context, Map<String, dynamic> record, bool isDark) {
    final dateStr = record['recorded_at'] ?? record['created_at'] ?? '';
    String formattedDate = 'N/A';
    if (dateStr.isNotEmpty) {
      try {
        final dt = DateTime.parse(dateStr);
        formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(dt);
      } catch (_) {}
    }

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
                                  color: isDark ? Colors.white : AppColors.textPrimary,
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
                        _buildDetailCard(
                          title: "Prescribed Medicines",
                          icon: Icons.medication_outlined,
                          iconColor: Colors.teal,
                          isDark: isDark,
                          children: [
                            if (record['medicines'] != null && record['medicines'].toString().trim().isNotEmpty) ...[
                              Text(record['medicines'] as String, style: AppTextStyles.bodySmall.copyWith(color: isDark ? Colors.white70 : AppColors.textPrimary)),
                              const Divider(height: 24),
                            ],
                            _buildInfoRow("Medicine Total", "₹${medAmount.toStringAsFixed(2)}", isDark),
                            if (medInvoice.isNotEmpty)
                              _buildInfoRow("Med Invoice No", medInvoice, isDark),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        _buildDetailCard(
                          title: "Diagnostic Lab Tests",
                          icon: Icons.biotech_outlined,
                          iconColor: Colors.purple,
                          isDark: isDark,
                          children: [
                            if (record['lab_tests'] != null && record['lab_tests'].toString().trim().isNotEmpty) ...[
                              Text(record['lab_tests'] as String, style: AppTextStyles.bodySmall.copyWith(color: isDark ? Colors.white70 : AppColors.textPrimary)),
                              const Divider(height: 24),
                            ],
                            _buildInfoRow("Lab Tests Total", "₹${labAmount.toStringAsFixed(2)}", isDark),
                            if (labInvoice.isNotEmpty)
                              _buildInfoRow("Lab Invoice No", labInvoice, isDark),
                          ],
                        ),
                        if (record['prescription_notes'] != null && record['prescription_notes'].toString().trim().isNotEmpty) ...[
                          SizedBox(height: 16.h),
                          _buildDetailCard(
                            title: "Doctor's Advice & Notes",
                            icon: Icons.notes_outlined,
                            iconColor: Colors.orange,
                            isDark: isDark,
                            children: [
                              Text(
                                record['prescription_notes'] as String,
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: isDark ? Colors.white70 : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ],
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
}
