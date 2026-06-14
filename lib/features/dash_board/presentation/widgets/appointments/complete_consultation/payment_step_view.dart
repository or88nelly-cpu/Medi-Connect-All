import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/features/dash_board/domain/entities/appointment_entity.dart';
import 'payment_section.dart';
import 'submit_emr_section.dart';

class PaymentStepView extends StatelessWidget {
  final AppointmentEntity appointment;
  final TextEditingController feeCtrl;
  final TextEditingController prescriptionNotesCtrl;
  final VoidCallback onConfirmPayment;
  final VoidCallback onSubmitEMR;

  const PaymentStepView({
    super.key,
    required this.appointment,
    required this.feeCtrl,
    required this.prescriptionNotesCtrl,
    required this.onConfirmPayment,
    required this.onSubmitEMR,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PaymentSection(
          feeCtrl: feeCtrl,
          onConfirmPayment: onConfirmPayment,
        ),
        SizedBox(height: 24.h),
        SubmitEmrSection(
          appointment: appointment,
          prescriptionNotesCtrl: prescriptionNotesCtrl,
          onSubmitEMR: onSubmitEMR,
        ),
      ],
    );
  }
}
