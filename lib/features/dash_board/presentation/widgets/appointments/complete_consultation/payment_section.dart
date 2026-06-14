import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'complete_consultation_cubit.dart';
import 'consultation_section_header.dart';

class PaymentSection extends StatelessWidget {
  final TextEditingController feeCtrl;
  final VoidCallback onConfirmPayment;

  const PaymentSection({
    super.key,
    required this.feeCtrl,
    required this.onConfirmPayment,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.watch<CompleteConsultationCubit>();
    final state = cubit.state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ConsultationSectionHeader(
          icon: Icons.receipt_long_outlined,
          title: 'C. Payment & Invoice',
          subtitle: 'Confirm payment details',
          color: AppColors.accent,
        ),
        SizedBox(height: 12.h),

        // Invoice Container
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.05),
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(color: AppColors.primary.withOpacity(0.2)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Invoice Number',
                style: AppTextStyles.bodySmall.copyWith(
                  color: isDark ? Colors.white54 : AppColors.textSecondary,
                ),
              ),
              Text(
                state.invoiceNumber,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.primary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),

        // Fee Input
        Row(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8.r),
                  bottomLeft: Radius.circular(8.r),
                ),
              ),
              child: Text(
                '₹',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: feeCtrl,
                keyboardType: TextInputType.number,
                style: AppTextStyles.titleMedium.copyWith(
                  color: isDark ? Colors.white : AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: 'Consultation fee',
                  filled: true,
                  fillColor: isDark ? AppColors.terminalDarkBg : Colors.grey[50],
                  contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: isDark ? AppColors.terminalDarkBorder : AppColors.border,
                    ),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8.r),
                      bottomRight: Radius.circular(8.r),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: isDark ? AppColors.terminalDarkBorder : AppColors.border,
                    ),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8.r),
                      bottomRight: Radius.circular(8.r),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 14.h),

        Text(
          'Payment Method',
          style: AppTextStyles.bodySmall.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white70 : AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),

        // Cash vs Online Selector Tabs
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => cubit.setPaymentMethod('Cash'),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: state.paymentMethod == 'Cash'
                        ? AppColors.accent.withOpacity(0.15)
                        : (isDark ? AppColors.terminalDarkBg : Colors.grey[100]),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: state.paymentMethod == 'Cash'
                          ? AppColors.accent
                          : (isDark ? AppColors.terminalDarkBorder : AppColors.border),
                      width: state.paymentMethod == 'Cash' ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.money,
                        color: state.paymentMethod == 'Cash'
                            ? AppColors.accent
                            : (isDark ? Colors.white54 : AppColors.textSecondary),
                        size: 28.r,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Cash',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: state.paymentMethod == 'Cash'
                              ? AppColors.accent
                              : (isDark ? Colors.white54 : AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: GestureDetector(
                onTap: () => cubit.setPaymentMethod('Online'),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: EdgeInsets.all(14.r),
                  decoration: BoxDecoration(
                    color: state.paymentMethod == 'Online'
                        ? AppColors.primary.withOpacity(0.12)
                        : (isDark ? AppColors.terminalDarkBg : Colors.grey[100]),
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: state.paymentMethod == 'Online'
                          ? AppColors.primary
                          : (isDark ? AppColors.terminalDarkBorder : AppColors.border),
                      width: state.paymentMethod == 'Online' ? 2 : 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.qr_code_scanner,
                        color: state.paymentMethod == 'Online'
                            ? AppColors.primary
                            : (isDark ? Colors.white54 : AppColors.textSecondary),
                        size: 28.r,
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'Online / QR',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: state.paymentMethod == 'Online'
                              ? AppColors.primary
                              : (isDark ? Colors.white54 : AppColors.textSecondary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),

        // QR Code Container
        if (state.paymentMethod == 'Online') ...[
          SizedBox(height: 16.h),
          Center(
            child: Container(
              width: 200.r,
              height: 200.r,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: AppColors.primary.withOpacity(0.3),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.qr_code_2, size: 120.r, color: Colors.black87),
                  SizedBox(height: 8.h),
                  Text(
                    '₹ ${feeCtrl.text.isEmpty ? '0.00' : feeCtrl.text}',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'Scan to Pay',
                    style: AppTextStyles.bodySmall.copyWith(color: Colors.black45),
                  ),
                ],
              ),
            ),
          ),
        ],
        SizedBox(height: 14.h),

        // Pay & Confirm button or confirmation success box
        if (!state.paymentConfirmed)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onConfirmPayment,
              icon: const Icon(Icons.check_circle, color: Colors.white),
              label: Text(
                'Pay & Confirm  ₹${feeCtrl.text.isEmpty ? '0.00' : feeCtrl.text}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.success,
                padding: EdgeInsets.symmetric(vertical: 14.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
            ),
          )
        else
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.success.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: AppColors.success.withOpacity(0.3)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.check_circle, color: AppColors.success, size: 20),
                SizedBox(width: 8.w),
                Text(
                  'Payment Confirmed!',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
