import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/doctor_image_widget.dart';
import 'package:medi_connect/features/patient/booking/presentation/pages/patient_all_appointments_page.dart';
import 'package:medi_connect/features/patient/booking/presentation/pages/patient_appointment_detail_page.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/shared/dashboard/domain/entities/appointment_entity.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_appointments_bloc.dart';
import 'package:intl/intl.dart';

class PatientUpcomingAppointments extends StatefulWidget {
  const PatientUpcomingAppointments({super.key});

  @override
  State<PatientUpcomingAppointments> createState() =>
      _PatientUpcomingAppointmentsState();
}

class _PatientUpcomingAppointmentsState
    extends State<PatientUpcomingAppointments> {
  @override
  void initState() {
    super.initState();
    // Ensure we trigger load on entry to always have fresh data
    context.read<AdminAppointmentsBloc>().add(LoadAppointments());
  }

  bool _isFutureAppointment(DateTime date, String timeStr) {
    try {
      final format = DateFormat('hh:mm a');
      final parsedTime = format.parse(timeStr.trim());
      final combined = DateTime(
        date.year,
        date.month,
        date.day,
        parsedTime.hour,
        parsedTime.minute,
      );
      return combined.isAfter(DateTime.now());
    } catch (_) {
      final now = DateTime.now();
      final todayDateOnly = DateTime(now.year, now.month, now.day);
      return date.isAfter(todayDateOnly) ||
          date.isAtSameMomentAs(todayDateOnly);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : AppColors.surface;
    final textColor = isDark ? AppColors.surface : AppColors.terminalLightText;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! Authenticated) {
          return const SizedBox.shrink();
        }

        final user = UserModel.fromEntity(authState.user);

        return BlocBuilder<AdminAppointmentsBloc, AdminAppointmentsState>(
          builder: (context, aptState) {
            List<AppointmentEntity> upcomingApts = [];
            if (aptState is AdminAppointmentsLoaded) {
              upcomingApts = aptState.appointments
                  .where(
                    (apt) =>
                        apt.patientId == user.id &&
                        (apt.status.toLowerCase() == 'confirmed' ||
                            apt.status.toLowerCase() == 'pending') &&
                        _isFutureAppointment(
                          apt.appointmentDate,
                          apt.appointmentTime,
                        ),
                  )
                  .toList();

              // Sort by date (closest upcoming first)
              upcomingApts.sort((a, b) {
                final dateCompare = a.appointmentDate.compareTo(
                  b.appointmentDate,
                );
                if (dateCompare != 0) return dateCompare;
                return a.appointmentTime.compareTo(b.appointmentTime);
              });
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Upcoming Appointments',
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 16.sp,
                        color: textColor,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) =>
                                const PatientAllAppointmentsPage(),
                          ),
                        );
                      },
                      child: Text(
                        'View All >',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 11.sp,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),

                if (upcomingApts.isEmpty)
                  _buildNoUpcomingCard(context, cardBg, textColor)
                else
                  _buildUpcomingAptCard(
                    context,
                    upcomingApts.first,
                    cardBg,
                    textColor,
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildNoUpcomingCard(
    BuildContext context,
    Color cardBg,
    Color textColor,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.event_note_outlined,
            color: Colors.grey.shade400,
            size: 36.r,
          ),
          SizedBox(height: 10.h),
          Text(
            'No upcoming appointments scheduled.',
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            'Regular medical checkups help you stay healthy.',
            style: TextStyle(
              fontSize: 8.5.sp,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingAptCard(
    BuildContext context,
    AppointmentEntity apt,
    Color cardBg,
    Color textColor,
  ) {
    final formattedDate = DateFormat(
      'EEEE, d MMMM yyyy',
    ).format(apt.appointmentDate);
    final isPending = apt.status.toLowerCase() == 'pending';
    final statusColor = isPending
        ? const Color(0xFFF59E0B)
        : const Color(0xFF10B981);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (ctx) => PatientAppointmentDetailPage(appointment: apt),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.border(context)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10.r,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Doctor Avatar placeholder
            DoctorImageWidget(doctorId: apt.doctorId, size: 46.r),
            SizedBox(width: 14.w),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        apt.doctorName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w900,
                          color: textColor,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Icon(
                        Icons.verified_rounded,
                        color: const Color(0xFF3B5BFD),
                        size: 12.r,
                      ),
                    ],
                  ),
                  Text(
                    '${apt.specialty} Specialty',
                    style: TextStyle(
                      fontSize: 9.sp,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        color: AppColors.primary,
                        size: 12.r,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '$formattedDate Ã¢â‚¬Â¢ ${apt.appointmentTime}',
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: textColor,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Status Badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: statusColor.withValues(alpha: 0.2)),
              ),
              child: Text(
                isPending ? 'Pending Payment' : 'Confirmed',
                style: TextStyle(
                  color: statusColor,
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
