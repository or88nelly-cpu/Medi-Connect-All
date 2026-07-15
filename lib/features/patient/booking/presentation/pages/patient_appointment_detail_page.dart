import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/appbar/common_app_bar.dart';
import 'package:medi_connect/core/widgets/buttons/common_button.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/features/common/dashboard/domain/entities/appointment_entity.dart';
import 'package:medi_connect/features/common/dashboard/presentation/bloc/admin/admin_appointments_bloc.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/appointment_detail_row.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/doctor_image_widget.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/payment_method_selection_sheet.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/qr_code_payment_dialog.dart';

class PatientAppointmentDetailPage extends StatelessWidget {
  final AppointmentEntity appointment;

  const PatientAppointmentDetailPage({super.key, required this.appointment});

  bool _isAppointmentInPast() {
    try {
      final format = DateFormat('hh:mm a');
      final parsedTime = format.parse(appointment.appointmentTime.trim());
      final combined = DateTime(
        appointment.appointmentDate.year,
        appointment.appointmentDate.month,
        appointment.appointmentDate.day,
        parsedTime.hour,
        parsedTime.minute,
      );
      return combined.isBefore(DateTime.now());
    } catch (_) {
      final now = DateTime.now();
      final todayDateOnly = DateTime(now.year, now.month, now.day);
      return appointment.appointmentDate.isBefore(todayDateOnly);
    }
  }

