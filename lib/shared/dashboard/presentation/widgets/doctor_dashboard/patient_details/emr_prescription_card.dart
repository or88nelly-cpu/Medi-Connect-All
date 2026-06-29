import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/constants/app_assets.dart';

class EmrPrescriptionCard extends StatelessWidget {
  final Map<String, dynamic>? emrRecord;
  final bool isLoading;
  final VoidCallback? onViewAll;
  final VoidCallback? onInvoicePdfPressed;
  final VoidCallback? onShareRxPressed;

  const EmrPrescriptionCard({
    super.key,
    required this.emrRecord,
    required this.isLoading,
    this.onViewAll,
    this.onInvoicePdfPressed,
    this.onShareRxPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? Colors.white : AppColors.textDarkNavy;
    final borderCol = AppColors.border(context);
    final cardBg = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF7FAFD); // Light blue tint matching mockup

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.emrPrescription,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: titleColor,
                fontSize: 16.sp,
              ),
            ),
            GestureDetector(
              onTap: onViewAll,
              child: Row(
                children: [
                  Text(
                    AppStrings.viewAll,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 4.w),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 10.r,
                    color: AppColors.primary,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // Card Content
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: borderCol),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.1 : 0.02),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: isLoading
              ? Container(
                  height: 100.h,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                )
              : emrRecord == null
              ? Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Text(
                      "No EMR Prescription details recorded yet.",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isDark
                            ? Colors.white38
                            : AppColors.textSecondary(context),
                      ),
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 3D Document Icon
                        Image.asset(
                          AppAssets.emrd,
                          width: 48.w,
                          height: 48.h,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.receipt_long_rounded,
                            color: AppColors.primary,
                            size: 40.r,
                          ),
                        ),
                        SizedBox(width: 14.w),

                        // Medicines details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.prescribedMedicines,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.textDarkNavy,
                                ),
                              ),
                              SizedBox(height: 6.h),
                              _buildPrescribedMedicinesList(
                                emrRecord!['medicines']?.toString() ?? '',
                                isDark,
                                context,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 24, thickness: 0.8),

                    // Action buttons
                    Row(
                      children: [
                        // Invoice PDF Button
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: onInvoicePdfPressed,
                            icon: Icon(
                              Icons.receipt_long_outlined,
                              size: 16.r,
                              color: AppColors.primary,
                            ),
                            label: Text(
                              AppStrings.invoicePdf,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.primary),
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),

                        // Share Rx Button
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: onShareRxPressed,
                            icon: Icon(
                              Icons.share_outlined,
                              size: 16.r,
                              color: Colors.white,
                            ),
                            label: Text(
                              AppStrings.shareRx,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: EdgeInsets.symmetric(vertical: 12.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r),
                              ),
                              elevation: 0,
                            ),
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

  Widget _buildPrescribedMedicinesList(
    String medicinesStr,
    bool isDark,
    BuildContext context,
  ) {
    if (medicinesStr.isEmpty) {
      return Text(
        "No medicines prescribed.",
        style: TextStyle(
          color: isDark ? Colors.white30 : AppColors.textSecondary(context),
          fontSize: 12.sp,
        ),
      );
    }

    final list = medicinesStr
        .split('\n')
        .where((m) => m.trim().isNotEmpty)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: list.map((item) {
        String name = item;
        String? details;

        final parenIndex = item.indexOf('(');
        if (parenIndex != -1) {
          name = item.substring(0, parenIndex).trim();
          details = item.substring(parenIndex).trim();
        }

        return Padding(
          padding: EdgeInsets.only(bottom: 6.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white70 : AppColors.textDarkNavy,
                  fontSize: 12.sp,
                ),
              ),
              if (details != null) ...[
                SizedBox(height: 2.h),
                Text(
                  details,
                  style: TextStyle(
                    color: isDark
                        ? Colors.white38
                        : AppColors.textSecondary(context),
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}
