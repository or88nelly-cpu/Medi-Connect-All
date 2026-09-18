import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/widgets/buttons/common_button.dart';

class LanguageButton extends StatelessWidget {
  const LanguageButton({
    super.key,
    required this.languageCode,
    required this.languageName,
  });

  final String languageCode;
  final String languageName;

  @override
  Widget build(BuildContext context) {
    final isSelected = context.locale.languageCode == languageCode;
    return CommonButton(
      width: (MediaQuery.of(context).size.width - 40.w) / 3,

      color: isSelected ? AppColors.primaryDark : Colors.white,
      isOutline: !isSelected,
      textColor: isSelected ? Colors.white : AppColors.primaryDark,
      onPressed: () {
        context.setLocale(Locale(languageCode));
      },
      child: Text(languageName),
    );
  }
}
