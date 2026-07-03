import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/core/widgets/appbar/common_app_bar.dart';
import 'package:medi_connect/core/widgets/buttons/common_button.dart';
import 'package:medi_connect/shared/dashboard/domain/entities/appointment_entity.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_appointments_bloc.dart';
import 'package:medi_connect/modules/patient/booking/presentation/widgets/doctor_image_widget.dart';
import 'package:intl/intl.dart';

class PatientAppointmentDetailPage extends StatelessWidget {
  final AppointmentEntity appointment;

  const PatientAppointmentDetailPage({
    super.key,
    required this.appointment,
  });

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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;

    var displayStatus = appointment.status;
    var isExpiredPending = false;

    if (appointment.status.toLowerCase() == 'pending' && _isAppointmentInPast()) {
      displayStatus = 'Cancelled';
      isExpiredPending = true;
    }

    // Status Pill Colors
    Color statusColor = const Color(0xFF10B981); // Green Confirmed
    if (displayStatus.toLowerCase() == 'pending') {
      statusColor = const Color(0xFFF59E0B); // Orange Pending
    } else if (displayStatus.toLowerCase() == 'cancelled') {
      statusColor = const Color(0xFFEF4444); // Red Cancelled
    } else if (displayStatus.toLowerCase() == 'completed') {
      statusColor = const Color(0xFF3B82F6); // Blue Completed
    }

    final dateStr = DateFormat('EEEE, d MMMM yyyy').format(appointment.appointmentDate);

    return CustomScaffold(
      customAppbar: const CommonAppBar(
        title: "Appointment Details",
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner / Stepper Info
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
                        : (displayStatus.toLowerCase() == 'pending' ? Icons.warning_amber_rounded : Icons.check_circle_outline_rounded),
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
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w900, color: textColor),
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
                          style: TextStyle(fontSize: 9.sp, color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Icon(Icons.location_on_rounded, color: AppColors.primary, size: 10.r),
                            SizedBox(width: 4.w),
                            Text(
                              'MediConnect Hospital • OPD Room 3A',
                              style: TextStyle(fontSize: 8.5.sp, color: Colors.grey, fontWeight: FontWeight.bold),
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
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w900, color: textColor),
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
                  _buildDetailRow('Date', dateStr, textColor),
                  _buildDetailRow('Time slot', appointment.appointmentTime, textColor),
                  _buildDetailRow('Token Number', appointment.token ?? 'MC-N/A', textColor),
                  _buildDetailRow('Consultation Type', appointment.type, textColor),
                  _buildDetailRow('Consultation Fee', '₹${appointment.amount ?? 500}', AppColors.primary),
                ],
              ),
            ),
            SizedBox(height: 20.h),

            // Vitals
            Text(
              'Recorded Vitals',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w900, color: textColor),
            ),
            SizedBox(height: 10.h),
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: AppColors.border(context)),
              ),
              child: (appointment.bp == null && appointment.weight == null && appointment.height == null && appointment.fever == null)
                  ? Center(
                      child: Padding(
                        padding: EdgeInsets.all(8.r),
                        child: Text(
                          'No vitals recorded for this appointment yet.',
                          style: TextStyle(color: Colors.grey, fontSize: 10.sp, fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : Column(
                      children: [
                        if (appointment.bp != null) _buildDetailRow('Blood Pressure', appointment.bp!, textColor),
                        if (appointment.weight != null) _buildDetailRow('Weight', '${appointment.weight} kg', textColor),
                        if (appointment.height != null) _buildDetailRow('Height', '${appointment.height} cm', textColor),
                        if (appointment.fever != null) _buildDetailRow('Body Temperature', '${appointment.fever} °F', textColor),
                        if (appointment.headCircumference != null) _buildDetailRow('Head Circumference', '${appointment.headCircumference} cm', textColor),
                      ],
                    ),
            ),
            SizedBox(height: 32.h),

            // Action Buttons
            if (displayStatus.toLowerCase() == 'pending') ...[
              CommonButton(
                text: 'Complete Payment Now',
                color: const Color(0xFF3B5BFD),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Payment gateway starting...')),
                  );
                },
              ),
              SizedBox(height: 12.h),
            ],
            if (displayStatus.toLowerCase() == 'confirmed' || displayStatus.toLowerCase() == 'pending') ...[
              CommonButton(
                text: 'Cancel Appointment',
                isOutline: true,
                color: Colors.red,
                onPressed: () {
                  context.read<AdminAppointmentsBloc>().add(CancelAppointment(appointment.id));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Appointment has been cancelled.')),
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

  Widget _buildDetailRow(String label, String value, Color valColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 10.sp, fontWeight: FontWeight.bold)),
          Text(value, style: TextStyle(color: valColor, fontSize: 10.sp, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
