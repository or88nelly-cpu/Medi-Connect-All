import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class BasicInfoStep extends StatelessWidget {
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

    return Column(
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
                children: [
                  Expanded(
                    child: _buildTextField(
                      context: context,
                      controller: firstNameCtrl,
                      label: "First Name *",
                      hint: "Enter first name",
                      icon: Icons.person_outline_rounded,
                      isDark: isDark,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildTextField(
                      context: context,
                      controller: lastNameCtrl,
                      label: "Last Name *",
                      hint: "Enter last name",
                      icon: Icons.person_outline_rounded,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              _buildTextField(
                context: context,
                controller: emailCtrl,
                label: "Email Address (Optional)",
                hint: "Enter email address",
                icon: Icons.mail_outline_rounded,
                keyboardType: TextInputType.emailAddress,
                isDark: isDark,
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      context: context,
                      controller: phoneCtrl,
                      label: "Mobile Number *",
                      hint: "Enter mobile number",
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      isDark: isDark,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildDatePickerField(
                      context: context,
                      controller: dobCtrl,
                      label: "Date of Birth *",
                      hint: "DD / MM / YYYY",
                      icon: Icons.calendar_today_outlined,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              // Gender Selector
              CrossFadeState(
              //  crossAxisAlignment: CrossAxisAlignment.start,
                child: _buildGenderSelector(context, isDark),
              ),
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
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: _buildTextField(
                      context: context,
                      controller: pincodeCtrl,
                      label: "Pincode *",
                      hint: "Enter 6 digit pincode",
                      icon: Icons.pin_drop_outlined,
                      keyboardType: TextInputType.number,
                      isDark: isDark,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  ElevatedButton.icon(
                    onPressed: isFetchingAddress || pincodeCtrl.text.length != 6
                        ? null
                        : () => onFetchAddress(pincodeCtrl.text),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
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
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Icon(Icons.my_location, color: Colors.white, size: 14.r),
                    label: Text(
                      "Fetch Address",
                      style: AppTextStyles.buttonMedium.copyWith(
                        color: Colors.white,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
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
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
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
              _buildTextField(
                context: context,
                controller: placeCtrl,
                label: "Place / Locality *",
                hint: "Enter place / locality",
                icon: Icons.home_work_outlined,
                isDark: isDark,
              ),
              SizedBox(height: 16.h),
              _buildTextField(
                context: context,
                controller: wardCtrl,
                label: "Ward Number (Optional)",
                hint: "Enter ward number",
                icon: Icons.door_front_door_outlined,
                isDark: isDark,
              ),
            ],
          ),
        ),
      ],
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

  Widget _buildCardContainer(BuildContext context, bool isDark, {required Widget child}) {
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
        border: Border.all(
          color: AppColors.border(context),
          width: 1.w,
        ),
      ),
      child: child,
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary(context),
            fontWeight: FontWeight.w600,
            fontSize: 9.sp,
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          style: AppTextStyles.bodyMedium.copyWith(fontSize: 11.sp),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? Colors.white30 : Colors.grey.shade400,
              fontSize: 11.sp,
            ),
            prefixIcon: Icon(icon, color: AppColors.primary, size: 16.r),
            filled: true,
            fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
            contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: AppColors.border(context), width: 1.w),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: AppColors.border(context), width: 1.w),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDatePickerField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary(context),
            fontWeight: FontWeight.w600,
            fontSize: 9.sp,
          ),
        ),
        SizedBox(height: 6.h),
        TextFormField(
          controller: controller,
          readOnly: true,
          style: AppTextStyles.bodyMedium.copyWith(fontSize: 11.sp),
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              controller.text = DateFormat('dd/MM/yyyy').format(picked);
            }
          },
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: isDark ? Colors.white30 : Colors.grey.shade400,
              fontSize: 11.sp,
            ),
            prefixIcon: Icon(icon, color: AppColors.primary, size: 16.r),
            filled: true,
            fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
            contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: AppColors.border(context), width: 1.w),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(color: AppColors.border(context), width: 1.w),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
          ),
        ),
      ],
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
            _buildGenderCard(context, "Male", Icons.male, Colors.blue, selectedSex == "Male", isDark),
            _buildGenderCard(context, "Female", Icons.female, Colors.pink, selectedSex == "Female", isDark),
            _buildGenderCard(context, "Transgender", Icons.transgender, Colors.purple, selectedSex == "Transgender", isDark),
            _buildGenderCard(context, "Prefer not to say", Icons.lock_outline, Colors.orange, selectedSex == "Prefer not to say", isDark),
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
    final activeBg = const Color(0xFF5E3BFF).withValues(alpha: 0.1);
    final activeBorder = const Color(0xFF5E3BFF);
    final inactiveBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
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
              color: isSelected ? const Color(0xFF5E3BFF) : color,
              size: 16.r,
            ),
            SizedBox(width: 8.w),
            Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isSelected ? const Color(0xFF5E3BFF) : AppColors.textPrimary(context),
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

class CrossFadeState extends StatelessWidget {
  final Widget child;
  const CrossFadeState({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 200),
      child: child,
    );
  }
}
