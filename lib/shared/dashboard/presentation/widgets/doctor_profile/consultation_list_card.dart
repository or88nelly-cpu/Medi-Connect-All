import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_event.dart';
import 'dart:convert';
import 'package:medi_connect/shared/dashboard/domain/entities/appointment_entity.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_appointments_bloc.dart';

class ConsultationListCard extends StatefulWidget {
  final UserModel user;
  const ConsultationListCard({super.key, required this.user});

  @override
  State<ConsultationListCard> createState() => _ConsultationListCardState();
}

class _ConsultationListCardState extends State<ConsultationListCard> {
  String _selectedDate = "20 May 2025";
  String _selectedMode = "All"; // All, Video, Audio

  static const List<Map<String, dynamic>> _defaultConsultations = [
    {
      "time": "09:00 AM",
      "name": "Ramesh Kumar",
      "age": 45,
      "gender": "Male",
      "type": "Follow Up",
      "mode": "Video",
      "status": "Completed",
    },
    {
      "time": "09:20 AM",
      "name": "Anita Sharma",
      "age": 38,
      "gender": "Female",
      "type": "New Consultation",
      "mode": "Audio",
      "status": "Completed",
    },
    {
      "time": "09:40 AM",
      "name": "Vikram Singh",
      "age": 52,
      "gender": "Male",
      "type": "Follow Up",
      "mode": "Video",
      "status": "Completed",
    },
    {
      "time": "10:00 AM",
      "name": "Pooja Mehta",
      "age": 29,
      "gender": "Female",
      "type": "New Consultation",
      "mode": "Video",
      "status": "Booked",
    },
    {
      "time": "10:20 AM",
      "name": "Arjun Patel",
      "age": 41,
      "gender": "Male",
      "type": "Follow Up",
      "mode": "Audio",
      "status": "Pending",
    },
    {
      "time": "10:40 AM",
      "name": "Suresh Yadav",
      "age": 50,
      "gender": "Male",
      "type": "New Consultation",
      "mode": "Video",
      "status": "Booked",
    },
    {
      "time": "11:00 AM",
      "name": "Neha Verma",
      "age": 35,
      "gender": "Female",
      "type": "Follow Up",
      "mode": "Audio",
      "status": "Pending",
    },
  ];

  List<Map<String, dynamic>> get _consultations {
    final metadataConsultations =
        widget.user.metadata?['consultations'] as List<dynamic>?;
    if (metadataConsultations != null) {
      return metadataConsultations.map((item) {
        final map = item as Map<dynamic, dynamic>;
        return {
          "time": (map["time"] ?? "").toString(),
          "name": (map["name"] ?? "").toString(),
          "age": int.tryParse(map["age"].toString()) ?? 30,
          "gender": (map["gender"] ?? "").toString(),
          "type": (map["type"] ?? "").toString(),
          "mode": (map["mode"] ?? "").toString(),
          "status": (map["status"] ?? "").toString(),
        };
      }).toList();
    }
    return _defaultConsultations;
  }

