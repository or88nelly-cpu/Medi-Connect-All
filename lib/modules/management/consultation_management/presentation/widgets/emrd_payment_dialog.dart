import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/core/services/secure_storage_service.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/bloc/emrd_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_billing_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_pharmacy_bloc.dart';

void showEmrdPaymentDialog({
  required BuildContext context,
  required Map<String, dynamic> record,
  required bool isMedicine,
  required double amount,
  required String invoiceNum,
}) {
  showDialog(
    context: context,
    builder: (dialogCtx) {
      String payMethod = 'Cash';
      bool paymentDone = false;

      return StatefulBuilder(
        builder: (stCtx, setDialogState) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          return AlertDialog(
            backgroundColor: isDark ? AppColors.terminalDarkCard : Colors.white,
            title: Text(
              'Payment for ${isMedicine ? "Medicines" : "Lab Tests"}',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Invoice: $invoiceNum', style: AppTextStyles.bodySmall),
                SizedBox(height: 8.h),
                Text(
                  'Total Amount: ₹${amount.toStringAsFixed(2)}',
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                SizedBox(height: 16.h),
                if (!paymentDone) ...[
                  Text(
                    'Select Payment Method:',
                    style: AppTextStyles.bodySmall,
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('Cash'),
                          selected: payMethod == 'Cash',
                          onSelected: (val) {
                            if (val) setDialogState(() => payMethod = 'Cash');
                          },
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: ChoiceChip(
                          label: const Text('Online/QR'),
                          selected: payMethod == 'Online',
                          onSelected: (val) {
                            if (val) {
                              setDialogState(() => payMethod = 'Online');
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  if (payMethod == 'Online') ...[
                    SizedBox(height: 16.h),
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Icon(
                          Icons.qr_code_scanner,
                          size: 100.r,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Center(
                      child: Text(
                        'Scan to Pay ₹${amount.toStringAsFixed(2)}',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 10.sp,
                        ),
                      ),
                    ),
                  ],
                ] else ...[
                  Center(
                    child: Column(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 48,
                        ),
                        SizedBox(height: 8.h),
                        Text(
                          'Payment Confirmed!',
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            actions: [
              if (!paymentDone) ...[
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    setDialogState(() => paymentDone = true);

                    final billingBloc = context.read<AdminBillingBloc>();
                    final pharmacyBloc = context.read<AdminPharmacyBloc>();
                    final emrdBloc = context.read<EmrdBloc>();
                    final messenger = ScaffoldMessenger.of(context);
                    final navigator = Navigator.of(context);

                    await Future.delayed(const Duration(seconds: 1));

                    // 1. Update Supabase
                    try {
                      final supabase = GetIt.I<SupabaseService>().client;
                      final fieldToUpdate = isMedicine
                          ? 'medicine_payment_status'
                          : 'lab_payment_status';
                      await supabase
                          .from('emr_records')
                          .update({
                            fieldToUpdate: 'Paid',
                            'payment_method': payMethod == 'Online'
                                ? 'UPI/QR'
                                : 'Cash',
                          })
                          .eq('appointment_id', record['appointment_id']);

                      if (isMedicine) {
                        // Decrement stock in pharmacy_inventory
                        try {
                          final medicinesText = record['medicines'] as String?;
                          if (medicinesText != null &&
                              medicinesText.trim().isNotEmpty) {
                            final lines = medicinesText.split('\n');
                            for (final line in lines) {
                              if (line.trim().isEmpty) continue;
                              // Parse the medicine name before the first parenthesis
                              String medName = line;
                              if (line.contains('(')) {
                                medName = line.split('(').first.trim();
                              } else {
                                medName = line.trim();
                              }

                              // Fetch the medicine item from database to check current stock and get ID
                              final response = await supabase
                                  .from('pharmacy_inventory')
                                  .select('id, stock')
                                  .ilike('name', '%$medName%')
                                  .limit(1)
                                  .maybeSingle();

                              if (response != null) {
                                final currentStock =
                                    response['stock'] as int? ?? 0;
                                final newStock = (currentStock - 1).clamp(
                                  0,
                                  999999,
                                );
                                await supabase
                                    .from('pharmacy_inventory')
                                    .update({'stock': newStock})
                                    .eq('id', response['id']);
                              }
                            }
                          }
                        } catch (e) {
                          debugPrint(
                            "Failed to update pharmacy stock from EMRD payment: $e",
                          );
                        }
                      }

                      if (context.mounted) {
                        billingBloc.add(
                          RecordInvoice({
                            'patient_name': record['patient_name'],
                            'amount': amount,
                            'status': 'Paid',
                            'payment_method': payMethod == 'Online'
                                ? 'UPI/QR'
                                : 'Cash',
                          }),
                        );
                        if (isMedicine) {
                          pharmacyBloc.add(LoadPharmacyItems());
                        }
                      }
                    } catch (e) {
                      debugPrint("Supabase payment update failed: $e");
                    }

                    // 2. Update Local Storage
                    try {
                      final storage = GetIt.I<SecureStorageService>();
                      final localDataStr = await storage.read('emr_records');
                      if (localDataStr != null) {
                        final List<dynamic> list = jsonDecode(localDataStr);
                        for (final item in list) {
                          if (item['appointment_id'] ==
                              record['appointment_id']) {
                            if (isMedicine) {
                              item['medicine_payment_status'] = 'Paid';
                            } else {
                              item['lab_payment_status'] = 'Paid';
                            }
                            item['payment_method'] = payMethod == 'Online'
                                ? 'UPI/QR'
                                : 'Cash';
                          }
                        }
                        await storage.write('emr_records', jsonEncode(list));
                      }
                    } catch (e) {
                      debugPrint("Local storage payment update failed: $e");
                    }

                    if (context.mounted) {
                      emrdBloc.add(LoadEmrdStats());
                      if (dialogCtx.mounted) {
                        Navigator.pop(dialogCtx);
                      }
                      navigator.pop();

                      messenger.showSnackBar(
                        SnackBar(
                          content: Text(
                            'Payment of ₹${amount.toStringAsFixed(2)} confirmed for ${record['patient_name']}',
                          ),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                  child: const Text(
                    'Confirm Pay',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ] else ...[
                TextButton(
                  onPressed: () => Navigator.pop(dialogCtx),
                  child: const Text('Close'),
                ),
              ],
            ],
          );
        },
      );
    },
  );
}
