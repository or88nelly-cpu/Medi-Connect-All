import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class AdditionalInfoStep extends StatefulWidget {
  final TextEditingController policyIdCtrl;
  final TextEditingController validTillCtrl; // used for policy holder name or valid till
  final String selectedProvider;
  final Function(String) onProviderChanged;

  // Lifestyle
  final String bloodGroup;
  final Function(String) onBloodGroupChanged;
  final String smoking;
  final Function(String) onSmokingChanged;
  final String alcohol;
  final Function(String) onAlcoholChanged;
  final String dietType;
  final Function(String) onDietTypeChanged;
  final String exercise;
  final Function(String) onExerciseChanged;

  // Medical
  final TextEditingController allergiesCtrl;
  final TextEditingController otherDetailsCtrl; // used for medical conditions

  // Emergency Contact
  final TextEditingController emergencyNameCtrl;
  final TextEditingController emergencyPhoneCtrl;
  final String emergencyRelationship;
  final Function(String) onRelationshipChanged;
  final TextEditingController alternatePhoneCtrl;

  const AdditionalInfoStep({
    super.key,
    required this.policyIdCtrl,
    required this.validTillCtrl,
    required this.selectedProvider,
    required this.onProviderChanged,
    required this.bloodGroup,
    required this.onBloodGroupChanged,
    required this.smoking,
    required this.onSmokingChanged,
    required this.alcohol,
    required this.onAlcoholChanged,
    required this.dietType,
    required this.onDietTypeChanged,
    required this.exercise,
    required this.onExerciseChanged,
    required this.allergiesCtrl,
    required this.otherDetailsCtrl,
    required this.emergencyNameCtrl,
    required this.emergencyPhoneCtrl,
    required this.emergencyRelationship,
    required this.onRelationshipChanged,
    required this.alternatePhoneCtrl,
  });

  @override
  State<AdditionalInfoStep> createState() => _AdditionalInfoStepState();
}

