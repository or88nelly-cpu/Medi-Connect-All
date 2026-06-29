import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/functions/profile_image_helper.dart';
import 'package:medi_connect/core/constants/app_assets.dart';
import 'package:medi_connect/shared/dashboard/domain/entities/appointment_entity.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/modules/management/patient_management/presentation/bloc/patient_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_appointments_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/doctor/doctor_appointments_bloc.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';

class PremiumAppointmentCard extends StatelessWidget {
  final AppointmentEntity appointment;
  final VoidCallback onCancel;
  final VoidCallback onComplete;

  const PremiumAppointmentCard({
    super.key,
    required this.appointment,
    required this.onCancel,
    required this.onComplete,
  });

  // Color _getStatusColor(String status) {
  //   switch (status) {
  //     case 'Confirmed':
  //       return AppColors.success;
  //     case 'Pending':
  //       return AppColors.warning;
  //     case 'Completed':
  //       return AppColors.infoPurple;
  //     case 'Cancelled':
  //     default:
  //       return AppColors.error;
  //   }
  // }

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
    final badgeBg = _getStatusBgColor(appointment.status, isDark);
    final badgeText = _getStatusTextColor(appointment.status, isDark);
    final formattedDate = DateFormat(
      'dd MMM yyyy',
    ).format(appointment.appointmentDate);

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
      debugPrint("Error watching PatientBloc: $e");
    }

    // Determine resolved profile image
    String? resolvedImagePath;
    if (patient?.profilePhoto != null && patient!.profilePhoto!.isNotEmpty) {
      resolvedImagePath = patient.profilePhoto;
    } else {
      resolvedImagePath = ProfileImageHelper.resolveImagePath(
        patient?.profilePhoto,
        'patient',
        patient?.gender,
      );
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.terminalDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border(context), width: 1),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Patient Avatar
          Container(
            width: 46.r,
            height: 46.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDark ? Colors.white12 : const Color(0xFFF3F4F6),
              border: Border.all(color: AppColors.border(context), width: 1),
            ),
            child: ClipOval(
              child: CustomImageView(
                imagePath: resolvedImagePath ?? AppAssets.femaleAvatarPng,
                width: 46.r,
                height: 46.r,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 12.w),

          // Main Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Patient Name
                Text(
                  appointment.patientName,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp,
                    color: isDark
                        ? Colors.white
                        : AppColors.textPrimary(context),
                  ),
                ),
                SizedBox(height: 4.h),

                // Specialty
                Row(
                  children: [
                    Icon(
                      Icons.healing_outlined,
                      size: 12.r,
                      color: isDark
                          ? Colors.white70
                          : AppColors.textSecondary(context),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        appointment.specialty,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 11.sp,
                          color: isDark
                              ? Colors.white60
                              : AppColors.textSecondary(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 4.h),

                // Doctor Name
                Row(
                  children: [
                    Icon(
                      Icons.person_outline,
                      size: 12.r,
                      color: isDark
                          ? Colors.white70
                          : AppColors.textSecondary(context),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text(
                        _cleanDoctorName(appointment.doctorName),
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 11.sp,
                          color: isDark
                              ? Colors.white60
                              : AppColors.textSecondary(context),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),

          // Right Side Actions and Badges
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Status Badge
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: badgeBg,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      appointment.status,
                      style: TextStyle(
                        color: badgeText,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 4.w),
                  // Popup Actions Menu
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert_outlined,
                      size: 16.r,
                      color: isDark
                          ? Colors.white70
                          : AppColors.textSecondary(context),
                    ),
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(minWidth: 140.w),
                    onSelected: (val) {
                      if (val == 'complete') {
                        onComplete();
                      } else if (val == 'cancel') {
                        onCancel();
                      } else if (val == 'details') {
                        _showAppointmentDetailsDialog(
                          context,
                          patient,
                          formattedDate,
                        );
                      } else if (val == 'vitals') {
                        _showVitalsEntryDialog(context);
                      }
                    },
                    itemBuilder: (ctx) => [
                      PopupMenuItem(
                        value: 'details',
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 16.r,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              "View Details",
                              style: TextStyle(fontSize: 12.sp),
                            ),
                          ],
                        ),
                      ),
                      if (appointment.status == 'Confirmed' ||
                          appointment.status == 'Pending') ...[
                        PopupMenuItem(
                          value: 'vitals',
                          child: Row(
                            children: [
                              Icon(
                                Icons.thermostat_outlined,
                                size: 16.r,
                                color: Colors.orange,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                "Record Vitals",
                                style: TextStyle(fontSize: 12.sp),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'complete',
                          child: Row(
                            children: [
                              Icon(
                                Icons.check_circle_outline,
                                size: 16.r,
                                color: AppColors.success,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                "Complete Consult",
                                style: TextStyle(fontSize: 12.sp),
                              ),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'cancel',
                          child: Row(
                            children: [
                              Icon(
                                Icons.cancel_outlined,
                                size: 16.r,
                                color: AppColors.error,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                "Cancel Booking",
                                style: TextStyle(fontSize: 12.sp),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              // Appointment Time
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.access_time,
                    size: 11.r,
                    color: isDark
                        ? Colors.white60
                        : AppColors.textSecondary(context),
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    appointment.appointmentTime,
                    style: TextStyle(
                      color: isDark
                          ? Colors.white70
                          : AppColors.textPrimary(context),
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 6.h),
              // OPD / Slot Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white12 : const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  appointment.token != null && appointment.token!.isNotEmpty
                      ? (appointment.token!.toUpperCase().contains("OPD")
                            ? appointment.token!
                            : "OPD - ${appointment.token}")
                      : "OPD - 1",
                  style: TextStyle(
                    color: isDark ? AppColors.accent : AppColors.primary,
                    fontSize: 9.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAppointmentDetailsDialog(
    BuildContext context,
    UserModel? patient,
    String formattedDate,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final genderStr = patient?.gender ?? 'N/A';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.terminalDarkCard : Colors.white,
        title: Row(
          children: [
            Icon(Icons.assignment_outlined, color: AppColors.primary),
            SizedBox(width: 8.w),
            Text(
              AppStrings.appointmentDetails,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
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
              _buildInfoRow(
                AppStrings.dateLabel,
                formattedDate,
                isDark,
                context,
              ),
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
                  color: AppColors.textPrimary(context),
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

  Widget _buildInfoRow(
    String label,
    String value,
    bool isDark,
    BuildContext context, {
    Color? valueColor,
    FontWeight? valueFontWeight,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: isDark
                  ? AppColors.terminalDarkLabel
                  : AppColors.textSecondary(context),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: valueFontWeight ?? FontWeight.w600,
              color: valueColor ?? AppColors.textPrimary(context),
            ),
          ),
        ],
      ),
    );
  }

  void _showVitalsEntryDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark
        ? AppColors.terminalDarkCard
        : AppColors.terminalLightCard;
    final textColor = isDark
        ? AppColors.terminalDarkText
        : AppColors.terminalLightText;
    final borderColor = isDark
        ? AppColors.terminalDarkBorder
        : AppColors.terminalLightBorder;
    final labelColor = isDark
        ? AppColors.terminalDarkLabel
        : AppColors.terminalLightLabel;

    final bpController = TextEditingController(text: appointment.bp);
    final weightController = TextEditingController(text: appointment.weight);
    final heightController = TextEditingController(text: appointment.height);
    final feverController = TextEditingController(text: appointment.fever);
    final headCircumferenceController = TextEditingController(
      text: appointment.headCircumference,
    );

    // Parse custom vitals
    final List<MapEntry<String, String>> customVitalsList = [];
    final addVitalsStr = appointment.additionalVitals;
    if (addVitalsStr != null && addVitalsStr.isNotEmpty) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(addVitalsStr);
        decoded.forEach((key, value) {
          customVitalsList.add(MapEntry(key, value.toString()));
        });
      } catch (_) {}
    }

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: cardBg,
          title: Row(
            children: [
              Icon(Icons.thermostat, color: AppColors.primary),
              SizedBox(width: 8.w),
              Text(
                "Record Vitals",
                style: AppTextStyles.titleLarge.copyWith(
                  color: textColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: bpController,
                  keyboardType: TextInputType.text,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: "Blood Pressure (mmHg)",
                    labelStyle: TextStyle(color: labelColor),
                    hintText: "e.g., 120/80",
                    hintStyle: TextStyle(
                      color: labelColor.withValues(alpha: 0.5),
                    ),
                    prefixIcon: Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 18.sp,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                TextField(
                  controller: weightController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: "Weight (kg)",
                    labelStyle: TextStyle(color: labelColor),
                    hintText: "e.g., 70",
                    hintStyle: TextStyle(
                      color: labelColor.withValues(alpha: 0.5),
                    ),
                    prefixIcon: Icon(
                      Icons.scale,
                      color: Colors.orange,
                      size: 18.sp,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                TextField(
                  controller: heightController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: "Height (cm)",
                    labelStyle: TextStyle(color: labelColor),
                    hintText: "e.g., 175",
                    hintStyle: TextStyle(
                      color: labelColor.withValues(alpha: 0.5),
                    ),
                    prefixIcon: Icon(
                      Icons.height,
                      color: Colors.blue,
                      size: 18.sp,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                TextField(
                  controller: feverController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: "Fever / Temp (°F)",
                    labelStyle: TextStyle(color: labelColor),
                    hintText: "e.g., 98.6",
                    hintStyle: TextStyle(
                      color: labelColor.withValues(alpha: 0.5),
                    ),
                    prefixIcon: Icon(
                      Icons.thermostat,
                      color: Colors.teal,
                      size: 18.sp,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                TextField(
                  controller: headCircumferenceController,
                  keyboardType: TextInputType.number,
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: "Circumference Head (cm)",
                    labelStyle: TextStyle(color: labelColor),
                    hintText: "e.g., 42",
                    hintStyle: TextStyle(
                      color: labelColor.withValues(alpha: 0.5),
                    ),
                    prefixIcon: Icon(
                      Icons.child_care,
                      color: Colors.purple,
                      size: 18.sp,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                Divider(color: borderColor),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Custom Vitals",
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.sp,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () {
                        setDialogState(() {
                          customVitalsList.add(const MapEntry("", ""));
                        });
                      },
                      icon: const Icon(Icons.add, size: 14),
                      label: Text(
                        "Add More",
                        style: TextStyle(
                          fontSize: 11.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                if (customVitalsList.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text(
                      "No custom vitals added. Tap 'Add More' to record fields like SPO2, Blood Sugar, etc.",
                      style: TextStyle(
                        color: labelColor,
                        fontSize: 10.sp,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ...List.generate(customVitalsList.length, (index) {
                  final entry = customVitalsList[index];
                  final nameCtrl = TextEditingController(text: entry.key);
                  final valCtrl = TextEditingController(text: entry.value);

                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: TextField(
                            controller: nameCtrl,
                            style: TextStyle(color: textColor, fontSize: 12.sp),
                            decoration: InputDecoration(
                              hintText: "Vital Name (e.g., SPO2)",
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 8.h,
                              ),
                            ),
                            onChanged: (val) {
                              customVitalsList[index] = MapEntry(
                                val.trim(),
                                valCtrl.text.trim(),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          flex: 5,
                          child: TextField(
                            controller: valCtrl,
                            style: TextStyle(color: textColor, fontSize: 12.sp),
                            decoration: InputDecoration(
                              hintText: "Value (e.g., 98%)",
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 8.h,
                              ),
                            ),
                            onChanged: (val) {
                              customVitalsList[index] = MapEntry(
                                nameCtrl.text.trim(),
                                val.trim(),
                              );
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: AppColors.error,
                            size: 18.sp,
                          ),
                          onPressed: () {
                            setDialogState(() {
                              customVitalsList.removeAt(index);
                            });
                          },
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                final Map<String, String> customMap = {};
                for (final item in customVitalsList) {
                  if (item.key.isNotEmpty && item.value.isNotEmpty) {
                    customMap[item.key] = item.value;
                  }
                }

                final vitalsMap = {
                  'bp': bpController.text.trim().isNotEmpty
                      ? bpController.text.trim()
                      : null,
                  'weight': weightController.text.trim().isNotEmpty
                      ? weightController.text.trim()
                      : null,
                  'height': heightController.text.trim().isNotEmpty
                      ? heightController.text.trim()
                      : null,
                  'fever': feverController.text.trim().isNotEmpty
                      ? feverController.text.trim()
                      : null,
                  'head_circumference':
                      headCircumferenceController.text.trim().isNotEmpty
                      ? headCircumferenceController.text.trim()
                      : null,
                  'additional_vitals': customMap.isNotEmpty
                      ? jsonEncode(customMap)
                      : null,
                };

                try {
                  final authState = context.read<AuthBloc>().state;
                  if (authState is Authenticated &&
                      authState.user.role == 'doctor') {
                    context.read<DoctorAppointmentsBloc>().add(
                      UpdateDoctorAppointmentVitals(appointment.id, vitalsMap),
                    );
                  } else {
                    context.read<AdminAppointmentsBloc>().add(
                      UpdateAppointmentVitals(appointment.id, vitalsMap),
                    );
                  }
                } catch (_) {
                  context.read<AdminAppointmentsBloc>().add(
                    UpdateAppointmentVitals(appointment.id, vitalsMap),
                  );
                }

                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Vitals successfully saved.")),
                );
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
