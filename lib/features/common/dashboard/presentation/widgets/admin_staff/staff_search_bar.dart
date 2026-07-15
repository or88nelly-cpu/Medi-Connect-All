import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';

class StaffSearchBar extends StatelessWidget {
  const StaffSearchBar({
    super.key,
    required this.searchNotifier,
    required this.currentPageNotifier,
  });

  final ValueNotifier<String> searchNotifier;
  final ValueNotifier<int> currentPageNotifier;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark
        ? AppColors.terminalDarkCard
        : AppColors.terminalLightCard;
    final borderColor = isDark
        ? AppColors.terminalDarkBorder
        : AppColors.terminalLightBorder;
    final textColor = isDark
        ? AppColors.terminalDarkText
        : AppColors.terminalLightText;
    final labelColor = isDark
        ? AppColors.terminalDarkLabel
        : AppColors.terminalLightLabel;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: TextField(
        onChanged: (val) {
          searchNotifier.value = val;
          currentPageNotifier.value = 1;
        },
        style: TextStyle(color: textColor, fontSize: 13.sp),
        decoration: InputDecoration(
          hintText: "Search staff by name or role...",
          hintStyle: TextStyle(color: labelColor.withValues(alpha: 0.7)),
          prefixIcon: Icon(Icons.search, color: labelColor),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 12.h),
        ),
      ),
    );
  }
}
