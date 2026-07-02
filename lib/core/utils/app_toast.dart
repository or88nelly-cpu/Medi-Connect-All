import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

enum ToastType { success, error, info }

class AppToast {
  static void show(
    BuildContext context,
    String message, {
    ToastType type = ToastType.success,
  }) {
    final overlayState = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (ctx) => _ToastWidget(
        message: message,
        type: type,
      ),
    );

    overlayState.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }
    });
  }
}

class _ToastWidget extends StatelessWidget {
  final String message;
  final ToastType type;

  const _ToastWidget({
    required this.message,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    Color bgColor;
    IconData icon;

    switch (type) {
      case ToastType.success:
        bgColor = AppColors.success;
        icon = Icons.check_circle_outline;
        break;
      case ToastType.error:
        bgColor = AppColors.error;
        icon = Icons.error_outline;
        break;
      case ToastType.info:
        bgColor = AppColors.primary;
        icon = Icons.info_outline;
        break;
    }

    return Positioned(
      top: 60.h,
      left: 20.w,
      right: 20.w,
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 24.r),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