  void _showStatusDialog(Map<String, dynamic> consultation) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text("Update Status"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: ["Completed", "Booked", "Pending"].map((status) {
              return ListTile(
                title: Text(status),
                leading: CircleAvatar(
                  radius: 8,
                  backgroundColor: _getStatusColor(status),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _updateConsultationStatus(consultation, status);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _updateConsultationStatus(
    Map<String, dynamic> consultation,
    String newStatus,
  ) {
    final isReal = consultation['isReal'] == true;
    if (isReal) {
      final appointmentId = consultation['id'].toString();
      context.read<AdminAppointmentsBloc>().add(
        CancelAppointment(appointmentId),
      );
      if (newStatus == 'Completed') {
        context.read<AdminAppointmentsBloc>().add(
          CompleteAppointment(appointmentId),
        );
      }
      return;
    }

    final updatedMetadata = Map<String, dynamic>.from(
      widget.user.metadata ?? {},
    );
    final currentConsultations = List<dynamic>.from(
      updatedMetadata['consultations'] ?? _defaultConsultations,
    );

    final idx = currentConsultations.indexWhere(
      (item) =>
          item['time'] == consultation['time'] &&
          item['name'] == consultation['name'],
    );

    if (idx != -1) {
      final item = Map<String, dynamic>.from(currentConsultations[idx]);
      item['status'] = newStatus;
      currentConsultations[idx] = item;

      updatedMetadata['consultations'] = currentConsultations;
      final updatedUser = widget.user.copyWith(metadata: updatedMetadata);

      context.read<DoctorStaffBloc>().add(UpdateDoctorStaffMember(updatedUser));

      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated && authState.user.id == widget.user.id) {
        context.read<AuthBloc>().add(UserUpdated(updatedUser));
      }
    }
  }

  void _updateConsultationVitals(
    Map<String, dynamic> consultation,
    Map<String, dynamic> vitals,
  ) {
    final updatedMetadata = Map<String, dynamic>.from(
      widget.user.metadata ?? {},
    );
    final currentConsultations = List<dynamic>.from(
      updatedMetadata['consultations'] ?? _defaultConsultations,
    );

    final idx = currentConsultations.indexWhere(
      (item) =>
          item['time'] == consultation['time'] &&
          item['name'] == consultation['name'],
    );

    if (idx != -1) {
      final item = Map<String, dynamic>.from(currentConsultations[idx]);
      item['bp'] = vitals['bp'];
      item['weight'] = vitals['weight'];
      item['height'] = vitals['height'];
      item['fever'] = vitals['fever'];
      item['head_circumference'] = vitals['head_circumference'];
      item['additional_vitals'] = vitals['additional_vitals'];
      currentConsultations[idx] = item;

      updatedMetadata['consultations'] = currentConsultations;
      final updatedUser = widget.user.copyWith(metadata: updatedMetadata);

      context.read<DoctorStaffBloc>().add(UpdateDoctorStaffMember(updatedUser));

      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated && authState.user.id == widget.user.id) {
        context.read<AuthBloc>().add(UserUpdated(updatedUser));
      }
    }
  }

  void _showConsultationOptions(
    BuildContext context,
    Map<String, dynamic> consultation,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark
        ? AppColors.terminalDarkCard
        : AppColors.terminalLightCard;
    final textColor = isDark
        ? AppColors.terminalDarkText
        : AppColors.terminalLightText;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
          ),
          padding: EdgeInsets.all(20.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.info_outline, color: AppColors.primary),
                title: Text(
                  "View Details & Vitals",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _showConsultationDetailSheet(context, consultation);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.edit_road_outlined,
                  color: AppColors.success,
                ),
                title: Text(
                  "Update Status",
                  style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onTap: () {
                  Navigator.pop(ctx);
                  _showStatusDialog(consultation);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showConsultationDetailSheet(
    BuildContext context,
    Map<String, dynamic> item,
  ) {
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

    final statusColor = _getStatusColor(item["status"]);

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
                Text(
                  "Consultation Details",
                  style: AppTextStyles.titleLarge.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
                SizedBox(height: 16.h),
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
                        "Patient Name",
                        item["name"].toString(),
                        labelColor,
                        textColor,
                      ),
                      Divider(color: borderColor.withValues(alpha: 0.3)),
                      _buildDetailRow(
                        "Age & Gender",
                        "${item["age"]} Years, ${item["gender"]}",
                        labelColor,
                        textColor,
                      ),
                      Divider(color: borderColor.withValues(alpha: 0.3)),
                      _buildDetailRow(
                        "Consultation Type",
                        item["type"].toString(),
                        labelColor,
                        textColor,
                      ),
                      Divider(color: borderColor.withValues(alpha: 0.3)),
                      _buildDetailRow(
                        "Time & Mode",
                        "${item["time"]} (${item["mode"]})",
                        labelColor,
                        textColor,
                      ),
                      Divider(color: borderColor.withValues(alpha: 0.3)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Status",
                            style: TextStyle(
                              color: labelColor,
                              fontSize: 12.sp,
                            ),
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
                              item["status"].toString(),
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),

                // Vitals section
                Text(
                  "Recorded Vitals",
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
                SizedBox(height: 10.h),

                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  children: [
                    _buildVitalBadge(
                      "BP",
                      item["bp"]?.toString() ?? "--",
                      Icons.favorite_border,
                      Colors.red,
                      isDark,
                    ),
                    _buildVitalBadge(
                      "Weight",
                      item["weight"] != null ? "${item["weight"]} kg" : "--",
                      Icons.scale_outlined,
                      Colors.orange,
                      isDark,
                    ),
                    _buildVitalBadge(
                      "Height",
                      item["height"] != null ? "${item["height"]} cm" : "--",
                      Icons.height,
                      Colors.blue,
                      isDark,
                    ),
                    _buildVitalBadge(
                      "Fever",
                      item["fever"] != null ? "${item["fever"]} °F" : "--",
                      Icons.thermostat_outlined,
                      Colors.teal,
                      isDark,
                    ),
                    _buildVitalBadge(
                      "Head Circ.",
                      item["head_circumference"] != null
                          ? "${item["head_circumference"]} cm"
                          : "--",
                      Icons.child_care,
                      Colors.purple,
                      isDark,
                    ),
                  ],
                ),

                if (item["additional_vitals"] != null &&
                    item["additional_vitals"].toString().isNotEmpty) ...[
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
                    item["additional_vitals"].toString(),
                    isDark,
                    borderColor,
                  ),
                ],

                SizedBox(height: 24.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      _showVitalsEntryDialog(context, item);
                    },
                    icon: const Icon(
                      Icons.add_moderator_outlined,
                      color: Colors.white,
                    ),
                    label: const Text(
                      "Record / Update Vitals",
                      style: TextStyle(
                        color: Colors.white,
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

  void _showVitalsEntryDialog(
    BuildContext context,
    Map<String, dynamic> consultation,
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

    final bpController = TextEditingController(
      text: consultation['bp']?.toString(),
    );
    final weightController = TextEditingController(
      text: consultation['weight']?.toString(),
    );
    final heightController = TextEditingController(
      text: consultation['height']?.toString(),
    );
    final feverController = TextEditingController(
      text: consultation['fever']?.toString(),
    );
    final headCircumferenceController = TextEditingController(
      text: consultation['head_circumference']?.toString(),
    );

    // Parse custom vitals
    final List<MapEntry<String, String>> customVitalsList = [];
    final addVitalsStr = consultation['additional_vitals']?.toString();
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
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
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

                final isReal = consultation['isReal'] == true;
                if (isReal) {
                  final appointmentId = consultation['id'].toString();
                  context.read<AdminAppointmentsBloc>().add(
                    UpdateAppointmentVitals(appointmentId, vitalsMap),
                  );
                } else {
                  _updateConsultationVitals(consultation, vitalsMap);
                }

                Navigator.pop(ctx); // Close dialog
                Navigator.pop(
                  context,
                ); // Close details sheet to trigger refresh

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

  Color _getStatusColor(String status) {
    switch (status) {
      case "Completed":
        return const Color(0xFF0F9F58);
      case "Booked":
        return AppColors.primary;
      case "Pending":
        return AppColors.warning;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
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

    return BlocBuilder<AdminAppointmentsBloc, AdminAppointmentsState>(
      builder: (context, state) {
        // Load real appointments for this doctor
        List<AppointmentEntity> realAppointments = [];
        if (state is AdminAppointmentsLoaded) {
          realAppointments = state.appointments
              .where((a) => a.doctorId == widget.user.id)
              .toList();
        }

        // Merge real appointments with default/metadata consultations to preserve mock data
        final List<Map<String, dynamic>> consultationsList = [];

        // Add real appointments first
        for (final apt in realAppointments) {
          consultationsList.add({
            "isReal": true,
            "id": apt.id,
            "appointment": apt,
            "time": apt.appointmentTime,
            "name": apt.patientName,
            "age": 30, // Default age or lookup if needed
            "gender": "Male", // Default gender or lookup if needed
            "type": apt.type,
            "mode": "Video", // Default mode
            "status": apt.status,
            "bp": apt.bp,
            "weight": apt.weight,
            "height": apt.height,
            "fever": apt.fever,
            "head_circumference": apt.headCircumference,
            "additional_vitals": apt.additionalVitals,
          });
        }

        // Add mock consultations if no real ones exist, or append them
        final mockList = _consultations;
        for (final item in mockList) {
          // Check if we already added a real appointment with similar patient name to avoid duplicates in mock views
          final isDuplicate = consultationsList.any(
            (e) => e["name"] == item["name"] && e["time"] == item["time"],
          );
          if (!isDuplicate) {
            consultationsList.add({"isReal": false, ...item});
          }
        }

        // Filter consultations based on selected mode
        final filteredConsultations = consultationsList.where((item) {
          if (_selectedMode == "All") return true;
          return item["mode"].toString().toLowerCase() ==
              _selectedMode.toLowerCase();
        }).toList();

        return Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: cardBg,
            border: Border.all(color: borderColor, width: 1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with filters
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Consultation List",
                      style: AppTextStyles.titleMedium.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  // Date picker
                  Container(
                    height: 28.h,
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: borderColor),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedDate,
                        dropdownColor: cardBg,
                        icon: Icon(
                          Icons.arrow_drop_down,
                          color: labelColor,
                          size: 14.sp,
                        ),
                        style: TextStyle(
                          color: textColor,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        onChanged: (val) =>
                            setState(() => _selectedDate = val!),
                        items: ["20 May 2025", "21 May 2025", "22 May 2025"]
                            .map((date) {
                              return DropdownMenuItem<String>(
                                value: date,
                                child: Text(date),
                              );
                            })
                            .toList(),
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  // Video / Audio toggles
                  _buildModeToggleButton(
                    "Video",
                    Icons.videocam_outlined,
                    AppColors.primary,
                  ),
                  SizedBox(width: 4.w),
                  _buildModeToggleButton(
                    "Audio",
                    Icons.phone_outlined,
                    const Color(0xFF9C27B0),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              // Consultation table / headers
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      "Time",
                      style: TextStyle(
                        color: labelColor,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      "Patient Name",
                      style: TextStyle(
                        color: labelColor,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Type",
                      style: TextStyle(
                        color: labelColor,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "Mode",
                      style: TextStyle(
                        color: labelColor,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      "Status",
                      style: TextStyle(
                        color: labelColor,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Expanded(flex: 1, child: Container()),
                ],
              ),
              Divider(color: borderColor),
              // Rows
              filteredConsultations.isEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 20.h),
                      child: Center(
                        child: Text(
                          "No consultations found for selected mode.",
                          style: TextStyle(color: labelColor, fontSize: 12.sp),
                        ),
                      ),
                    )
                  : ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredConsultations.length,
                      separatorBuilder: (context, idx) =>
                          Divider(color: borderColor, height: 1),
                      itemBuilder: (context, idx) {
                        final item = filteredConsultations[idx];
                        final isVideo = item["mode"] == "Video";
                        final statusColor = _getStatusColor(item["status"]);
                        final avatarUrl =
                            "https://ui-avatars.com/api/?name=${Uri.encodeComponent(item["name"])}&background=random";

                        return InkWell(
                          onTap: () => _showConsultationOptions(context, item),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 8.h),
                            child: Row(
                              children: [
                                // Time
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    item["time"],
                                    style: TextStyle(
                                      color: textColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                ),
                                // Patient Info
                                Expanded(
                                  flex: 4,
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 12.r,
                                        backgroundImage: NetworkImage(
                                          avatarUrl,
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              item["name"],
                                              style: TextStyle(
                                                color: textColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11.sp,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              "${item["age"]} Years, ${item["gender"]}",
                                              style: TextStyle(
                                                color: labelColor,
                                                fontSize: 9.sp,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Type
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    item["type"],
                                    style: TextStyle(
                                      color: labelColor,
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                ),
                                // Mode
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Icon(
                                      isVideo ? Icons.videocam : Icons.phone,
                                      size: 14.sp,
                                      color: isVideo
                                          ? AppColors.primary
                                          : const Color(0xFF9C27B0),
                                    ),
                                  ),
                                ),
                                // Status
                                Expanded(
                                  flex: 2,
                                  child: Center(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6.w,
                                        vertical: 2.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: statusColor.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        border: Border.all(
                                          color: statusColor,
                                          width: 0.5,
                                        ),
                                      ),
                                      child: Text(
                                        item["status"],
                                        style: TextStyle(
                                          color: statusColor,
                                          fontSize: 9.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Action button
                                Expanded(
                                  flex: 1,
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.more_horiz,
                                      color: labelColor,
                                      size: 14.sp,
                                    ),
                                    onPressed: () =>
                                        _showConsultationOptions(context, item),
                                    style: IconButton.styleFrom(
                                      padding: EdgeInsets.zero,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
              Divider(color: borderColor),
              // Footer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Total ${filteredConsultations.length} consultations",
                    style: TextStyle(
                      color: labelColor,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Opening consultation report details...",
                          ),
                        ),
                      );
                    },
                    child: Text(
                      "View All",
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildModeToggleButton(String mode, IconData icon, Color color) {
    final isSelected = _selectedMode == mode;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedMode = isSelected ? "All" : mode;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 28.h,
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.transparent,
          border: Border.all(
            color: isSelected
                ? color
                : AppColors.terminalDarkBorder.withValues(alpha: 0.2),
          ),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Row(
          children: [
            Icon(icon, size: 12.sp, color: isSelected ? Colors.white : color),
            SizedBox(width: 4.w),
            Text(
              mode,
              style: TextStyle(
                color: isSelected ? Colors.white : color,
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
