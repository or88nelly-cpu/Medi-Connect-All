import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/common_widgets/text_fields/text_fields.dart';

class PersonalInfoSection extends StatelessWidget {
  final TextEditingController firstNameCtrl;
  final TextEditingController lastNameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController dobCtrl;
  final String selectedSex;
  final String selectedGenderIdentity;
  final String selectedBloodGroup;
  final String photoPath;
  final ValueChanged<String> onSexChanged;
  final ValueChanged<String> onGenderIdentityChanged;
  final ValueChanged<String> onBloodGroupChanged;
  final VoidCallback onPhotoPick;
  final VoidCallback onFieldsChanged;

  const PersonalInfoSection({
    super.key,
    required this.firstNameCtrl,
    required this.lastNameCtrl,
    required this.emailCtrl,
    required this.phoneCtrl,
    required this.dobCtrl,
    required this.selectedSex,
    required this.selectedGenderIdentity,
    required this.selectedBloodGroup,
    required this.photoPath,
    required this.onSexChanged,
    required this.onGenderIdentityChanged,
    required this.onBloodGroupChanged,
    required this.onPhotoPick,
    required this.onFieldsChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF09121F) : Colors.white;
    final borderColor = isDark ? const Color(0xFF16253B) : const Color(0xFFD3E0EE);
    final labelColor = isDark ? const Color(0xFF5E98C7) : const Color(0xFF3F6D94);
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
                Icons.person_outline_rounded,
                color: AppColors.primary,
                size: 22.r,
              ),
              SizedBox(width: 10.w),
              Text(
                "Personal Information",
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F2C59),
                ),
              ),
            ],
          ),
          SizedBox(height: 24.h),
          
          // Form Grid/Row
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 650;
              return Column(
                children: [
                  // First row: First Name, Last Name, Photo Upload
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: isWide ? 2 : 1,
                        child: Column(
                          children: [
                            _buildLabel("First Name *", labelColor),
                            AppTextField(
                              controller: firstNameCtrl,
                              labelText: "Enter first name",
                              hintText: "Ramesh",
                              onTap: onFieldsChanged,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        flex: isWide ? 2 : 1,
                        child: Column(
                          children: [
                            _buildLabel("Last Name *", labelColor),
                            AppTextField(
                              controller: lastNameCtrl,
                              labelText: "Enter last name",
                              hintText: "Kumar",
                              onTap: onFieldsChanged,
                            ),
                          ],
                        ),
                      ),
                      if (isWide) ...[
                        SizedBox(width: 20.w),
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildLabel("Photo (Optional)", labelColor),
                              _buildPhotoUploadButton(context, isDark, borderColor, labelColor),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (!isWide) ...[
                    SizedBox(height: 16.h),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("Photo (Optional)", labelColor),
                        _buildPhotoUploadButton(context, isDark, borderColor, labelColor),
                      ],
                    ),
                  ],
                  SizedBox(height: 16.h),

                  // Second row: Email, Phone Number, Date of Birth
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            _buildLabel("Email (Optional)", labelColor),
                            AppTextField(
                              controller: emailCtrl,
                              labelText: "Enter email address",
                              hintText: "ramesh.kumar@email.com",
                              keyboardType: TextInputType.emailAddress,
                              onTap: onFieldsChanged,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          children: [
                            _buildLabel("Phone Number *", labelColor),
                            _buildPhoneField(context, isDark, borderColor, inputTextColor),
                          ],
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: Column(
                          children: [
                            _buildLabel("Date of Birth *", labelColor),
                            AppTextField(
                              controller: dobCtrl,
                              labelText: "Select DOB",
                              hintText: "15/06/1990",
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
                  SizedBox(height: 16.h),

                  // Third row: Sex, Gender Identity, Blood Group
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel("Sex *", labelColor),
                            _buildDropdown(
                              value: selectedSex,
                              items: ['Male', 'Female', 'Transgender', 'Other'],
                              onChanged: (val) {
                                if (val != null) {
                                  onSexChanged(val);
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel("Gender Identity (Including Trans)", labelColor),
                            _buildDropdown(
                              value: selectedGenderIdentity,
                              items: [
                                'Cisgender Male',
                                'Cisgender Female',
                                'Transgender Male',
                                'Transgender Female',
                                'Non-Binary',
                                'Other'
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  onGenderIdentityChanged(val);
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
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildLabel("Blood Group *", labelColor),
                            _buildDropdown(
                              value: selectedBloodGroup,
                              items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'],
                              onChanged: (val) {
                                if (val != null) {
                                  onBloodGroupChanged(val);
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
                ],
              );
            },
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

  Widget _buildPhotoUploadButton(BuildContext context, bool isDark, Color borderColor, Color labelColor) {
    final fillBg = isDark ? const Color(0xFF050C16) : const Color(0xFFEDF2F7);
    return InkWell(
      onTap: onPhotoPick,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        height: 52.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: fillBg,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: borderColor, width: 1.w),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              photoPath.isNotEmpty ? Icons.check_circle_outline : Icons.cloud_upload_outlined,
              color: photoPath.isNotEmpty ? AppColors.success : AppColors.primary,
              size: 20.r,
            ),
            SizedBox(width: 8.w),
            Flexible(
              child: Text(
                photoPath.isNotEmpty ? "Photo Attached" : "Upload / Scan Photo",
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: photoPath.isNotEmpty ? AppColors.success : labelColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneField(BuildContext context, bool isDark, Color borderColor, Color inputTextColor) {
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
              Text(
                "🇮🇳",
                style: TextStyle(fontSize: 16.sp),
              ),
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
              hintText: "98765 43210",
              hintStyle: AppTextStyles.bodyMedium.copyWith(
                color: isDark ? AppColors.terminalDarkFieldHint : AppColors.terminalLightFieldHint,
              ),
              filled: true,
              fillColor: fillBg,
              contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
          icon: Icon(Icons.arrow_drop_down, color: inputTextColor.withValues(alpha: 0.6)),
          dropdownColor: fillBg,
          isExpanded: true,
          style: AppTextStyles.bodyLarge.copyWith(color: inputTextColor),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 30)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
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
      dobCtrl.text = DateFormat('dd/MM/yyyy').format(picked);
      onFieldsChanged();
    }
  }
}
