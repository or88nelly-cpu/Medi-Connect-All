import 'package:flutter/material.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/modules/departments/emrd/presentation/widgets/emrd_detail_card.dart';

class EmrdBillingPaymentCard extends StatelessWidget {
  final Map<String, dynamic> record;
  final bool isDark;

  const EmrdBillingPaymentCard({
    super.key,
    required this.record,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return EmrdDetailCard(
      title: "Billing & Payment",
      icon: Icons.receipt_long_outlined,
      iconColor: Colors.green,
      isDark: isDark,
      children: [
        EmrdInfoRow(
          label: "Consultation Fee",
          value: "₹${(record['amount'] ?? 0.0).toStringAsFixed(2)}",
          isDark: isDark,
          valueColor: Colors.green,
          valueFontWeight: FontWeight.bold,
        ),
        EmrdInfoRow(
          label: "Payment Method",
          value: record['payment_method'] ?? 'Cash',
          isDark: isDark,
        ),
        EmrdInfoRow(
          label: "Payment Status",
          value: "PAID",
          isDark: isDark,
          valueColor: AppColors.success,
          valueFontWeight: FontWeight.bold,
        ),
        EmrdInvoiceSignature(
          doctorName: record['doctor_name'] ?? 'Authorized Doctor',
          isDark: isDark,
        ),
      ],
    );
  }
}
