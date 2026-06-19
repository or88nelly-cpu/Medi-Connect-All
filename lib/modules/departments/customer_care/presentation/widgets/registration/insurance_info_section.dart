import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/common_widgets/text_fields/text_fields.dart';

class InsuranceInfoSection extends StatelessWidget {
  final TextEditingController policyIdCtrl;
  final TextEditingController validTillCtrl;
  final String selectedProvider;
  final ValueChanged<String> onProviderChanged;
  final VoidCallback onFieldsChanged;

  const InsuranceInfoSection({
    super.key,
    required this.policyIdCtrl,
    required this.validTillCtrl,
    required this.selectedProvider,
    required this.onProviderChanged,
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
              Icon(Icons.shield_outlined, color: AppColors.primary, size: 22.r),
              SizedBox(width: 10.w),
              Text(
                "Insurance Information",
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
              // Provider Dropdown
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Insurance Provider (Optional)", labelColor),
                    _buildDropdown(
                      value: selectedProvider,
                      items: [
                        'Star Health Insurance',
                        'Care Health Insurance',
                        'HDFC Ergo',
                        'Max Life Insurance',
                        'Other',
                        'None',
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          onProviderChanged(val);
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

              // Policy / Member ID
              Expanded(
                child: Column(
                  children: [
                    _buildLabel("Policy / Member ID (Optional)", labelColor),
                    AppTextField(
                      controller: policyIdCtrl,
                      labelText: "Enter policy ID",
                      hintText: "SHI987654321",
                      onTap: onFieldsChanged,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),

              // Valid Till Date
              Expanded(
                child: Column(
                  children: [
                    _buildLabel("Valid Till (Optional)", labelColor),
                    AppTextField(
                      controller: validTillCtrl,
                      labelText: "Select expiry date",
                      hintText: "31/12/2025",
                      readOnly: true,
                      suffixIcon: Icon(
                        Icons.calendar_today_rounded,
                        size: 18.r,
                        color: labelColor,
                      ),
                      onTap: () => _selectDate(context),
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 365)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).brightness == Brightness.dark
              ? ThemeData.dark().copyWith(
                  colorScheme: const ColorScheme.dark(
                    primary: AppColors.primary,
                    onPrimary: Colors.white,
                    surface: Color(0xFF09121F),
                    onSurface: Colors.white,
                  ),
                )
              : ThemeData.light().copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: AppColors.primary,
                    onPrimary: Colors.white,
                    surface: Colors.white,
                    onSurface: Colors.black87,
                  ),
                ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      validTillCtrl.text = DateFormat('dd/MM/yyyy').format(picked);
      onFieldsChanged();
    }
  }
}
