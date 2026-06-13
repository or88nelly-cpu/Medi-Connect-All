import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/utils/profile_image_helper.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';
import 'package:medi_connect/features/patient/presentation/bloc/patient_bloc.dart';
import 'dart:math';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:medi_connect/features/dash_board/domain/entities/appointment_entity.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/admin_appointments_bloc.dart';

// Extracted sub-widgets
import 'package:medi_connect/features/dash_board/presentation/widgets/common/directory_pagination.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/admin_patients/patient_header.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/admin_patients/patient_search_bar.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/admin_patients/patient_filter_sort_row.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/admin_patients/patient_card.dart';

class AdminPatientsPage extends StatefulWidget {
  const AdminPatientsPage({super.key});

  @override
  State<AdminPatientsPage> createState() => _AdminPatientsPageState();
}

class _AdminPatientsPageState extends State<AdminPatientsPage> {
  final ValueNotifier<String> _searchNotifier = ValueNotifier<String>('');
  final ValueNotifier<String> _selectedBloodNotifier = ValueNotifier<String>('All');
  final ValueNotifier<String> _sortByNotifier = ValueNotifier<String>('None');
  final ValueNotifier<String> _statusFilterNotifier = ValueNotifier<String>('All');
  final ValueNotifier<int> _currentPageNotifier = ValueNotifier<int>(1);
  final int _itemsPerPage = 5;

  @override
  void initState() {
    super.initState();
    context.read<PatientBloc>().add(LoadPatients());
  }

  @override
  void dispose() {
    _searchNotifier.dispose();
    _selectedBloodNotifier.dispose();
    _sortByNotifier.dispose();
    _statusFilterNotifier.dispose();
    _currentPageNotifier.dispose();
    super.dispose();
  }

  String _generateUUID() {
    final random = Random();
    String hex(int length) {
      return List.generate(
        length,
        (_) => random.nextInt(16).toRadixString(16),
      ).join();
    }

    return '${hex(8)}-${hex(4)}-4${hex(3)}-${(random.nextInt(4) + 8).toRadixString(16)}${hex(3)}-${hex(12)}';
  }

  void _showAddPatientDialog(BuildContext context) {
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
                  decoration: const InputDecoration(labelText: "Email Address (Optional)"),
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

                  final newPatient = UserModel(
                    id: _generateUUID(),
                    email: emailVal,
                    name: nameController.text.trim(),
                    phoneNumber: phoneController.text.trim().isNotEmpty
                        ? phoneController.text.trim()
                        : null,
                    role: 'patient',
                    profileCompletionStatus: true,
                    status: 'Active',
                    age: int.tryParse(ageController.text) ?? 30,
                    gender: gender,
                    bloodGroup: blood,
                    patientId: 'PAT-${Random().nextInt(900000) + 100000}',
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

  void _showEditPatientDialog(BuildContext context, UserModel patient) {
    final nameController = TextEditingController(text: patient.name);
    final emailController = TextEditingController(text: patient.email);
    final ageController = TextEditingController(
      text: patient.age?.toString() ?? '',
    );
    final phoneController = TextEditingController(
      text: patient.phoneNumber ?? '',
    );
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
                      value: ['Male', 'Female', 'Other'].contains(gender) ? gender : 'Male',
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
                      value: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'].contains(blood) ? blood : 'O+',
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
                  final updatedPatient = UserModel(
                    id: patient.id,
                    email: emailController.text.trim(),
                    name: nameController.text.trim(),
                    phoneNumber: phoneController.text.trim().isNotEmpty
                        ? phoneController.text.trim()
                        : null,
                    role: 'patient',
                    profileCompletionStatus: patient.profileCompletionStatus,
                    status: patient.status,
                    age: int.tryParse(ageController.text) ?? patient.age,
                    gender: gender,
                    bloodGroup: blood,
                    patientId: patient.patientId,
                    profileImage: patient.profileImage,
                  );

                  context.read<PatientBloc>().add(UpdatePatient(updatedPatient));
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
        content: Text("Are you sure you want to delete patient ${patient.name}?"),
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

  void _showPatientDetailSheet(BuildContext context, UserModel patient) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final borderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final textColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;

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
                      color: labelColor.withOpacity(0.3),
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
                      backgroundColor: isDark ? Colors.white12 : Colors.black12,
                      child: ClipOval(
                        child: CustomImageView(
                          imagePath: ProfileImageHelper.resolveImagePath(
                            patient.profileImage,
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
                            patient.name ?? 'Unnamed Patient',
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
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(4.r),
                                ),
                                child: Text(
                                  patient.patientId ?? 'PAT-N/A',
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 8.w),
                              _buildStatusPill(patient.status),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit_outlined, color: AppColors.primary, size: 22.sp),
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
                    color: isDark ? Colors.white.withOpacity(0.02) : Colors.black.withOpacity(0.01),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: borderColor.withOpacity(0.5)),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow("Age", "${patient.age ?? 'N/A'} years", labelColor, textColor),
                      Divider(color: borderColor.withOpacity(0.3)),
                      _buildDetailRow("Gender", patient.gender ?? 'N/A', labelColor, textColor),
                      Divider(color: borderColor.withOpacity(0.3)),
                      _buildDetailRow("Blood Group", patient.bloodGroup ?? 'N/A', labelColor, textColor),
                      Divider(color: borderColor.withOpacity(0.3)),
                      _buildDetailRow("Phone", patient.phoneNumber ?? 'N/A', labelColor, textColor),
                      Divider(color: borderColor.withOpacity(0.3)),
                      _buildDetailRow("Email", patient.email, labelColor, textColor),
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
                      return const Center(child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 20.0),
                        child: CircularProgressIndicator(),
                      ));
                    }
                    