  bool _canCancelAppointment() {
    try {
      final format = DateFormat('hh:mm a');
      final parsedTime = format.parse(appointment.appointmentTime.trim());
      final combined = DateTime(
        appointment.appointmentDate.year,
        appointment.appointmentDate.month,
        appointment.appointmentDate.day,
        parsedTime.hour,
        parsedTime.minute,
      );
      final difference = combined.difference(DateTime.now());
      return difference.inMinutes >= 10;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;

    var displayStatus = appointment.status;
    var isExpiredPending = false;

    if (appointment.status.toLowerCase() == 'pending' &&
        _isAppointmentInPast()) {
      displayStatus = 'Cancelled';
      isExpiredPending = true;
    } else if (appointment.status.toLowerCase() != 'completed' &&
        appointment.status.toLowerCase() != 'cancelled' &&
        _isAppointmentInPast()) {
      displayStatus = 'Pending Updation';
    }

    // Status Pill Colors
    Color statusColor = const Color(0xFF10B981); // Green Confirmed
    if (displayStatus.toLowerCase() == 'pending') {
      statusColor = AppColors.warning; // Orange Pending
    } else if (displayStatus == 'Pending Updation') {
      statusColor = const Color(0xFFD97706); // Amber/Orange Pending Updation
    } else if (displayStatus.toLowerCase() == 'cancelled') {
      statusColor = AppColors.error; // Red Cancelled
    } else if (displayStatus.toLowerCase() == 'completed') {
      statusColor = AppColors.info; // Blue Completed
    }

    final dateStr = DateFormat(
      'EEEE, d MMMM yyyy',
    ).format(appointment.appointmentDate);

    return CustomScaffold(
      customAppbar: const CommonAppBar(title: "Appointment Details"),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.r),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: statusColor.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Icon(
                    displayStatus.toLowerCase() == 'cancelled'
                        ? Icons.cancel_outlined
                        : (displayStatus.toLowerCase() == 'pending'
                              ? Icons.warning_amber_rounded
                              : Icons.check_circle_outline_rounded),
                    color: statusColor,
                    size: 20.r,
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Status: $displayStatus',
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w900,
                            fontSize: 12.sp,
                          ),
                        ),
                        if (isExpiredPending)
                          Text(
                            'Cancelled automatically: unpaid reservation.',
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontWeight: FontWeight.bold,
                              fontSize: 8.5.sp,
                            ),
                          )
                        else if (displayStatus.toLowerCase() == 'pending')
                          Text(
                            'Complete payment to prevent automatic cancellation.',
                            style: TextStyle(
                              color: Colors.amber.shade900,
                              fontWeight: FontWeight.bold,
                              fontSize: 8.5.sp,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Doctor details card
            Text(
              'Doctor Information',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w900,
                color: textColor,
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.border(context)),
              ),
              child: Row(
                children: [
                  DoctorImageWidget(doctorId: appointment.doctorId, size: 56.r),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appointment.doctorName,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w900,
                            color: textColor,
                          ),
                        ),
                        Text(
                          '${appointment.specialty} Department',
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on_rounded,
                              color: AppColors.primary,
                              size: 10.r,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'MediConnect Hospital • OPD Room 3A',
                              style: TextStyle(
                                fontSize: 8.5.sp,
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Booking details
            Text(
              'Booking Schedule',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w900,
                color: textColor,
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.border(context)),
              ),
              child: Column(
                children: [
                  AppointmentDetailRow(
                    label: 'Date',
                    value: dateStr,
                    valColor: textColor,
                  ),
                  AppointmentDetailRow(
                    label: 'Time slot',
                    value: appointment.appointmentTime,
                    valColor: textColor,
                  ),
                  AppointmentDetailRow(
                    label: 'Token Number',
                    value: appointment.token ?? 'MC-N/A',
                    valColor: textColor,
                  ),
                  AppointmentDetailRow(
                    label: 'Consultation Type',
                    value: appointment.type,
                    valColor: textColor,
                  ),
                  AppointmentDetailRow(
                    label: 'Consultation Fee',
                    value: '₹${appointment.amount ?? 500}',
                    valColor: AppColors.primary,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Vitals
            Text(
              'Recorded Vitals',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w900,
                color: textColor,
              ),
            ),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.border(context)),
              ),
              child:
                  (appointment.bp == null &&
                      appointment.weight == null &&
                      appointment.height == null &&
                      appointment.fever == null)
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.r),
                        child: Text(
                          'No vitals recorded for this appointment yet.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        if (appointment.bp != null)
                          AppointmentDetailRow(
                            label: 'Blood Pressure',
                            value: appointment.bp!,
                            valColor: textColor,
                          ),
                        if (appointment.weight != null)
                          AppointmentDetailRow(
                            label: 'Weight',
                            value: '${appointment.weight} kg',
                            valColor: textColor,
                          ),
                        if (appointment.height != null)
                          AppointmentDetailRow(
                            label: 'Height',
                            value: '${appointment.height} cm',
                            valColor: textColor,
                          ),
                        if (appointment.fever != null)
                          AppointmentDetailRow(
                            label: 'Body Temperature',
                            value: '${appointment.fever} °F',
                            valColor: textColor,
                          ),
                        if (appointment.headCircumference != null)
                          AppointmentDetailRow(
                            label: 'Head Circumference',
                            value: '${appointment.headCircumference} cm',
                            valColor: textColor,
                          ),
                      ],
                    ),
            ),
            SizedBox(height: 32.h),

            // Action Buttons
            if (displayStatus.toLowerCase() == 'pending') ...[
              CommonButton(
                text: AppStrings.completePayment,
                color: AppColors.primary,
                onPressed: () {
                  _showPaymentSelectionSheet(context);
                },
              ),
              SizedBox(height: 12.h),
            ],
            if ((displayStatus.toLowerCase() == 'confirmed' ||
                    displayStatus.toLowerCase() == 'pending') &&
                _canCancelAppointment()) ...[
              CommonButton(
                text: 'Cancel Appointment',
                isOutline: true,
                color: AppColors.red,
                onPressed: () {
                  context.read<AdminAppointmentsBloc>().add(
                    CancelAppointment(appointment.id),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Appointment has been cancelled.'),
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showPaymentSelectionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) {
        return PaymentMethodSelectionSheet(
          onSelectQRCode: () {
            Navigator.pop(ctx);
            _showQRCodePaymentDialog(context);
          },
          onSelectCOD: () {
            Navigator.pop(ctx);
            _confirmCODPayment(context);
          },
        );
      },
    );
  }

  void _showQRCodePaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return QRCodePaymentDialog(
          onConfirm: () {
            Navigator.pop(ctx);
            context.read<AdminAppointmentsBloc>().add(
              ConfirmAppointmentPayment(appointment.id),
            );
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'UPI payment verified and completed successfully!',
                ),
              ),
            );
            Navigator.pop(context);
          },
        );
      },
    );
  }

  void _confirmCODPayment(BuildContext context) {
    context.read<AdminAppointmentsBloc>().add(
      ConfirmAppointmentPayment(appointment.id),
    );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Payment registered as Pay at Counter (COD).'),
      ),
    );
    Navigator.pop(context);
  }
}
