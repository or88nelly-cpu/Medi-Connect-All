/// Data model for billing invoices with JSON serialization.
import 'package:medi_connect/features/dash_board/domain/entities/invoice_entity.dart';

class InvoiceModel extends InvoiceEntity {
  const InvoiceModel({
    required super.id,
    required super.patientName,
    required super.amount,
    required super.status,
    required super.paymentMethod,
    required super.date,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    return InvoiceModel(
      id: json['id']?.toString() ?? '',
      patientName: json['patient_name'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'Pending',
      paymentMethod: json['payment_method'] as String? ?? 'Cash',
      date: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'patient_name': patientName,
        'amount': amount,
        'status': status,
        'payment_method': paymentMethod,
      };
}
