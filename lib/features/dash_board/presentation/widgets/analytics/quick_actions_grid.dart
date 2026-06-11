import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class QuickActionsGrid extends StatelessWidget {
  final Function(String action)? onActionTap;

  const QuickActionsGrid({
    super.key,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;
    final cardBg = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final borderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;

    final actions = [
      {
        'label': 'MAP',
        'icon': Icons.map_outlined,
        'action': 'map',
      },
      {
        'label': 'LAB TEST',
        'icon': Icons.science_outlined,
        'action': 'lab',
      },
      {
        'label': 'ADMIT',
        'icon': Icons.person_add_alt_1_outlined,
        'action': 'admit',
      },
      {
        'label': 'MORE',
        'icon': Icons.more_horiz_outlined,
        'action': 'more',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.quickActions,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: titleColor,
            fontSize: 15.sp,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: actions.map((act) {
            final label = act['label'] as String;
            final icon = act['icon'] as IconData;
            final key = act['action'] as String;

            return Expanded(
              child: Card(
                color: cardBg,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  side: BorderSide(color: borderColor, width: 1.2),
                ),
                margin: EdgeInsets.symmetric(horizontal: 4.w),
                child: InkWell(
                  onTap: () => onActionTap?.call(key),
                  borderRadius: BorderRadius.circular(12.r),
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          icon,
                          color: AppColors.primary,
                          size: 24.r,
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          label,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            color: labelColor,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
