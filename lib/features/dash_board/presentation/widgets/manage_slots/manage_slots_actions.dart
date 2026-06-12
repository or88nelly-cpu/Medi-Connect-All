import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';

class ManageSlotsActions extends StatelessWidget {
  final UserModel user;
  const ManageSlotsActions({super.key, required this.user});

  static const List<Map<String, dynamic>> _actions = [
    {
      "label": "Add Slot",
      "icon": Icons.add_circle_outline,
      "color": AppColors.primary,
    },
    {
      "label": "Edit Slot",
      "icon": Icons.edit_outlined,
      "color": Color(0xFF00C2A8),
    },
    {
      "label": "Block Date",
      "icon": Icons.calendar_today_outlined,
      "color": AppColors.error,
    },
    {
      "label": "Copy Slots",
      "icon": Icons.copy_all_outlined,
      "color": Color(0xFF009688),
    },
    {
      "label": "Assign Slot",
      "icon": Icons.person_add_alt_1_outlined,
      "color": Color(0xFF9C27B0),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final borderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final textColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _actions.map((act) {
        final color = act["color"] as Color;

        return Expanded(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 4.w),
            decoration: BoxDecoration(
              color: cardBg,
              border: Border.all(color: borderColor, width: 1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  if (act["label"] == "Add Slot") {
                    context.push('/admin/doctor-staff/add-slot', extra: user);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("${act['label']} Action Clicked")),
                    );
                  }
                },
                borderRadius: BorderRadius.circular(8.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        act["icon"] as IconData,
                        size: 18.sp,
                        color: color,
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        act["label"] as String,
                        style: TextStyle(
                          color: textColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
