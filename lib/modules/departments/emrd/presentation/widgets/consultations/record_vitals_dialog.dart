import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/dashboard/domain/entities/appointment_entity.dart';

class RecordVitalsDialog extends StatefulWidget {
  final AppointmentEntity appointment;
  final Function(Map<String, dynamic> vitals) onSave;

  const RecordVitalsDialog({
    super.key,
    required this.appointment,
    required this.onSave,
  });

  @override
  State<RecordVitalsDialog> createState() => _RecordVitalsDialogState();
}

class _RecordVitalsDialogState extends State<RecordVitalsDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _bpController;
  late final TextEditingController _weightController;
  late final TextEditingController _heightController;
  late final TextEditingController _feverController;
  late final TextEditingController _headCircController;
  late final TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    _bpController = TextEditingController(text: widget.appointment.bp);
    _weightController = TextEditingController(text: widget.appointment.weight);
    _heightController = TextEditingController(text: widget.appointment.height);
    _feverController = TextEditingController(text: widget.appointment.fever);
    _headCircController = TextEditingController(text: widget.appointment.headCircumference);
    _notesController = TextEditingController(text: widget.appointment.additionalVitals);
  }

  @override
  void dispose() {
    _bpController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    _feverController.dispose();
    _headCircController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Dialog(
      backgroundColor: isDark ? AppColors.terminalDarkCard : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.85,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: EdgeInsets.all(20.r),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Record Vitals",
                          style: AppTextStyles.titleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "Patient: ${widget.appointment.patientName}",
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isDark ? Colors.white60 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              SizedBox(height: 12.h),

              // Form fields
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _buildTextField(
                        controller: _bpController,
                        label: "Blood Pressure",
                        hint: "e.g. 120/80 mmHg",
                        icon: Icons.speed_outlined,
                        isDark: isDark,
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _weightController,
                              label: "Weight",
                              hint: "e.g. 70 kg",
                              icon: Icons.monitor_weight_outlined,
                              isDark: isDark,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _buildTextField(
                              controller: _heightController,
                              label: "Height",
                              hint: "e.g. 175 cm",
                              icon: Icons.height_outlined,
                              isDark: isDark,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _feverController,
                              label: "Temperature",
                              hint: "e.g. 98.6 F",
                              icon: Icons.thermostat_outlined,
                              isDark: isDark,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: _buildTextField(
                              controller: _headCircController,
                              label: "Head Circumference",
                              hint: "e.g. 55 cm (Optional)",
                              icon: Icons.face_outlined,
                              isDark: isDark,
                              keyboardType: TextInputType.text,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      _buildTextField(
                        controller: _notesController,
                        label: "Additional Vitals / Symptoms",
                        hint: "e.g. SpO2 98%, Mild headache, etc.",
                        icon: Icons.notes_outlined,
                        isDark: isDark,
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16.h),
              // Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel"),
                  ),
                  SizedBox(width: 12.w),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final vitals = {
                          'bp': _bpController.text.trim(),
                          'weight': _weightController.text.trim(),
                          'height': _heightController.text.trim(),
                          'fever': _feverController.text.trim(),
                          'headCircumference': _headCircController.text.trim(),
                          'additionalVitals': _notesController.text.trim(),
                        };
                        widget.onSave(vitals);
                        Navigator.pop(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    ),
                    child: const Text(
                      "Save Vitals",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDark,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    final borderColor = isDark ? Colors.white24 : Colors.black12;
    final fillCol = isDark ? AppColors.terminalDarkFieldFill : AppColors.terminalLightFieldFill;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: TextStyle(color: isDark ? Colors.white : Colors.black87),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.black38, fontSize: 13.sp),
            prefixIcon: Icon(icon, size: 20.r, color: isDark ? Colors.white60 : Colors.black54),
            filled: true,
            fillColor: fillCol,
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: borderColor),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: borderColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
