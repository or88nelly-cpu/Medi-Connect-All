import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';

class EditPersonalInfo extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController dobController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController alternatePhoneController;
  final String gender;
  final ValueChanged<String?> onGenderChanged;
  final String bloodGroup;
  final ValueChanged<String?> onBloodGroupChanged;

  const EditPersonalInfo({
    super.key,
    required this.nameController,
    required this.dobController,
    required this.emailController,
    required this.phoneController,
    required this.alternatePhoneController,
    required this.gender,
    required this.onGenderChanged,
    required this.bloodGroup,
    required this.onBloodGroupChanged,
  });

  @override
  State<EditPersonalInfo> createState() => _EditPersonalInfoState();
}

class _EditPersonalInfoState extends State<EditPersonalInfo> {
  Future<void> _selectDOB() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(1985, 5, 20),
      firstDate: DateTime(1940, 1, 1),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final months = [
        "Jan",
        "Feb",
        "Mar",
        "Apr",
        "May",
        "Jun",
        "Jul",
        "Aug",
        "Sep",
        "Oct",
        "Nov",
        "Dec",
      ];
      setState(() {
        widget.dobController.text =
            "${picked.day} ${months[picked.month - 1]} ${picked.year}";
      });
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
    final fieldBg = isDark
        ? AppColors.terminalDarkFieldFill
        : Colors.grey.shade50;

    final genders = ["Male", "Female", "Other"];
    final bloodGroups = ["A+", "A-", "B+", "B-", "AB+", "AB-", "O+", "O-"];

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
            "Personal Information",
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 14.h),

          // Name
          _buildLabel(textColor, "Full Name*"),
          SizedBox(height: 6.h),
          _buildTextField(
            controller: widget.nameController,
            hintText: "Enter full name",
            icon: Icons.person_outline,
            isDark: isDark,
            validator: (val) =>
                val == null || val.isEmpty ? AppStrings.requiredField : null,
          ),
          SizedBox(height: 12.h),

          // DOB & Gender Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(textColor, "Date of Birth*"),
                    SizedBox(height: 6.h),
                    GestureDetector(
                      onTap: _selectDOB,
                      child: AbsorbPointer(
                        child: _buildTextField(
                          controller: widget.dobController,
                          hintText: "Select DOB",
                          icon: Icons.calendar_today_outlined,
                          isDark: isDark,
                          validator: (val) => val == null || val.isEmpty
                              ? AppStrings.requiredField
                              : null,
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
                    _buildLabel(textColor, "Gender*"),
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
                          value: genders.contains(widget.gender)
                              ? widget.gender
                              : genders.first,
                          isExpanded: true,
                          dropdownColor: cardBg,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: labelColor,
                            size: 16.sp,
                          ),
                          style: TextStyle(
                            color: textColor,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          onChanged: widget.onGenderChanged,
                          items: genders.map((g) {
                            return DropdownMenuItem<String>(
                              value: g,
                              child: Text(g),
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

          // Blood Group & Email Row/Fields
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(textColor, "Blood Group*"),
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
                          value: bloodGroups.contains(widget.bloodGroup)
                              ? widget.bloodGroup
                              : bloodGroups.first,
                          isExpanded: true,
                          dropdownColor: cardBg,
                          icon: Icon(
                            Icons.keyboard_arrow_down,
                            color: labelColor,
                            size: 16.sp,
                          ),
                          style: TextStyle(
                            color: textColor,
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w600,
                          ),
                          onChanged: widget.onBloodGroupChanged,
                          items: bloodGroups.map((b) {
                            return DropdownMenuItem<String>(
                              value: b,
                              child: Text(b),
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
                    _buildLabel(textColor, "Email Address*"),
                    SizedBox(height: 6.h),
                    _buildTextField(
                      controller: widget.emailController,
                      hintText: "Enter email address",
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      isDark: isDark,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return AppStrings.requiredField;
                        }
                        if (!val.contains('@')) return "Invalid email address";
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),

          // Phone & Alternate Phone Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(textColor, "Mobile Number*"),
                    SizedBox(height: 6.h),
                    _buildTextField(
                      controller: widget.phoneController,
                      hintText: "Enter phone number",
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      isDark: isDark,
                      prefixText: "+91 ", // Flag indicator simulation
                      validator: (val) => val == null || val.isEmpty
                          ? AppStrings.requiredField
                          : null,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(textColor, "Alternate Number"),
                    SizedBox(height: 6.h),
                    _buildTextField(
                      controller: widget.alternatePhoneController,
                      hintText: "Enter alternate phone",
                      icon: Icons.phone_android_outlined,
                      keyboardType: TextInputType.phone,
                      isDark: isDark,
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
    String? prefixText,
    String? Function(String?)? validator,
  }) {
    final textColor = isDark
        ? AppColors.terminalDarkText
        : AppColors.terminalLightText;
    final labelColor = isDark
        ? AppColors.terminalDarkLabel
        : AppColors.terminalLightLabel;
    final fieldBg = isDark
        ? AppColors.terminalDarkFieldFill
        : Colors.grey.shade50;
    final borderColor = isDark
        ? AppColors.terminalDarkBorder
        : Colors.grey.shade300;

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
          if (prefixText != null) ...[
            Text(
              prefixText,
              style: TextStyle(
                color: textColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
          Expanded(
            child: TextFormField(
              controller: controller,
              keyboardType: keyboardType,
              validator: validator,
              style: TextStyle(
                color: textColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: TextStyle(
                  color: labelColor,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.normal,
                ),
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
