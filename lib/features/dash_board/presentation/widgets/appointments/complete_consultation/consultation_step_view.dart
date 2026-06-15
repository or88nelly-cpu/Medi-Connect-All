import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'prescription_section.dart';
import 'lab_tests_section.dart';

class ConsultationStepView extends StatelessWidget {
  final TextEditingController prescriptionNotesCtrl;
  final TextEditingController labNotesCtrl;

  const ConsultationStepView({
    super.key,
    required this.prescriptionNotesCtrl,
    required this.labNotesCtrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        PrescriptionSection(prescriptionNotesCtrl: prescriptionNotesCtrl),
        SizedBox(height: 24.h),
        LabTestsSection(labNotesCtrl: labNotesCtrl),
      ],
    );
  }
}
