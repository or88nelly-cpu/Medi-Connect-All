import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/features/management/patient_management/presentation/bloc/patient_bloc.dart';
import 'dart:math';
import 'package:intl/intl.dart';
import 'package:medi_connect/shared/dashboard/domain/entities/appointment_entity.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_appointments_bloc.dart';

class AdminPatientDialogs {
  static String generateUUID() {
    final random = Random();
    String hex(int length) {
      return List.generate(
        length,
        (_) => random.nextInt(16).toRadixString(16),
      ).join();
    }

    return '${hex(8)}-${hex(4)}-4${hex(3)}-${(random.nextInt(4) + 8).toRadixString(16)}${hex(3)}-${hex(12)}';
  }

  static int calculateAge(DateTime? dob) {
    if (dob == null) return 30;
    final now = DateTime.now();
    int age = now.year - dob.year;
    if (now.month < dob.month ||
        (now.month == dob.month && now.day < dob.day)) {
      age--;
    }
    return age;
  }

  static void showAddPatientDialog(BuildContext context) {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final ageController = TextEditingController();
    final phoneController = TextEditingController();
    String gender = 'Male';
    String blood = 'O+';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text("Add Patient", style: AppTextStyles.titleLarge),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Full Name"),
                ),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email Address (Optional)",
                  ),
                ),
                TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Age"),
                ),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: "Phone Number"),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    const Text("Gender: "),
                    SizedBox(width: 8.w),
                    DropdownButton<String>(
                      value: gender,
                      items: ['Male', 'Female', 'Other'].map((g) {
                        return DropdownMenuItem(value: g, child: Text(g));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => gender = val);
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text("Blood: "),
                    SizedBox(width: 8.w),
                    DropdownButton<String>(
                      value: blood,
                      items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
                          .map((b) {
                            return DropdownMenuItem(value: b, child: Text(b));
                          })
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => blood = val);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(AppStrings.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  final emailVal = emailController.text.trim().isNotEmpty
                      ? emailController.text.trim()
                      : 'patient-${Random().nextInt(900000) + 100000}@mediconnect.com';

                  final nameParts = nameController.text.trim().split(' ');
                  final firstName = nameParts.isNotEmpty ? nameParts.first : '';
                  final lastName = nameParts.length > 1
                      ? nameParts.sublist(1).join(' ')
                      : '';

                  final newPatient = UserModel(
                    id: generateUUID(),
                    email: emailVal,
                    firstName: firstName,
                    lastName: lastName,
                    phone: phoneController.text.trim().isNotEmpty
                        ? phoneController.text.trim()
                        : null,
                    role: UserRole.patient,
                    status: 'Active',
                    dob: DateTime.now().subtract(
                      Duration(
                        days: 365 * (int.tryParse(ageController.text) ?? 30),
                      ),
                    ),
                    gender: gender,
                    bloodGroup: blood,
                  );

                  context.read<PatientBloc>().add(CreatePatient(newPatient));
                  Navigator.pop(ctx);
                }
              },
              child: const Text(AppStrings.submit),
            ),
          ],
        ),
      ),
    );
  }

  static void showEditPatientDialog(BuildContext context, UserModel patient) {
    final nameController = TextEditingController(text: patient.fullName);
    final emailController = TextEditingController(text: patient.email);
    final ageController = TextEditingController(
      text: calculateAge(patient.dob).toString(),
    );
    final phoneController = TextEditingController(text: patient.phone ?? '');
    String gender = patient.gender ?? 'Male';
    String blood = patient.bloodGroup ?? 'O+';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: Text("Edit Patient", style: AppTextStyles.titleLarge),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: "Full Name"),
                ),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: "Email Address"),
                ),
                TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: "Age"),
                ),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: "Phone Number"),
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    const Text("Gender: "),
                    SizedBox(width: 8.w),
                    DropdownButton<String>(
                      value: ['Male', 'Female', 'Other'].contains(gender)
                          ? gender
                          : 'Male',
                      items: ['Male', 'Female', 'Other'].map((g) {
                        return DropdownMenuItem(value: g, child: Text(g));
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => gender = val);
                      },
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text("Blood: "),
                    SizedBox(width: 8.w),
                    DropdownButton<String>(
                      value:
                          [
                            'A+',
                            'A-',
                            'B+',
                            'B-',
                            'O+',
                            'O-',
                            'AB+',
                            'AB-',
                          ].contains(blood)
                          ? blood
                          : 'O+',
                      items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
                          .map((b) {
                            return DropdownMenuItem(value: b, child: Text(b));
                          })
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => blood = val);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text(AppStrings.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  final nameParts = nameController.text.trim().split(' ');
                  final firstName = nameParts.isNotEmpty ? nameParts.first : '';
                  final lastName = nameParts.length > 1
                      ? nameParts.sublist(1).join(' ')
                      : '';

                  final updatedPatient = UserModel(
                    id: patient.id,
                    email: emailController.text.trim(),
                    firstName: firstName,
                    lastName: lastName,
                    phone: phoneController.text.trim().isNotEmpty
                        ? phoneController.text.trim()
                        : null,
                    role: UserRole.patient,
                    status: patient.status ?? 'Active',
                    dob:
                        patient.dob ??
                        DateTime.now().subtract(
                          Duration(
                            days:
                                365 * (int.tryParse(ageController.text) ?? 30),
                          ),
                        ),
                    gender: gender,
                    bloodGroup: blood,
                    profilePhoto: patient.profilePhoto,
                  );

                  context.read<PatientBloc>().add(
                    UpdatePatient(updatedPatient),
                  );
                  Navigator.pop(ctx);
                }
              },
              child: const Text(AppStrings.submit),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeletePatient(BuildContext context, UserModel patient) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Delete Patient"),
        content: Text(
          "Are you sure you want to delete patient ${patient.fullName}?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<PatientBloc>().add(DeletePatient(patient.id));
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text("Delete"),
          ),
        ],
      ),
    );
  }

  static void showPatientDetailSheet(BuildContext context, UserModel patient) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark
        ? AppColors.terminalDarkCard
        : AppColors.terminalLightCard;
    final borderColor = isDark
        ? AppColors.terminalDarkBorder
        : AppColors.terminalLightBorder;
    final textColor = isDark
        ? AppColors.terminalDarkText
        : AppColors.terminalLightText;
    final labelColor = isDark
        ? AppColors.terminalDarkLabel
        : AppColors.terminalLightLabel;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          padding: EdgeInsets.only(
            top: 20.h,
            left: 20.w,
            right: 20.w,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 20.h,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Indicator line
                Center(
                  child: Container(
                    width: 40.w,
                    height: 5.h,
                    decoration: BoxDecoration(
                      color: labelColor.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(2.5.r),
                    ),
                  ),
                ),
                SizedBox(height: 16.h),

                // Patient Main Header Profile
                Row(
                  children: [
                    CircleAvatar(
                      radius: 36.r,
                      backgroundColor: isDark
                          ? AppColors.surface12
                          : Colors.black12,
                      child: ClipOval(
                        child: CustomImageView(
                          imagePath: ProfileImageHelper.resolveImagePath(
                            patient.profilePhoto,
                            'patient',
                            patient.gender,
                          ),
                          width: 72.r,
                          height: 72.r,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            patient.fullName,
                            style: AppTextStyles.titleLarge.copyWith(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 18.sp,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 3.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.15,
                                  ),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  'PAT-N/A',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              _buildStatusPill(patient.status ?? 'Active'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.edit_outlined,
                        color: AppColors.primary,
                        size: 22.sp,
                      ),
                      onPressed: () {
                        Navigator.pop(ctx);
                        _showEditPatientDialog(context, patient);
                      },
                    ),
                  ],
                ),
                SizedBox(height: 20.h),

                // Details Grid
                Text(
                  "Patient Information",
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 10.h),
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.surface.withValues(alpha: 0.02)
                        : Colors.black.withValues(alpha: 0.01),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: borderColor.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(
                        "Age",
                        "${calculateAge(patient.dob)} years",
                        labelColor,
                        textColor,
                      ),
                      Divider(color: borderColor.withValues(alpha: 0.3)),
                      _buildDetailRow(
                        "Gender",
                        patient.gender ?? 'N/A',
                        labelColor,
                        textColor,
                      ),
                      Divider(color: borderColor.withValues(alpha: 0.3)),
                      _buildDetailRow(
                        "Blood Group",
                        patient.bloodGroup ?? 'N/A',
                        labelColor,
                        textColor,
                      ),
                      Divider(color: borderColor.withValues(alpha: 0.3)),
                      _buildDetailRow(
                        "Phone",
                        patient.phone ?? 'N/A',
                        labelColor,
                        textColor,
                      ),
                      Divider(color: borderColor.withValues(alpha: 0.3)),
                      _buildDetailRow(
                        "Email",
                        patient.email ?? 'N/A',
                        labelColor,
                        textColor,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // Recent Appointment and Vitals
                Text(
                  "Recent Appointment & Vitals",
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 10.h),

                BlocBuilder<AdminAppointmentsBloc, AdminAppointmentsState>(
                  builder: (context, state) {
                    if (state is AdminAppointmentsLoading) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20.0),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }

                    List<AppointmentEntity> appointments = [];
                    if (state is AdminAppointmentsLoaded) {
                      appointments = state.appointments
                          .where((a) => a.patientId == patient.id)
                          .toList();
                    }

                    if (appointments.isEmpty) {
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.surface.withValues(alpha: 0.02)
                              : Colors.black.withValues(alpha: 0.01),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: borderColor.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "No appointments found for this patient.",
                              style: TextStyle(
                                color: labelColor,
                                fontSize: 12.sp,
                                fontStyle: FontStyle.italic,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 12.h),
                            ElevatedButton.icon(
                              onPressed: () {
                                final now = DateTime.now();
                                final timeStr = DateFormat(
                                  'hh:mm a',
                                ).format(now);
                                final dateStr = now
                                    .toIso8601String()
                                    .split('T')
                                    .first;

                                context.read<AdminAppointmentsBloc>().add(
                                  CreateAppointmentEvent({
                                    'patient_id': patient.id,
                                    'patient_name': patient.fullName,
                                    'doctor_name': 'General Clinic',
                                    'specialty': 'OPD',
                                    'appointment_date': dateStr,
                                    'appointment_time': timeStr,
                                    'status': 'Completed',
                                    'type': 'Consultation',
                                  }),
                                );

                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Quick checkup session created.",
                                    ),
                                  ),
                                );
                              },
                              icon: const Icon(
                                Icons.add,
                                color: AppColors.surface,
                                size: 16,
                              ),
                              label: const Text(
                                "Create Quick Visit to Add Vitals",
                                style: TextStyle(
                                  color: AppColors.surface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    // Most recent appointment
                    final recent = appointments.first;
                    final statusColor = recent.status == 'Completed'
                        ? AppColors.success
                        : (recent.status == 'Cancelled'
                              ? AppColors.error
                              : AppColors.primary);

                    return Container(
                      padding: EdgeInsets.all(14.r),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.surface.withValues(alpha: 0.02)
                            : Colors.black.withValues(alpha: 0.01),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: borderColor.withValues(alpha: 0.5),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recent.doctorName,
                                    style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                  Text(
                                    recent.specialty,
                                    style: TextStyle(
                                      color: labelColor,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8.w,
                                  vertical: 3.h,
                                ),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: statusColor,
                                    width: 0.5,
                                  ),
                                ),
                                child: Text(
                                  recent.status,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            "Date: ${DateFormat('dd MMM yyyy').format(recent.appointmentDate)} | Time: ${recent.appointmentTime}",
                            style: TextStyle(
                              color: labelColor,
                              fontSize: 11.sp,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Divider(color: borderColor.withValues(alpha: 0.3)),
                          SizedBox(height: 8.h),

                          // Vitals Display
                          Text(
                            "Vitals:",
                            style: TextStyle(
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12.sp,
                            ),
                          ),
                          SizedBox(height: 10.h),

                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: [
                              _buildVitalBadge(
                                "BP",
                                recent.bp ?? "--",
                                Icons.favorite_border,
                                Colors.red,
                                isDark,
                              ),
                              _buildVitalBadge(
                                "Weight",
                                recent.weight != null
                                    ? "${recent.weight} kg"
                                    : "--",
                                Icons.scale_outlined,
                                Colors.orange,
                                isDark,
                              ),
                              _buildVitalBadge(
                                "Height",
                                recent.height != null
                                    ? "${recent.height} cm"
                                    : "--",
                                Icons.height,
                                Colors.blue,
                                isDark,
                              ),
                              _buildVitalBadge(
                                "Fever",
                                recent.fever != null
                                    ? "${recent.fever} Ã‚Â°F"
                                    : "--",
                                Icons.thermostat_outlined,
                                Colors.teal,
                                isDark,
                              ),
                              _buildVitalBadge(
                                "Head Circ.",
                                recent.headCircumference != null
                                    ? "${recent.headCircumference} cm"
                                    : "--",
                                Icons.child_care,
                                Colors.purple,
                                isDark,
                              ),
                            ],
                          ),

                          // Custom Vitals List
                          if (recent.additionalVitals != null &&
                              recent.additionalVitals!.isNotEmpty) ...[
                            SizedBox(height: 12.h),
                            Text(
                              "Additional Vitals:",
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 11.sp,
                              ),
                            ),
                            SizedBox(height: 6.h),
                            _buildCustomVitalsDisplay(
                              recent.additionalVitals!,
                              isDark,
                              borderColor,
                            ),
                          ],

                          SizedBox(height: 16.h),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                showVitalsEntryDialog(
                                  context,
                                  recent.id,
                                  recent,
                                );
                              },
                              icon: const Icon(
                                Icons.edit_note_outlined,
                                color: AppColors.surface,
                              ),
                              label: const Text(
                                "Record / Update Vitals",
                                style: TextStyle(
                                  color: AppColors.surface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(
    String label,
    String value,
    Color labelColor,
    Color valueColor,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: labelColor, fontSize: 12.sp),
          ),
          Text(
            value,
            style: TextStyle(
              color: valueColor,
              fontWeight: FontWeight.w600,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVitalBadge(
    String label,
    String value,
    IconData icon,
    Color color,
    bool isDark,
  ) {
    final bg = isDark
        ? color.withValues(alpha: 0.12)
        : color.withValues(alpha: 0.08);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14.sp),
          SizedBox(width: 6.w),
          Text(
            "$label: ",
            style: TextStyle(
              color: isDark ? AppColors.surface70 : Colors.black87,
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomVitalsDisplay(
    String jsonStr,
    bool isDark,
    Color borderColor,
  ) {
    try {
      final Map<String, dynamic> custom = jsonDecode(jsonStr);
      if (custom.isEmpty) return const SizedBox();
      return Wrap(
        spacing: 8.w,
        runSpacing: 8.h,
        children: custom.entries.map((entry) {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surface12
                  : Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: borderColor.withValues(alpha: 0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${entry.key}: ",
                  style: TextStyle(
                    color: isDark ? AppColors.surface70 : Colors.black87,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  entry.value.toString(),
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      );
    } catch (_) {
      return const SizedBox();
    }
  }

  static void showVitalsEntryDialog(
    BuildContext context,
    String appointmentId,
    AppointmentEntity? current,
  ) {
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

    final bpController = TextEditingController(text: current?.bp);
    final weightController = TextEditingController(text: current?.weight);
    final heightController = TextEditingController(text: current?.height);
    final feverController = TextEditingController(text: current?.fever);
    final headCircumferenceController = TextEditingController(
      text: current?.headCircumference,
    );

    // Parse custom vitals
    final List<MapEntry<String, String>> customVitalsList = [];
    if (current?.additionalVitals != null &&
        current!.additionalVitals!.isNotEmpty) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(
          current.additionalVitals!,
        );
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
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: "Fever / Temp (Ã‚Â°F)",
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
                    labelText: "Circumference Head (cm) [Baby]",
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

                // Custom Vitals Section
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

                context.read<AdminAppointmentsBloc>().add(
                  UpdateAppointmentVitals(appointmentId, vitalsMap),
                );

                Navigator.pop(ctx); // Close dialog
                Navigator.pop(
                  context,
                ); // Close bottom sheet to force update/refresh display

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
