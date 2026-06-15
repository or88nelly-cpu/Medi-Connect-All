import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/doctor/doctor_appointments_bloc.dart';
import 'package:medi_connect/features/dash_board/domain/entities/appointment_entity.dart';

class DoctorConsultsTab extends StatelessWidget {
  const DoctorConsultsTab({super.key});

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! Authenticated) {
          return const Center(child: Text("Please login to see consultations"));
        }
        final doctor = authState.user;
        final docDisplayName =
            doctor.name ??
            "${doctor.firstName ?? ''} ${doctor.lastName ?? ''}".trim();

        return BlocBuilder<DoctorAppointmentsBloc, DoctorAppointmentsState>(
          builder: (context, state) {
            if (state is DoctorAppointmentsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is DoctorAppointmentsLoaded) {
              final appointments = state.appointments;

              // Filter for current logged-in doctor
              final doctorApts = appointments.where((a) {
                final matchId = a.doctorId == doctor.id;
                final matchName =
                    a.doctorName.toLowerCase().replaceAll("dr.", "").trim() ==
                    docDisplayName.toLowerCase().replaceAll("dr.", "").trim();
                return matchId || matchName;
              }).toList();

              // Filter for upcoming Video consultations that are not Cancelled or Completed
              final upcomingVideoApts = doctorApts.where((a) {
                final isVideo =
                    a.type.toLowerCase().contains("video") ||
                    a.type.toLowerCase().contains("virtual") ||
                    a.specialty.toLowerCase().contains("video");
                final isNotDone =
                    a.status != 'Cancelled' && a.status != 'Completed';

                // Compare dates
                final today = DateTime.now();
                final isTodayOrFuture = a.appointmentDate.isAfter(
                  today.subtract(const Duration(days: 1)),
                );

                return isVideo && isNotDone && isTodayOrFuture;
              }).toList();

              // Sort chronologically (by date, then time if dates are equal)
              upcomingVideoApts.sort((a, b) {
                final dateCompare = a.appointmentDate.compareTo(
                  b.appointmentDate,
                );
                if (dateCompare != 0) return dateCompare;
                return a.appointmentTime.compareTo(b.appointmentTime);
              });

              final hasUpcoming = upcomingVideoApts.isNotEmpty;
              final AppointmentEntity? nextApt = hasUpcoming
                  ? upcomingVideoApts.first
                  : null;

              return Padding(
                padding: EdgeInsets.all(20.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Video Consultations",
                      style: AppTextStyles.headingMedium.copyWith(
                        fontSize: 22.sp,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: const BorderSide(color: AppColors.border),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(20.r),
                        child: Column(
                          children: [
                            Icon(
                              Icons.video_camera_front_outlined,
                              size: 60.r,
                              color: hasUpcoming
                                  ? AppColors.secondary
                                  : Colors.grey[400],
                            ),
                            SizedBox(height: 12.h),
                            Text(
                              hasUpcoming
                                  ? "Next Virtual Session"
                                  : "No Upcoming Sessions",
                              style: AppTextStyles.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            if (hasUpcoming && nextApt != null) ...[
                              Text(
                                "Patient: ${nextApt.patientName}",
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                "Time: ${_formatAptDateTime(nextApt.appointmentDate, nextApt.appointmentTime)}",
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 16.h),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Launching video consultation room for ${nextApt.patientName}...",
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.video_call,
                                    color: Colors.white,
                                  ),
                                  label: const Text(
                                    "Launch Consult",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.secondary,
                                    padding: EdgeInsets.symmetric(
                                      vertical: 12.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.r),
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              Text(
                                "You have no virtual sessions scheduled for today or upcoming days.",
                                textAlign: TextAlign.center,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return const Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }

  String _formatAptDateTime(DateTime date, String time) {
    final now = DateTime.now();
    final dateStr = _isSameDay(date, now)
        ? "Today"
        : _isSameDay(date, now.add(const Duration(days: 1)))
        ? "Tomorrow"
        : DateFormat('dd MMM yyyy').format(date);
    return "$dateStr, $time";
  }
}
