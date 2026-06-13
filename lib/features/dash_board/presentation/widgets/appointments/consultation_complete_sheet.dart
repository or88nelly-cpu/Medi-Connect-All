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
import 'package:medi_connect/features/dash_board/domain/entities/pharmacy_item_entity.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/admin_appointments_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/admin_billing_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/admin_pharmacy_bloc.dart';

class ConsultationCompleteSheet extends StatefulWidget {
  final AppointmentEntity appointment;
  const ConsultationCompleteSheet({super.key, required this.appointment});

  @override
  State<ConsultationCompleteSheet> createState() =>
      _ConsultationCompleteSheetState();
}

class _ConsultationCompleteSheetState
    extends State<ConsultationCompleteSheet> {
  // ── Section A: Prescription ──────────────────────────────────────────────
  final TextEditingController _prescriptionNotesCtrl = TextEditingController();
  final List<Map<String, dynamic>> _medicines = [];

  // ── Section B: Lab Tests ─────────────────────────────────────────────────
  final List<String> _availableTests = [
    'CBC (Blood Count)',
    'Blood Sugar (Fasting)',
    'Blood Sugar (PP)',
    'Lipid Profile',
    'HbA1c',
    'Thyroid Panel (T3/T4/TSH)',
    'Kidney Function Test',
    'Liver Function Test',
    'Urine Routine',
    'X-Ray Chest',
    'ECG',
    'Ultrasound Abdomen',
    'MRI Brain',
    'CT Scan',
    'Echocardiography',
  ];
  final List<String> _selectedTests = [];
  final TextEditingController _labNotesCtrl = TextEditingController();

  // ── Section C: Payment ───────────────────────────────────────────────────
  final TextEditingController _feeCtrl =
      TextEditingController(text: '500.00');
  String _paymentMethod = 'Cash'; // 'Cash' or 'Online'
  bool _paymentConfirmed = false;
  String _invoiceNumber = '';

  // ── UI state ─────────────────────────────────────────────────────────────
  bool _emrSubmitted = false;

  @override
  void initState() {
    super.initState();
    _addMedicineRow();
    final now = DateTime.now();
    _invoiceNumber =
        'INV-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${(now.millisecondsSinceEpoch % 10000).toString().padLeft(4, '0')}';
    context.read<AdminPharmacyBloc>().add(LoadPharmacyItems());
  }

  @override
  void dispose() {
    _prescriptionNotesCtrl.dispose();
    _labNotesCtrl.dispose();
    _feeCtrl.dispose();
    for (final row in _medicines) {
      (row['name'] as TextEditingController?)?.dispose();
      (row['dosage'] as TextEditingController?)?.dispose();
      (row['frequency'] as TextEditingController?)?.dispose();
      (row['focusNode'] as FocusNode?)?.dispose();
    }
    super.dispose();
  }

  void _addMedicineRow() {
    final nameCtrl = TextEditingController();
    nameCtrl.addListener(_updateTotalFee);
    final daysCtrl = TextEditingController(text: '7');
    daysCtrl.addListener(_updateTotalFee);
    final freqCtrl = TextEditingController(text: '1-0-1');
    freqCtrl.addListener(_updateTotalFee);
    setState(() {
      _medicines.add({
        'name': nameCtrl,
        'dosage': TextEditingController(),
        'frequency': freqCtrl,
        'days': daysCtrl,
        'focusNode': FocusNode(),
        'sell_price': 150.0,
      });
    });
  }

  void _removeMedicineRow(int index) {
    final row = _medicines[index];
    (row['name'] as TextEditingController?)?.removeListener(_updateTotalFee);
    (row['days'] as TextEditingController?)?.removeListener(_updateTotalFee);
    (row['frequency'] as TextEditingController?)?.removeListener(_updateTotalFee);
    (row['name'] as TextEditingController?)?.dispose();
    (row['dosage'] as TextEditingController?)?.dispose();
    (row['frequency'] as TextEditingController?)?.dispose();
    (row['days'] as TextEditingController?)?.dispose();
    (row['focusNode'] as FocusNode?)?.dispose();
    setState(() {
      _medicines.removeAt(index);
    });
    _updateTotalFee();
  }

  List<Map<String, String>> _getMedicineList() {
    return _medicines.map((row) {
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
    }).where((m) => m['name']!.isNotEmpty).toList();
  }

  void _updateTotalFee() {
    if (!mounted) return;
    final state = context.read<AdminPharmacyBloc>().state;
    List<PharmacyItemEntity> pharmacyItems = [];
    if (state is AdminPharmacyLoaded) {
      pharmacyItems = state.items;
    }
    double consultationFee = 500.00;
    double medicineTotal = 0.0;
    for (final row in _medicines) {
      final nameCtrl = row['name'] as TextEditingController;
      final name = nameCtrl.text.trim().toLowerCase();
      if (name.isNotEmpty) {
        double price = 150.0;
        if (pharmacyItems.isNotEmpty) {
          final match = pharmacyItems.firstWhere(
            (item) => item.name.toLowerCase() == name,
            orElse: () => const PharmacyItemEntity(
              id: '', name: '', stock: 0, category: '', status: '',
              buyPrice: 0.0, sellPrice: -1.0, dosage: '',
            ),
          );
          if (match.sellPrice >= 0) {
            price = match.sellPrice;
            row['sell_price'] = price;
          } else {
            price = row['sell_price'] as double? ?? 150.0;
          }
        } else {
          price = row['sell_price'] as double? ?? 150.0;
        }

        final freqCtrl = row['frequency'] as TextEditingController?;
        final daysCtrl = row['days'] as TextEditingController?;
        final freqStr = freqCtrl?.text.trim() ?? '';
        final daysStr = daysCtrl?.text.trim() ?? '';

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
        medicineTotal += rowCost;
      }
    }
    double labTotal = _selectedTests.length * 250.0;
    double total = consultationFee + medicineTotal + labTotal;
    
    final totalStr = total.toStringAsFixed(2);
    if (_feeCtrl.text != totalStr) {
      _feeCtrl.text = totalStr;
    }
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  void _confirmPayment(BuildContext context) {
    final amount = double.tryParse(_feeCtrl.text.trim()) ?? 0.0;
    final apt = widget.appointment;
    final patientName = apt.patientName;

    context.read<AdminAppointmentsBloc>().add(CompleteAppointment(apt.id));

    context.read<AdminBillingBloc>().add(RecordInvoice({
          'patient_name': patientName,
          'amount': amount,
          'status': 'Paid',
          'payment_method': _paymentMethod == 'Online' ? 'UPI/QR' : 'Cash',
        }));

    setState(() => _paymentConfirmed = true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Payment of ₹${amount.toStringAsFixed(2)} confirmed for $patientName'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _submitEMR(BuildContext context) async {
    final apt = widget.appointment;
    final medicines = _getMedicineList();
    final amount = double.tryParse(_feeCtrl.text.trim()) ?? 0.0;
    final paymentMethodStr = _paymentMethod == 'Online' ? 'UPI/QR' : 'Cash';
    final recordedAtStr = DateTime.now().toIso8601String();

    double medicineAmount = 0.0;
    for (final row in _medicines) {
      final nameCtrl = row['name'] as TextEditingController;
      if (nameCtrl.text.trim().isNotEmpty) {
        final price = row['sell_price'] as double? ?? 150.0;
        final freqStr = (row['frequency'] as TextEditingController?)?.text.trim() ?? '';
        final daysStr = (row['days'] as TextEditingController?)?.text.trim() ?? '';
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
    final double labAmount = _selectedTests.length * 250.0;

    final medicinePaymentStatus = medicines.isEmpty ? 'Paid' : 'Pending';
    final labPaymentStatus = _selectedTests.isEmpty ? 'Paid' : 'Pending';

    final suffix = _invoiceNumber.contains('-') ? _invoiceNumber.split('-').last : DateTime.now().millisecondsSinceEpoch.toString().substring(8);

    final emrRecordData = {
      'patient_id': apt.patientId,
      'patient_name': apt.patientName,
      'doctor_id': apt.doctorId,
      'doctor_name': apt.doctorName,
      'specialty': apt.specialty,
      'appointment_id': apt.id,
      'medicines': medicines.map((m) => '${m['name']} (${m['dosage']}, ${m['frequency']}, ${m['days']} Days)').join('\n'),
      'lab_tests': _selectedTests.join(', '),
      'prescription_notes': _prescriptionNotesCtrl.text.trim(),
      'invoice_number': _invoiceNumber,
      'amount': amount,
      'payment_method': paymentMethodStr,
      'medicine_payment_status': medicinePaymentStatus,
      'lab_payment_status': labPaymentStatus,
      'medicine_amount': medicineAmount,
      'lab_amount': labAmount,
      'medicine_invoice_number': medicines.isEmpty ? '' : 'MED-$suffix',
      'lab_invoice_number': _selectedTests.isEmpty ? '' : 'LAB-$suffix',
      'recorded_at': recordedAtStr,
    };

    // Attempt to save to emr_records table in Supabase
    bool savedToSupabase = false;
    try {
      final supabase = GetIt.I<SupabaseService>().client;
      await supabase.from('emr_records').insert(emrRecordData);
      savedToSupabase = true;

      // Deduct stock for each prescribed medicine
      final state = context.read<AdminPharmacyBloc>().state;
      if (state is AdminPharmacyLoaded) {
        final pharmacyItems = state.items;
        for (final med in medicines) {
          final name = med['name']!.toLowerCase();
          final match = pharmacyItems.firstWhere(
            (item) => item.name.toLowerCase() == name,
            orElse: () => const PharmacyItemEntity(
              id: '', name: '', stock: 0, category: '', status: '',
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
            final int stripsToDeduct = (dailyCount * days / 10.0).ceil().clamp(1, 999);
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

    // Always save to local storage as a reliable fallback/copy
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

    setState(() => _emrSubmitted = true);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('EMR record submitted for ${apt.patientName} ${savedToSupabase ? "(Sync'd)" : "(Local)"}'),
          backgroundColor: AppColors.secondary,
          duration: const Duration(seconds: 3),
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final apt = widget.appointment;
    final sheetBg =
        isDark ? AppColors.terminalDarkCard : Colors.white;

    return BlocBuilder<AdminPharmacyBloc, AdminPharmacyState>(
      builder: (context, pharmacyState) {
        List<PharmacyItemEntity> pharmacyItems = [];
        if (pharmacyState is AdminPharmacyLoaded) {
          pharmacyItems = pharmacyState.items;
        }

        return DraggableScrollableSheet(
          initialChildSize: 0.92,
          minChildSize: 0.5,
          maxChildSize: 0.97,
          builder: (ctx, scrollCtrl) {
            return Container(
              decoration: BoxDecoration(
                color: sheetBg,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
                    child: Column(
                      children: [
                        Center(
                          child: Container(
                            width: 40.w,
                            height: 4.h,
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white24 : Colors.grey[300],
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
                                  'Complete Consultation',
                                  style: AppTextStyles.titleLarge.copyWith(
                                    color:
                                        isDark ? Colors.white : AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'Patient: ${apt.patientName} · Dr. ${apt.doctorName}',
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
                              icon: Icon(Icons.close,
                                  color: isDark
                                      ? Colors.white54
                                      : AppColors.textSecondary),
                            ),
                          ],
                        ),
                        const Divider(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView(
                      controller: scrollCtrl,
                      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                      children: [
                        _buildSectionHeader(
                          Icons.description_outlined,
                          'A. Prescription',
                          'Add medicines and notes',
                          isDark,
                          color: AppColors.primary,
                        ),
                        SizedBox(height: 10.h),
                        ...List.generate(_medicines.length, (i) {
                          final row = _medicines[i];
                          return Container(
                            margin: EdgeInsets.only(bottom: 10.h),
                            padding: EdgeInsets.all(12.r),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.terminalDarkBg
                                  : Colors.grey[50],
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.terminalDarkBorder
                                    : AppColors.border,
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: RawAutocomplete<PharmacyItemEntity>(
                                        textEditingController: row['name'] as TextEditingController,
                                        focusNode: row['focusNode'] as FocusNode,
                                        optionsBuilder: (TextEditingValue textEditingValue) {
                                          if (textEditingValue.text.isEmpty) {
                                            return const Iterable<PharmacyItemEntity>.empty();
                                          }
                                          return pharmacyItems.where((PharmacyItemEntity option) {
                                            return option.name
                                                .toLowerCase()
                                                .contains(textEditingValue.text.toLowerCase());
                                          });
                                        },
                                        displayStringForOption: (PharmacyItemEntity option) => option.name,
                                        fieldViewBuilder: (BuildContext context,
                                            TextEditingController fieldTextEditingController,
                                            FocusNode fieldFocusNode,
                                            VoidCallback onFieldSubmitted) {
                                          return TextField(
                                            controller: fieldTextEditingController,
                                            focusNode: fieldFocusNode,
                                            style: TextStyle(
                                                color: isDark ? Colors.white : AppColors.textPrimary,
                                                fontSize: 13.sp),
                                            decoration: InputDecoration(
                                              hintText: 'Medicine name',
                                              hintStyle: TextStyle(
                                                  color: isDark ? Colors.white38 : AppColors.textSecondary,
                                                  fontSize: 12.sp),
                                              filled: true,
                                              fillColor: isDark ? AppColors.terminalDarkBg : Colors.grey[50],
                                              contentPadding:
                                                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                                              enabledBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8.r),
                                                borderSide: BorderSide(
                                                    color: isDark ? AppColors.terminalDarkBorder : AppColors.border),
                                              ),
                                              focusedBorder: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(8.r),
                                                borderSide:
                                                    const BorderSide(color: AppColors.primary, width: 1.5),
                                              ),
                                            ),
                                          );
                                        },
                                        optionsViewBuilder: (BuildContext context,
                                            AutocompleteOnSelected<PharmacyItemEntity> onSelected,
                                            Iterable<PharmacyItemEntity> options) {
                                          return Align(
                                            alignment: Alignment.topLeft,
                                            child: Material(
                                              elevation: 4.0,
                                              color: isDark ? AppColors.terminalDarkCard : Colors.white,
                                              borderRadius: BorderRadius.circular(8.r),
                                              child: Container(
                                                width: 250.w,
                                                constraints: BoxConstraints(maxHeight: 200.h),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                    color: isDark ? AppColors.terminalDarkBorder : AppColors.border,
                                                  ),
                                                  borderRadius: BorderRadius.circular(8.r),
                                                ),
                                                child: ListView.builder(
                                                  padding: EdgeInsets.zero,
                                                  shrinkWrap: true,
                                                  itemCount: options.length,
                                                  itemBuilder: (BuildContext context, int index) {
                                                    final PharmacyItemEntity option = options.elementAt(index);
                                                    return InkWell(
                                                      onTap: () => onSelected(option),
                                                      child: Container(
                                                        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                                                        decoration: BoxDecoration(
                                                          border: Border(
                                                            bottom: BorderSide(
                                                              color: isDark
                                                                  ? AppColors.terminalDarkBorder.withOpacity(0.5)
                                                                  : AppColors.border.withOpacity(0.5),
                                                            ),
                                                          ),
                                                        ),
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  Text(
                                                                    option.name,
                                                                    style: TextStyle(
                                                                      fontWeight: FontWeight.bold,
                                                                      color: isDark ? Colors.white : AppColors.textPrimary,
                                                                      fontSize: 12.sp,
                                                                    ),
                                                                  ),
                                                                  if (option.dosage.isNotEmpty) ...[
                                                                    SizedBox(height: 2.h),
                                                                    Text(
                                                                      'Dosage: ${option.dosage}',
                                                                      style: TextStyle(
                                                                        color: isDark ? Colors.white38 : AppColors.textSecondary,
                                                                        fontSize: 10.sp,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ],
                                                              ),
                                                            ),
                                                            Text(
                                                              '₹${option.sellPrice}',
                                                              style: TextStyle(
                                                                fontWeight: FontWeight.bold,
                                                                color: AppColors.primary,
                                                                fontSize: 11.sp,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                        onSelected: (PharmacyItemEntity selection) {
                                          setState(() {
                                            (row['dosage'] as TextEditingController).text = selection.dosage;
                                            row['sell_price'] = selection.sellPrice;
                                          });
                                          _updateTotalFee();
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      flex: 2,
                                      child: _buildTextField(
                                          row['dosage']!, 'Dosage (e.g. 500mg)',
                                          isDark),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 8.h),
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: _buildTextField(
                                          row['frequency']!,
                                          'Frequency (e.g. 1-0-1)',
                                          isDark),
                                    ),
                                    SizedBox(width: 8.w),
                                    Expanded(
                                      flex: 1,
                                      child: _buildTextField(
                                          row['days']!,
                                          'Days (e.g. 7)',
                                          isDark,
                                          keyboardType: TextInputType.number),
                                    ),
                                    SizedBox(width: 8.w),
                                    IconButton(
                                      onPressed: _medicines.length > 1
                                          ? () => _removeMedicineRow(i)
                                          : null,
                                      icon: Icon(Icons.delete_outline,
                                          color: _medicines.length > 1
                                              ? AppColors.error
                                              : Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                        OutlinedButton.icon(
                          onPressed: _addMedicineRow,
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('Add Medicine'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.r)),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        _buildTextField(
                            _prescriptionNotesCtrl,
                            'Prescription notes / doctor remarks...',
                            isDark,
                            maxLines: 3),
                        SizedBox(height: 24.h),
                        _buildSectionHeader(
                          Icons.science_outlined,
                          'B. Lab Tests / Scanning',
                          'Schedule investigations',
                          isDark,
                          color: AppColors.secondary,
                        ),
                        SizedBox(height: 10.h),
                        Wrap(
                          spacing: 8.w,
                          runSpacing: 6.h,
                          children: _availableTests.map((test) {
                            final isSelected = _selectedTests.contains(test);
                            return FilterChip(
                              label: Text(test,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: isSelected
                                        ? AppColors.secondary
                                        : (isDark
                                            ? Colors.white70
                                            : AppColors.textPrimary),
                                  )),
                              selected: isSelected,
                              onSelected: (val) {
                                setState(() {
                                  if (val) {
                                    _selectedTests.add(test);
                                  } else {
                                    _selectedTests.remove(test);
                                  }
                                });
                                _updateTotalFee();
                              },
                              selectedColor: AppColors.secondary.withOpacity(0.15),
                              checkmarkColor: AppColors.secondary,
                              backgroundColor: isDark
                                  ? AppColors.terminalDarkBg
                                  : Colors.grey[100],
                              side: BorderSide(
                                color: isSelected
                                    ? AppColors.secondary
                                    : (isDark
                                        ? AppColors.terminalDarkBorder
                                        : AppColors.border),
                              ),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 10.h),
                        _buildTextField(
                            _labNotesCtrl, 'Special instructions for lab...', isDark,
                            maxLines: 2),
                        SizedBox(height: 24.h),
                        _buildSectionHeader(
                          Icons.receipt_long_outlined,
                          'C. Payment & Invoice',
                          'Confirm payment details',
                          isDark,
                          color: AppColors.accent,
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          padding: EdgeInsets.all(12.r),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.05),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                                color: AppColors.primary.withOpacity(0.2)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Invoice Number',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: isDark
                                        ? Colors.white54
                                        : AppColors.textSecondary,
                                  )),
                              Text(_invoiceNumber,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color:
                                        isDark ? Colors.white : AppColors.primary,
                                  )),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 14.h),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.r),
                                  bottomLeft: Radius.circular(8.r),
                                ),
                              ),
                              child: Text('₹',
                                  style: AppTextStyles.titleMedium.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _feeCtrl,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                    color: isDark
                                        ? Colors.white
                                        : AppColors.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.sp),
                                decoration: InputDecoration(
                                  hintText: 'Consultation fee',
                                  filled: true,
                                  fillColor: isDark
                                      ? AppColors.terminalDarkBg
                                      : Colors.grey[50],
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12.w, vertical: 14.h),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: isDark
                                            ? AppColors.terminalDarkBorder
                                            : AppColors.border),
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(8.r),
                                      bottomRight: Radius.circular(8.r),
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: isDark
                                            ? AppColors.terminalDarkBorder
                                            : AppColors.border),
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
                        Text('Payment Method',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white70 : AppColors.textPrimary,
                            )),
                        SizedBox(height: 8.h),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: !_paymentConfirmed
                                    ? () =>
                                        setState(() => _paymentMethod = 'Cash')
                                    : null,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: EdgeInsets.all(14.r),
                                  decoration: BoxDecoration(
                                    color: _paymentMethod == 'Cash'
                                        ? AppColors.accent.withOpacity(0.15)
                                        : (isDark
                                            ? AppColors.terminalDarkBg
                                            : Colors.grey[100]),
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                      color: _paymentMethod == 'Cash'
                                          ? AppColors.accent
                                          : (isDark
                                              ? AppColors.terminalDarkBorder
                                              : AppColors.border),
                                      width: _paymentMethod == 'Cash' ? 2 : 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(Icons.money,
                                          color: _paymentMethod == 'Cash'
                                              ? AppColors.accent
                                              : (isDark
                                                  ? Colors.white54
                                                  : AppColors.textSecondary),
                                          size: 28.r),
                                      SizedBox(height: 4.h),
                                      Text('Cash',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.sp,
                                            color: _paymentMethod == 'Cash'
                                                ? AppColors.accent
                                                : (isDark
                                                    ? Colors.white54
                                                    : AppColors.textSecondary),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: GestureDetector(
                                onTap: !_paymentConfirmed
                                    ? () =>
                                        setState(() => _paymentMethod = 'Online')
                                    : null,
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  padding: EdgeInsets.all(14.r),
                                  decoration: BoxDecoration(
                                    color: _paymentMethod == 'Online'
                                        ? AppColors.primary.withOpacity(0.12)
                                        : (isDark
                                            ? AppColors.terminalDarkBg
                                            : Colors.grey[100]),
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                      color: _paymentMethod == 'Online'
                                          ? AppColors.primary
                                          : (isDark
                                              ? AppColors.terminalDarkBorder
                                              : AppColors.border),
                                      width: _paymentMethod == 'Online' ? 2 : 1,
                                    ),
                                  ),
                                  child: Column(
                                    children: [
                                      Icon(Icons.qr_code_scanner,
                                          color: _paymentMethod == 'Online'
                                              ? AppColors.primary
                                              : (isDark
                                                  ? Colors.white54
                                                  : AppColors.textSecondary),
                                          size: 28.r),
                                      SizedBox(height: 4.h),
                                      Text('Online / QR',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12.sp,
                                            color: _paymentMethod == 'Online'
                                              ? AppColors.primary
                                              : (isDark
                                                  ? Colors.white54
                                                  : AppColors.textSecondary),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (_paymentMethod == 'Online') ...[
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
                                    width: 2),
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
                                  Icon(Icons.qr_code_2,
                                      size: 120.r, color: Colors.black87),
                                  SizedBox(height: 8.h),
                                  Text(
                                    '₹ ${_feeCtrl.text.isEmpty ? '0.00' : _feeCtrl.text}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                      fontSize: 16.sp,
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text('Scan to Pay',
                                      style: TextStyle(
                                          fontSize: 11.sp,
                                          color: Colors.black45)),
                                ],
                              ),
                            ),
                          ),
                        ],
                        SizedBox(height: 14.h),
                        if (!_paymentConfirmed)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () => _confirmPayment(context),
                              icon: const Icon(Icons.check_circle,
                                  color: Colors.white),
                              label: Text(
                                'Pay & Confirm  ₹${_feeCtrl.text.isEmpty ? '0.00' : _feeCtrl.text}',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.success,
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r)),
                              ),
                            ),
                          )
                        else
                          Container(
                            padding: EdgeInsets.all(12.r),
                            decoration: BoxDecoration(
                              color: AppColors.success.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                  color: AppColors.success.withOpacity(0.3)),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.check_circle,
                                    color: AppColors.success, size: 20),
                                SizedBox(width: 8.w),
                                Text('Payment Confirmed!',
                                    style: TextStyle(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                    )),
                              ],
                            ),
                          ),
                        SizedBox(height: 24.h),
                        _buildSectionHeader(
                          Icons.local_hospital_outlined,
                          'D. Submit to EMR',
                          'Electronic Medical Record',
                          isDark,
                          color: AppColors.adminPrimary,
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          padding: EdgeInsets.all(14.r),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.terminalDarkBg
                                : Colors.grey[50],
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: isDark
                                  ? AppColors.terminalDarkBorder
                                  : AppColors.border,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildEMRRow('Patient', apt.patientName, isDark),
                              _buildEMRRow('Doctor', 'Dr. ${apt.doctorName}', isDark),
                              _buildEMRRow('Specialty', apt.specialty, isDark),
                              _buildEMRRow('Invoice', _invoiceNumber, isDark),
                              if (_getMedicineList().isNotEmpty)
                                _buildEMRRow(
                                  'Medicines',
                                  _getMedicineList()
                                      .map((m) => m['name'])
                                      .join(', '),
                                  isDark,
                                ),
                              if (_selectedTests.isNotEmpty)
                                _buildEMRRow(
                                  'Lab Tests',
                                  _selectedTests.join(', '),
                                  isDark,
                                ),
                              if (_prescriptionNotesCtrl.text.isNotEmpty)
                                _buildEMRRow(
                                  'Notes',
                                  _prescriptionNotesCtrl.text,
                                  isDark,
                                  isLast: true,
                                ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                        if (!_emrSubmitted)
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed:
                                  _paymentConfirmed ? () => _submitEMR(context) : null,
                              icon: const Icon(Icons.cloud_upload_outlined,
                                  color: Colors.white),
                              label: const Text(
                                'Submit to EMR',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.adminPrimary,
                                disabledBackgroundColor:
                                    AppColors.adminPrimary.withOpacity(0.4),
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.r)),
                              ),
                            ),
                          ),
                        if (!_paymentConfirmed)
                          Padding(
                            padding: EdgeInsets.only(top: 6.h),
                            child: Center(
                              child: Text(
                                'Complete payment first to enable EMR submission',
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: isDark
                                      ? Colors.white38
                                      : AppColors.textSecondary.withOpacity(0.6),
                                ),
                              ),
                            ),
                          ),
                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSectionHeader(
      IconData icon, String title, String subtitle, bool isDark,
      {Color color = AppColors.primary}) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18.r, color: color),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: isDark ? Colors.white : AppColors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  )),
              Text(subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark ? Colors.white54 : AppColors.textSecondary,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController ctrl, String hint, bool isDark,
      {int maxLines = 1, TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: TextStyle(
          color: isDark ? Colors.white : AppColors.textPrimary,
          fontSize: 13.sp),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
            color: isDark ? Colors.white38 : AppColors.textSecondary,
            fontSize: 12.sp),
        filled: true,
        fillColor: isDark ? AppColors.terminalDarkBg : Colors.grey[50],
        contentPadding:
            EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
              color: isDark ? AppColors.terminalDarkBorder : AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide:
              const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildEMRRow(String label, String value, bool isDark,
      {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(label,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: isDark ? Colors.white38 : AppColors.textSecondary,
                )),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(value,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                )),
          ),
        ],
      ),
    );
  }
}
