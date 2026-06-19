import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/common_widgets/text_fields/text_fields.dart';

class EmergencyContactSection extends StatelessWidget {
  final TextEditingController nameCtrl;
  final TextEditingController phoneCtrl;
  final String selectedRelationship;
  final ValueChanged<String> onRelationshipChanged;
  final VoidCallback onFieldsChanged;

  const EmergencyContactSection({
    super.key,
    required this.nameCtrl,
    required this.phoneCtrl,
    required this.selectedRelationship,
    required this.onRelationshipChanged,
    required this.onFieldsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF09121F) : Colors.white;
    final borderColor = isDark
        ? const Color(0xFF16253B)
        : const Color(0xFFD3E0EE);
    final labelColor = isDark
        ? const Color(0xFF5E98C7)
        : const Color(0xFF3F6D94);
    final inputTextColor = isDark ? Colors.white : const Color(0xFF0C192E);

    return Container(
      padding: EdgeInsets.all(24.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor, width: 1.w),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.contact_phone_outlined,
                color: AppColors.primary,
                size: 22.r,
              ),
              SizedBox(width: 10.w),
              Text(
                "Emergency Contact",
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F2C59),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Inputs Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Contact Name
              Expanded(
                child: Column(
                  children: [
                    _buildLabel("Contact Name *", labelColor),
                    AppTextField(
                      controller: nameCtrl,
                      labelText: "Enter contact name",
                      hintText: "Sita Kumar",
                      onTap: onFieldsChanged,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),

              // Relationship
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Relationship *", labelColor),
                    _buildDropdown(
                      value: selectedRelationship,
                      items: [
                        'Wife',
                        'Husband',
                        'Parent',
                        'Child',
                        'Sibling',
                        'Friend',
                        'Other',
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          onRelationshipChanged(val);
                          onFieldsChanged();
                        }
                      },
                      isDark: isDark,
                      borderColor: borderColor,
                      inputTextColor: inputTextColor,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),

              // Phone Number
              Expanded(
                child: Column(
                  children: [
                    _buildLabel("Phone Number *", labelColor),
                    _buildPhoneField(
                      context,
                      isDark,
                      borderColor,
                      inputTextColor,
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

  Widget _buildLabel(String text, Color color) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(bottom: 8.h),
        child: Text(
          text,
          style: AppTextStyles.labelSmall.copyWith(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required bool isDark,
    required Color borderColor,
    required Color inputTextColor,
  }) {
    final fillBg = isDark ? const Color(0xFF050C16) : const Color(0xFFEDF2F7);
    return Container(
      height: 52.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: fillBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: borderColor, width: 1.w),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          icon: Icon(
            Icons.arrow_drop_down,
            color: inputTextColor.withValues(alpha: 0.6),
          ),
          dropdownColor: fillBg,
          isExpanded: true,
          style: AppTextStyles.bodyLarge.copyWith(color: inputTextColor),
          items: items.map((item) {
            return DropdownMenuItem<String>(value: item, child: Text(item));
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildPhoneField(
    BuildContext context,
    bool isDark,
    Color borderColor,
    Color inputTextColor,
  ) {
    final fillBg = isDark ? const Color(0xFF050C16) : const Color(0xFFEDF2F7);
    return Row(
      children: [
        // Flag dropdown container
        Container(
          height: 52.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: fillBg,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8.r),
              bottomLeft: Radius.circular(8.r),
            ),
            border: Border.all(color: borderColor, width: 1.w),
          ),
          child: Row(
            children: [
              Text("🇮🇳", style: TextStyle(fontSize: 16.sp)),
              SizedBox(width: 4.w),
              Text(
                "+91",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: inputTextColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: inputTextColor.withValues(alpha: 0.6),
                size: 18.r,
              ),
            ],
          ),
        ),
        // Number field
        Expanded(
          child: TextFormField(
            controller: phoneCtrl,
            keyboardType: TextInputType.phone,
            onChanged: (_) => onFieldsChanged(),
            style: AppTextStyles.bodyLarge.copyWith(color: inputTextColor),
            decoration: InputDecoration(
              hintText: "91234 56789",
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: isDark
                    ? AppColors.terminalDarkFieldHint
                    : AppColors.terminalLightFieldHint,
              ),
              filled: true,
              fillColor: fillBg,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 16.h,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: borderColor, width: 1.w),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8.r),
                  bottomRight: Radius.circular(8.r),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary, width: 1.5.w),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(8.r),
                  bottomRight: Radius.circular(8.r),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
