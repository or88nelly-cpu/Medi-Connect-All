import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/core/storage/secure_storage_service.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/dash_board/domain/entities/appointment_entity.dart';
import 'package:medi_connect/features/dash_board/data/models/pharmacy_item_model.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/admin/admin_appointments_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/admin/admin_billing_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/admin/admin_pharmacy_bloc.dart';
import 'package:medi_connect/features/patient/presentation/bloc/patient_bloc.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/doctor/doctor_appointments_bloc.dart';

import 'complete_consultation/complete_consultation_cubit.dart';
import 'complete_consultation/consultation_step_view.dart';
import 'complete_consultation/review_step_view.dart';
import 'complete_consultation/payment_step_view.dart';
import 'complete_consultation/success_step_view.dart';

class ConsultationCompleteSheet extends StatefulWidget {
  final AppointmentEntity appointment;
  const ConsultationCompleteSheet({super.key, required this.appointment});

  @override
  State<ConsultationCompleteSheet> createState() =>
      _ConsultationCompleteSheetState();
}

class _ConsultationCompleteSheetState extends State<ConsultationCompleteSheet> {
  final TextEditingController _prescriptionNotesCtrl = TextEditingController();
  final TextEditingController _labNotesCtrl = TextEditingController();
  final TextEditingController _feeCtrl = TextEditingController(text: '500.00');

  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated && authState.user.role == 'doctor') {
      context.read<DoctorAppointmentsBloc>().add(LoadDoctorAppointments());
    } else {
      context.read<AdminAppointmentsBloc>().add(LoadAppointments());
    }
    context.read<AdminPharmacyBloc>().add(LoadPharmacyItems());
    context.read<PatientBloc>().add(LoadPatients());
  }

  @override
  void dispose() {
    _prescriptionNotesCtrl.dispose();
    _labNotesCtrl.dispose();
    _feeCtrl.dispose();
    super.dispose();
  }

  void _confirmPayment(BuildContext context, CompleteConsultationCubit cubit) {
    final amount = double.tryParse(_feeCtrl.text.trim()) ?? 0.0;
    final apt = widget.appointment;
    final patientName = apt.patientName;

    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated && authState.user.role == 'doctor') {
      context.read<DoctorAppointmentsBloc>().add(
        CompleteDoctorAppointment(apt.id),
      );
    } else {
      context.read<AdminAppointmentsBloc>().add(CompleteAppointment(apt.id));
    }

    context.read<AdminBillingBloc>().add(
      RecordInvoice({
        'patient_name': patientName,
        'amount': amount,
        'status': 'Paid',
        'payment_method': cubit.state.paymentMethod == 'Online'
            ? 'UPI/QR'
            : 'Cash',
      }),
    );

    cubit.confirmPaymentSuccess();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Payment of ₹${amount.toStringAsFixed(2)} confirmed for $patientName',
        ),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  List<Map<String, String>> _getMedicineList(
    List<Map<String, dynamic>> medicines,
  ) {
    return medicines
        .map((row) {
          final nameCtrl = row['name'] as TextEditingController;
          final dosageCtrl = row['dosage'] as TextEditingController;
          final freqCtrl = row['frequency'] as TextEditingController;
          final daysCtrl = row['days'] as TextEditingController;
          return {
            'name': nameCtrl.text.trim(),
            'dosage': dosageCtrl.text.trim(),
            'frequency': freqCtrl.text.trim(),
            'days': daysCtrl.text.trim(),
          };
        })
        .where((m) => m['name']!.isNotEmpty)
        .toList();
  }

  Future<void> _submitEMR(
    BuildContext context,
    CompleteConsultationCubit cubit,
  ) async {
    final apt = widget.appointment;
    final state = cubit.state;
    final medicines = _getMedicineList(state.medicines);
    final amount = double.tryParse(_feeCtrl.text.trim()) ?? 0.0;
    final paymentMethodStr = state.paymentMethod == 'Online'
        ? 'UPI/QR'
        : 'Cash';
    final recordedAtStr = DateTime.now().toIso8601String();

    double medicineAmount = 0.0;
    for (final row in state.medicines) {
      final nameCtrl = row['name'] as TextEditingController;
      if (nameCtrl.text.trim().isNotEmpty) {
        final price = row['sell_price'] as double? ?? 150.0;
        final freqStr =
            (row['frequency'] as TextEditingController?)?.text.trim() ?? '';
        final daysStr =
            (row['days'] as TextEditingController?)?.text.trim() ?? '';
        int days = int.tryParse(daysStr) ?? 7;
        double dailyCount = 0.0;
        if (freqStr.contains('-')) {
          final parts = freqStr.split('-');
          double sum = 0.0;
          for (final part in parts) {
            sum += double.tryParse(part.trim()) ?? 0.0;
          }
          dailyCount = sum;
        } else {
          dailyCount = double.tryParse(freqStr) ?? 1.0;
        }
        double totalPills = dailyCount * days;
        double rowCost = (totalPills / 10.0) * price;
        medicineAmount += rowCost;
      }
    }
    final double labAmount = state.selectedTests.length * 250.0;

    final medicinePaymentStatus = medicines.isEmpty ? 'Paid' : 'Pending';
    final labPaymentStatus = state.selectedTests.isEmpty ? 'Paid' : 'Pending';

    final suffix = state.invoiceNumber.contains('-')
        ? state.invoiceNumber.split('-').last
        : DateTime.now().millisecondsSinceEpoch.toString().substring(8);

    final emrRecordData = {
      'patient_id': apt.patientId,
      'patient_name': apt.patientName,
      'doctor_id': apt.doctorId,
      'doctor_name': apt.doctorName,
      'specialty': apt.specialty,
      'appointment_id': apt.id,
      'medicines': medicines
          .map(
            (m) =>
                '${m['name']} (${m['dosage']}, ${m['frequency']}, ${m['days']} Days)',
          )
          .join('\n'),
      'lab_tests': state.selectedTests.join(', '),
      'prescription_notes': _prescriptionNotesCtrl.text.trim(),
      'invoice_number': state.invoiceNumber,
      'amount': amount,
      'payment_method': paymentMethodStr,
      'medicine_payment_status': medicinePaymentStatus,
      'lab_payment_status': labPaymentStatus,
      'medicine_amount': medicineAmount,
      'lab_amount': labAmount,
      'medicine_invoice_number': medicines.isEmpty ? '' : 'MED-$suffix',
      'lab_invoice_number': state.selectedTests.isEmpty ? '' : 'LAB-$suffix',
      'recorded_at': recordedAtStr,
    };

    bool savedToSupabase = false;
    try {
      final supabase = GetIt.I<SupabaseService>().client;
      await supabase.from('emr_records').insert(emrRecordData);
      savedToSupabase = true;

      // Deduct stock
      final pharmacyState = context.read<AdminPharmacyBloc>().state;
      if (pharmacyState is AdminPharmacyLoaded) {
        final pharmacyItems = pharmacyState.items;
        for (final med in medicines) {
          final name = med['name']!.toLowerCase();
          final match = pharmacyItems.firstWhere(
            (item) => item.name.toLowerCase() == name,
            orElse: () => const PharmacyItemModel(
              id: '',
              name: '',
              stock: 0,
              category: '',
              status: '',
            ),
          );
          if (match.id.isNotEmpty && match.stock > 0) {
            final days = int.tryParse(med['days'] ?? '7') ?? 7;
            final freqStr = med['frequency'] ?? '';
            double dailyCount = 0.0;
            if (freqStr.contains('-')) {
              final parts = freqStr.split('-');
              double sum = 0.0;
              for (final part in parts) {
                sum += double.tryParse(part.trim()) ?? 0.0;
              }
              dailyCount = sum;
            } else {
              dailyCount = double.tryParse(freqStr) ?? 1.0;
            }
            final int stripsToDeduct = (dailyCount * days / 10.0).ceil().clamp(
              1,
              999,
            );
            final newStock = (match.stock - stripsToDeduct).clamp(0, 999999);
            context.read<AdminPharmacyBloc>().add(
              UpdatePharmacyItemStock(match.id, newStock),
            );
          }
        }
      }
    } catch (e) {
      debugPrint("Supabase EMR insert or stock reduction failed: $e");
    }

    try {
      final storage = GetIt.I<SecureStorageService>();
      final localDataStr = await storage.read('emr_records');
      List<dynamic> list = [];
      if (localDataStr != null) {
        list = jsonDecode(localDataStr);
      }
      final localRecord = Map<String, dynamic>.from(emrRecordData);
      localRecord['id'] ??= DateTime.now().millisecondsSinceEpoch.toString();
      list.add(localRecord);
      await storage.write('emr_records', jsonEncode(list));
    } catch (e) {
      debugPrint("Local EMR storage write failed: $e");
    }

    cubit.submitEMRSuccess();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'EMR record submitted for ${apt.patientName} ${savedToSupabase ? "(Sync'd)" : "(Local)"}',
        ),
        backgroundColor: AppColors.secondary,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // Clean double doctor title prefixes
  String _cleanDoctorName(String name) {
    if (name.toLowerCase().startsWith('dr. dr.')) {
      return name.substring(7).trim();
    }
    if (name.toLowerCase().startsWith('dr. dr')) {
      return name.substring(6).trim();
    }
    if (name.toLowerCase().startsWith('dr.')) {
      return name.substring(3).trim();
    }
    if (name.toLowerCase().startsWith('dr')) {
      return name.substring(2).trim();
    }
    return name;
  }

  Widget _buildStepIndicator(int currentStep, bool isDark) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStepCircle(
            1,
            'Consultation',
            currentStep == 1,
            currentStep > 1,
            isDark,
          ),
          _buildStepLine(currentStep > 1, isDark),
          _buildStepCircle(
            2,
            'Review',
            currentStep == 2,
            currentStep > 2,
            isDark,
          ),
          _buildStepLine(currentStep > 2, isDark),
          _buildStepCircle(3, 'Payment', currentStep == 3, false, isDark),
        ],
      ),
    );
  }

  Widget _buildStepCircle(
    int step,
    String label,
    bool isActive,
    bool isCompleted,
    bool isDark,
  ) {
    final activeColor = AppColors.primary;
    final completedColor = AppColors.success;
    final inactiveColor = isDark ? Colors.white24 : Colors.grey[300]!;

    Color circleBg = inactiveColor;
    Color borderCol = inactiveColor;
    Color textCol = isDark ? Colors.white38 : Colors.grey[600]!;
    Widget child = Text(
      step.toString(),
      style: TextStyle(
        fontSize: 12.sp,
        fontWeight: FontWeight.bold,
        color: isDark ? Colors.white70 : Colors.grey[700],
      ),
    );

    if (isActive) {
      circleBg = activeColor.withValues(alpha: 0.12);
      borderCol = activeColor;
      textCol = activeColor;
      child = Text(
        step.toString(),
        style: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: activeColor,
        ),
      );
    } else if (isCompleted) {
      circleBg = completedColor;
      borderCol = completedColor;
      textCol = completedColor;
      child = const Icon(Icons.check, color: Colors.white, size: 12);
    }

    return Column(
      children: [
        Container(
          width: 24.r,
          height: 24.r,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: circleBg,
            shape: BoxShape.circle,
            border: Border.all(color: borderCol, width: isActive ? 2 : 1),
          ),
          child: child,
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: textCol,
          ),
        ),
      ],
    );
  }

  Widget _buildStepLine(bool isCompleted, bool isDark) {
    return Container(
      width: 60.w,
      height: 2.h,
      margin: EdgeInsets.only(bottom: 14.h, left: 4.w, right: 4.w),
      color: isCompleted
          ? AppColors.success
          : (isDark ? Colors.white12 : Colors.grey[200]),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final apt = widget.appointment;
    final sheetBg = isDark ? AppColors.terminalDarkCard : Colors.white;
    final cleanDocName = _cleanDoctorName(apt.doctorName);

    return BlocProvider(
      create: (context) => CompleteConsultationCubit(),
      child: BlocConsumer<CompleteConsultationCubit, CompleteConsultationState>(
        listener: (context, state) {
          final feeStr = state.totalFee.toStringAsFixed(2);
          if (_feeCtrl.text != feeStr) {
            _feeCtrl.text = feeStr;
          }
        },
        builder: (context, state) {
          final cubit = context.read<CompleteConsultationCubit>();
          final currentStep = state.currentStep;
          final emrSubmitted = state.emrSubmitted;

          return DraggableScrollableSheet(
            initialChildSize: 0.92,
            minChildSize: 0.5,
            maxChildSize: 0.97,
            builder: (ctx, scrollCtrl) {
              return Container(
                decoration: BoxDecoration(
                  color: sheetBg,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
                child: Column(
                  children: [
                    // Header Area
                    Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
                      child: Column(
                        children: [
                          Center(
                            child: Container(
                              width: 40.w,
                              height: 4.h,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white24
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    emrSubmitted
                                        ? 'Consultation Completed'
                                        : 'Complete Consultation',
                                    style: AppTextStyles.titleLarge.copyWith(
                                      color: isDark
                                          ? Colors.white
                                          : AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    'Patient: ${apt.patientName} · Dr. $cleanDocName',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: isDark
                                          ? Colors.white54
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Icon(
                                  Icons.close,
                                  color: isDark
                                      ? Colors.white54
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                          // Render Step Progress Indicator if EMR is not yet submitted successfully
                          if (!emrSubmitted) ...[
                            const Divider(),
                            _buildStepIndicator(currentStep, isDark),
                          ],
                          const Divider(),
                        ],
                      ),
                    ),

                    // Scrollable Body
                    Expanded(
                      child: ListView(
                        controller: scrollCtrl,
                        padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 20.h),
                        children: [
                          if (emrSubmitted)
                            SuccessStepView(
                              appointment: apt,
                              onViewInvoice: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Generating PDF invoice: ${state.invoiceNumber}...',
                                    ),
                                    backgroundColor: AppColors.primary,
                                  ),
                                );
                              },
                              onBackToAppointments: () =>
                                  Navigator.pop(context),
                            )
                          else if (currentStep == 1)
                            ConsultationStepView(
                              prescriptionNotesCtrl: _prescriptionNotesCtrl,
                              labNotesCtrl: _labNotesCtrl,
                            )
                          else if (currentStep == 2)
                            ReviewStepView(
                              appointment: apt,
                              prescriptionNotesCtrl: _prescriptionNotesCtrl,
                            )
                          else if (currentStep == 3)
                            PaymentStepView(
                              appointment: apt,
                              feeCtrl: _feeCtrl,
                              prescriptionNotesCtrl: _prescriptionNotesCtrl,
                              onConfirmPayment: () =>
                                  _confirmPayment(context, cubit),
                              onSubmitEMR: () => _submitEMR(context, cubit),
                            ),
                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),

                    // Bottom Wizard Controls (only visible if EMR is not submitted)
                    if (!emrSubmitted)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 20.w,
                          vertical: 12.h,
                        ),
                        decoration: BoxDecoration(
                          color: sheetBg,
                          border: Border(
                            top: BorderSide(
                              color: isDark
                                  ? AppColors.terminalDarkBorder
                                  : AppColors.border,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (currentStep == 1) ...[
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => Navigator.pop(context),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: isDark
                                        ? Colors.white70
                                        : AppColors.textSecondary,
                                    side: BorderSide(
                                      color: isDark
                                          ? Colors.white24
                                          : AppColors.border,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 14.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => cubit.nextStep(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 14.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Next',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 6.w),
                                      const Icon(Icons.arrow_forward, size: 16),
                                    ],
                                  ),
                                ),
                              ),
                            ] else if (currentStep == 2) ...[
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => cubit.previousStep(),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: isDark
                                        ? Colors.white70
                                        : AppColors.textSecondary,
                                    side: BorderSide(
                                      color: isDark
                                          ? Colors.white24
                                          : AppColors.border,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 14.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                  child: const Text(
                                    'Back',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () => cubit.nextStep(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primary,
                                    foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 14.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Proceed to Payment',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 6.w),
                                      const Icon(Icons.arrow_forward, size: 16),
                                    ],
                                  ),
                                ),
                              ),
                            ] else if (currentStep == 3) ...[
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => cubit.previousStep(),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: isDark
                                        ? Colors.white70
                                        : AppColors.textSecondary,
                                    side: BorderSide(
                                      color: isDark
                                          ? Colors.white24
                                          : AppColors.border,
                                    ),
                                    padding: EdgeInsets.symmetric(
                                      vertical: 14.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                  ),
                                  child: const Text(
                                    'Back',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              // Note: No Next button in step 3 as the actions are inline ("Pay & Confirm" and "Submit to EMR").
                            ],
                          ],
                        ),
                      ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
