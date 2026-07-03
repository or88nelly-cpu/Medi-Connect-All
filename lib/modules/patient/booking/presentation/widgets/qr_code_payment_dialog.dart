import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/widgets/buttons/common_button.dart';

class QRCodePaymentDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const QRCodePaymentDialog({
    super.key,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;

    return AlertDialog(
      backgroundColor: cardBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      title: Text(
        AppStrings.upiQrPayment,
        style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold, color: textColor),
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.scanToCompletePay,
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.h),
          Container(
            width: 180.r,
            height: 180.r,
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: Colors.grey[200]!),
            ),
            child: CustomImageView(
              imagePath: '', // fallback to errorWidget which renders standard qr icon
              width: 140.r,
              height: 140.r,
              fit: BoxFit.contain,
              errorWidget: Icon(Icons.qr_code_2_rounded, size: 140.r, color: Colors.black87),
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.security, color: Colors.green, size: 14.r),
              SizedBox(width: 4.w),
              Text(
                AppStrings.secureUpiGateway,
                style: TextStyle(color: Colors.green, fontSize: 10.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        CommonButton(
          text: AppStrings.confirmPaymentBtn,
          color: AppColors.primary,
          onPressed: onConfirm,
        ),
      ],
    );
  }
}
