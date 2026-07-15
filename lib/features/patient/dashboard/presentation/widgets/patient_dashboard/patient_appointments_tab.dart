import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/constants/app_enum.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/features/admin/management/staff_management/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/features/admin/management/staff_management/presentation/bloc/doctor_staff_event.dart';
import 'package:medi_connect/features/admin/management/staff_management/presentation/bloc/doctor_staff_state.dart';
import 'package:medi_connect/features/authentication/data/models/user_model.dart';
import 'package:medi_connect/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/common/dashboard/domain/entities/appointment_entity.dart';
import 'package:medi_connect/features/common/dashboard/presentation/bloc/admin/admin_appointments_bloc.dart';
import 'package:medi_connect/features/patient/booking/presentation/pages/patient_appointment_detail_page.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/doctor_image_widget.dart';

class PatientAppointmentsTab extends StatefulWidget {
  const PatientAppointmentsTab({super.key});

  @override
  State<PatientAppointmentsTab> createState() => _PatientAppointmentsTabState();
}

class _PatientAppointmentsTabState extends State<PatientAppointmentsTab> {
  @override
  void initState() {
    super.initState();
    context.read<AdminAppointmentsBloc>().add(LoadAppointments());
  }

  String _formatDateTime(DateTime date, String timeStr) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return "${months[date.month - 1]} ${date.day}, $timeStr";
  }

  bool _isAppointmentInPast(DateTime date, String timeStr) {
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
      return combined.isBefore(DateTime.now());
    } catch (_) {
      final now = DateTime.now();
      final todayDateOnly = DateTime(now.year, now.month, now.day);
      return date.isBefore(todayDateOnly);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! Authenticated) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = UserModel.fromEntity(authState.user);

        return BlocBuilder<AdminAppointmentsBloc, AdminAppointmentsState>(
          builder: (context, aptState) {
            List<AppointmentEntity> realApts = [];
            if (aptState is AdminAppointmentsLoaded) {
              realApts = aptState.appointments
                  .where((apt) => apt.patientId == user.id)
                  .toList();
            }

            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppStrings.appointments,
                        style: AppTextStyles.headingMedium.copyWith(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1E3A8A),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () => _showBookDoctorDialog(context),
                        icon: const Icon(Icons.search, color: Colors.white),
                        label: const Text(
                          'Book Doctor',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.w,
                            vertical: 10.h,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'My Scheduled Bookings',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Expanded(
                    child: aptState is AdminAppointmentsLoading
                        ? const Center(child: CircularProgressIndicator())
                        : realApts.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.calendar_month_outlined,
                                  color: AppColors.textSecondary(
                                    context,
                                  ).withValues(alpha: 0.3),
                                  size: 56.r,
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  "No scheduled appointments found.",
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary(context),
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: realApts.length,
                            itemBuilder: (context, idx) {
                              final apt = realApts[idx];
                              final doctorName = apt.doctorName;
                              final specialty = apt.specialty;
                              final type = apt.type;
                              final time = _formatDateTime(
                                apt.appointmentDate,
                                apt.appointmentTime,
                              );

                              // Dynamic Auto-Cancellation Check:
                              // If appointment is Pending and past, it cancels automatically.
                              var displayStatus = apt.status;
                              var isUnpaidAndExpired = false;
                              if (apt.status.toLowerCase() == 'pending' &&
                                  _isAppointmentInPast(
                                    apt.appointmentDate,
                                    apt.appointmentTime,
                                  )) {
                                displayStatus = 'Cancelled';
                                isUnpaidAndExpired = true;
                              } else if (apt.status.toLowerCase() !=
                                      'completed' &&
                                  apt.status.toLowerCase() != 'cancelled' &&
                                  _isAppointmentInPast(
                                    apt.appointmentDate,
                                    apt.appointmentTime,
                                  )) {
                                displayStatus = 'Pending Updation';
                              }

                              // Status Colors
                              Color statusColor = const Color(
                                0xFF10B981,
                              ); // Green Confirmed
                              if (displayStatus.toLowerCase() == 'pending') {
                                statusColor = const Color(
                                  0xFFF59E0B,
                                ); // Orange Pending
                              } else if (displayStatus == 'Pending Updation') {
                                statusColor = const Color(
                                  0xFFD97706,
                                ); // Amber/Orange Pending Updation
                              } else if (displayStatus.toLowerCase() ==
                                  'cancelled') {
                                statusColor = const Color(
                                  0xFFEF4444,
                                ); // Red Cancelled
                              } else if (displayStatus.toLowerCase() ==
                                  'completed') {
                                statusColor = const Color(
                                  0xFF3B82F6,
                                ); // Blue Completed
                              }

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (ctx) =>
                                          PatientAppointmentDetailPage(
                                            appointment: apt,
                                          ),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 12.h),
                                  padding: EdgeInsets.all(14.r),
                                  decoration: BoxDecoration(
                                    color: cardBg,
                                    borderRadius: BorderRadius.circular(16.r),
                                    border: Border.all(
                                      color: AppColors.border(context),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(
                                          alpha: 0.02,
                                        ),
                                        blurRadius: 10.r,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      // Left Profile Icon
                                      DoctorImageWidget(
                                        doctorId: apt.doctorId,
                                        size: 44.r,
                                      ),
                                      SizedBox(width: 12.w),

                                      // Summary block
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              doctorName,
                                              style: AppTextStyles.bodyMedium
                                                  .copyWith(
                                                    fontWeight: FontWeight.w900,
                                                    color: textColor,
                                                  ),
                                            ),
                                            SizedBox(height: 2.h),
                                            Text(
                                              "$specialty | $type",
                                              style: TextStyle(
                                                fontSize: 9.5.sp,
                                                color: Colors.grey,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            if (isUnpaidAndExpired) ...[
                                              SizedBox(height: 4.h),
                                              Text(
                                                'Cancelled: Payment lapsed before consultation',
                                                style: TextStyle(
                                                  fontSize: 7.5.sp,
                                                  color: const Color(
                                                    0xFFEF4444,
                                                  ),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                      ),

                                      // Status Pill & Time
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10.w,
                                              vertical: 4.h,
                                            ),
                                            decoration: BoxDecoration(
                                              color: statusColor.withValues(
                                                alpha: 0.1,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.r),
                                              border: Border.all(
                                                color: statusColor.withValues(
                                                  alpha: 0.2,
                                                ),
                                              ),
                                            ),
                                            child: Text(
                                              displayStatus,
                                              style: TextStyle(
                                                color: statusColor,
                                                fontSize: 8.5.sp,
                                                fontWeight: FontWeight.w900,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 6.h),
                                          Text(
                                            time,
                                            style: TextStyle(
                                              color: AppColors.primary,
                                              fontSize: 8.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showBookDoctorDialog(BuildContext context) {
    context.read<DoctorStaffBloc>().add(const LoadDoctorStaff('All'));
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      builder: (ctx) {
        return BlocProvider.value(
          value: context.read<DoctorStaffBloc>(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Find & Choose Doctor',
                      style: AppTextStyles.titleLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                Divider(color: AppColors.border(context)),
                SizedBox(height: 12.h),
                Expanded(
                  child: BlocBuilder<DoctorStaffBloc, DoctorStaffState>(
                    builder: (context, state) {
                      if (state is DoctorStaffLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is DoctorStaffError ||
                          state is! DoctorStaffLoaded) {
                        return _buildFallbackDoctorsList(ctx);
                      }
                      final doctors = state.doctors;
                      if (doctors.isEmpty) {
                        return _buildFallbackDoctorsList(ctx);
                      }
                      return ListView.builder(
                        itemCount: doctors.length,
                        itemBuilder: (_, idx) =>
                            _buildDoctorBookingTile(ctx, doctors[idx]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFallbackDoctorsList(BuildContext ctx) {
    final fallbackDocs = [
      const UserModel(
        id: 'doc-1',
        email: 'sarah.j@mediconnect.com',
        firstName: 'Dr. Sarah',
        lastName: 'Johnson',
        role: UserRole.doctor,
      ),
      const UserModel(
        id: 'doc-2',
        email: 'michael.c@mediconnect.com',
        firstName: 'Dr. Michael',
        lastName: 'Chen',
        role: UserRole.doctor,
      ),
      const UserModel(
        id: 'doc-3',
        email: 'james.w@mediconnect.com',
        firstName: 'Dr. James',
        lastName: 'Wilson',
        role: UserRole.doctor,
      ),
    ];
    return ListView.builder(
      itemCount: fallbackDocs.length,
      itemBuilder: (_, idx) => _buildDoctorBookingTile(ctx, fallbackDocs[idx]),
    );
  }

  Widget _buildDoctorBookingTile(BuildContext ctx, UserModel doc) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: AppColors.border(context)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.r),
        leading: CircleAvatar(
          backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
          child: Icon(
            Icons.local_hospital_outlined,
            color: AppColors.secondary,
          ),
        ),
        title: Text(
          doc.fullName,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary(context),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            Text("${'General Medicine'} | Exp: ${5} Yrs"),
            Text("Fee: ₹ 500"),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.pop(ctx);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.r),
            ),
          ),
          child: const Text('Book', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }
}
