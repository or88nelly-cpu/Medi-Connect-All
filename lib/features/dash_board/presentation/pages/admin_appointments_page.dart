import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/dash_board/domain/entities/appointment_entity.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/admin_appointments_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/appointments/admin_appointments_filter_cubit.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/appointments/appointments_header.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/appointments/appointments_search_bar.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/appointments/appointments_status_filter.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/appointments/appointments_overview_section.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/appointments/appointment_card.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/appointments/appointments_bottom_banner.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/appointments/consultation_complete_sheet.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/appointments/create_appointment_wizard_dialog.dart';

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
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (_) => AdminAppointmentsFilterCubit(),
      child: Builder(
        builder: (context) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(
              horizontal: 20.r,
              vertical: 16.r,
            ).copyWith(top: 0.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppointmentsHeader(
                  onBookNew: () => _showCreateAppointmentWizard(context),
                ),
                SizedBox(height: 12.r),
                const AppointmentsSearchBar(),
                SizedBox(height: 8.r),
                BlocBuilder<AdminAppointmentsBloc, AdminAppointmentsState>(
                  builder: (context, appointmentsState) {
                    if (appointmentsState is AdminAppointmentsLoading) {
                      return SizedBox(
                        height: 300.h,
                        child: const Center(child: CircularProgressIndicator()),
                      );
                    }
                    if (appointmentsState is AdminAppointmentsError) {
                      return SizedBox(
                        height: 300.h,
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

                      // Calculate counts dynamically based on ALL appointments
                      final totalCount = appointments.length;
                      final confirmedCount = appointments
                          .where((a) => a.status == 'Confirmed')
                          .length;
                      final pendingCount = appointments
                          .where((a) => a.status == 'Pending')
                          .length;
                      final completedCount = appointments
                          .where((a) => a.status == 'Completed')
                          .length;
                      final cancelledCount = appointments
                          .where((a) => a.status == 'Cancelled')
                          .length;

                      final statusCounts = {
                        'All': totalCount,
                        'Confirmed': confirmedCount,
                        'Pending': pendingCount,
                        'Completed': completedCount,
                        'Cancelled': cancelledCount,
                      };

                      return BlocBuilder<
                        AdminAppointmentsFilterCubit,
                        AdminAppointmentsFilterState
                      >(
                        builder: (context, filterState) {
                          // Filter list for selected date + status + search query
                          final filteredList = appointments.where((apt) {
                            final matchesStatus =
                                filterState.filterStatus == 'All' ||
                                apt.status.toLowerCase() ==
                                    filterState.filterStatus.toLowerCase();
                            final matchesDate = _isSameDay(
                              apt.appointmentDate,
                              filterState.selectedDate,
                            );
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
                            return matchesStatus &&
                                matchesDate &&
                                matchesSearch;
                          }).toList();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppointmentsStatusFilter(
                                statusCounts: statusCounts,
                              ),
                              SizedBox(height: 16.h),
                              AppointmentsOverviewSection(
                                appointments: appointments,
                                selectedDate: filterState.selectedDate,
                                onDateChanged: (newDate) {
                                  context
                                      .read<AdminAppointmentsFilterCubit>()
                                      .changeSelectedDate(newDate);
                                },
                              ),
                              SizedBox(height: 20.h),
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
                                                      .withOpacity(0.5),
                                            size: 48.r,
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
                                        return AppointmentCard(
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
                              SizedBox(height: 12.h),
                              AppointmentsBottomBanner(
                                onBookNew: () =>
                                    _showCreateAppointmentWizard(context),
                              ),
                            ],
                          );
                        },
                      );
                    }
                    return SizedBox(
                      height: 300.h,
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showCreateAppointmentWizard(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const CreateAppointmentWizardBottomSheet(),
    );
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
}
