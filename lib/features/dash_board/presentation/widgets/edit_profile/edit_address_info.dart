import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';

class EditAddressInfo extends StatefulWidget {
  final TextEditingController address1Controller;
  final TextEditingController address2Controller;
  final TextEditingController cityController;
  final String selectedState;
  final ValueChanged<String?> onStateChanged;
  final TextEditingController pincodeController;

  const EditAddressInfo({
    super.key,
    required this.address1Controller,
    required this.address2Controller,
    required this.cityController,
    required this.selectedState,
    required this.onStateChanged,
    required this.pincodeController,
  });

  @override
  State<EditAddressInfo> createState() => _EditAddressInfoState();
}

class _EditAddressInfoState extends State<EditAddressInfo> {
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

    final states = [
      "Maharashtra",
      "Delhi",
      "Karnataka",
      "Tamil Nadu",
      "Telangana",
      "Punjab",
      "Haryana",
      "Uttar Pradesh",
      "West Bengal",
      "Kerala",
    ];

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
            "Address Details",
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 14.h),

          // Address Line 1
          _buildLabel(textColor, "Address Line 1*"),
          SizedBox(height: 6.h),
          _buildTextField(
            controller: widget.address1Controller,
            hintText: "Flat / House No. / Street",
            icon: Icons.home_outlined,
            isDark: isDark,
            validator: (val) =>
                val == null || val.isEmpty ? AppStrings.requiredField : null,
          ),
          SizedBox(height: 12.h),

          // Address Line 2
          _buildLabel(textColor, "Address Line 2"),
          SizedBox(height: 6.h),
          _buildTextField(
            controller: widget.address2Controller,
            hintText: "Area / Landmark",
            icon: Icons.location_on_outlined,
            isDark: isDark,
          ),
          SizedBox(height: 12.h),

          // City, State & Pincode Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(textColor, "City*"),
                    SizedBox(height: 6.h),
                    _buildTextField(
                      controller: widget.cityController,
                      hintText: "City name",
                      icon: Icons.location_city_outlined,
                      isDark: isDark,
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
                    _buildLabel(textColor, "State*"),
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
                          value: states.contains(widget.selectedState)
                              ? widget.selectedState
                              : states.first,
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
                          onChanged: widget.onStateChanged,
                          items: states.map((state) {
                            return DropdownMenuItem<String>(
                              value: state,
                              child: Text(state),
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

          // Pincode
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel(textColor, "Pincode*"),
                    SizedBox(height: 6.h),
                    _buildTextField(
                      controller: widget.pincodeController,
                      hintText: "6-digit PIN",
                      icon: Icons.pin_drop_outlined,
                      keyboardType: TextInputType.number,
                      isDark: isDark,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return AppStrings.requiredField;
                        }
                        if (val.length != 6) return "Must be 6 digits";
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: SizedBox(),
              ), // spacer to keep row symmetrical
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
