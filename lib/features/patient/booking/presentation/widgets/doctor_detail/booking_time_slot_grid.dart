import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_dimensions.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/features/patient/booking/presentation/bloc/speciality_booking_bloc.dart';
import 'package:medi_connect/features/patient/booking/presentation/bloc/speciality_booking_state.dart';

class BookingTimeSlotGrid extends StatelessWidget {
  final SpecialityBookingState state;
  final bool isDark;
  final Color cardBg;

  const BookingTimeSlotGrid({
    super.key,
    required this.state,
    required this.isDark,
    required this.cardBg,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select Time Slot',
              style: TextStyle(
                fontSize: AppTextStyles.s14,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0F172A),
              ),
            ),
            Row(
              children: [
                Text(
                  'Morning',
                  style: TextStyle(
                    fontSize: AppTextStyles.s12 - 1, // 11
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: AppDimensions.spaceWXS),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.primary,
                  size: 16,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: AppDimensions.spaceM),

        // Grid
        state.availableSlots.isEmpty
            ? Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppDimensions.paddingL,
                  ),
                  child: Text(
                    'No available slots on this date. Please select another date.',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: AppTextStyles.s12 - 1, // 11
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.availableSlots.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: AppDimensions.spaceWS,
                  mainAxisSpacing: AppDimensions.spaceS,
                  childAspectRatio: 1.8,
                ),
                itemBuilder: (context, idx) {
                  final slot = state.availableSlots[idx];
                  final isBooked = state.bookedSlots.contains(slot);
                  final isSelected = state.selectedSlot == slot;

                  return GestureDetector(
                    onTap: isBooked
                        ? null
                        : () => context.read<SpecialityBookingBloc>().add(
                            SelectSlot(slot: slot),
                          ),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isBooked
                            ? const Color(0xFFF1F5F9)
                            : (isSelected ? const Color(0xFF3B5BFD) : cardBg),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusM - 2,
                        ), // 10
                        border: Border.all(
                          color: isBooked
                              ? Colors.transparent
                              : (isSelected
                                    ? const Color(0xFF3B5BFD)
                                    : AppColors.border(context)),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            slot,
                            style: TextStyle(
                              fontSize: AppTextStyles.s10,
                              fontWeight: FontWeight.w900,
                              color: isBooked
                                  ? Colors.grey.shade400
                                  : (isSelected
                                        ? Colors.white
                                        : const Color(0xFF0F172A)),
                            ),
                          ),
                          SizedBox(height: AppDimensions.spaceXS),
                          Text(
                            isBooked ? 'Booked' : 'Available',
                            style: TextStyle(
                              fontSize: 7.5,
                              fontWeight: FontWeight.bold,
                              color: isBooked
                                  ? Colors.grey.shade400
                                  : (isSelected
                                        ? Colors.white70
                                        : AppColors.success),
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
  }
}
