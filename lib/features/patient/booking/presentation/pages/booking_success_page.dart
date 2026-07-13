import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/core/widgets/appbar/common_app_bar.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/navigation/patient_bottom_nav_bar.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/success_header.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/success_action_buttons.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/success_appointment_summary_card.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/success_stay_updated_card.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/success_helper_cards.dart';
import 'package:intl/intl.dart';

class BookingSuccessPage extends StatelessWidget {
  final String doctorName;
  final String doctorQual;
  final String specialityName;
  final DateTime date;
  final String slot;
  final String patientName;
  final double amount;
  final String bookingId;
  final String paymentMethod;

  const BookingSuccessPage({
    super.key,
    required this.doctorName,
    required this.doctorQual,
    required this.specialityName,
    required this.date,
    required this.slot,
    required this.patientName,
    required this.amount,
    required this.bookingId,
    required this.paymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;

    final isPayLater = paymentMethod == 'Pay Later';
    final formattedDateStr = DateFormat('EEEE, d MMMM yyyy').format(date);

    return CustomScaffold(
      customAppbar: const CommonAppBar(
        title: "Booking Completed",
        // automaticallyImplyLeading: false,
      ),
      bottomNavigationBar: PatientBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          context.go('/patient/dashboard');
        },
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [
            SuccessHeader(isPayLater: isPayLater, isDark: isDark),
            SizedBox(height: 24.h),

            SuccessActionButtons(
              onDownloadReceipt: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Downloading receipt...')),
                );
              },
              onViewAppointment: () {
                context.go('/patient/dashboard');
              },
            ),
            SizedBox(height: 24.h),

            SuccessAppointmentSummaryCard(
              doctorName: doctorName,
              doctorQual: doctorQual,
              specialityName: specialityName,
              dateStr: formattedDateStr,
              slot: slot,
              patientName: patientName,
              amount: amount,
              bookingId: bookingId,
              isPayLater: isPayLater,
              cardBg: cardBg,
              textColor: textColor,
            ),
            SizedBox(height: 20.h),

            SuccessStayUpdatedCard(cardBg: cardBg, textColor: textColor),
            SizedBox(height: 12.h),

            SuccessHelperCards(
              onCalendarTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Adding to calendar...')),
                );
              },
              onSupportTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Connecting support...')),
                );
              },
              cardBg: cardBg,
              textColor: textColor,
            ),
            SizedBox(height: 20.h),

            Text(
              'Thank you for choosing MediConnect. â™¥',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 9.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}
