import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/widgets/buttons/common_button.dart';

class SuccessActionButtons extends StatelessWidget {
  final VoidCallback onDownloadReceipt;
  final VoidCallback onViewAppointment;

  const SuccessActionButtons({
    super.key,
    required this.onDownloadReceipt,
    required this.onViewAppointment,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CommonButton(
          text: 'Download Receipt',
          isOutline: true,
          width: 160.w,
          height: 44.h,
          borderRadius: 10.r,
          color: AppColors.primary,
          onPressed: onDownloadReceipt,
          icon: Icon(
            Icons.download_rounded,
            color: AppColors.primary,
            size: 14.r,
          ),
        ),
        SizedBox(width: 12.w),
        CommonButton(
          text: 'View Appointment',
          width: 160.w,
          height: 44.h,
          borderRadius: 10.r,
          color: AppColors.primary,
          onPressed: onViewAppointment,
          icon: const Icon(
            Icons.chevron_right_rounded,
            color: AppColors.surface,
          ),
        ),
      ],
    );
  }
}
