import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/shared/dashboard/domain/entities/appointment_entity.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/doctor/doctor_appointments_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/appointments/premium_appointment_card.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/appointments/appointment_summary_card.dart';
import 'package:medi_connect/features/doctors/dashboard/presentation/widgets/doctor_dashboard/slot_management_grid.dart';
import 'package:medi_connect/features/doctors/dashboard/presentation/widgets/doctor_dashboard/schedule_timeline_indicator.dart';
import 'package:medi_connect/features/doctors/dashboard/presentation/widgets/doctor_dashboard/schedule_status_chips.dart';
import 'package:medi_connect/features/doctors/dashboard/presentation/pages/patient_visit_detail_page.dart';
import 'package:medi_connect/features/admin/management/patient_management/presentation/bloc/patient_bloc.dart';
import 'package:medi_connect/shared/auth/domain/entities/user_entity.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/core/constants/app_enum.dart';

class DoctorScheduleTab extends StatefulWidget {
  const DoctorScheduleTab({super.key});

  @override
  State<DoctorScheduleTab> createState() => _DoctorScheduleTabState();
}

class _DoctorScheduleTabState extends State<DoctorScheduleTab> {
  DateTime _selectedDate = DateTime.now();
  String _searchQuery = "";
  String _selectedStatus = "All";
  int _activeSubTab = 0; // 0 = Appointments List, 1 = Slot Management Grid
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  int _compareTimes(String t1, String t2) {
    try {
      final format = DateFormat("hh:mm a");
      final d1 = format.parse(t1.trim());
      final d2 = format.parse(t2.trim());
      return d1.compareTo(d2);
    } catch (_) {
      return t1.compareTo(t2);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  String _greetingMessage() {
    final hour = DateTime.now().hour;
    if (hour < 12) return "Good Morning";
    if (hour < 17) return "Good Afternoon";
    return "Good Evening";
  }

  void _showConsultationCompleteSheet(
    BuildContext context,
    AppointmentEntity apt,
  ) {
    UserModel? patientUser;
    try {
      final patientState = context.read<PatientBloc>().state;
      if (patientState is PatientLoaded) {
        final matches = patientState.patients.where(
          (p) =>
              p.id == apt.patientId ||
              p.fullName.toLowerCase().trim() ==
                  apt.patientName.toLowerCase().trim(),
        );
        if (matches.isNotEmpty) {
          patientUser = matches.first;
        }
      }
    } catch (_) {}

    final patientEntity = patientUser != null
        ? UserEntity(
            id: patientUser.id,
            //fullName: patientUser.fullName,
            firstName: patientUser.firstName,
            lastName: patientUser.lastName,
            email: patientUser.email ?? '',
            phone: patientUser.phone,
            role: UserRole.patient,
            dob: patientUser.dob,
            gender: patientUser.gender,
            bloodGroup: patientUser.bloodGroup,
            profilePhoto: patientUser.profilePhoto,
          )
        : UserEntity(
            id: apt.patientId ?? '',
            firstName: apt.patientName.split(" ").first,
            lastName: apt.patientName.split(" ").first,
            email: '',
            role: UserRole.patient,
          );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PatientVisitDetailPage(appointment: apt, patient: patientEntity),
      ),
    );
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

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return AppColors.success;
      case 'Pending MRD':
        return AppColors.infoPurple;
      case 'Pending':
        return AppColors.warning;
      case 'Completed':
        return AppColors.infoPurple;
      case 'Cancelled':
      default:
        return AppColors.error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! Authenticated) {
          return const Center(child: Text("Please login to see schedule"));
        }
        final doctor = authState.user;
        final docDisplayName = doctor.fullName;

