import 'package:flutter/material.dart';
import 'package:medi_connect/core/widgets/textfields/text_fields.dart';

class PersonalInfo extends StatelessWidget {
  const PersonalInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [AppTextField(labelText: "Name")]);
  }
}
