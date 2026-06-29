import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/functions/profile_image_helper.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/modules/management/patient_management/presentation/bloc/patient_bloc.dart';
import 'package:medi_connect/shared/dashboard/domain/entities/appointment_entity.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_appointments_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_patients/patient_card.dart';
import 'package:medi_connect/modules/management/customer_care/presentation/widgets/qr_scanner_overlay.dart';
import 'package:medi_connect/core/functions/date_utils.dart';
import 'package:intl/intl.dart';
import 'dart:convert';

class PatientSearchPage extends StatefulWidget {
  const PatientSearchPage({super.key});

  @override
  State<PatientSearchPage> createState() => _PatientSearchPageState();
}

class _PatientSearchPageState extends State<PatientSearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final ValueNotifier<String> _queryNotifier = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    context.read<PatientBloc>().add(LoadPatients());
    _searchController.addListener(() {
      _queryNotifier.value = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _queryNotifier.dispose();
    super.dispose();
  }

  void _openQrScanner(BuildContext context, List<UserModel> patients) {
    showDialog(
      context: context,
      builder: (ctx) => QrScannerOverlay(
        demoPatients: patients,
        onQrScanned: (patient) {
          _searchController.text = patient.id;
          _queryNotifier.value = patient.id;
        },
      ),
    );
  }

  void _showPatientDetailSheet(BuildContext context, UserModel patient) {
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

                // Patient Profile Header
                Row(
                  children: [
                    CircleAvatar(
                      radius: 36.r,
                      backgroundColor: isDark ? Colors.white12 : Colors.black12,
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
                                  patient.id,
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
                  ],
                ),
                SizedBox(height: 20.h),

                // Info Box
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
                        ? Colors.white.withValues(alpha: 0.02)
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
                        "${AppDateUtils.calculateAge(patient.dob) ?? 'N/A'} years",
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
                        patient.email ?? '',
                        labelColor,
                        textColor,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),

                // Vitals
                Text(
                  "Recent Visit Vitals",
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
                              ? Colors.white.withValues(alpha: 0.02)
                              : Colors.black.withValues(alpha: 0.01),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(
                            color: borderColor.withValues(alpha: 0.5),
                          ),
                        ),
                        child: Text(
                          "No active vitals or recent EMR history records.",
                          style: TextStyle(
                            color: labelColor,
                            fontSize: 12.sp,
                            fontStyle: FontStyle.italic,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    final recent = appointments.first;

                    return Container(
                      padding: EdgeInsets.all(14.r),
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.02)
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
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: AppColors.primary,
                                    width: 0.5,
                                  ),
                                ),
                                child: Text(
                                  recent.status,
                                  style: TextStyle(
                                    color: AppColors.primary,
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
                          Text(
                            "Recorded Vitals:",
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
                                    ? "${recent.fever} °F"
                                    : "--",
                                Icons.thermostat_outlined,
                                Colors.teal,
                                isDark,
                              ),
                            ],
                          ),
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
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 20.h),
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
              color: isDark ? Colors.white70 : Colors.black87,
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
                  ? Colors.white12
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
                    color: isDark ? Colors.white70 : Colors.black87,
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

  Widget _buildStatusPill(String status) {
    Color dotColor = AppColors.success;
    Color bgPillColor = AppColors.success.withValues(alpha: 0.1);
    String label = "Active";

    if (status.toLowerCase().contains("away")) {
      dotColor = AppColors.accent;
      bgPillColor = AppColors.accent.withValues(alpha: 0.1);
      label = "Away";
    } else if (status.toLowerCase().contains("inactive")) {
      dotColor = AppColors.error;
      bgPillColor = AppColors.error.withValues(alpha: 0.1);
      label = "Inactive";
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgPillColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: dotColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.r,
            height: 6.r,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
          ),
          SizedBox(width: 6.w),
          Text(
            label,
            style: TextStyle(
              color: dotColor,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomScaffold(
      appBarNeeded: true,
      customAppbar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary(context),
            size: 20.r,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Patient Search",
          style: AppTextStyles.titleLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary(context),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Column(
            children: [
              // Search Input Row
              Container(
                height: 52.h,
                decoration: BoxDecoration(
                  color: AppColors.card(context),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: AppColors.border(context)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow(context),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    SizedBox(width: 14.w),
                    Icon(
                      Icons.search_rounded,
                      color: AppColors.textSecondary(context),
                      size: 22.r,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary(context),
                          fontSize: 14.sp,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Search by UHID, Name, or Phone...',
                          hintStyle: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary(
                              context,
                            ).withValues(alpha: 0.6),
                            fontSize: 14.sp,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                    BlocBuilder<PatientBloc, PatientState>(
                      builder: (context, state) {
                        List<UserModel> list = [];
                        if (state is PatientLoaded) {
                          list = state.patients;
                        }
                        return IconButton(
                          icon: Icon(
                            Icons.qr_code_scanner_rounded,
                            color: AppColors.primary,
                            size: 24.r,
                          ),
                          onPressed: () => _openQrScanner(context, list),
                        );
                      },
                    ),
                    SizedBox(width: 8.w),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              // Search Results List
              Expanded(
                child: BlocBuilder<PatientBloc, PatientState>(
                  builder: (context, state) {
                    if (state is PatientLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is PatientError) {
                      return Center(
                        child: Text(
                          "Error: ${state.message}",
                          style: TextStyle(color: AppColors.error),
                        ),
                      );
                    }

                    List<UserModel> patientsList = [];
                    if (state is PatientLoaded) {
                      patientsList = state.patients;
                    }

                    if (patientsList.isEmpty) {
                      return Center(
                        child: Text(
                          "No patients found in directory.",
                          style: TextStyle(
                            color: AppColors.textSecondary(context),
                          ),
                        ),
                      );
                    }

                    return ValueListenableBuilder<String>(
                      valueListenable: _queryNotifier,
                      builder: (context, query, _) {
                        final filtered = patientsList.where((p) {
                          final nameMatch = p.fullName
                              .toLowerCase()
                              .contains(query.toLowerCase());
                          final phoneMatch = (p.phone ?? '').contains(
                            query,
                          );
                          final uhidMatch = (p.id)
                              .toLowerCase()
                              .contains(query.toLowerCase());
                          return nameMatch || phoneMatch || uhidMatch;
                        }).toList();

                        if (filtered.isEmpty) {
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 40.h),
                              child: Text(
                                "No matching patient details found.",
                                style: TextStyle(
                                  color: AppColors.textSecondary(context),
                                  fontSize: 13.sp,
                                ),
                              ),
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: filtered.length,
                          padding: EdgeInsets.only(bottom: 20.h),
                          itemBuilder: (context, index) {
                            final patient = filtered[index];
                            return PatientCard(
                              patient: patient,
                              onTap: () =>
                                  _showPatientDetailSheet(context, patient),
                              onEdit: () {},
                              onDelete: () {},
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
