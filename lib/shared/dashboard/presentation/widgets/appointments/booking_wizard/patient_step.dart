import 'package:flutter/material.dart';

class PatientStep extends StatelessWidget {
  final GlobalKey<FormState> patientFormKey;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController ageController;

  const PatientStep({
    super.key,
    required this.patientFormKey,
    required this.firstNameController,
    required this.lastNameController,
    required this.emailController,
    required this.phoneController,
    required this.ageController,
  });

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container();
  }
}
