/// Domain entity for a billing invoice.
import 'package:equatable/equatable.dart';

class InvoiceEntity extends Equatable {
  final String id;
  final String patientName;
  final double amount;
  final String status;
  final String paymentMethod;
  final DateTime date;

  const InvoiceEntity({
    required this.id,
    required this.patientName,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    required this.date,
  });

  @override
  List<Object?> get props => [id, patientName, amount, status, date];
}
