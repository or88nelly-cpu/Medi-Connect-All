import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/common_widgets/text_fields/text_fields.dart';

class LifestyleInfoSection extends StatelessWidget {
  final TextEditingController allergiesCtrl;
  final TextEditingController otherDetailsCtrl;
  final String selectedSmoking;
  final String selectedAlcohol;
  final String selectedDietType;
  final String selectedExercise;
  final ValueChanged<String> onSmokingChanged;
  final ValueChanged<String> onAlcoholChanged;
  final ValueChanged<String> onDietTypeChanged;
  final ValueChanged<String> onExerciseChanged;
  final VoidCallback onFieldsChanged;

  const LifestyleInfoSection({
    super.key,
    required this.allergiesCtrl,
    required this.otherDetailsCtrl,
    required this.selectedSmoking,
    required this.selectedAlcohol,
    required this.selectedDietType,
    required this.selectedExercise,
    required this.onSmokingChanged,
    required this.onAlcoholChanged,
    required this.onDietTypeChanged,
    required this.onExerciseChanged,
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
                Icons.favorite_outline_rounded,
                color: AppColors.primary,
                size: 22.r,
              ),
              SizedBox(width: 10.w),
              Text(
                "Lifestyle Details",
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F2C59),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),

          // Dropdowns row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Smoking", labelColor),
                    _buildDropdown(
                      value: selectedSmoking,
                      items: ['No', 'Yes', 'Occasionally'],
                      onChanged: (val) {
                        if (val != null) {
                          onSmokingChanged(val);
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
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Alcohol", labelColor),
                    _buildDropdown(
                      value: selectedAlcohol,
                      items: ['No', 'Yes', 'Occasionally'],
                      onChanged: (val) {
                        if (val != null) {
                          onAlcoholChanged(val);
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
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Diet Type", labelColor),
                    _buildDropdown(
                      value: selectedDietType,
                      items: [
                        'Non Vegetarian',
                        'Vegetarian',
                        'Vegan',
                        'Eggetarian',
                      ],
                      onChanged: (val) {
                        if (val != null) {
                          onDietTypeChanged(val);
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
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Exercise", labelColor),
                    _buildDropdown(
                      value: selectedExercise,
                      items: ['Regular', 'Occasionally', 'None'],
                      onChanged: (val) {
                        if (val != null) {
                          onExerciseChanged(val);
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
            ],
          ),
          SizedBox(height: 16.h),

          // Textfields Row
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildLabel(
                      "Allergies / Medical Conditions (Optional)",
                      labelColor,
                    ),
                    AppTextField(
                      controller: allergiesCtrl,
                      labelText: "Enter allergies",
                      hintText: "No known allergies",
                      onTap: onFieldsChanged,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  children: [
                    _buildLabel("Any Other Details (Optional)", labelColor),
                    AppTextField(
                      controller: otherDetailsCtrl,
                      labelText: "Enter other details",
                      hintText: "Enter other details",
                      onTap: onFieldsChanged,
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
}
