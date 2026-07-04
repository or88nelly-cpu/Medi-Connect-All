import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_profile/apply_leave_bottom_sheet.dart';

class QuickActionsRow extends StatelessWidget {
  final UserModel user;
  const QuickActionsRow({super.key, required this.user});

  static const List<Map<String, dynamic>> actions = [
    {
      "label": "Assign Slot\nto Doctor",
      "icon": Icons.calendar_today_outlined,
      "color": AppColors.primary,
    },
    {
      "label": "Edit Schedule\n& Timings",
      "icon": Icons.edit_calendar_outlined,
      "color": Color(0xFF00C2A8),
    },
    {
      "label": "Block Date\n/ Slot",
      "icon": Icons.block_flipped,
      "color": AppColors.error,
    },
    {
      "label": "Apply\nLeave",
      "icon": Icons.add_moderator_outlined,
      "color": AppColors.warning,
    },
    {
      "label": "View Patients\nList",
      "icon": Icons.people_outline,
      "color": Color(0xFF3F51B5),
    },
    {
      "label": "Start Video Call\n(Now)",
      "icon": Icons.video_call_outlined,
      "color": Color(0xFFE91E63),
    },
    {
      "label": "Prescriptions\nList",
      "icon": Icons.description_outlined,
      "color": Color(0xFF9C27B0),
    },
    {
      "label": "Documents\n& Certificates",
      "icon": Icons.verified_user_outlined,
      "color": Color(0xFF009688),
    },
    {
      "label": "Reports\n& Analytics",
      "icon": Icons.analytics_outlined,
      "color": Color(0xFFFF9800),
    },
  ];

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Text(
            "Quick Actions",
            style: AppTextStyles.titleMedium.copyWith(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 72.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: actions.length,
            itemBuilder: (context, idx) {
              final action = actions[idx];
              final actColor = action["color"] as Color;

              return Container(
                width: 104.w,
                margin: EdgeInsets.only(right: 8.w),
                decoration: BoxDecoration(
                  color: cardBg,
                  border: Border.all(color: borderColor, width: 1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      if (action["label"] == "Apply\nLeave") {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          builder: (ctx) => ApplyLeaveBottomSheet(
                            onLeaveApplied: (leave) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Mock leave applied for ${leave['type']}",
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Triggering Action: ${action["label"].toString().replaceAll('\n', ' ')}",
                            ),
                          ),
                        );
                      }
                    },
                    borderRadius: BorderRadius.circular(8.r),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 8.h,
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(6.r),
                            decoration: BoxDecoration(
                              color: actColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6.r),
                            ),
                            child: Icon(
                              action["icon"] as IconData,
                              size: 16.sp,
                              color: actColor,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              action["label"] as String,
                              style: TextStyle(
                                color: textColor,
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w600,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
