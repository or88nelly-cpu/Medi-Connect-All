import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';

class EditProfessionalInfo extends StatefulWidget {
  final TextEditingController qualificationController;
  final TextEditingController experienceController;
  final TextEditingController regNumberController;
  final TextEditingController feeController;
  final String selectedDepartment;
  final ValueChanged<String?> onDepartmentChanged;
  final String selectedSpecialization;
  final ValueChanged<String?> onSpecializationChanged;

  const EditProfessionalInfo({
    super.key,
    required this.qualificationController,
    required this.experienceController,
    required this.regNumberController,
    required this.feeController,
    required this.selectedDepartment,
    required this.onDepartmentChanged,
    required this.selectedSpecialization,
    required this.onSpecializationChanged,
  });

  @override
  State<EditProfessionalInfo> createState() => _EditProfessionalInfoState();
}

class _EditProfessionalInfoState extends State<EditProfessionalInfo> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final borderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final textColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;
    final fieldBg = isDark ? AppColors.terminalDarkFieldFill : Colors.grey.shade50;

    final departments = ["Cardiology", "Dermatology", "Orthopedics", "Pediatrics", "Neurology", "General Medicine"];
    final specializations = ["Cardiologist", "Dermatologist", "Orthopedic Surgeon", "Pediatrician", "Neurologist", "General Physician"];

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
          Text(
            "Professional Details",
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 14.h),

          // Department & Specialization Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(textColor, "Department*"),
                    SizedBox(height: 6.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: fieldBg,
                        border: Border.all(color: borderColor),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: departments.contains(widget.selectedDepartment) ? widget.selectedDepartment : departments.first,
                          isExpanded: true,
                          dropdownColor: cardBg,
                          icon: Icon(Icons.keyboard_arrow_down, color: labelColor, size: 16.sp),
                          style: TextStyle(color: textColor, fontSize: 11.sp, fontWeight: FontWeight.w600),
                          onChanged: widget.onDepartmentChanged,
                          items: departments.map((dept) {
                            return DropdownMenuItem<String>(
                              value: dept,
                              child: Text(dept),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(textColor, "Specialization*"),
                    SizedBox(height: 6.h),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: fieldBg,
                        border: Border.all(color: borderColor),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: specializations.contains(widget.selectedSpecialization) ? widget.selectedSpecialization : specializations.first,
                          isExpanded: true,
                          dropdownColor: cardBg,
                          icon: Icon(Icons.keyboard_arrow_down, color: labelColor, size: 16.sp),
                          style: TextStyle(color: textColor, fontSize: 11.sp, fontWeight: FontWeight.w600),
                          onChanged: widget.onSpecializationChanged,
                          items: specializations.map((spec) {
                            return DropdownMenuItem<String>(
                              value: spec,
                              child: Text(spec),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Qualification & Experience Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(textColor, "Qualification*"),
                    SizedBox(height: 6.h),
                    _buildTextField(
                      controller: widget.qualificationController,
                      hintText: "e.g. MBBS, MD",
                      icon: Icons.school_outlined,
                      isDark: isDark,
                      validator: (val) => val == null || val.isEmpty ? AppStrings.requiredField : null,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(textColor, "Experience (Years)*"),
                    SizedBox(height: 6.h),
                    _buildTextField(
                      controller: widget.experienceController,
                      hintText: "e.g. 10",
                      icon: Icons.work_outline,
                      keyboardType: TextInputType.number,
                      isDark: isDark,
                      validator: (val) => val == null || val.isEmpty ? AppStrings.requiredField : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Reg Number & Consultation Fee Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(textColor, "Medical Reg. Number*"),
                    SizedBox(height: 6.h),
                    _buildTextField(
                      controller: widget.regNumberController,
                      hintText: "Registration No.",
                      icon: Icons.badge_outlined,
                      isDark: isDark,
                      validator: (val) => val == null || val.isEmpty ? AppStrings.requiredField : null,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(textColor, "Consultation Fee (₹)*"),
                    SizedBox(height: 6.h),
                    _buildTextField(
                      controller: widget.feeController,
                      hintText: "e.g. 500",
                      icon: Icons.currency_rupee,
                      keyboardType: TextInputType.number,
                      isDark: isDark,
                      validator: (val) => val == null || val.isEmpty ? AppStrings.requiredField : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(Color textColor, String text) {
    return Text(
      text,
      style: TextStyle(
        color: textColor,
        fontWeight: FontWeight.w600,
        fontSize: 10.5.sp,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    required bool isDark,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    final textColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;
    final fieldBg = isDark ? AppColors.terminalDarkFieldFill : Colors.grey.shade50;
    final borderColor = isDark ? AppColors.terminalDarkBorder : Colors.grey.shade300;

    return Container(
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: fieldBg,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14.sp, color: labelColor),
          SizedBox(width: 8.w),
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              validator: validator,
              style: TextStyle(color: textColor, fontSize: 11.sp, fontWeight: FontWeight.w600),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(color: labelColor, fontSize: 11.sp, fontWeight: FontWeight.normal),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
