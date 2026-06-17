import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/dash_board/domain/entities/invoice_entity.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/admin/admin_billing_bloc.dart';

class AdminBillingPage extends StatefulWidget {
  const AdminBillingPage({super.key});

  @override
  State<AdminBillingPage> createState() => _AdminBillingPageState();
}

class _AdminBillingPageState extends State<AdminBillingPage> {
  @override
  void initState() {
    super.initState();
    context.read<AdminBillingBloc>().add(LoadBillingDetails());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminBillingBloc, AdminBillingState>(
      builder: (context, state) {
        if (state is AdminBillingLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is AdminBillingError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.message,
                  style: const TextStyle(color: AppColors.error),
                ),
                SizedBox(height: 12.h),
                ElevatedButton(
                  onPressed: () => context.read<AdminBillingBloc>().add(
                    LoadBillingDetails(),
                  ),
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        }

        if (state is AdminBillingLoaded) {
          final invoices = state.invoices;
          final summary = state.summary;
          final totalRevenue = summary['totalRevenue'] ?? 0.0;
          final pendingBills = summary['pendingBills'] ?? 0.0;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Billing & Invoices",
                  style: AppTextStyles.headingMedium.copyWith(fontSize: 22.sp),
                ),
                SizedBox(height: 16.h),
                // Stats Row
                Row(
                  children: [
                    _buildStatCard(
                      "Total Revenue",
                      "₹ ${totalRevenue.toStringAsFixed(2)}",
                      AppColors.primary,
                    ),
                    SizedBox(width: 12.w),
                    _buildStatCard(
                      "Pending Bills",
                      "₹ ${pendingBills.toStringAsFixed(2)}",
                      AppColors.warning,
                    ),
                  ],
                ),
                SizedBox(height: 24.h),
                Text(
                  "Recent Invoices",
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),
                if (invoices.isEmpty)
                  const Text("No recent invoices found.")
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: invoices.length,
                    itemBuilder: (context, idx) {
                      final inv = invoices[idx];
                      Color statusColor;
                      switch (inv.status) {
                        case 'Paid':
                          statusColor = AppColors.success;
                          break;
                        case 'Pending':
                          statusColor = AppColors.warning;
                          break;
                        default:
                          statusColor = AppColors.error;
                      }

                      // Format date
                      final dateStr =
                          "${inv.date.day}/${inv.date.month}/${inv.date.year}";

                      return Card(
                        margin: EdgeInsets.only(bottom: 12.h),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          side: BorderSide(color: AppColors.border(context)),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12.r),
                          onTap: () => _showInvoiceDetailsDialog(context, inv),
                          child: Padding(
                            padding: EdgeInsets.all(16.r),
                            child: Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.all(10.r),
                                  decoration: BoxDecoration(
                                    color: statusColor.withValues(alpha: 0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.receipt,
                                    color: statusColor,
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        inv.patientName,
                                        style: AppTextStyles.titleMedium
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.sp,
                                            ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        "Invoice: ${inv.id} | ${inv.paymentMethod}",
                                      ),
                                      Text(
                                        dateStr,
                                        style: AppTextStyles.bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "₹ ${inv.amount.toStringAsFixed(2)}",
                                      style: AppTextStyles.titleMedium.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.sp,
                                        color: AppColors.textPrimary(context),
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 6.w,
                                        vertical: 2.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: statusColor.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          4.r,
                                        ),
                                      ),
                                      child: Text(
                                        inv.status,
                                        style: TextStyle(
                                          color: statusColor,
                                          fontSize: 9.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildStatCard(String title, String value, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary(context),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              value,
              style: AppTextStyles.headingMedium.copyWith(
                color: color,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showInvoiceDetailsDialog(BuildContext context, InvoiceEntity invoice) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final statusColor = invoice.status == 'Paid'
        ? AppColors.success
        : (invoice.status == 'Pending' ? AppColors.warning : AppColors.error);
    final formattedDate =
        "${invoice.date.day}/${invoice.date.month}/${invoice.date.year} ${invoice.date.hour.toString().padLeft(2, '0')}:${invoice.date.minute.toString().padLeft(2, '0')}";

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          backgroundColor: isDark ? AppColors.terminalDarkCard : Colors.white,
          child: Container(
            padding: EdgeInsets.all(24.r),
            width: 320.w,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.receipt_long,
                    color: statusColor,
                    size: 36.r,
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  "Transaction Receipt",
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: isDark
                        ? Colors.white
                        : AppColors.textPrimary(context),
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Invoice Review",
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: isDark
                        ? Colors.white54
                        : AppColors.textSecondary(context),
                  ),
                ),
                SizedBox(height: 16.h),
                Divider(color: AppColors.border(context), height: 1),
                SizedBox(height: 16.h),

                _buildReceiptRow("Patient Name", invoice.patientName, isDark),
                _buildReceiptRow(
                  "Invoice ID",
                  invoice.id.length > 8
                      ? invoice.id.substring(0, 8).toUpperCase()
                      : invoice.id.toUpperCase(),
                  isDark,
                ),
                _buildReceiptRow("Date & Time", formattedDate, isDark),
                _buildReceiptRow(
                  "Payment Method",
                  invoice.paymentMethod,
                  isDark,
                ),
                _buildReceiptRow(
                  "Status",
                  invoice.status,
                  isDark,
                  valueColor: statusColor,
                  isBold: true,
                ),

                SizedBox(height: 12.h),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 10.h,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.terminalDarkBg : Colors.grey[50],
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(color: AppColors.border(context)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Paid",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white70
                              : AppColors.textPrimary(context),
                        ),
                      ),
                      Text(
                        "₹ ${invoice.amount.toStringAsFixed(2)}",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: const Text(
                      "Done",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildReceiptRow(
    String label,
    String value,
    bool isDark, {
    Color? valueColor,
    bool isBold = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              color: isDark ? Colors.white54 : AppColors.textSecondary(context),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: valueColor ?? (AppColors.textPrimary(context)),
            ),
          ),
        ],
      ),
    );
  }
}
