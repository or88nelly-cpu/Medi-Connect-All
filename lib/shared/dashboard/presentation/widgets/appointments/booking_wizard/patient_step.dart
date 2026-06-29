import 'dart:math' as math;
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

  String _generateUUID() {
    final random = math.Random();
    String hex(int length) {
      return List.generate(
        length,
        (_) => random.nextInt(16).toRadixString(16),
      ).join();
    }

    return '${hex(8)}-${hex(4)}-4${hex(3)}-${(random.nextInt(4) + 8).toRadixString(16)}${hex(3)}-${hex(12)}';
  }
  
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container();
  }

 

}
