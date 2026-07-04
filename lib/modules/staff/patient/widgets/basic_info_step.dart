import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/widgets/textfields/text_fields.dart';

class BasicInfoStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController firstNameCtrl;
  final TextEditingController lastNameCtrl;
  final TextEditingController emailCtrl;
  final TextEditingController phoneCtrl;
  final TextEditingController dobCtrl;
  final String selectedSex;
  final Function(String) onSexChanged;

  // Address
  final TextEditingController pincodeCtrl;
  final TextEditingController placeCtrl;
  final TextEditingController wardCtrl;
  final String fetchedAddress;
  final bool isFetchingAddress;
  final Function(String) onFetchAddress;

  const BasicInfoStep({
    super.key,
    required this.formKey,
    required this.firstNameCtrl,
    required this.lastNameCtrl,
    required this.emailCtrl,
    required this.phoneCtrl,
    required this.dobCtrl,
    required this.selectedSex,
    required this.onSexChanged,
    required this.pincodeCtrl,
    required this.placeCtrl,
    required this.wardCtrl,
    required this.fetchedAddress,
    required this.isFetchingAddress,
    required this.onFetchAddress,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Personal Details Section
          _buildSectionHeader(context, "Personal Details"),
          SizedBox(height: 12.h),

          _buildCardContainer(
            context,
            isDark,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: firstNameCtrl,
                        labelText: "First Name *",
                        hintText: "Enter first name",
                        prefixIcon: Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.primary,
                          size: 20.r,
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? AppStrings.requiredField
                            : null,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: AppTextField(
                        controller: lastNameCtrl,
                        labelText: "Last Name *",
                        hintText: "Enter last name",
                        prefixIcon: Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.primary,
                          size: 20.r,
                        ),
                        validator: (val) => val == null || val.trim().isEmpty
                            ? AppStrings.requiredField
                            : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),
                AppTextField(
                  controller: emailCtrl,
                  labelText: "Email Address (Optional)",
                  hintText: "Enter email address",
                  prefixIcon: Icon(
                    Icons.mail_outline_rounded,
                    color: AppColors.primary,
                    size: 20.r,
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (val) {
                    if (val != null && val.trim().isNotEmpty) {
                      final hasMatch = RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(val.trim());
                      if (!hasMatch) return AppStrings.invalidEmail;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: phoneCtrl,
                        labelText: "Mobile Number *",
                        hintText: "Enter mobile number",
                        prefixIcon: Icon(
                          Icons.phone_outlined,
                          color: AppColors.primary,
                          size: 20.r,
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return AppStrings.requiredField;
                          }
                          if (val.trim().length < 8) {
                            return AppStrings.invalidPhone;
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: AppTextField(
                        controller: dobCtrl,
                        labelText: "Date of Birth *",
                        hintText: "DD / MM / YYYY",
                        prefixIcon: Icon(
                          Icons.calendar_today_outlined,
                          color: AppColors.primary,
                          size: 20.r,
                        ),
                        readOnly: true,
                        onTap: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now().subtract(
                              const Duration(days: 365 * 18),
                            ),
                            firstDate: DateTime(1900),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            dobCtrl.text = DateFormat(
                              'dd/MM/yyyy',
                            ).format(picked);
                          }
                        },
                        validator: (val) => val == null || val.trim().isEmpty
                            ? AppStrings.requiredField
                            : null,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.h),

                // Gender Selector
                _buildGenderSelector(context, isDark),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // Address Details Section
          _buildSectionHeader(context, "Address Details"),
          SizedBox(height: 12.h),

          _buildCardContainer(
            context,
            isDark,
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: pincodeCtrl,
                        labelText: "Pincode *",
                        hintText: "Enter pincode",
                        prefixIcon: Icon(
                          Icons.pin_drop_outlined,
                          color: AppColors.primary,
                          size: 20.r,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) {
                            return AppStrings.requiredField;
                          }
                          if (val.trim().length != 6) {
                            return "Enter 6 digit pincode";
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: ElevatedButton.icon(
                        onPressed:
                            isFetchingAddress || pincodeCtrl.text.length != 6
                            ? null
                            : () => onFetchAddress(pincodeCtrl.text),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          padding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 16.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                        ),
                        icon: isFetchingAddress
                            ? SizedBox(
                                width: 14.r,
                                height: 14.r,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Icon(
                                Icons.my_location,
                                color: Colors.white,
                                size: 14.r,
                              ),
                        label: Text(
                          "Fetch Address",
                          style: AppTextStyles.buttonMedium.copyWith(
                            color: Colors.white,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                if (fetchedAddress.isNotEmpty) ...[
                  SizedBox(height: 12.h),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12.r),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Text(
                      fetchedAddress,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary(context),
                        fontSize: 10.sp,
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 16.h),
                AppTextField(
                  controller: placeCtrl,
                  labelText: "Place / Locality *",
                  hintText: "Enter place / locality",
                  prefixIcon: Icon(
                    Icons.home_work_outlined,
                    color: AppColors.primary,
                    size: 20.r,
                  ),
                  validator: (val) => val == null || val.trim().isEmpty
                      ? AppStrings.requiredField
                      : null,
                ),
                SizedBox(height: 16.h),
                AppTextField(
                  controller: wardCtrl,
                  labelText: "Ward Number (Optional)",
                  hintText: "Enter ward number",
                  prefixIcon: Icon(
                    Icons.door_front_door_outlined,
                    color: AppColors.primary,
                    size: 20.r,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: AppTextStyles.titleMedium.copyWith(
        color: AppColors.textPrimary(context),
        fontWeight: FontWeight.bold,
        fontSize: 13.sp,
      ),
    );
  }

  Widget _buildCardContainer(
    BuildContext context,
    bool isDark, {
    required Widget child,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.04),
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.border(context), width: 1.w),
      ),
      child: child,
    );
  }

  Widget _buildGenderSelector(BuildContext context, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Gender / Sex *",
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary(context),
            fontWeight: FontWeight.w600,
            fontSize: 9.sp,
          ),
        ),
        SizedBox(height: 8.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: [
            _buildGenderCard(
              context,
              "Male",
              Icons.male,
              AppColors.blue,
              selectedSex == "Male",
              isDark,
            ),
            _buildGenderCard(
              context,
              "Female",
              Icons.female,
              AppColors.pink,
              selectedSex == "Female",
              isDark,
            ),
            _buildGenderCard(
              context,
              "Transgender",
              Icons.transgender,
              AppColors.purple,
              selectedSex == "Transgender",
              isDark,
            ),
            _buildGenderCard(
              context,
              "Prefer not to say",
              Icons.lock_outline,
              AppColors.orange,
              selectedSex == "Prefer not to say",
              isDark,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildGenderCard(
    BuildContext context,
    String value,
    IconData icon,
    Color color,
    bool isSelected,
    bool isDark,
  ) {
    final activeBg = AppColors.primary.withValues(alpha: 0.1);
    final activeBorder = AppColors.primary;
    final inactiveBg = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF8FAFC);
    final inactiveBorder = AppColors.border(context);

    return InkWell(
      onTap: () => onSexChanged(value),
      borderRadius: BorderRadius.circular(10.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: isSelected ? activeBg : inactiveBg,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(
            color: isSelected ? activeBorder : inactiveBorder,
            width: isSelected ? 1.5.w : 1.w,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.primary : color,
              size: 16.r,
            ),
            SizedBox(width: 8.w),
            Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.textPrimary(context),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 10.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
