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
import 'package:medi_connect/shared/dashboard/presentation/widgets/appointments/consultation_complete_sheet.dart';

class DoctorScheduleTab extends StatefulWidget {
  const DoctorScheduleTab({super.key});

  @override
  State<DoctorScheduleTab> createState() => _DoctorScheduleTabState();
}

class _DoctorScheduleTabState extends State<DoctorScheduleTab> {
  DateTime _selectedDate = DateTime.now();
  String _searchQuery = "";
  String _selectedStatus = "All";
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ConsultationCompleteSheet(appointment: apt),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Confirmed':
        return AppColors.success;
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
        final docDisplayName =
            doctor.name ??
            "${doctor.firstName ?? ''} ${doctor.lastName ?? ''}".trim();

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
                final matchesStatus =
                    _selectedStatus == 'All' ||
                    a.status.toLowerCase() == _selectedStatus.toLowerCase();

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

                    // Selected Date indicator

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
                                  //  vertical: 6.h,
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children:
                            [
                              'All',
                              'Confirmed',
                              'Pending',
                              'Completed',
                              'Cancelled',
                            ].map((status) {
                              final isSelected = _selectedStatus == status;
                              return Padding(
                                padding: EdgeInsets.only(right: 8.w),
                                child: ChoiceChip(
                                  label: Text(
                                    status,
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : _getChipTextColor(status, isDark),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.sp,
                                    ),
                                  ),
                                  selected: isSelected,
                                  selectedColor: const Color(0xFF0F6FFF),
                                  backgroundColor: _getChipBgColor(
                                    status,
                                    isDark,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.r),
                                    side: BorderSide(
                                      color: isSelected
                                          ? Colors.transparent
                                          : _getChipBorderColor(status, isDark),
                                    ),
                                  ),
                                  showCheckmark: false,
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _selectedStatus = status;
                                      });
                                    }
                                  },
                                ),
                              );
                            }).toList(),
                      ),
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
                              final timeParts = apt.appointmentTime.split(" ");
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
                                    _buildTimelineIndicator(
                                      _getStatusColor(apt.status),
                                      idx,
                                      filteredApts.length,
                                    ),

                                    // Card content
                                    Expanded(
                                      child: PremiumAppointmentCard(
                                        appointment: apt,
                                        onCancel: () {
                                          context
                                              .read<DoctorAppointmentsBloc>()
                                              .add(
                                                CancelDoctorAppointment(apt.id),
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
                                  ],
                                ),
                              );
                            },
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

  Widget _buildTimelineIndicator(Color color, int index, int totalCount) {
    return SizedBox(
      width: 24.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Line
          if (totalCount > 1)
            Positioned(
              top: index == 0 ? 24.h : 0,
              bottom: index == totalCount - 1 ? 24.h : 0,
              child: Container(
                width: 2.w,
                color: AppColors.border(context).withValues(alpha: 0.5),
              ),
            ),
          // Dot
          Positioned(
            top: 24.h,
            child: Container(
              width: 10.r,
              height: 10.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.4),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getChipBgColor(String status, bool isDark) {
    if (status == 'All') return const Color(0xFF0F6FFF).withValues(alpha: 0.1);
    switch (status) {
      case 'Confirmed':
        return isDark
            ? AppColors.statusConfirmedBgDark.withValues(alpha: 0.3)
            : AppColors.statusConfirmedBgLight;
      case 'Pending':
        return isDark
            ? AppColors.statusPendingBgDark.withValues(alpha: 0.3)
            : AppColors.statusPendingBgLight;
      case 'Completed':
        return isDark
            ? AppColors.statusCompletedBgDark.withValues(alpha: 0.3)
            : AppColors.statusCompletedBgLight;
      case 'Cancelled':
      default:
        return isDark
            ? AppColors.statusCancelledBgDark.withValues(alpha: 0.3)
            : AppColors.statusCancelledBgLight;
    }
  }

  Color _getChipBorderColor(String status, bool isDark) {
    if (status == 'All') return const Color(0xFF0F6FFF).withValues(alpha: 0.3);
    switch (status) {
      case 'Confirmed':
        return AppColors.success.withValues(alpha: 0.3);
      case 'Pending':
        return AppColors.warning.withValues(alpha: 0.3);
      case 'Completed':
        return AppColors.infoPurple.withValues(alpha: 0.3);
      case 'Cancelled':
      default:
        return AppColors.error.withValues(alpha: 0.3);
    }
  }

  Color _getChipTextColor(String status, bool isDark) {
    if (status == 'All') return const Color(0xFF0F6FFF);
    switch (status) {
      case 'Confirmed':
        return isDark
            ? AppColors.statusConfirmedTextDark
            : AppColors.statusConfirmedTextLight;
      case 'Pending':
        return isDark
            ? AppColors.statusPendingTextDark
            : AppColors.statusPendingTextLight;
      case 'Completed':
        return isDark
            ? AppColors.statusCompletedTextDark
            : AppColors.statusCompletedTextLight;
      case 'Cancelled':
      default:
        return isDark
            ? AppColors.statusCancelledTextDark
            : AppColors.statusCancelledTextLight;
    }
  }
}
