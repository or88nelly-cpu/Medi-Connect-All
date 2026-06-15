import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/dash_board/domain/entities/appointment_entity.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/admin/admin_appointments_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/appointments/admin_appointments_filter_cubit.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/appointments/premium_appointment_card.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/appointments/appointment_summary_card.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/appointments/consultation_complete_sheet.dart';
import 'package:medi_connect/features/patient/presentation/bloc/patient_bloc.dart';

class AdminAppointmentsPage extends StatefulWidget {
  const AdminAppointmentsPage({super.key});

  @override
  State<AdminAppointmentsPage> createState() => _AdminAppointmentsPageState();
}

class _AdminAppointmentsPageState extends State<AdminAppointmentsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AdminAppointmentsBloc>().add(LoadAppointments());
    context.read<PatientBloc>().add(LoadPatients());
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

  Future<void> _selectDate(
    BuildContext context,
    DateTime currentDate,
    Function(DateTime) onChanged,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      onChanged(picked);
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => AdminAppointmentsFilterCubit(),
      child: Builder(
        builder: (context) {
          return BlocBuilder<AuthBloc, AuthState>(
            builder: (context, authState) {
              String adminName = "Administrator";
              if (authState is Authenticated) {
                adminName =
                    authState.user.name ??
                    "${authState.user.firstName ?? ''} ${authState.user.lastName ?? ''}"
                        .trim();
              }

              return BlocBuilder<AdminAppointmentsBloc, AdminAppointmentsState>(
                builder: (context, appointmentsState) {
                  if (appointmentsState is AdminAppointmentsLoading) {
                    return SizedBox(
                      height: 500.h,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  }

                  if (appointmentsState is AdminAppointmentsError) {
                    return SizedBox(
                      height: 500.h,
                      child: Center(
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
                              "Failed to load appointments",
                              style: AppTextStyles.titleMedium.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              appointmentsState.message,
                              style: AppTextStyles.bodyMedium,
                            ),
                            SizedBox(height: 16.h),
                            ElevatedButton(
                              onPressed: () {
                                context.read<AdminAppointmentsBloc>().add(
                                  LoadAppointments(),
                                );
                              },
                              child: const Text("Retry"),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (appointmentsState is AdminAppointmentsLoaded) {
                    final appointments = appointmentsState.appointments;

                    return BlocBuilder<
                      AdminAppointmentsFilterCubit,
                      AdminAppointmentsFilterState
                    >(
                      builder: (context, filterState) {
                        // Calculate today's overview stats based on the selected date
                        final targetDateApts = appointments
                            .where(
                              (a) => _isSameDay(
                                a.appointmentDate,
                                filterState.selectedDate,
                              ),
                            )
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

                        // Filter list for status & search query
                        final filteredList = targetDateApts.where((apt) {
                          final matchesStatus =
                              filterState.filterStatus == 'All' ||
                              apt.status.toLowerCase() ==
                                  filterState.filterStatus.toLowerCase();

                          final matchesSearch =
                              apt.patientName.toLowerCase().contains(
                                filterState.searchQuery.toLowerCase(),
                              ) ||
                              apt.doctorName.toLowerCase().contains(
                                filterState.searchQuery.toLowerCase(),
                              ) ||
                              apt.specialty.toLowerCase().contains(
                                filterState.searchQuery.toLowerCase(),
                              );

                          return matchesStatus && matchesSearch;
                        }).toList();

                        // Sort by chronological time
                        filteredList.sort(
                          (a, b) => _compareTimes(
                            a.appointmentTime,
                            b.appointmentTime,
                          ),
                        );

                        return SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.r,
                            vertical: 16.r,
                          ).copyWith(top: 0.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 16.h),
                              // Greeting Header
                              Text(
                                "${_greetingMessage()}, Dr. ${adminName.replaceAll("Dr.", "").replaceAll("dr.", "").trim()} 👋",
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: isDark
                                      ? AppColors.terminalDarkLabel
                                      : AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppStrings.appointments,
                                    style: AppTextStyles.headingMedium.copyWith(
                                      color: isDark
                                          ? Colors.white
                                          : AppColors.textPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24.sp,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.refresh,
                                      color: isDark
                                          ? Colors.white70
                                          : AppColors.textSecondary,
                                      size: 24.r,
                                    ),
                                    onPressed: () {
                                      context.read<AdminAppointmentsBloc>().add(
                                        LoadAppointments(),
                                      );
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
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

                              // Selected Date row
                              InkWell(
                                onTap: () => _selectDate(
                                  context,
                                  filterState.selectedDate,
                                  (newDate) => context
                                      .read<AdminAppointmentsFilterCubit>()
                                      .changeSelectedDate(newDate),
                                ),
                                borderRadius: BorderRadius.circular(8.r),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 4.h),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.calendar_today_outlined,
                                        size: 16.r,
                                        color: AppColors.primary,
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        DateFormat(
                                          'dd MMMM yyyy, EEEE',
                                        ).format(filterState.selectedDate),
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                              color: isDark
                                                  ? Colors.white70
                                                  : AppColors.textPrimary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h),

                              // Gradient summary card
                              AppointmentSummaryCard(
                                totalCount: totalCount,
                                completedCount: completedCount,
                                pendingCount: pendingCount,
                                date: filterState.selectedDate,
                                cancelledCount: cancelledCount,
                                onViewCalendar: () => _selectDate(
                                  context,
                                  filterState.selectedDate,
                                  (newDate) => context
                                      .read<AdminAppointmentsFilterCubit>()
                                      .changeSelectedDate(newDate),
                                ),
                              ),
                              SizedBox(height: 20.h),

                              // Search Bar
                              Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? AppColors.terminalDarkCard
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        border: Border.all(
                                          color: isDark
                                              ? AppColors.terminalDarkBorder
                                              : AppColors.border,
                                        ),
                                      ),
                                      child: TextField(
                                        onChanged: (val) => context
                                            .read<
                                              AdminAppointmentsFilterCubit
                                            >()
                                            .changeSearchQuery(val),
                                        style: TextStyle(
                                          color: isDark
                                              ? Colors.white
                                              : AppColors.textPrimary,
                                          fontSize: 13.sp,
                                        ),
                                        decoration: InputDecoration(
                                          hintText:
                                              "Search patient, doctor or specialty...",
                                          hintStyle: TextStyle(
                                            color: isDark
                                                ? AppColors
                                                      .terminalDarkFieldHint
                                                : Colors.grey,
                                            fontSize: 13.sp,
                                          ),
                                          prefixIcon: Icon(
                                            Icons.search,
                                            color: isDark
                                                ? Colors.white54
                                                : AppColors.textSecondary,
                                            size: 20.r,
                                          ),
                                          border: InputBorder.none,
                                          contentPadding: EdgeInsets.symmetric(
                                            vertical: 12.h,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Container(
                                    padding: EdgeInsets.all(12.r),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.terminalDarkCard
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(12.r),
                                      border: Border.all(
                                        color: isDark
                                            ? AppColors.terminalDarkBorder
                                            : AppColors.border,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.filter_list,
                                      color: isDark
                                          ? Colors.white70
                                          : AppColors.textPrimary,
                                      size: 20.r,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16.h),

                              // Status Filter chips
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
                                        final isSelected =
                                            filterState.filterStatus == status;
                                        return Padding(
                                          padding: EdgeInsets.only(right: 8.w),
                                          child: ChoiceChip(
                                            label: Text(
                                              status,
                                              style: TextStyle(
                                                color: isSelected
                                                    ? Colors.white
                                                    : _getChipTextColor(
                                                        status,
                                                        isDark,
                                                      ),
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12.sp,
                                              ),
                                            ),
                                            selected: isSelected,
                                            selectedColor: const Color(
                                              0xFF0F6FFF,
                                            ),
                                            backgroundColor: _getChipBgColor(
                                              status,
                                              isDark,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.r),
                                              side: BorderSide(
                                                color: isSelected
                                                    ? Colors.transparent
                                                    : _getChipBorderColor(
                                                        status,
                                                        isDark,
                                                      ),
                                              ),
                                            ),
                                            showCheckmark: false,
                                            onSelected: (selected) {
                                              if (selected) {
                                                context
                                                    .read<
                                                      AdminAppointmentsFilterCubit
                                                    >()
                                                    .changeFilterStatus(status);
                                              }
                                            },
                                          ),
                                        );
                                      }).toList(),
                                ),
                              ),
                              SizedBox(height: 20.h),

                              // Subtitle Date header
                              Text(
                                _isSameDay(
                                      filterState.selectedDate,
                                      DateTime.now(),
                                    )
                                    ? "Today, ${DateFormat('dd MMMM yyyy').format(filterState.selectedDate)}"
                                    : DateFormat(
                                        'dd MMMM yyyy',
                                      ).format(filterState.selectedDate),
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                  fontSize: 14.sp,
                                ),
                              ),
                              SizedBox(height: 16.h),

                              // Listing (without timeline dot-and-line indicators)
                              filteredList.isEmpty
                                  ? Container(
                                      height: 200.h,
                                      alignment: Alignment.center,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.calendar_today_outlined,
                                            color: isDark
                                                ? Colors.white30
                                                : AppColors.textSecondary
                                                      .withValues(alpha: 0.5),
                                            size: 40.r,
                                          ),
                                          SizedBox(height: 12.h),
                                          Text(
                                            AppStrings.noRecords,
                                            style: AppTextStyles.titleMedium
                                                .copyWith(
                                                  color: isDark
                                                      ? Colors.white54
                                                      : AppColors.textSecondary,
                                                ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: filteredList.length,
                                      itemBuilder: (context, idx) {
                                        final apt = filteredList[idx];
                                        return PremiumAppointmentCard(
                                          appointment: apt,
                                          onCancel: () {
                                            context
                                                .read<AdminAppointmentsBloc>()
                                                .add(CancelAppointment(apt.id));
                                          },
                                          onComplete: () {
                                            _showConsultationCompleteSheet(
                                              context,
                                              apt,
                                            );
                                          },
                                        );
                                      },
                                    ),
                              SizedBox(height: 16.h),
                            ],
                          ),
                        );
                      },
                    );
                  }

                  return SizedBox(
                    height: 500.h,
                    child: const Center(child: CircularProgressIndicator()),
                  );
                },
              );
            },
          );
        },
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
