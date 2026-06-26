import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/appointments/booking_wizard/booking_wizard_cubit.dart';

class SlotStep extends StatelessWidget {
  const SlotStep({super.key});

  List<Map<String, dynamic>> _generateDefaultSlots(
    String session,
    String durationStr,
  ) {
    final int minutes = durationStr.contains("10")
        ? 10
        : durationStr.contains("15")
        ? 15
        : 30;

    final List<Map<String, dynamic>> list = [];
    int startHour = session == "morning" ? 9 : 14;
    int endHour = session == "morning" ? 13 : 18;

    int currentMin = startHour * 60;
    int endMin = endHour * 60;

    while (currentMin < endMin) {
      final hour = currentMin ~/ 60;
      final min = currentMin % 60;
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      final amPm = hour >= 12 ? "PM" : "AM";
      final timeStr =
          "${displayHour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')} $amPm";

      list.add({"time": timeStr, "status": "Available"});
      currentMin += minutes;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.watch<BookingWizardCubit>();
    final state = cubit.state;

    if (state.selectedDoctor == null) {
      return Center(
        child: Text(
          "Please select a doctor first.",
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDark ? Colors.white54 : AppColors.textSecondary(context),
          ),
        ),
      );
    }

    final formattedDate = DateFormat('dd MMM yyyy').format(state.selectedDate);

    final slotsByDate =
        state.selectedDoctor!.metadata?['slots_by_date']
            as Map<dynamic, dynamic>? ??
        {};
    final dateData = slotsByDate[formattedDate] as Map<dynamic, dynamic>? ?? {};

    String slotDuration = "10 Minutes";
    if (dateData.isNotEmpty) {
      slotDuration = dateData.keys.first.toString();
    }

    final durationData = dateData[slotDuration] as Map<dynamic, dynamic>? ?? {};
    final morningList = durationData['morning'] as List<dynamic>?;
    final afternoonList = durationData['afternoon'] as List<dynamic>?;

    List<Map<String, dynamic>> morningSlots = [];
    List<Map<String, dynamic>> afternoonSlots = [];

    if (morningList != null) {
      morningSlots = morningList
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } else {
      morningSlots = _generateDefaultSlots("morning", slotDuration);
    }

    if (afternoonList != null) {
      afternoonSlots = afternoonList
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } else {
      afternoonSlots = _generateDefaultSlots("afternoon", slotDuration);
    }

    final doctorName =
        state.selectedDoctor!.name ??
        '${state.selectedDoctor!.firstName} ${state.selectedDoctor!.lastName}'
            .trim();
    final cleanName = doctorName
        .replaceAll(RegExp(r'^(dr\.|dr|Dr\.|Dr)\s+', caseSensitive: false), '')
        .trim();
    final parts = cleanName
        .split(RegExp(r'\s+'))
        .where((s) => s.isNotEmpty)
        .toList();
    String initials = 'DR';
    if (parts.isNotEmpty) {
      if (parts.length == 1) {
        initials = parts[0]
            .substring(0, parts[0].length >= 2 ? 2 : 1)
            .toUpperCase();
      } else {
        initials =
            '${parts.first[0].toUpperCase()}${parts.last[0].toUpperCase()}';
      }
    }
    final normalPrefix = '${initials}A';
    final waitingPrefix = '${initials}W';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Picker List (6 days)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (idx) {
            final date = DateTime.now().add(Duration(days: idx));
            final isSelected =
                DateFormat('yyyy-MM-dd').format(state.selectedDate) ==
                DateFormat('yyyy-MM-dd').format(date);
            final dayStr = DateFormat('E').format(date);
            final dateStr = DateFormat('d').format(date);

            return Expanded(
              child: GestureDetector(
                onTap: () => cubit.selectDate(date),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  padding: EdgeInsets.symmetric(vertical: 6.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark
                              ? AppColors.terminalDarkBg
                              : Colors.grey[100]),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : (AppColors.border(context)),
                    ),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        dayStr,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 9.sp,
                          color: isSelected
                              ? Colors.white
                              : (isDark
                                    ? Colors.white70
                                    : AppColors.textSecondary(context)),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        dateStr,
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : (AppColors.textPrimary(context)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 12.h),

        // Queue Token list config for selected doctor
        state.isLoadingCounts
            ? const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Center(
                  child: SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                margin: EdgeInsets.only(bottom: 12.h),
                decoration: BoxDecoration(
                  color: isDark ? Colors.white12 : Colors.grey[100],
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(color: AppColors.border(context)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Queue Type:",
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 11.sp,
                        color: isDark
                            ? Colors.white
                            : AppColors.textPrimary(context),
                      ),
                    ),
                    Row(
                      children: [
                        ChoiceChip(
                          label: Text(
                            "Normal($normalPrefix: ${state.currentNormalCount})",
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 8.sp,
                            ),
                          ),
                          selected: !state.isWaitingList,
                          selectedColor: AppColors.primary.withValues(
                            alpha: 0.2,
                          ),
                          checkmarkColor: AppColors.primary,
                          onSelected: (val) {
                            if (val) cubit.setWaitingList(false);
                          },
                        ),
                        SizedBox(width: 3.w),
                        ChoiceChip(
                          label: Text(
                            "Waiting List $waitingPrefix: ${state.currentWaitingCount}",
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 8.sp,
                            ),
                          ),
                          selected: state.isWaitingList,
                          selectedColor: AppColors.primary.withValues(
                            alpha: 0.2,
                          ),
                          checkmarkColor: AppColors.primary,
                          onSelected: (val) {
                            if (val) cubit.setWaitingList(true);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),

        // Slots grid lists
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (morningSlots.isNotEmpty) ...[
                  Text(
                    "Morning Slots",
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? Colors.white
                          : AppColors.textPrimary(context),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Wrap(
                    spacing: 6.w,
                    runSpacing: 6.h,
                    children: morningSlots.map((slot) {
                      final isAvailable = slot['status'] == 'Available';
                      final isSelected = state.selectedSlotTime == slot['time'];

                      return ChoiceChip(
                        label: Text(
                          slot['time'] as String,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 10.sp,
                          ),
                        ),
                        selected: isSelected,
                        disabledColor: isDark
                            ? Colors.white12
                            : Colors.grey[200],
                        selectedColor: AppColors.primary.withValues(alpha: 0.2),
                        checkmarkColor: AppColors.primary,
                        onSelected: isAvailable
                            ? (val) {
                                if (val) cubit.selectSlotTime(slot['time']);
                              }
                            : null,
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : (isDark
                                    ? AppColors.terminalDarkBorder
                                    : AppColors.border(context)),
                        ),
                        labelStyle: AppTextStyles.bodySmall.copyWith(
                          fontSize: 10.sp,
                          color: isSelected
                              ? AppColors.primary
                              : (isAvailable
                                    ? (AppColors.textPrimary(context))
                                    : (isDark
                                          ? Colors.white24
                                          : Colors.grey[400])),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 12.h),
                ],
                if (afternoonSlots.isNotEmpty) ...[
                  Text(
                    "Afternoon Slots",
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? Colors.white
                          : AppColors.textPrimary(context),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Wrap(
                    spacing: 6.w,
                    runSpacing: 6.h,
                    children: afternoonSlots.map((slot) {
                      final isAvailable = slot['status'] == 'Available';
                      final isSelected = state.selectedSlotTime == slot['time'];

                      return ChoiceChip(
                        label: Text(
                          slot['time'] as String,
                          style: AppTextStyles.bodySmall.copyWith(
                            fontSize: 10.sp,
                          ),
                        ),
                        selected: isSelected,
                        disabledColor: isDark
                            ? Colors.white12
                            : Colors.grey[200],
                        selectedColor: AppColors.primary.withValues(alpha: 0.2),
                        checkmarkColor: AppColors.primary,
                        onSelected: isAvailable
                            ? (val) {
                                if (val) cubit.selectSlotTime(slot['time']);
                              }
                            : null,
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : (isDark
                                    ? AppColors.terminalDarkBorder
                                    : AppColors.border(context)),
                        ),
                        labelStyle: AppTextStyles.bodySmall.copyWith(
                          fontSize: 10.sp,
                          color: isSelected
                              ? AppColors.primary
                              : (isAvailable
                                    ? (isDark
                                          ? Colors.white
                                          : AppColors.textPrimary(context))
                                    : (isDark
                                          ? Colors.white24
                                          : Colors.grey[400])),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
