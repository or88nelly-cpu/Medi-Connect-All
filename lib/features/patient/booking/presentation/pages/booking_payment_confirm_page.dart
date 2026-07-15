import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/widgets/appbar/common_app_bar.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/features/authentication/data/models/user_model.dart';
import 'package:medi_connect/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/common/dashboard/presentation/bloc/admin/admin_appointments_bloc.dart';
import 'package:medi_connect/features/patient/booking/presentation/bloc/speciality_booking_bloc.dart';
import 'package:medi_connect/features/patient/booking/presentation/bloc/speciality_booking_state.dart';
import 'package:medi_connect/features/patient/booking/presentation/bloc/speciality_booking_status.dart';
import 'package:medi_connect/features/patient/booking/presentation/pages/booking_success_page.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/booking_stepper.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/medi_logo_loader.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/payment_appointment_summary_card.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/payment_checkout_bar.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/payment_methods_selector.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/payment_security_info.dart';

class BookingPaymentConfirmPage extends StatefulWidget {
  final String specialityName;

  const BookingPaymentConfirmPage({super.key, required this.specialityName});

  @override
  State<BookingPaymentConfirmPage> createState() =>
      _BookingPaymentConfirmPageState();
}

class _BookingPaymentConfirmPageState extends State<BookingPaymentConfirmPage> {
  final ValueNotifier<int> _selectedPaymentNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    _selectedPaymentNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;

    return BlocConsumer<SpecialityBookingBloc, SpecialityBookingState>(
      listener: (context, state) {
        if (state.status == SpecialityBookingStatus.success) {
          final authState = context.read<AuthBloc>().state;
          String patientName = 'Likhin Nelliyotan';
          if (authState is Authenticated) {
            patientName = authState.user.fullName;
          }

          final formattedDate = state.selectedDate != null
              ? DateFormat('yyMMdd').format(state.selectedDate!)
              : '250522';
          final randomSuffix = (Random().nextInt(9000) + 1000).toString();
          final bookingId = 'MCB$formattedDate$randomSuffix';

          final paymentMethodsList = const [
            'UPI',
            'Credit/Debit Card',
            'Net Banking',
            'Wallet',
            'Pay Later',
          ];
          final selectedMethod =
              paymentMethodsList[_selectedPaymentNotifier.value];

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (ctx) => BookingSuccessPage(
                doctorName: state.selectedDoctor?.user.fullName ?? '',
                doctorQual:
                    state.selectedDoctor?.doctorInfo?.qualification ??
                    'Specialist MD',
                specialityName: widget.specialityName,
                date: state.selectedDate ?? DateTime.now(),
                slot: state.selectedSlot ?? '09:00 AM',
                patientName: patientName,
                amount: state.consultationFee,
                bookingId: bookingId,
                paymentMethod: selectedMethod,
              ),
            ),
          );
        } else if (state.status == SpecialityBookingStatus.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? "Failed to book appointment"),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.status == SpecialityBookingStatus.loading) {
          return const Scaffold(body: Center(child: MediLogoLoader()));
        }

        final docInfo = state.selectedDoctor;
        final date = state.selectedDate;
        final slot = state.selectedSlot;

        if (docInfo == null || date == null || slot == null) {
          return const Scaffold(
            body: Center(child: Text("Missing booking details.")),
          );
        }

        final fee = state.consultationFee;
        final selectedDateStr = DateFormat('EEEE, d MMMM yyyy').format(date);

        return CustomScaffold(
          customAppbar: const CommonAppBar(title: "Confirm & Pay"),
          bottomNavigationBar: PaymentCheckoutBar(
            fee: fee,
            selectedPaymentNotifier: _selectedPaymentNotifier,
            isLoading: state.status == SpecialityBookingStatus.loading,
            cardBg: cardBg,
            onCheckoutPressed: () {
              final authState = context.read<AuthBloc>().state;
              if (authState is Authenticated) {
                final userModel = UserModel.fromEntity(authState.user);
                final paymentMethodsList = const [
                  'UPI',
                  'Credit/Debit Card',
                  'Net Banking',
                  'Wallet',
                  'Pay Later',
                ];
                final selectedMethod =
                    paymentMethodsList[_selectedPaymentNotifier.value];

                context.read<SpecialityBookingBloc>().add(
                  ConfirmPayment(
                    appointmentsBloc: context.read<AdminAppointmentsBloc>(),
                    patientId: userModel.id,
                    patientName: userModel.fullName,
                    specialtyName: widget.specialityName,
                    paymentMethod: selectedMethod,
                  ),
                );
              }
            },
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BookingStepper(currentStep: 3),
                SizedBox(height: 20.h),

                Text(
                  'Confirm & Pay',
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  'Complete your payment to confirm your appointment.',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 20.h),

                PaymentAppointmentSummaryCard(
                  docInfo: docInfo,
                  dateStr: selectedDateStr,
                  slot: slot,
                  fee: fee,
                  specialityName: widget.specialityName,
                  cardBg: cardBg,
                  textColor: textColor,
                ),
                SizedBox(height: 24.h),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Choose Payment Method',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          PaymentMethodsSelector(
                            selectedPaymentNotifier: _selectedPaymentNotifier,
                            cardBg: cardBg,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.w),
                    const Expanded(flex: 4, child: PaymentSecurityInfo()),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