class _AdditionalInfoStepState extends State<AdditionalInfoStep> {
  bool _hasInsurance = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Insurance Details Section
        _buildSectionHeader(context, "Insurance Details"),
        SizedBox(height: 12.h),
        _buildCardContainer(
          context,
          isDark,
          child: Column(
            children: [
              // Insurance Toggle Row
              Row(
                children: [
                  Expanded(
                    child: _buildInsuranceToggleCard(
                      context,
                      "I have insurance",
                      "Add your insurance details",
                      Icons.credit_card_outlined,
                      _hasInsurance,
                      () => setState(() => _hasInsurance = true),
                      isDark,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildInsuranceToggleCard(
                      context,
                      "I don't have insurance",
                      "No insurance coverage",
                      Icons.shield_outlined,
                      !_hasInsurance,
                      () => setState(() => _hasInsurance = false),
                      isDark,
                    ),
                  ),
                ],
              ),
              if (_hasInsurance) ...[
                SizedBox(height: 16.h),
                _buildDropdownField(
                  context: context,
                  label: "Insurance Provider",
                  value: widget.selectedProvider,
                  items: [
                    "Star Health Insurance",
                    "LIC Health",
                    "HDFC Ergo",
                    "ICICI Lombard",
                    "Care Health Insurance",
                    "Niva Bupa Health Insurance",
                  ],
                  onChanged: widget.onProviderChanged,
                  icon: Icons.business_outlined,
                  isDark: isDark,
                ),
                SizedBox(height: 16.h),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        context: context,
                        controller: widget.policyIdCtrl,
                        label: "Policy Number",
                        hint: "Enter policy number",
                        icon: Icons.assignment_outlined,
                        isDark: isDark,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: _buildTextField(
                        context: context,
                        controller: widget.validTillCtrl,
                        label: "Policy Holder Name",
                        hint: "Enter policy holder name",
                        icon: Icons.person_outline_rounded,
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: 24.h),

        // Lifestyle Details Section
        _buildSectionHeader(context, "Lifestyle Details"),
        SizedBox(height: 12.h),
        _buildCardContainer(
          context,
          isDark,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownField(
                      context: context,
                      label: "Blood Group",
                      value: widget.bloodGroup,
                      items: ["O+", "O-", "A+", "A-", "B+", "B-", "AB+", "AB-"],
                      onChanged: widget.onBloodGroupChanged,
                      icon: Icons.bloodtype_outlined,
                      isDark: isDark,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildDropdownField(
                      context: context,
                      label: "Smoking",
                      value: widget.smoking,
                      items: ["No", "Yes", "Occasionally"],
                      onChanged: widget.onSmokingChanged,
                      icon: Icons.smoking_rooms_outlined,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: _buildDropdownField(
                      context: context,
                      label: "Alcohol",
                      value: widget.alcohol,
                      items: ["No", "Occasionally", "Frequently"],
                      onChanged: widget.onAlcoholChanged,
                      icon: Icons.local_bar_outlined,
                      isDark: isDark,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildDropdownField(
                      context: context,
                      label: "Physical Activity",
                      value: widget.exercise,
                      items: ["Sedentary", "Moderate", "Active"],
                      onChanged: widget.onExerciseChanged,
                      icon: Icons.directions_run_outlined,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              _buildDropdownField(
                context: context,
                label: "Diet Type",
                value: widget.dietType,
                items: ["Vegetarian", "Non Vegetarian", "Vegan"],
                onChanged: widget.onDietTypeChanged,
                icon: Icons.restaurant_menu_outlined,
                isDark: isDark,
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),

        // Medical Details Section
        _buildSectionHeader(context, "Medical Details"),
        SizedBox(height: 12.h),
        _buildCardContainer(
          context,
          isDark,
          child: Column(
            children: [
              _buildTextField(
                context: context,
                controller: widget.allergiesCtrl,
                label: "Allergies (If any)",
                hint: "e.g. Pollen, Peanuts, Medicines etc.",
                icon: Icons.healing_outlined,
                isDark: isDark,
              ),
              SizedBox(height: 16.h),
              _buildTextField(
                context: context,
                controller: widget.otherDetailsCtrl,
                label: "Existing Medical Conditions (If any)",
                hint: "e.g. Diabetes, Hypertension, Asthma etc.",
                icon: Icons.assignment_late_outlined,
                isDark: isDark,
              ),
            ],
          ),
        ),
        SizedBox(height: 24.h),

        // Emergency Contact Section
        _buildSectionHeader(context, "Emergency Contact"),
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
                      controller: widget.emergencyNameCtrl,
                      label: "Contact Name *",
                      hint: "Enter contact name",
                      icon: Icons.person_outline_rounded,
                      isDark: isDark,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildDropdownField(
                      context: context,
                      label: "Relationship *",
                      value: widget.emergencyRelationship,
                      items: ["Wife", "Husband", "Father", "Mother", "Brother", "Sister", "Friend", "Other"],
                      onChanged: widget.onRelationshipChanged,
                      icon: Icons.people_outline_rounded,
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      context: context,
                      controller: widget.emergencyPhoneCtrl,
                      label: "Mobile Number *",
                      hint: "Enter mobile number",
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      isDark: isDark,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: _buildTextField(
                      context: context,
                      controller: widget.alternatePhoneCtrl,
                      label: "Alternate Number (Optional)",
                      hint: "Enter number",
                      icon: Icons.phone_callback_outlined,
                      keyboardType: TextInputType.phone,
                      isDark: isDark,
                    ),
                  ),
                ],
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

  Widget _buildInsuranceToggleCard(
    BuildContext context,
    String title,
    String desc,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
    bool isDark,
  ) {
    final activeBg = const Color(0xFF5E3BFF).withValues(alpha: 0.1);
    final activeBorder = const Color(0xFF5E3BFF);
    final inactiveBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final inactiveBorder = AppColors.border(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: isSelected ? activeBg : inactiveBg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? activeBorder : inactiveBorder,
            width: isSelected ? 1.5.w : 1.w,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFF5E3BFF) : AppColors.primary,
              size: 20.r,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? const Color(0xFF5E3BFF) : AppColors.textPrimary(context),
                      fontWeight: FontWeight.bold,
                      fontSize: 10.5.sp,
                    ),
                  ),
                  Text(
                    desc,
                    style: TextStyle(
                      color: isDark ? Colors.white30 : Colors.grey.shade500,
                      fontSize: 8.5.sp,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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

  Widget _buildDropdownField({
    required BuildContext context,
    required String label,
    required String value,
    required List<String> items,
    required Function(String) onChanged,
    required IconData icon,
    required bool isDark,
  }) {
    // Safety check to ensure value is present in items list
    final val = items.contains(value) ? value : items.first;

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
        DropdownButtonFormField<String>(
          value: val,
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 11.sp,
            color: AppColors.textPrimary(context),
          ),
          dropdownColor: AppColors.card(context),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: (val) {
            if (val != null) onChanged(val);
          },
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.primary, size: 16.r),
            filled: true,
            fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
            contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
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
}
