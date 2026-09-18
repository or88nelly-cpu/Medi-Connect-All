import 'package:flutter/material.dart';
import 'package:medi_connect/core/widgets/buttons/language_button.dart';

class LanguageSelect extends StatelessWidget {
  const LanguageSelect({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        LanguageButton(languageCode: 'en', languageName: 'English'),
        LanguageButton(languageCode: 'ml', languageName: 'മലയാളം'),
        LanguageButton(languageCode: 'hi', languageName: 'हिन्दी'),
      ],
    );
  }
}
