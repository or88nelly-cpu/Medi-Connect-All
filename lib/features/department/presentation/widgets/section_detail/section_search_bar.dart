import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';

class SectionSearchBar extends StatelessWidget {
  final ValueNotifier<String> searchNotifier;
  final ValueNotifier<int> currentPageNotifier;
  final String hintText;

  const SectionSearchBar({
    super.key,
    required this.searchNotifier,
    required this.currentPageNotifier,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fillFill = isDark
        ? AppColors.terminalDarkFieldFill
        : AppColors.terminalLightFieldFill;
    final borderCol = isDark
        ? AppColors.terminalDarkFieldBorder
        : AppColors.terminalLightFieldBorder;
    final hintCol = isDark
        ? AppColors.terminalDarkFieldHint
        : AppColors.terminalLightFieldHint;
    final textCol = isDark
        ? AppColors.terminalDarkText
        : AppColors.terminalLightText;

    final controller = TextEditingController(text: searchNotifier.value);
    controller.selection = TextSelection.fromPosition(
      TextPosition(offset: controller.text.length),
    );

    return Container(
      decoration: BoxDecoration(
        color: fillFill,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderCol, width: 1.2),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(color: textCol, fontSize: 13.sp),
        onChanged: (value) {
          searchNotifier.value = value;
          currentPageNotifier.value = 1; // Reset to first page on search
        },
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: hintCol, fontSize: 13.sp),
          prefixIcon: Icon(Icons.search, color: hintCol, size: 20.r),
          suffixIcon: searchNotifier.value.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: hintCol, size: 18.r),
                  onPressed: () {
                    searchNotifier.value = '';
                    controller.clear();
                    currentPageNotifier.value = 1;
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
        ),
      ),
    );
  }
}
