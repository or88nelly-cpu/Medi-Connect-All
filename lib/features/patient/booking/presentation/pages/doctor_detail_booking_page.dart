import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/features/patient/booking/presentation/bloc/speciality_booking_bloc.dart';
import 'package:medi_connect/features/patient/booking/presentation/bloc/speciality_booking_state.dart';
import 'package:medi_connect/features/patient/booking/presentation/pages/booking_payment_confirm_page.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/booking_stepper.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/doctor_detail/doctor_detail_info_card.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/doctor_detail/booking_date_picker.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/doctor_detail/booking_time_slot_grid.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/doctor_detail/booking_reason_for_visit.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/doctor_detail/booking_select_patient_section.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/doctor_detail/booking_summary_section.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/doctor_detail/booking_payment_methods_section.dart';

class DoctorDetailBookingPage extends StatefulWidget {
  final List<Color> gradientColors;
  final String specialityName;

  const DoctorDetailBookingPage({
    super.key,
    required this.gradientColors,
    required this.specialityName,
  });

  @override
  State<DoctorDetailBookingPage> createState() =>
      _DoctorDetailBookingPageState();
}

class _DoctorDetailBookingPageState extends State<DoctorDetailBookingPage> {
  final TextEditingController _reasonCtrl = TextEditingController();
  final ValueNotifier<int> _selectedPaymentNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    _reasonCtrl.dispose();
    _selectedPaymentNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;

    return BlocBuilder<SpecialityBookingBloc, SpecialityBookingState>(
      builder: (context, state) {
        final docInfo = state.selectedDoctor;
        if (docInfo == null) {
          return const Scaffold(
            body: Center(child: Text("No doctor selected.")),
          );
        }

        final user = docInfo.user;
        final doc = docInfo.doctorInfo;
        final exp = doc?.yearsOfExperience ?? doc?.experienceYears ?? 5;
        final fee = state.consultationFee;

        // Formatted Selected Date
        final selectedDateStr = state.selectedDate != null
            ? DateFormat('EEEE, d MMMM yyyy').format(state.selectedDate!)
            : 'Select Date';

        return CustomScaffold(
          bottomNavigationBar: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: cardBg,
                border: Border(
                  top: BorderSide(color: AppColors.border(context)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
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
                            '₹${fee.toStringAsFixed(0)}',
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
                        (state.selectedDate == null ||
                            state.selectedSlot == null)
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
                                    specialityName: widget.specialityName,
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
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.white,
                            size: 16.r,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stepper Progress Bar
                const BookingStepper(currentStep: 1),
                SizedBox(height: 20.h),

                // Doctor Info Card
                DoctorDetailInfoCard(
                  user: user,
                  doc: doc,
                  exp: exp,
                  specialityName: widget.specialityName,
                  cardBg: cardBg,
                  textColor: textColor,
                ),
                SizedBox(height: 20.h),

                // Statistics Row
                DoctorDetailStatsRow(isDark: isDark),
                SizedBox(height: 24.h),

                // Choose Appointment Date
                BookingDatePicker(
                  state: state,
                  isDark: isDark,
                  cardBg: cardBg,
                ),
                SizedBox(height: 24.h),

                // Select Time Slot
                BookingTimeSlotGrid(
                  state: state,
                  isDark: isDark,
                  cardBg: cardBg,
                ),
                SizedBox(height: 24.h),

                // Reason for Visit
                BookingReasonForVisit(
                  controller: _reasonCtrl,
                  isDark: isDark,
                  cardBg: cardBg,
                  textColor: textColor,
                ),
                SizedBox(height: 24.h),

                // Select Patient
                BookingSelectPatientSection(
                  isDark: isDark,
                  cardBg: cardBg,
                  textColor: textColor,
                ),
                SizedBox(height: 24.h),

                // Booking Summary
                BookingSummarySection(
                  user: user,
                  specialityName: widget.specialityName,
                  selectedDate: selectedDateStr,
                  selectedSlot: state.selectedSlot,
                  fee: fee,
                  isDark: isDark,
                  cardBg: cardBg,
                  textColor: textColor,
                ),
                SizedBox(height: 24.h),

                // Payment Method
                BookingPaymentMethodsSection(
                  selectedPaymentNotifier: _selectedPaymentNotifier,
                  isDark: isDark,
                  cardBg: cardBg,
                  textColor: textColor,
                ),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        );
      },
    );
  }
}
