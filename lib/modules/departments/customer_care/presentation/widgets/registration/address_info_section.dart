import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/common_widgets/text_fields/text_fields.dart';

class AddressInfoSection extends StatelessWidget {
  final TextEditingController pincodeCtrl;
  final TextEditingController placeCtrl;
  final TextEditingController wardCtrl;
  final String fetchedAddress;
  final bool isFetchingAddress;
  final Function(String) onFetchAddress;
  final VoidCallback onFieldsChanged;

  const AddressInfoSection({
    super.key,
    required this.pincodeCtrl,
    required this.placeCtrl,
    required this.wardCtrl,
    required this.fetchedAddress,
    required this.isFetchingAddress,
    required this.onFetchAddress,
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

    final addressCardBg = isDark
        ? AppColors.primary.withValues(alpha: 0.08)
        : AppColors.primary.withValues(alpha: 0.04);
    final addressBorderColor = isDark
        ? AppColors.primary.withValues(alpha: 0.3)
        : AppColors.primary.withValues(alpha: 0.15);
    final addressTextColor = isDark
        ? const Color(0xFF90B9FF)
        : const Color(0xFF0D54B7);

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
                Icons.location_on_outlined,
                color: AppColors.primary,
                size: 22.r,
              ),
              SizedBox(width: 10.w),
              Text(
                "Address Information",
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
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Pincode Input
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildLabel("Pincode *", labelColor),
                    AppTextField(
                      controller: pincodeCtrl,
                      labelText: "Enter pincode",
                      hintText: "560001",
                      keyboardType: TextInputType.number,
                      onTap: onFieldsChanged,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w),

              // Fetch Button
              Container(
                height: 52.h,
                margin: EdgeInsets.only(bottom: 0.h),
                child: ElevatedButton(
                  onPressed: isFetchingAddress
                      ? null
                      : () {
                          if (pincodeCtrl.text.isNotEmpty) {
                            onFetchAddress(pincodeCtrl.text);
                          }
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: isFetchingAddress
                      ? SizedBox(
                          width: 20.r,
                          height: 20.r,
                          child: const CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : Text(
                          "Fetch Address",
                          style: AppTextStyles.buttonMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              SizedBox(width: 16.w),

              // Place / Area Input
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _buildLabel("Place / Area *", labelColor),
                    AppTextField(
                      controller: placeCtrl,
                      labelText: "Enter place/area",
                      hintText: "MG Road",
                      onTap: onFieldsChanged,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 16.w),

              // Ward No Input
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildLabel("Ward No. (Optional)", labelColor),
                    AppTextField(
                      controller: wardCtrl,
                      labelText: "Enter ward number",
                      hintText: "12",
                      keyboardType: TextInputType.number,
                      onTap: onFieldsChanged,
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Auto fetched address display block
          if (fetchedAddress.isNotEmpty) ...[
            SizedBox(height: 20.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: addressCardBg,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: addressBorderColor, width: 1.w),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Address (Auto Fetched)",
                    style: AppTextStyles.bodySmall.copyWith(
                      color: addressTextColor.withValues(alpha: 0.7),
                      fontWeight: FontWeight.bold,
                      fontSize: 10.sp,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    fetchedAddress,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: addressTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
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
}
