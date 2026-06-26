import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:get_it/get_it.dart';
import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/core/services/secure_storage_service.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/constants/app_assets.dart';
import 'package:medi_connect/shared/dashboard/domain/entities/appointment_entity.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/functions/profile_image_helper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/modules/management/patient_management/presentation/bloc/patient_bloc.dart';

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
        return AppColors.success;
      case 'Pending':
        return AppColors.warning;
      case 'Completed':
        return AppColors.infoPurple;
      case 'Cancelled':
      default:
        return AppColors.error;
    }
  }

  Color _getStatusBgColor(String status, bool isDark) {
    switch (status) {
      case 'Confirmed':
        return isDark
            ? AppColors.statusConfirmedBgDark
            : AppColors.statusConfirmedBgLight;
      case 'Pending':
        return isDark
            ? AppColors.statusPendingBgDark
            : AppColors.statusPendingBgLight;
      case 'Completed':
        return isDark
            ? AppColors.statusCompletedBgDark
            : AppColors.statusCompletedBgLight;
      case 'Cancelled':
      default:
        return isDark
            ? AppColors.statusCancelledBgDark
            : AppColors.statusCancelledBgLight;
    }
  }

  Color _getStatusTextColor(String status, bool isDark) {
    switch (status) {
      case 'Confirmed':
        return isDark
            ? AppColors.statusConfirmedTextDark
            : AppColors.statusConfirmedTextLight;
      case 'Pending':
        return isDark
            ? AppColors.statusPendingTextDark
            : AppColors.statusPendingTextLight;
      case 'Completed':
        return isDark
            ? AppColors.statusCompletedTextDark
            : AppColors.statusCompletedTextLight;
      case 'Cancelled':
      default:
        return isDark
            ? AppColors.statusCancelledTextDark
            : AppColors.statusCancelledTextLight;
    }
  }

  Color _getChipBgColor(String patientId, bool isDark) {
    return isDark ? AppColors.patientChipBgDark : AppColors.patientChipBgLight;
  }

  Color _getChipTextColor(String patientId, bool isDark) {
    return isDark
        ? AppColors.patientChipTextDark
        : AppColors.patientChipTextLight;
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

    // Try to retrieve patient info from PatientBloc
    UserModel? patient;
    try {
      final patientState = context.watch<PatientBloc>().state;
      if (patientState is PatientLoaded) {
        final matches = patientState.patients.where(
          (p) =>
              p.id == appointment.patientId ||
              p.patientId == appointment.patientId,
        );
        if (matches.isNotEmpty) {
          patient = matches.first;
        }
      }
    } catch (e) {
      debugPrint("Error watching PatientBloc in AppointmentCard: $e");
    }

    // Determine the resolved profile image path
    // final patientNameLower = appointment.patientName.toLowerCase();
    String? resolvedImagePath;

    if (patient?.profileImage != null && patient!.profileImage!.isNotEmpty) {
      resolvedImagePath = patient.profileImage;
    } else {
      resolvedImagePath = ProfileImageHelper.resolveImagePath(
        patient?.profileImage,
        'patient',
        patient?.gender,
      );
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: isDark ? AppColors.terminalDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border(context)),
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
                    leading: Container(
                      width: 44.r,
                      height: 44.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark
                            ? Colors.white12
                            : const Color(0xFFF3F4F6),
                        border: Border.all(
                          color: AppColors.border(context),
                          width: 1,
                        ),
                      ),
                      child: ClipOval(
                        child: CustomImageView(
                          imagePath:
                              resolvedImagePath ?? AppAssets.femaleAvatarPng,
                          width: 60.r,
                          height: 60.r,
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
                                  fontSize: 13.sp,
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.textPrimary(context),
                                ),
                              ),

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
                                  "${AppStrings.patientIdPrefix}$shortId",
                                  style: AppTextStyles.bodySmall.copyWith(
                                    fontSize: 6.sp,
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
                            style: AppTextStyles.bodySmall.copyWith(
                              color: badgeTextColor,
                              fontSize: 8.sp,
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
                              "${AppStrings.tokenNoLabel}:- ${appointment.token}",
                              style: AppTextStyles.bodyMedium.copyWith(
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
                                Icons.person_outline,
                                size: 12.r,
                                color: isDark
                                    ? Colors.white54
                                    : AppColors.textSecondary(context),
                              ),
                              SizedBox(width: 4.w),
                              Expanded(
                                child: Text(
                                  "$docName (${appointment.specialty})",
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w500,
                                    color: isDark
                                        ? Colors.white70
                                        : AppColors.textSecondary(context),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Icon(
                                Icons.calendar_today_outlined,
                                size: 12.r,
                                color: isDark
                                    ? Colors.white54
                                    : AppColors.textSecondary(context),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                formattedDate,
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontSize: 11.sp,
                                  color: isDark
                                      ? Colors.white54
                                      : AppColors.textSecondary(context),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Icon(
                                Icons.access_time_outlined,
                                size: 12.r,
                                color: isDark
                                    ? Colors.white54
                                    : AppColors.textSecondary(context),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                appointment.appointmentTime,
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontSize: 11.sp,
                                  color: isDark
                                      ? Colors.white54
                                      : AppColors.textSecondary(context),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    children: [
                      const Divider(height: 16),
                      // Expandable actions based on status
                      if (appointment.status == 'Confirmed' ||
                          appointment.status == 'Pending')
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: () {
                                  _showAppointmentDetailsDialog(
                                    context,
                                    patient,
                                  );
                                },
                                icon: Icon(
                                  Icons.info_outline,
                                  size: 16.r,
                                  color: AppColors.primary,
                                ),
                                label: Text(
                                  AppStrings.viewDetails,
                                  style: AppTextStyles.labelMedium.copyWith(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: AppColors.primary,
                                  backgroundColor: isDark
                                      ? AppColors.terminalDarkCard
                                      : Colors.white,
                                  side: const BorderSide(
                                    color: AppColors.primary,
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 6.h),
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
                                icon: Icon(
                                  Icons.check_circle_outlined,
                                  size: 16.r,
                                  color: AppColors.success,
                                ),
                                label: Text(
                                  AppStrings.markAsCompleted,
                                  style: AppTextStyles.labelMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.success,
                                    fontSize: 10.sp,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isDark
                                      ? const Color(
                                          0xFF064E3B,
                                        ).withValues(alpha: 0.2)
                                      : const Color(0xFFE8F5E9),
                                  elevation: 0,
                                  foregroundColor: AppColors.success,
                                  padding: EdgeInsets.symmetric(vertical: 10.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.r),
                                    side: const BorderSide(
                                      color: AppColors.success,
                                      width: 0.5,
                                    ),
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
                            icon: const Icon(
                              Icons.article_outlined,
                              size: 16,
                              color: AppColors.infoPurple,
                            ),
                            label: Text(
                              AppStrings.viewSummary,
                              style: AppTextStyles.labelMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.infoPurple,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.infoPurple,
                              backgroundColor: isDark
                                  ? const Color(
                                      0xFF3B0764,
                                    ).withValues(alpha: 0.2)
                                  : const Color(0xFFF3E8FF),
                              side: const BorderSide(
                                color: AppColors.infoPurple,
                                width: 0.5,
                              ),
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

  void _showAppointmentDetailsDialog(BuildContext context, UserModel? patient) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final formattedDate = DateFormat(
      'dd MMM yyyy',
    ).format(appointment.appointmentDate);

    final patientNameLower = appointment.patientName.toLowerCase();
    final rawGender =
        patient?.gender ??
        (patientNameLower.contains('lajitha') ||
                patientNameLower.contains('aarushi')
            ? 'Female'
            : (patientNameLower.contains('tset') ? 'Male' : 'N/A'));
    final String genderStr;
    if (rawGender.toLowerCase() == 'male') {
      genderStr = 'Male';
    } else if (rawGender.toLowerCase() == 'female') {
      genderStr = 'Female';
    } else {
      genderStr = rawGender;
    }

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.terminalDarkCard : Colors.white,
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: AppColors.primary),
            SizedBox(width: 8.w),
            Text(
              AppStrings.appointmentDetails,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow(
              AppStrings.patientNameLabel,
              appointment.patientName,
              isDark,
              context,
            ),
            _buildInfoRow(
              AppStrings.patientIdLabel,
              "PAT-${(appointment.patientId?.length ?? 0) > 8 ? appointment.patientId?.substring(0, 8).toUpperCase() : appointment.patientId?.toUpperCase()}",
              isDark,
              context,
            ),
            _buildInfoRow(AppStrings.gender, genderStr, isDark, context),
            _buildInfoRow(
              AppStrings.ageLabel,
              patient?.age != null ? "${patient!.age} years" : "N/A",
              isDark,
              context,
            ),
            _buildInfoRow(
              AppStrings.doctorNameLabel,
              _cleanDoctorName(appointment.doctorName),
              isDark,
              context,
            ),
            _buildInfoRow(
              AppStrings.specialtyLabel,
              appointment.specialty,
              isDark,
              context,
            ),
            _buildInfoRow(AppStrings.dateLabel, formattedDate, isDark, context),
            _buildInfoRow(
              AppStrings.timeLabel,
              appointment.appointmentTime,
              isDark,
              context,
            ),
            if (appointment.token != null && appointment.token!.isNotEmpty)
              _buildInfoRow(
                AppStrings.tokenNoLabel,
                appointment.token!,
                isDark,
                context,
                valueColor: AppColors.accent,
                valueFontWeight: FontWeight.bold,
              ),
            const Divider(height: 20),
            Text(
              AppStrings.vitalsInformation,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : AppColors.textPrimary(context),
              ),
            ),
            SizedBox(height: 8.h),
            _buildInfoRow(
              AppStrings.bloodPressure,
              appointment.bp ?? "N/A",
              isDark,
              context,
            ),
            _buildInfoRow(
              AppStrings.weightLabel,
              appointment.weight != null && appointment.weight!.isNotEmpty
                  ? "${appointment.weight} kg"
                  : "N/A",
              isDark,
              context,
            ),
            _buildInfoRow(
              AppStrings.heightLabel,
              appointment.height != null && appointment.height!.isNotEmpty
                  ? "${appointment.height} cm"
                  : "N/A",
              isDark,
              context,
            ),
            _buildInfoRow(
              AppStrings.temperature,
              appointment.fever != null && appointment.fever!.isNotEmpty
                  ? "${appointment.fever} °F"
                  : "N/A",
              isDark,
              context,
            ),
            _buildInfoRow(
              AppStrings.headCircumference,
              appointment.headCircumference ?? "N/A",
              isDark,
              context,
            ),
            if (appointment.additionalVitals != null &&
                appointment.additionalVitals!.isNotEmpty) ...[
              SizedBox(height: 8.h),
              Text(
                AppStrings.additionalNotesLabel,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? Colors.white38
                      : AppColors.textSecondary(context),
                ),
              ),
              Text(
                appointment.additionalVitals!,
                style: AppTextStyles.bodySmall,
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.close),
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
        emrRecord = response;
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
          title: const Text(AppStrings.noSummaryAvailable),
          content: const Text(AppStrings.couldNotRetrieveEmr),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(AppStrings.ok),
            ),
          ],
        ),
      );
    }
  }

  void _showRecordDetailsSheet(
    BuildContext context,
    Map<String, dynamic> record,
    bool isDark,
  ) {
    final dateStr = record['recorded_at'] ?? record['created_at'] ?? '';
    String formattedDate = 'N/A';
    if (dateStr.isNotEmpty) {
      try {
        final dt = DateTime.parse(dateStr);
        formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(dt);
      } catch (_) {}
    }

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
                                AppStrings.consultationEmrRecord,
                                style: AppTextStyles.titleLarge.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.textPrimary(context),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                "${AppStrings.datePrefix}$formattedDate",
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
                        _buildDetailCard(
                          context: context,
                          title: AppStrings.generalInformation,
                          icon: Icons.person_outline,
                          iconColor: AppColors.primary,
                          isDark: isDark,
                          children: [
                            _buildInfoRow(
                              AppStrings.patientNameLabel,
                              record['patient_name'] ?? 'N/A',
                              isDark,
                              context,
                            ),
                            _buildInfoRow(
                              AppStrings.doctorNameLabel,
                              'Dr. ${record['doctor_name'] ?? "N/A"}',
                              isDark,
                              context,
                            ),
                            _buildInfoRow(
                              AppStrings.specialtyLabel,
                              record['specialty'] ?? 'N/A',
                              isDark,
                              context,
                            ),
                            _buildInfoRow(
                              AppStrings.invoiceNumber,
                              record['invoice_number'] ?? 'N/A',
                              isDark,
                              context,
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        _buildDetailCard(
                          context: context,
                          title: AppStrings.prescribedMedicines,
                          icon: Icons.medication_outlined,
                          iconColor: AppColors.secondary,
                          isDark: isDark,
                          children: [
                            if (record['medicines'] != null &&
                                record['medicines']
                                    .toString()
                                    .trim()
                                    .isNotEmpty) ...[
                              Text(
                                record['medicines'] as String,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: isDark
                                      ? Colors.white70
                                      : AppColors.textPrimary(context),
                                ),
                              ),
                              const Divider(height: 24),
                            ],
                            _buildInfoRow(
                              AppStrings.medicineTotal,
                              "₹${medAmount.toStringAsFixed(2)}",
                              isDark,
                              context,
                            ),
                            if (medInvoice.isNotEmpty)
                              _buildInfoRow(
                                AppStrings.medInvoiceNo,
                                medInvoice,
                                isDark,
                                context,
                              ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        _buildDetailCard(
                          title: AppStrings.diagnosticLabTests,
                          icon: Icons.biotech_outlined,
                          iconColor: AppColors.infoPurple,
                          isDark: isDark,
                          context: context,
                          children: [
                            if (record['lab_tests'] != null &&
                                record['lab_tests']
                                    .toString()
                                    .trim()
                                    .isNotEmpty) ...[
                              Text(
                                record['lab_tests'] as String,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: isDark
                                      ? Colors.white70
                                      : AppColors.textPrimary(context),
                                ),
                              ),
                              const Divider(height: 24),
                            ],
                            _buildInfoRow(
                              AppStrings.labTestsTotal,
                              "₹${labAmount.toStringAsFixed(2)}",
                              isDark,
                              context,
                            ),
                            if (labInvoice.isNotEmpty)
                              _buildInfoRow(
                                AppStrings.labInvoiceNo,
                                labInvoice,
                                isDark,
                                context,
                              ),
                          ],
                        ),
                        if (record['prescription_notes'] != null &&
                            record['prescription_notes']
                                .toString()
                                .trim()
                                .isNotEmpty) ...[
                          SizedBox(height: 16.h),
                          _buildDetailCard(
                            context: context,
                            title: AppStrings.doctorsAdviceNotes,
                            icon: Icons.notes_outlined,
                            iconColor: AppColors.warning,
                            isDark: isDark,
                            children: [
                              Text(
                                record['prescription_notes'] as String,
                                style: AppTextStyles.bodySmall.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: isDark
                                      ? Colors.white70
                                      : AppColors.textPrimary(context),
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
    required BuildContext context,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.terminalDarkBg
            : AppColors.background(context),
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
    bool isDark,
    BuildContext context, {
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
}
