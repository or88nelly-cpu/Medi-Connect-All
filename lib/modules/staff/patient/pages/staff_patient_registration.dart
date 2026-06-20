import 'package:flutter/material.dart';
import 'package:medi_connect/core/common_widgets/common_app_bar.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';

class StaffPatientRegistration extends StatelessWidget {
  const StaffPatientRegistration({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      customAppbar: CommonAppBar(
        title: "Patient Registration",
      ),
      body: Column(children: [
          
        ],
      ));
  }
}
