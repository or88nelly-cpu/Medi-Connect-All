import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/doctor/doctor_appointments_bloc.dart';

class DoctorConsultationsCard extends StatelessWidget {
  const DoctorConsultationsCard({super.key});

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! Authenticated) {
          return const SizedBox.shrink();
        }
        final doctor = authState.user;
        final docDisplayName =
            doctor.name ??
            "${doctor.firstName ?? ''} ${doctor.lastName ?? ''}".trim();

        return BlocBuilder<DoctorAppointmentsBloc, DoctorAppointmentsState>(
          builder: (context, state) {
            if (state is DoctorAppointmentsLoading) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (state is DoctorAppointmentsError) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    "Error loading schedule",
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              );
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

              // Filter for today
              final todayApts = doctorApts
                  .where((a) => _isSameDay(a.appointmentDate, DateTime.now()))
                  .toList();

              // Sort chronologically
              todayApts.sort(
                (a, b) => a.appointmentTime.compareTo(b.appointmentTime),
              );

              if (todayApts.isEmpty) {
                return Card(
                  elevation: 0,
                  color: isDark ? AppColors.terminalDarkCard : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                    side: BorderSide(color: AppColors.border(context)),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(24.r),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            color: Colors.grey[400],
                            size: 32.r,
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            "No appointments scheduled for today",
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return Card(
                elevation: 0,
                color: isDark ? AppColors.terminalDarkCard : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                  side: BorderSide(color: AppColors.border(context)),
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: todayApts.length,
                  separatorBuilder: (context, idx) =>
                      Divider(color: AppColors.border(context), height: 1),
                  itemBuilder: (context, idx) {
                    final apt = todayApts[idx];

                    // Split Time column (e.g. "10:30 AM" -> "10:30" and "AM")
                    final timeParts = apt.appointmentTime.split(" ");
                    final timeVal = timeParts[0];
                    final timePeriod = timeParts.length > 1 ? timeParts[1] : "";

                    // Determine leading avatar background and icon
                    final isVideo =
                        apt.type.toLowerCase().contains("video") ||
                        apt.type.toLowerCase().contains("virtual") ||
                        apt.specialty.toLowerCase().contains("video");

                    Color avatarBg;
                    Color iconColor;
                    IconData icon;

                    if (isVideo) {
                      avatarBg = isDark
                          ? const Color(0xFF143A24)
                          : const Color(0xFFE6F4EA);
                      iconColor = isDark
                          ? const Color(0xFF34D399)
                          : const Color(0xFF137333);
                      icon = Icons.videocam;
                    } else {
                      final useBlue = idx % 2 == 0;
                      avatarBg = useBlue
                          ? (isDark
                                ? const Color(0xFF1A365D)
                                : const Color(0xFFE8F0FE))
                          : (isDark
                                ? const Color(0xFF3B0764)
                                : const Color(0xFFF3E8FF));
                      iconColor = useBlue
                          ? (isDark
                                ? const Color(0xFF60A5FA)
                                : const Color(0xFF1A73E8))
                          : (isDark
                                ? const Color(0xFFC084FC)
                                : const Color(0xFF7E22CE));
                      icon = Icons.person;
                    }

                    // Dynamically check if this is a new patient based on appointment count
                    final isNewPatient =
                        doctorApts
                            .where((a) => a.patientId == apt.patientId)
                            .length <=
                        1;
                    final patientType = isNewPatient
                        ? "New Patient"
                        : "Follow up";

                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 12.h,
                      ),
                      leading: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Time indicators
                          SizedBox(
                            width: 50.w,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  timeVal,
                                  style: TextStyle(
                                    color: isDark
                                        ? const Color(0xFF60A5FA)
                                        : const Color(0xFF1A73E8),
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  timePeriod,
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white30
                                        : Colors.grey[400],
                                    fontSize: 9.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 4.w),
                          // Custom Icon
                          CircleAvatar(
                            radius: 20.r,
                            backgroundColor: avatarBg,
                            child: Icon(icon, color: iconColor, size: 20.r),
                          ),
                        ],
                      ),
                      title: Text(
                        apt.patientName,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : AppColors.textPrimary(context),
                        ),
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(top: 4.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              apt.type,
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white60
                                    : Colors.grey[600],
                                fontSize: 11.sp,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              patientType,
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white30
                                    : Colors.grey[400],
                                fontSize: 9.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildStatusChip(apt.status, idx, isDark),
                          SizedBox(width: 8.w),
                          Icon(
                            Icons.chevron_right,
                            color: isDark ? Colors.white30 : Colors.grey[400],
                            size: 16.r,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              );
            }

            return const SizedBox.shrink();
          },
        );
      },
    );
  }

  Widget _buildStatusChip(String status, int index, bool isDark) {
    Color bg;
    Color text;
    IconData icon;

    if (status == 'Confirmed') {
      bg = isDark ? const Color(0xFF064E3B) : const Color(0xFFE6F4EA);
      text = isDark ? const Color(0xFF34D399) : const Color(0xFF137333);
      icon = Icons.check;
    } else if (status == 'Completed') {
      bg = isDark ? const Color(0xFF581C87) : const Color(0xFFF3E8FF);
      text = isDark ? const Color(0xFFC084FC) : const Color(0xFF7E22CE);
      icon = Icons.check_circle_outline;
    } else if (status == 'Cancelled') {
      bg = isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFCE8E6);
      text = isDark ? const Color(0xFFFCA5A5) : const Color(0xFFC5221F);
      icon = Icons.close;
    } else {
      final useOrange = index % 2 == 0;
      bg = useOrange
          ? (isDark ? const Color(0xFF7C2D12) : const Color(0xFFFFF7ED))
          : (isDark ? const Color(0xFF1E3A8A) : const Color(0xFFEFF6FF));
      text = useOrange ? const Color(0xFFFB923C) : const Color(0xFF60A5FA);
      icon = Icons.access_time;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: text, size: 10.r),
          SizedBox(width: 4.w),
          Text(
            status == 'Confirmed' ? 'Confirmed' : 'Upcoming',
            style: TextStyle(
              color: text,
              fontSize: 8.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
