import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';

class EditAdditionalInfo extends StatefulWidget {
  final List<String> languages;
  final Function(String) onAddLanguage;
  final Function(String) onRemoveLanguage;
  final List<String> selectedConsultationModes;
  final Function(String) onToggleConsultationMode;
  final TextEditingController aboutController;

  const EditAdditionalInfo({
    super.key,
    required this.languages,
    required this.onAddLanguage,
    required this.onRemoveLanguage,
    required this.selectedConsultationModes,
    required this.onToggleConsultationMode,
    required this.aboutController,
  });

  @override
  State<EditAdditionalInfo> createState() => _EditAdditionalInfoState();
}

class _EditAdditionalInfoState extends State<EditAdditionalInfo> {
  final _langController = TextEditingController();
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _charCount = widget.aboutController.text.length;
    widget.aboutController.addListener(() {
      if (mounted) {
        setState(() {
          _charCount = widget.aboutController.text.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _langController.dispose();
    super.dispose();
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

    final availableModes = ["Video", "Audio", "In-Person"];

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
            "Additional Information",
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 14.h),

          // Languages Known
          _buildLabel(textColor, "Languages Known"),
          SizedBox(height: 6.h),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 40.h,
                  padding: EdgeInsets.symmetric(horizontal: 10.w),
                  decoration: BoxDecoration(
                    color: fieldBg,
                    border: Border.all(color: borderColor),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: TextField(
                    controller: _langController,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: "Add a language (e.g. Spanish)",
                      hintStyle: TextStyle(
                        color: labelColor,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.normal,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                    onSubmitted: (val) {
                      if (val.trim().isNotEmpty) {
                        widget.onAddLanguage(val.trim());
                        _langController.clear();
                      }
                    },
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              ElevatedButton(
                onPressed: () {
                  if (_langController.text.trim().isNotEmpty) {
                    widget.onAddLanguage(_langController.text.trim());
                    _langController.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  minimumSize: Size(40.r, 40.r),
                  padding: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          // Language Chips wrap
          Wrap(
            spacing: 6.w,
            runSpacing: 6.h,
            children: widget.languages.map((lang) {
              return Chip(
                label: Text(
                  lang,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                backgroundColor: isDark
                    ? AppColors.terminalDarkFieldFill
                    : Colors.grey.shade100,
                side: BorderSide(color: borderColor),
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                deleteIcon: Icon(Icons.close, size: 12.sp, color: labelColor),
                onDeleted: () => widget.onRemoveLanguage(lang),
              );
            }).toList(),
          ),
          SizedBox(height: 14.h),

          // Consultation Mode
          _buildLabel(textColor, "Consultation Mode*"),
          SizedBox(height: 6.h),
          Wrap(
            spacing: 8.w,
            children: availableModes.map((mode) {
              final isSelected = widget.selectedConsultationModes.contains(
                mode,
              );
              return ChoiceChip(
                label: Text(
                  mode,
                  style: TextStyle(
                    color: isSelected ? Colors.white : textColor,
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                selected: isSelected,
                selectedColor: AppColors.primary,
                backgroundColor: isDark
                    ? AppColors.terminalDarkFieldFill
                    : Colors.grey.shade100,
                side: BorderSide(
                  color: isSelected ? AppColors.primary : borderColor,
                ),
                checkmarkColor: Colors.white,
                onSelected: (_) => widget.onToggleConsultationMode(mode),
              );
            }).toList(),
          ),
          SizedBox(height: 14.h),

          // About Doctor
          _buildLabel(textColor, "About Doctor"),
          SizedBox(height: 6.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: fieldBg,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(6.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Icon(
                        Icons.info_outline,
                        size: 14.sp,
                        color: labelColor,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: TextFormField(
                        controller: widget.aboutController,
                        maxLines: 4,
                        maxLength: 500,
                        style: TextStyle(color: textColor, fontSize: 11.sp),
                        buildCounter:
                            (
                              context, {
                              required currentLength,
                              required isFocused,
                              maxLength,
                            }) => null,
                        decoration: InputDecoration(
                          hintText: "Enter short bio / background...",
                          hintStyle: TextStyle(
                            color: labelColor,
                            fontSize: 11.sp,
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  "$_charCount/500",
                  style: TextStyle(color: labelColor, fontSize: 9.sp),
                ),
              ],
            ),
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
}
