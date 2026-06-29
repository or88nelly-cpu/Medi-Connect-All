import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/shared/dashboard/domain/entities/pharmacy_item_entity.dart';
import 'package:medi_connect/shared/dashboard/data/models/pharmacy_item_model.dart';

class CompleteConsultationState {
  final List<Map<String, dynamic>> medicines;
  final List<String> selectedTests;
  final String paymentMethod;
  final bool paymentConfirmed;
  final String invoiceNumber;
  final bool emrSubmitted;
  final double totalFee;
  final int currentStep;

  CompleteConsultationState({
    required this.medicines,
    required this.selectedTests,
    required this.paymentMethod,
    required this.paymentConfirmed,
    required this.invoiceNumber,
    required this.emrSubmitted,
    required this.totalFee,
    required this.currentStep,
  });

  CompleteConsultationState copyWith({
    List<Map<String, dynamic>>? medicines,
    List<String>? selectedTests,
    String? paymentMethod,
    bool? paymentConfirmed,
    String? invoiceNumber,
    bool? emrSubmitted,
    double? totalFee,
    int? currentStep,
  }) {
    return CompleteConsultationState(
      medicines: medicines ?? this.medicines,
      selectedTests: selectedTests ?? this.selectedTests,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentConfirmed: paymentConfirmed ?? this.paymentConfirmed,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      emrSubmitted: emrSubmitted ?? this.emrSubmitted,
      totalFee: totalFee ?? this.totalFee,
      currentStep: currentStep ?? this.currentStep,
    );
  }
}

class CompleteConsultationCubit extends Cubit<CompleteConsultationState> {
  final double initialConsultationFee;

  CompleteConsultationCubit({this.initialConsultationFee = 500.0})
    : super(
        CompleteConsultationState(
          medicines: [],
          selectedTests: [],
          paymentMethod: 'Cash',
          paymentConfirmed: false,
          invoiceNumber: '',
          emrSubmitted: false,
          totalFee: initialConsultationFee,
          currentStep: 1,
        ),
      ) {
    _init();
  }

  void _init() {
    final now = DateTime.now();
    final inv =
        'INV-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${(now.millisecondsSinceEpoch % 10000).toString().padLeft(4, '0')}';
    emit(state.copyWith(invoiceNumber: inv));
    addMedicineRow(notify: false);
  }

  List<PharmacyItemEntity> _lastPharmacyItems = [];

  void setPharmacyItems(List<PharmacyItemEntity> items) {
    _lastPharmacyItems = items;
    updateTotalFee();
  }

  void addMedicineRow({bool notify = true}) {
    final nameCtrl = TextEditingController();
    nameCtrl.addListener(updateTotalFee);
    final daysCtrl = TextEditingController(text: '7');
    daysCtrl.addListener(updateTotalFee);
    final freqCtrl = TextEditingController(text: '1-0-1');
    freqCtrl.addListener(updateTotalFee);

    final newRow = {
      'name': nameCtrl,
      'dosage': TextEditingController(),
      'frequency': freqCtrl,
      'days': daysCtrl,
      'focusNode': FocusNode(),
      'sell_price': 150.0,
    };

    final list = List<Map<String, dynamic>>.from(state.medicines)..add(newRow);
    emit(state.copyWith(medicines: list));
    if (notify) {
      updateTotalFee();
    }
  }

  void removeMedicineRow(int index) {
    if (state.medicines.length <= 1) return;
    final row = state.medicines[index];
    (row['name'] as TextEditingController?)?.removeListener(updateTotalFee);
    (row['days'] as TextEditingController?)?.removeListener(updateTotalFee);
    (row['frequency'] as TextEditingController?)?.removeListener(
      updateTotalFee,
    );

    (row['name'] as TextEditingController?)?.dispose();
    (row['dosage'] as TextEditingController?)?.dispose();
    (row['frequency'] as TextEditingController?)?.dispose();
    (row['days'] as TextEditingController?)?.dispose();
    (row['focusNode'] as FocusNode?)?.dispose();

    final list = List<Map<String, dynamic>>.from(state.medicines)
      ..removeAt(index);
    emit(state.copyWith(medicines: list));
    updateTotalFee();
  }

  void selectMedicine(int index, PharmacyItemEntity selection) {
    final row = state.medicines[index];
    (row['dosage'] as TextEditingController).text = selection.dosage;
    row['sell_price'] = selection.sellPrice;

    // Trigger update of state to refresh the UI text
    emit(
      state.copyWith(
        medicines: List<Map<String, dynamic>>.from(state.medicines),
      ),
    );
    updateTotalFee();
  }

  void toggleLabTest(String test) {
    final list = List<String>.from(state.selectedTests);
    if (list.contains(test)) {
      list.remove(test);
    } else {
      list.add(test);
    }
    emit(state.copyWith(selectedTests: list));
    updateTotalFee();
  }

  void setPaymentMethod(String method) {
    if (state.paymentConfirmed) return;
    emit(state.copyWith(paymentMethod: method));
  }

  void confirmPaymentSuccess() {
    emit(state.copyWith(paymentConfirmed: true));
  }

  void submitEMRSuccess() {
    emit(state.copyWith(emrSubmitted: true));
  }

  void goToStep(int step) {
    if (step >= 1 && step <= 3) {
      emit(state.copyWith(currentStep: step));
    }
  }

  void nextStep() {
    if (state.currentStep < 3) {
      emit(state.copyWith(currentStep: state.currentStep + 1));
    }
  }

  void previousStep() {
    if (state.currentStep > 1) {
      emit(state.copyWith(currentStep: state.currentStep - 1));
    }
  }

  void addCustomLabTest(String test) {
    if (test.trim().isEmpty) return;
    final list = List<String>.from(state.selectedTests);
    if (!list.contains(test.trim())) {
      list.add(test.trim());
    }
    emit(state.copyWith(selectedTests: list));
    updateTotalFee();
  }

  void updateTotalFee() {
    double consultationFee = initialConsultationFee;
    double medicineTotal = 0.0;
    for (final row in state.medicines) {
      final nameCtrl = row['name'] as TextEditingController?;
      final name = nameCtrl?.text.trim().toLowerCase() ?? '';
      if (name.isNotEmpty) {
        double price = 150.0;
        if (_lastPharmacyItems.isNotEmpty) {
          final match = _lastPharmacyItems.firstWhere(
            (item) => item.name.toLowerCase() == name,
            orElse: () => const PharmacyItemModel(
              id: '',
              name: '',
              stock: 0,
              category: '',
              status: '',
              buyPrice: 0.0,
              sellPrice: -1.0,
              dosage: '',
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
    double labTotal = state.selectedTests.length * 250.0;
    double total = consultationFee + medicineTotal + labTotal;
    emit(state.copyWith(totalFee: total));
  }

  @override
  Future<void> close() {
    for (final row in state.medicines) {
      (row['name'] as TextEditingController?)?.removeListener(updateTotalFee);
      (row['days'] as TextEditingController?)?.removeListener(updateTotalFee);
      (row['frequency'] as TextEditingController?)?.removeListener(
        updateTotalFee,
      );

      (row['name'] as TextEditingController?)?.dispose();
      (row['dosage'] as TextEditingController?)?.dispose();
      (row['frequency'] as TextEditingController?)?.dispose();
      (row['days'] as TextEditingController?)?.dispose();
      (row['focusNode'] as FocusNode?)?.dispose();
    }
    return super.close();
  }
}