                    List<AppointmentEntity> appointments = [];
                    if (state is AdminAppointmentsLoaded) {
                      appointments = state.appointments.where((a) => a.patientId == patient.id).toList();
                    }
                    
                    if (appointments.isEmpty) {
                      return Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16.r),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white.withOpacity(0.02) : Colors.black.withOpacity(0.01),
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: borderColor.withOpacity(0.5)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              "No appointments found for this patient.",
                              style: TextStyle(color: labelColor, fontSize: 12.sp, fontStyle: FontStyle.italic),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 12.h),
                            ElevatedButton.icon(
                              onPressed: () {
                                final now = DateTime.now();
                                final timeStr = DateFormat('hh:mm a').format(now);
                                final dateStr = now.toIso8601String().split('T').first;
                                
                                context.read<AdminAppointmentsBloc>().add(CreateAppointmentEvent({
                                  'patient_id': patient.id,
                                  'patient_name': patient.name,
                                  'doctor_name': 'General Clinic',
                                  'specialty': 'OPD',
                                  'appointment_date': dateStr,
                                  'appointment_time': timeStr,
                                  'status': 'Completed',
                                  'type': 'Consultation',
                                }));
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Quick checkup session created.")),
                                );
                              },
                              icon: const Icon(Icons.add, color: Colors.white, size: 16),
                              label: const Text("Create Quick Visit to Add Vitals", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
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
                        : (recent.status == 'Cancelled' ? AppColors.error : AppColors.primary);
                    
                    return Container(
                      padding: EdgeInsets.all(14.r),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withOpacity(0.02) : Colors.black.withOpacity(0.01),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: borderColor.withOpacity(0.5)),
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
                                    style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13.sp),
                                  ),
                                  Text(
                                    recent.specialty,
                                    style: TextStyle(color: labelColor, fontSize: 11.sp),
                                  ),
                                ],
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(color: statusColor, width: 0.5),
                                ),
                                child: Text(
                                  recent.status,
                                  style: TextStyle(color: statusColor, fontSize: 10.sp, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            "Date: ${DateFormat('dd MMM yyyy').format(recent.appointmentDate)} | Time: ${recent.appointmentTime}",
                            style: TextStyle(color: labelColor, fontSize: 11.sp),
                          ),
                          SizedBox(height: 12.h),
                          Divider(color: borderColor.withOpacity(0.3)),
                          SizedBox(height: 8.h),
                          
                          // Vitals Display
                          Text(
                            "Vitals:",
                            style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12.sp),
                          ),
                          SizedBox(height: 10.h),
                          
                          Wrap(
                            spacing: 8.w,
                            runSpacing: 8.h,
                            children: [
                              _buildVitalBadge("BP", recent.bp ?? "--", Icons.favorite_border, Colors.red, isDark),
                              _buildVitalBadge("Weight", recent.weight != null ? "${recent.weight} kg" : "--", Icons.scale_outlined, Colors.orange, isDark),
                              _buildVitalBadge("Height", recent.height != null ? "${recent.height} cm" : "--", Icons.height, Colors.blue, isDark),
                              _buildVitalBadge("Fever", recent.fever != null ? "${recent.fever} °F" : "--", Icons.thermostat_outlined, Colors.teal, isDark),
                              _buildVitalBadge("Head Circ.", recent.headCircumference != null ? "${recent.headCircumference} cm" : "--", Icons.child_care, Colors.purple, isDark),
                            ],
                          ),
                          
                          // Custom Vitals List
                          if (recent.additionalVitals != null && recent.additionalVitals!.isNotEmpty) ...[
                            SizedBox(height: 12.h),
                            Text(
                              "Additional Vitals:",
                              style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 11.sp),
                            ),
                            SizedBox(height: 6.h),
                            _buildCustomVitalsDisplay(recent.additionalVitals!, isDark, borderColor),
                          ],
                          
                          SizedBox(height: 16.h),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _showVitalsEntryDialog(context, recent.id, recent);
                              },
                              icon: const Icon(Icons.edit_note_outlined, color: Colors.white),
                              label: const Text("Record / Update Vitals", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                padding: EdgeInsets.symmetric(vertical: 12.h),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
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

  Widget _buildDetailRow(String label, String value, Color labelColor, Color valueColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: labelColor, fontSize: 12.sp)),
          Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.w600, fontSize: 12.sp)),
        ],
      ),
    );
  }

  Widget _buildVitalBadge(String label, String value, IconData icon, Color color, bool isDark) {
    final bg = isDark ? color.withOpacity(0.12) : color.withOpacity(0.08);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: color.withOpacity(0.3), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14.sp),
          SizedBox(width: 6.w),
          Text(
            "$label: ",
            style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontSize: 11.sp, fontWeight: FontWeight.w500),
          ),
          Text(
            value,
            style: TextStyle(color: color, fontSize: 11.sp, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomVitalsDisplay(String jsonStr, bool isDark, Color borderColor) {
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
              color: isDark ? Colors.white12 : Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(6.r),
              border: Border.all(color: borderColor.withOpacity(0.4)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "${entry.key}: ",
                  style: TextStyle(color: isDark ? Colors.white70 : Colors.black87, fontSize: 10.sp, fontWeight: FontWeight.bold),
                ),
                Text(
                  entry.value.toString(),
                  style: TextStyle(color: AppColors.primary, fontSize: 10.sp, fontWeight: FontWeight.bold),
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

  void _showVitalsEntryDialog(BuildContext context, String appointmentId, AppointmentEntity? current) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final textColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;
    final borderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;

    final bpController = TextEditingController(text: current?.bp);
    final weightController = TextEditingController(text: current?.weight);
    final heightController = TextEditingController(text: current?.height);
    final feverController = TextEditingController(text: current?.fever);
    final headCircumferenceController = TextEditingController(text: current?.headCircumference);

    // Parse custom vitals
    final List<MapEntry<String, String>> customVitalsList = [];
    if (current?.additionalVitals != null && current!.additionalVitals!.isNotEmpty) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(current.additionalVitals!);
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
              Text("Record Vitals", style: AppTextStyles.titleLarge.copyWith(color: textColor, fontSize: 16.sp, fontWeight: FontWeight.bold)),
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
                    hintStyle: TextStyle(color: labelColor.withOpacity(0.5)),
                    prefixIcon: Icon(Icons.favorite, color: Colors.red, size: 18.sp),
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
                    hintStyle: TextStyle(color: labelColor.withOpacity(0.5)),
                    prefixIcon: Icon(Icons.scale, color: Colors.orange, size: 18.sp),
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
                    hintStyle: TextStyle(color: labelColor.withOpacity(0.5)),
                    prefixIcon: Icon(Icons.height, color: Colors.blue, size: 18.sp),
                  ),
                ),
                SizedBox(height: 12.h),
                TextField(
                  controller: feverController,
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  style: TextStyle(color: textColor),
                  decoration: InputDecoration(
                    labelText: "Fever / Temp (°F)",
                    labelStyle: TextStyle(color: labelColor),
                    hintText: "e.g., 98.6",
                    hintStyle: TextStyle(color: labelColor.withOpacity(0.5)),
                    prefixIcon: Icon(Icons.thermostat, color: Colors.teal, size: 18.sp),
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
                    hintStyle: TextStyle(color: labelColor.withOpacity(0.5)),
                    prefixIcon: Icon(Icons.child_care, color: Colors.purple, size: 18.sp),
                  ),
                ),
                
                SizedBox(height: 20.h),
                Divider(color: borderColor),
                SizedBox(height: 8.h),
                
                // Custom Vitals Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Custom Vitals", style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 12.sp)),
                    TextButton.icon(
                      onPressed: () {
                        setDialogState(() {
                          customVitalsList.add(const MapEntry("", ""));
                        });
                      },
                      icon: const Icon(Icons.add, size: 14),
                      label: Text("Add More", style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold)),
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                
                if (customVitalsList.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text(
                      "No custom vitals added. Tap 'Add More' to record fields like SPO2, Blood Sugar, etc.",
                      style: TextStyle(color: labelColor, fontSize: 10.sp, fontStyle: FontStyle.italic),
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
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                            ),
                            onChanged: (val) {
                              customVitalsList[index] = MapEntry(val.trim(), valCtrl.text.trim());
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
                              contentPadding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                            ),
                            onChanged: (val) {
                              customVitalsList[index] = MapEntry(nameCtrl.text.trim(), val.trim());
                            },
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: AppColors.error, size: 18.sp),
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
                  'bp': bpController.text.trim().isNotEmpty ? bpController.text.trim() : null,
                  'weight': weightController.text.trim().isNotEmpty ? weightController.text.trim() : null,
                  'height': heightController.text.trim().isNotEmpty ? heightController.text.trim() : null,
                  'fever': feverController.text.trim().isNotEmpty ? feverController.text.trim() : null,
                  'head_circumference': headCircumferenceController.text.trim().isNotEmpty ? headCircumferenceController.text.trim() : null,
                  'additional_vitals': customMap.isNotEmpty ? jsonEncode(customMap) : null,
                };
                
                context.read<AdminAppointmentsBloc>().add(UpdateAppointmentVitals(appointmentId, vitalsMap));
                
                Navigator.pop(ctx); // Close dialog
                Navigator.pop(context); // Close bottom sheet to force update/refresh display
                
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;
    final List<String> bloodGroups = ['All', 'A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

    return BlocListener<PatientBloc, PatientState>(
      listener: (context, state) {
        if (state is PatientActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Action completed successfully.")),
          );
          context.read<PatientBloc>().add(LoadPatients());
        } else if (state is PatientError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: ${state.message}"),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Custom Header
                const PatientHeader(),
                SizedBox(height: 16.h),

                // 2. Dropdowns/Filters Row
                PatientFilterSortRow(
                  selectedBloodNotifier: _selectedBloodNotifier,
                  sortByNotifier: _sortByNotifier,
                  statusFilterNotifier: _statusFilterNotifier,
                  currentPageNotifier: _currentPageNotifier,
                  bloodGroups: bloodGroups,
                ),
                SizedBox(height: 12.h),

                // 3. Search Bar
                PatientSearchBar(
                  searchNotifier: _searchNotifier,
                  currentPageNotifier: _currentPageNotifier,
                ),
                SizedBox(height: 16.h),

                // 4. Patients List (Paginated, Filtered & Sorted)
                Expanded(
                  child: Stack(
                    children: [
                      BlocBuilder<PatientBloc, PatientState>(
                        builder: (context, state) {
                          if (state is PatientLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (state is PatientError && state is! PatientLoaded) {
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
                          } else {
                            final bloc = context.read<PatientBloc>();
                            if (bloc.state is PatientLoaded) {
                              patientsList = (bloc.state as PatientLoaded).patients;
                            }
                          }

                          if (patientsList.isEmpty) {
                            return Center(
                              child: Text(
                                AppStrings.noRecords,
                                style: TextStyle(color: labelColor),
                              ),
                            );
                          }

                          return ValueListenableBuilder<String>(
                            valueListenable: _searchNotifier,
                            builder: (context, searchQuery, _) {
                              return ValueListenableBuilder<String>(
                                valueListenable: _selectedBloodNotifier,
                                builder: (context, selectedBlood, _) {
                                  return ValueListenableBuilder<String>(
                                    valueListenable: _sortByNotifier,
                                    builder: (context, sortBy, _) {
                                      return ValueListenableBuilder<String>(
                                        valueListenable: _statusFilterNotifier,
                                        builder: (context, statusFilter, _) {
                                          // 1. Filter
                                          final filtered = patientsList.where((p) {
                                            final matchesSearch = (p.name ?? '').toLowerCase().contains(searchQuery.toLowerCase()) ||
                                                (p.phoneNumber ?? '').contains(searchQuery);
                                            final matchesBlood = selectedBlood == 'All' ||
                                                (p.bloodGroup ?? '').toLowerCase() == selectedBlood.toLowerCase();
                                            final matchesStatus = statusFilter == 'All' ||
                                                (p.status).toLowerCase() == statusFilter.toLowerCase();
                                            return matchesSearch && matchesBlood && matchesStatus;
                                          }).toList();

                                          // 2. Sort
                                          if (sortBy == 'Name (A-Z)') {
                                            filtered.sort((a, b) => (a.name ?? '').compareTo(b.name ?? ''));
                                          } else if (sortBy == 'Name (Z-A)') {
                                            filtered.sort((a, b) => (b.name ?? '').compareTo(a.name ?? ''));
                                          } else if (sortBy == 'Age (Young-Old)') {
                                            filtered.sort((a, b) => (a.age ?? 0).compareTo(b.age ?? 0));
                                          } else if (sortBy == 'Age (Old-Young)') {
                                            filtered.sort((a, b) => (b.age ?? 0).compareTo(a.age ?? 0));
                                          }

                                          if (filtered.isEmpty) {
                                            return Center(
                                              child: Text(
                                                "No matching patients found.",
                                                style: TextStyle(color: labelColor),
                                              ),
                                            );
                                          }

                                          return ValueListenableBuilder<int>(
                                            valueListenable: _currentPageNotifier,
                                            builder: (context, currentPage, _) {
                                              final totalPages = (filtered.length / _itemsPerPage).ceil();
                                              final startIndex = (currentPage - 1) * _itemsPerPage;
                                              final endIndex = (startIndex + _itemsPerPage).clamp(0, filtered.length);
                                              final paginatedList = filtered.sublist(startIndex, endIndex);

                                              return Column(
                                                children: [
                                                  Expanded(
                                                    child: ListView.builder(
                                                      itemCount: paginatedList.length,
                                                      itemBuilder: (context, idx) {
                                                        final patient = paginatedList[idx];
                                                        return PatientCard(
                                                          patient: patient,
                                                          onTap: () {
                                                            _showPatientDetailSheet(context, patient);
                                                          },
                                                          onEdit: () {
                                                            _showEditPatientDialog(context, patient);
                                                          },
                                                          onDelete: () {
                                                            _confirmDeletePatient(context, patient);
                                                          },
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  DirectoryPagination(
                                                    currentPage: currentPage,
                                                    totalPages: totalPages,
                                                    onPageChanged: (page) {
                                                      _currentPageNotifier.value = page;
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              );
                            },
                          );
                        },
                      ),
                      // Custom Add FAB & Label
                      Positioned(
                        bottom: 16.h,
                        right: 16.w,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            FloatingActionButton(
                              heroTag: 'add_patient_fab',
                              onPressed: () => _showAddPatientDialog(context),
                              backgroundColor: AppColors.primary,
                              child: const Icon(Icons.add, color: Colors.white),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "Add Patient",
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
