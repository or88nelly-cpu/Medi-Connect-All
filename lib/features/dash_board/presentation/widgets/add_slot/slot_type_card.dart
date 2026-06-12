import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class SlotTypeCard extends StatefulWidget {
  final ValueChanged<String>? onTypeChanged;

  const SlotTypeCard({super.key, this.onTypeChanged});

  @override
  State<SlotTypeCard> createState() => _SlotTypeCardState();
}

class _SlotTypeCardState extends State<SlotTypeCard> {
  String _selectedType = "Regular Slot";

  final List<Map<String, dynamic>> _types = [
    {
      "name": "Regular Slot",
      "subtitle": "Standard consultation",
      "color": const Color(0xFF0F9F58),
    },
    {
      "name": "Emergency Slot",
      "subtitle": "Priority consultation",
      "color": AppColors.warning,
    },
    {
      "name": "Follow-up Slot",
      "subtitle": "Follow-up consultation",
      "color": const Color(0xFF9C27B0),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final borderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final textColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Slot Type",
            style: AppTextStyles.titleMedium.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            "Select the type of slot",
            style: TextStyle(
              color: labelColor,
              fontSize: 10.sp,
            ),
          ),
          SizedBox(height: 14.h),
          // Horizontal choices
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 550;

              final children = _types.map((type) {
                final typeName = type["name"] as String;
                final isSelected = typeName == _selectedType;
                final color = type["color"] as Color;

                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedType = typeName;
                      });
                      if (widget.onTypeChanged != null) {
                        widget.onTypeChanged!(typeName);
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: EdgeInsets.symmetric(horizontal: 4.w),
                      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                      decoration: BoxDecoration(
                        color: isSelected ? color.withOpacity(0.1) : Colors.transparent,
                        border: Border.all(
                          color: isSelected ? color : borderColor,
                          width: 1.r,
                        ),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 14.r,
                            height: 14.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? color : labelColor,
                                width: 1.5.r,
                              ),
                            ),
                            child: isSelected
                                ? Center(
                                    child: Container(
                                      width: 6.r,
                                      height: 6.r,
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  typeName,
                                  style: TextStyle(
                                    color: isSelected ? color : textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 11.sp,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  type["subtitle"] as String,
                                  style: TextStyle(
                                    color: labelColor,
                                    fontSize: 9.sp,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList();

              if (isWide) {
                return Row(
                  children: children,
                );
              } else {
                return Column(
                  children: children.map((c) {
                    return Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: Row(children: [c]),
                    );
                  }).toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