        return BlocBuilder<DoctorAppointmentsBloc, DoctorAppointmentsState>(
          builder: (context, aptState) {
            if (aptState is DoctorAppointmentsLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (aptState is DoctorAppointmentsError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: AppColors.error,
                      size: 48.r,
                    ),
                    SizedBox(height: 12.h),
                    Text(
                      "Error loading appointments",
                      style: AppTextStyles.titleMedium,
                    ),
                    Text(aptState.message, style: AppTextStyles.bodyMedium),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () => context
                          .read<DoctorAppointmentsBloc>()
                          .add(LoadDoctorAppointments()),
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );
            }

            if (aptState is DoctorAppointmentsLoaded) {
              final appointments = aptState.appointments;

              // Filter for current logged-in doctor
              final doctorApts = appointments.where((a) {
                final matchId = a.doctorId == doctor.id;
                final matchName =
                    a.doctorName.toLowerCase().replaceAll("dr.", "").trim() ==
                    docDisplayName.toLowerCase().replaceAll("dr.", "").trim();
                return matchId || matchName;
              }).toList();

              // Compute counts for TODAY'S SCHEDULE card
              final targetDateApts = doctorApts
                  .where((a) => _isSameDay(a.appointmentDate, _selectedDate))
                  .toList();
              final totalCount = targetDateApts.length;
              final completedCount = targetDateApts
                  .where((a) => a.status == 'Completed')
                  .length;
              final pendingCount = targetDateApts
                  .where((a) => a.status == 'Pending')
                  .length;
              final cancelledCount = targetDateApts
                  .where((a) => a.status == 'Cancelled')
                  .length;

              // Filter current appointments list
              final filteredApts = targetDateApts.where((a) {
                var displayStatus = a.status;
                if (a.status.toLowerCase() != 'completed' &&
                    a.status.toLowerCase() != 'cancelled' &&
                    _isAppointmentInPast(
                      a.appointmentDate,
                      a.appointmentTime,
                    )) {
                  displayStatus = 'Pending MRD';
                }

                final matchesStatus =
                    _selectedStatus == 'All' ||
                    displayStatus.toLowerCase() ==
                        _selectedStatus.toLowerCase() ||
                    (_selectedStatus == 'Pending' &&
                        displayStatus == 'Pending MRD');

                final matchesSearch =
                    a.patientName.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    ) ||
                    a.specialty.toLowerCase().contains(
                      _searchQuery.toLowerCase(),
                    );

                return matchesStatus && matchesSearch;
              }).toList();

              // Sort by chronological time
              filteredApts.sort(
                (a, b) => _compareTimes(a.appointmentTime, b.appointmentTime),
              );

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Greeting Header
                    Text(
                      "${_greetingMessage()}, Dr. ${docDisplayName.replaceAll("Dr", "").replaceAll("dr.", "").trim()} 👋",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.terminalDarkLabel
                            : AppColors.textSecondary(context),
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppStrings.appointments,
                          style: AppTextStyles.headingMedium.copyWith(
                            color: isDark
                                ? Colors.white
                                : AppColors.textPrimary(context),
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.refresh,
                            color: isDark
                                ? Colors.white70
                                : AppColors.textSecondary(context),
                            size: 24.r,
                          ),
                          onPressed: () {
                            context.read<DoctorAppointmentsBloc>().add(
                              LoadDoctorAppointments(),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Refreshing appointments list...",
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),

                    SizedBox(height: 12.h),

                    // Custom sub-tab segmented controller
                    Container(
                      margin: EdgeInsets.only(bottom: 20.h),
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _activeSubTab = 0),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                decoration: BoxDecoration(
                                  color: _activeSubTab == 0
                                      ? (isDark
                                            ? const Color(0xFF0F6FFF)
                                            : Colors.white)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10.r),
                                  boxShadow: _activeSubTab == 0
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.05,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : [],
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Appointments List",
                                  style: TextStyle(
                                    color: _activeSubTab == 0
                                        ? (isDark
                                              ? Colors.white
                                              : const Color(0xFF0F6FFF))
                                        : (isDark
                                              ? Colors.white60
                                              : Colors.grey[600]),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _activeSubTab = 1),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 10.h),
                                decoration: BoxDecoration(
                                  color: _activeSubTab == 1
                                      ? (isDark
                                            ? const Color(0xFF0F6FFF)
                                            : Colors.white)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(10.r),
                                  boxShadow: _activeSubTab == 1
                                      ? [
                                          BoxShadow(
                                            color: Colors.black.withValues(
                                              alpha: 0.05,
                                            ),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ]
                                      : [],
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  "Slot Management",
                                  style: TextStyle(
                                    color: _activeSubTab == 1
                                        ? (isDark
                                              ? Colors.white
                                              : const Color(0xFF0F6FFF))
                                        : (isDark
                                              ? Colors.white60
                                              : Colors.grey[600]),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (_activeSubTab == 1) ...[
                      SlotManagementGrid(
                        selectedDate: _selectedDate,
                        doctor: doctor,
                      ),
                    ] else ...[
                      // Gradient summary card
                      AppointmentSummaryCard(
                        totalCount: totalCount,
                        completedCount: completedCount,
                        pendingCount: pendingCount,
                        date: _selectedDate,
                        cancelledCount: cancelledCount,
                        onViewCalendar: () => _selectDate(context),
                      ),
                      SizedBox(height: 20.h),

                      // Search input
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 40.h,
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.terminalDarkCard
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(12.r),
                                border: Border.all(
                                  color: AppColors.border(context),
                                ),
                              ),
                              child: TextField(
                                controller: _searchController,
                                onChanged: (val) =>
                                    setState(() => _searchQuery = val),
                                style: TextStyle(
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.textPrimary(context),
                                  fontSize: 12.sp,
                                ),
                                decoration: InputDecoration(
                                  hintText: "Search patient, or specialty...",
                                  hintStyle: TextStyle(
                                    color: isDark
                                        ? AppColors.terminalDarkFieldHint
                                        : Colors.grey,
                                    fontSize: 12.sp,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    color: isDark
                                        ? Colors.white54
                                        : AppColors.textSecondary(context),
                                    size: 16.r,
                                  ),
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12.w,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 12.r),
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.terminalDarkCard
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: AppColors.border(context),
                              ),
                            ),
                            child: Icon(
                              Icons.filter_list,
                              color: isDark
                                  ? Colors.white70
                                  : AppColors.textPrimary(context),
                              size: 20.r,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Status Chips
                      ScheduleStatusChips(
                        selectedStatus: _selectedStatus,
                        onStatusSelected: (status) {
                          setState(() {
                            _selectedStatus = status;
                          });
                        },
                      ),
                      SizedBox(height: 20.h),

                      // Subtitle: Date
                      Text(
                        _isSameDay(_selectedDate, DateTime.now())
                            ? "Today, ${DateFormat('dd MMMM yyyy').format(_selectedDate)}"
                            : DateFormat('dd MMMM yyyy').format(_selectedDate),
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : AppColors.textPrimary(context),
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 16.h),

                      // Timeline
                      filteredApts.isEmpty
                          ? Container(
                              height: 200.h,
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    color: AppColors.textSecondary(
                                      context,
                                    ).withValues(alpha: 0.5),
                                    size: 40.r,
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    "No appointments found",
                                    style: AppTextStyles.titleMedium.copyWith(
                                      color: isDark
                                          ? Colors.white54
                                          : AppColors.textSecondary(context),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: filteredApts.length,
                              itemBuilder: (context, idx) {
                                final apt = filteredApts[idx];
                                final timeParts = apt.appointmentTime.split(
                                  " ",
                                );
                                final timeVal = timeParts[0];
                                final timePeriod = timeParts.length > 1
                                    ? timeParts[1]
                                    : "";

                                return IntrinsicHeight(
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // Time Indicator
                                      SizedBox(
                                        width: 60.w,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 14.h),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                timeVal,
                                                style: TextStyle(
                                                  color: isDark
                                                      ? Colors.white
                                                      : AppColors.textPrimary(
                                                          context,
                                                        ),
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                timePeriod,
                                                style: TextStyle(
                                                  color: isDark
                                                      ? AppColors
                                                            .terminalDarkLabel
                                                      : AppColors.textSecondary(
                                                          context,
                                                        ),
                                                  fontSize: 10.sp,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      // Timeline vertical line and dot
                                      ScheduleTimelineIndicator(
                                        color: _getStatusColor(
                                          (apt.status.toLowerCase() !=
                                                      'completed' &&
                                                  apt.status.toLowerCase() !=
                                                      'cancelled' &&
                                                  _isAppointmentInPast(
                                                    apt.appointmentDate,
                                                    apt.appointmentTime,
                                                  ))
                                              ? 'Pending MRD'
                                              : apt.status,
                                        ),
                                        index: idx,
                                        totalCount: filteredApts.length,
                                      ),

                                      // Card content
                                      Expanded(
                                        child: GestureDetector(
                                          onTap: () {
                                            _showConsultationCompleteSheet(
                                              context,
                                              apt,
                                            );
                                          },
                                          child: PremiumAppointmentCard(
                                            appointment: apt,
                                            onCancel: () {
                                              context
                                                  .read<DoctorAppointmentsBloc>()
                                                  .add(
                                                    CancelDoctorAppointment(
                                                      apt.id,
                                                    ),
                                                  );
                                            },
                                            onComplete: () {
                                              _showConsultationCompleteSheet(
                                                context,
                                                apt,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ],
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
}
