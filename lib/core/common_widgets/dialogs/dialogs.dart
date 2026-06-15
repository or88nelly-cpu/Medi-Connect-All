/// Custom reusable feedback dialog widgets.
/// Implements: SuccessDialog, ErrorDialog, ConfirmationDialog.
library;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/buttons/buttons.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

/// Reusable base Dialog widget that styles the background card.
class BaseDialog extends StatelessWidget {
  final Widget child;

  const BaseDialog({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      elevation: 8,
      backgroundColor: Theme.of(context).cardColor,
      child: Padding(padding: EdgeInsets.all(24.r), child: child),
    );
  }
}

/// Dialog displayed on successful business outcomes.
class SuccessDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onConfirm;

  const SuccessDialog({
    super.key,
    this.title = AppStrings.success,
    required this.message,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundColor: AppColors.success.withValues(alpha: 0.1),
            child: Icon(
              Icons.check_circle_outline,
              size: 36.r,
              color: AppColors.success,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            style: AppTextStyles.titleLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          PrimaryButton(
            text: AppStrings.confirm,
            onPressed: () {
              Navigator.of(context).pop();
              onConfirm?.call();
            },
          ),
        ],
      ),
    );
  }
}

/// Dialog displayed when error or validations fail.
class ErrorDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onRetry;

  const ErrorDialog({
    super.key,
    this.title = AppStrings.error,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundColor: AppColors.error.withValues(alpha: 0.1),
            child: Icon(
              Icons.error_outline,
              size: 36.r,
              color: AppColors.error,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            style: AppTextStyles.titleLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              if (onRetry != null) ...[
                Expanded(
                  child: AppOutlinedButton(
                    text: "Retry",
                    onPressed: () {
                      Navigator.of(context).pop();
                      onRetry?.call();
                    },
                  ),
                ),
                SizedBox(width: 12.w),
              ],
              Expanded(
                child: PrimaryButton(
                  text: AppStrings.cancel,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Dialog to confirm destructive actions.
class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const ConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return BaseDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundColor: AppColors.warning.withValues(alpha: 0.1),
            child: Icon(
              Icons.warning_amber_outlined,
              size: 36.r,
              color: AppColors.warning,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            title,
            style: AppTextStyles.titleLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            message,
            style: AppTextStyles.bodyMedium,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: AppOutlinedButton(
                  text: AppStrings.cancel,
                  onPressed: () {
                    Navigator.of(context).pop();
                    onCancel?.call();
                  },
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: PrimaryButton(
                  text: AppStrings.confirm,
                  onPressed: () {
                    Navigator.of(context).pop();
                    onConfirm();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
