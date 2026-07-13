import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/features/patient/booking/presentation/bloc/speciality_booking_bloc.dart';
import 'package:medi_connect/features/patient/booking/presentation/bloc/speciality_booking_state.dart';

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Date Picker (Stateless, Bloc-driven)
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class BookingDatePicker extends StatelessWidget {
  final Color cardBg;
  final List<DateTime> nextSevenDays;

  const BookingDatePicker({
    super.key,
    required this.cardBg,
    required this.nextSevenDays,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpecialityBookingBloc, SpecialityBookingState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Choose Appointment Date',
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w900, color: const Color(0xFF0F172A)),
                ),
                Row(
                  children: [
                    Text(
                      'May 2025',
                      style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.calendar_month_outlined, color: AppColors.primary, size: 14.r),
                    SizedBox(width: 8.w),
                    Icon(Icons.chevron_left_rounded, color: Colors.grey, size: 18.r),
                    Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 18.r),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),
            SizedBox(
              height: 64.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: nextSevenDays.length,
                itemBuilder: (context, i) {
                  final d = nextSevenDays[i];
                  final isSelected =
                      state.selectedDate != null &&
                      state.selectedDate!.year == d.year &&
                      state.selectedDate!.month == d.month &&
                      state.selectedDate!.day == d.day;
                  return GestureDetector(
                    onTap: () => context.read<SpecialityBookingBloc>().add(SelectDate(date: d)),
                    child: Container(
                      width: 52.w,
                      margin: EdgeInsets.only(right: 8.w),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF3B5BFD) : cardBg,
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(
                          color: isSelected ? const Color(0xFF3B5BFD) : AppColors.border(context),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            isSelected ? 'Today' : _weekdayAbbr(d.weekday),
                            style: TextStyle(
                              fontSize: 9.sp,
                              color: isSelected ? AppColors.surface70 : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            "${d.day}",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w900,
                              color: isSelected ? AppColors.surface : const Color(0xFF0F172A),
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
      },
    );
  }

  String _weekdayAbbr(int wd) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[(wd - 1).clamp(0, 6)];
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Time Slot Grid (Stateless, Bloc-driven)
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class BookingTimeSlotGrid extends StatelessWidget {
  final Color cardBg;

  const BookingTimeSlotGrid({super.key, required this.cardBg});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpecialityBookingBloc, SpecialityBookingState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Select Time Slot',
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w900, color: const Color(0xFF0F172A)),
                ),
                Row(
                  children: [
                    Text(
                      'Morning',
                      style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary, size: 16.r),
                  ],
                ),
              ],
            ),
            SizedBox(height: 12.h),
            state.availableSlots.isEmpty
                ? Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      child: Text(
                        'No available slots on this date. Please select another date.',
                        style: TextStyle(color: Colors.grey, fontSize: 11.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.availableSlots.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 8.w,
                      mainAxisSpacing: 8.h,
                      childAspectRatio: 1.8,
                    ),
                    itemBuilder: (context, idx) {
                      final slot = state.availableSlots[idx];
                      final isBooked = state.bookedSlots.contains(slot);
                      final isSelected = state.selectedSlot == slot;

                      return GestureDetector(
                        onTap: isBooked
                            ? null
                            : () => context.read<SpecialityBookingBloc>().add(SelectSlot(slot: slot)),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isBooked
                                ? const Color(0xFFF1F5F9)
                                : (isSelected ? const Color(0xFF3B5BFD) : cardBg),
                            borderRadius: BorderRadius.circular(10.r),
                            border: Border.all(
                              color: isBooked
                                  ? Colors.transparent
                                  : (isSelected ? const Color(0xFF3B5BFD) : AppColors.border(context)),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                slot,
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w900,
                                  color: isBooked
                                      ? Colors.grey.shade400
                                      : (isSelected ? AppColors.surface : const Color(0xFF0F172A)),
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                isBooked ? 'Booked' : 'Available',
                                style: TextStyle(
                                  fontSize: 7.5.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isBooked
                                      ? Colors.grey.shade400
                                      : (isSelected ? AppColors.surface70 : const Color(0xFF22C55E)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ],
        );
      },
    );
  }
}
