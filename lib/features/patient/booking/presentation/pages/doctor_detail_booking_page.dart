import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/booking_datetime_widgets.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/booking_payment_widgets.dart';
import 'package:medi_connect/features/patient/booking/presentation/bloc/speciality_booking_bloc.dart';
import 'package:medi_connect/features/patient/booking/presentation/bloc/speciality_booking_state.dart';
import 'package:medi_connect/features/patient/booking/presentation/pages/booking_payment_confirm_page.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/booking_stepper.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/doctor_booking_widgets.dart';

class DoctorDetailBookingPage extends StatelessWidget {
  final dynamic user;
  final dynamic doc;
  final String specialityName;

  const DoctorDetailBookingPage({
    super.key,
    required this.user,
    required this.doc,
    required this.specialityName,
  });

  List<DateTime> get _nextSevenDays =>
      List.generate(7, (i) => DateTime.now().add(Duration(days: i)));

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E293B) : AppColors.surface;
    final textColor = isDark ? AppColors.surface : const Color(0xFF0F172A);
    final double fee = doc?.consultationFee?.toDouble() ?? 500.0;
    final int exp = doc?.experienceYears ?? 8;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : AppColors.surface,
      appBar: AppBar(
        title: const Text('Select Doctor'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      bottomNavigationBar: _buildBottomCheckoutBar(context, fee),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Stepper Progress Bar
            const BookingStepper(currentStep: 1),
            SizedBox(height: 20.h),

            // 2. Doctor Info Card
            BookingDoctorInfoCard(
              user: user,
              doc: doc,
              exp: exp,
              cardBg: cardBg,
              textColor: textColor,
              specialityName: specialityName,
            ),
            SizedBox(height: 20.h),

            // 3. Statistics Row
            BookingStatsRow(isDark: isDark),
            SizedBox(height: 24.h),

            // 4. Choose Appointment Date
            BookingDatePicker(cardBg: cardBg, nextSevenDays: _nextSevenDays),
            SizedBox(height: 24.h),

            // 5. Select Time Slot
            BookingTimeSlotGrid(cardBg: cardBg),
            SizedBox(height: 24.h),

            // 6. Reason for Visit
            BookingReasonInput(cardBg: cardBg, textColor: textColor),
            SizedBox(height: 24.h),

            // 7. Select Patient
            BookingPatientSelector(cardBg: cardBg, textColor: textColor),
            SizedBox(height: 24.h),

            // 8. Booking Summary
            BookingSummarySection(
              user: user,
              specialityName: specialityName,
              fee: fee,
              cardBg: cardBg,
              textColor: textColor,
            ),
            SizedBox(height: 24.h),

            // 9. Payment Method
            BookingPaymentMethodSection(cardBg: cardBg),
            SizedBox(height: 32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomCheckoutBar(BuildContext context, double fee) {
    return BlocBuilder<SpecialityBookingBloc, SpecialityBookingState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: AppColors.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Amount to Pay',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'â‚¹${fee.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w900,
                            color: const Color(0xFF1E3A8A),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(
                          Icons.keyboard_arrow_up_rounded,
                          color: AppColors.primary,
                          size: 16.r,
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap:
                      (state.selectedDate == null || state.selectedSlot == null)
                      ? () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Please select date and time slot first!',
                              ),
                            ),
                          );
                        }
                      : () {
                          context.read<SpecialityBookingBloc>().add(
                            ProceedToPayment(),
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => BlocProvider.value(
                                value: context.read<SpecialityBookingBloc>(),
                                child: BookingPaymentConfirmPage(
                                  specialityName: specialityName,
                                ),
                              ),
                            ),
                          );
                        },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 14.h,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3B5BFD),
                      borderRadius: BorderRadius.circular(16.r),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(
                            0xFF3B5BFD,
                          ).withValues(alpha: 0.25),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Proceed to Pay',
                          style: TextStyle(
                            color: AppColors.surface,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Icon(
                          Icons.chevron_right_rounded,
                          color: AppColors.surface,
                          size: 16.r,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
