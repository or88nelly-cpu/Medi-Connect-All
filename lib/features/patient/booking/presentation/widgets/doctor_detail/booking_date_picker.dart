import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_dimensions.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/features/patient/booking/presentation/bloc/speciality_booking_bloc.dart';
import 'package:medi_connect/features/patient/booking/presentation/bloc/speciality_booking_state.dart';

class BookingDatePicker extends StatelessWidget {
  final SpecialityBookingState state;
  final bool isDark;
  final Color cardBg;

  const BookingDatePicker({
    super.key,
    required this.state,
    required this.isDark,
    required this.cardBg,
  });

  List<DateTime> get _nextSevenDays =>
      List.generate(7, (i) => DateTime.now().add(Duration(days: i)));

  String _weekdayAbbr(int wd) {
    const d = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return d[(wd - 1).clamp(0, 6)];
  }

  @override
  Widget build(BuildContext context) {
    final currentMonthYearStr = DateFormat('MMMM yyyy').format(DateTime.now());

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Choose Appointment Date',
              style: TextStyle(
                fontSize: AppTextStyles.s14,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0F172A),
              ),
            ),
            Row(
              children: [
                Text(
                  currentMonthYearStr,
                  style: TextStyle(
                    fontSize: AppTextStyles.s12 - 1, // 11
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: AppDimensions.spaceWXS),
                Icon(
                  Icons.calendar_month_outlined,
                  color: AppColors.primary,
                  size: 14,
                ),
                SizedBox(width: AppDimensions.spaceWS),
                const Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.grey,
                  size: 18,
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey,
                  size: 18,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: AppDimensions.spaceM),

        // List
        SizedBox(
          height: 64,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _nextSevenDays.length,
            itemBuilder: (context, i) {
              final d = _nextSevenDays[i];
              final isSelected =
                  state.selectedDate != null &&
                  state.selectedDate!.year == d.year &&
                  state.selectedDate!.month == d.month &&
                  state.selectedDate!.day == d.day;
              return GestureDetector(
                onTap: () => context.read<SpecialityBookingBloc>().add(
                  SelectDate(date: d),
                ),
                child: Container(
                  width: 52,
                  margin: EdgeInsets.only(right: AppDimensions.marginS),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF3B5BFD) : cardBg,
                    borderRadius: BorderRadius.circular(AppDimensions.radiusM),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF3B5BFD)
                          : AppColors.border(context),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isSelected ? 'Today' : _weekdayAbbr(d.weekday),
                        style: TextStyle(
                          fontSize: AppTextStyles.s10 - 1, // 9
                          color: isSelected ? Colors.white70 : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: AppDimensions.spaceXS),
                      Text(
                        "${d.day}",
                        style: TextStyle(
                          fontSize: AppTextStyles.s16,
                          fontWeight: FontWeight.w900,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
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
