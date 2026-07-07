import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/routes/route_names.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/common/dashboard_tab_cubit.dart';
import 'package:medi_connect/features/doctors/dashboard/presentation/bloc/doctor_dashboard_bloc.dart';
import 'package:medi_connect/features/doctors/dashboard/presentation/bloc/doctor_dashboard_event.dart';
import 'package:medi_connect/features/doctors/dashboard/presentation/bloc/doctor_dashboard_state.dart';

import 'doctor_header.dart';
import 'doctor_date_picker_pill.dart';
import 'doctor_overview_card.dart';
import 'medical_certificates_card.dart';
import 'pending_mrd_banner.dart';
import 'slot_config_card.dart';

class DoctorHomeTab extends StatefulWidget {
  const DoctorHomeTab({super.key});

  @override
  State<DoctorHomeTab> createState() => _DoctorHomeTabState();
}

class _DoctorHomeTabState extends State<DoctorHomeTab> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _loadStats();
  }

  void _loadStats() {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<DoctorDashboardBloc>().add(
        LoadDoctorDashboardData(
          doctorId: authState.user.id,
          date: _selectedDate,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, authState) {
        if (authState is Authenticated) {
          _loadStats();
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          if (authState is! Authenticated) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          final doctor = authState.user;

          return BlocBuilder<DoctorDashboardBloc, DoctorDashboardState>(
            builder: (context, state) {
              if (state is DoctorDashboardLoading ||
                  state is DoctorDashboardInitial) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                );
              }
              if (state is DoctorDashboardError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.message,
                        style: TextStyle(
                          color: AppColors.error,
                          fontSize: 14.sp,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      ElevatedButton(
                        onPressed: _loadStats,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                        ),
                        child: Text(
                          AppStrings.retry,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (state is DoctorDashboardLoaded) {
                final stats = state.stats;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DoctorHeader(
                        doctor: doctor,
                        onMenuTap: () => Scaffold.of(context).openDrawer(),
                        onSearchTap: () {
                          context.read<DashboardTabCubit>().setTab(
                            2,
                          ); // Patients search
                        },
                        onNotificationsTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Loading notifications..."),
                            ),
                          );
                        },
                        datePickerPill: DoctorDatePickerPill(
                          selectedDate: _selectedDate,
                          onDateChanged: (date) {
                            setState(() => _selectedDate = date);
                            _loadStats();
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 24.h,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GridView.count(
                              crossAxisCount: 2,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              mainAxisSpacing: 12.r,
                              crossAxisSpacing: 12.r,
                              childAspectRatio: 0.95,
                              children: [
                                DoctorOverviewCard(
                                  icon: Icons.people_rounded,
                                  title: AppStrings.opInfoTitle,
                                  count: stats.opCount.toString().padLeft(
                                    2,
                                    '0',
                                  ),
                                  subtitle: AppStrings.opInfoSubtitle,
                                  trend: "+12%",
                                  themeColor: AppColors.primary,
                                  onTap: () => context.push(
                                    RouteNames.doctorOpInfo,
                                    extra: _selectedDate,
                                  ),
                                ),
                                DoctorOverviewCard(
                                  icon: Icons.single_bed_rounded,
                                  title: AppStrings.ipInfoTitle,
                                  count: stats.ipCount.toString().padLeft(
                                    2,
                                    '0',
                                  ),
                                  subtitle: AppStrings.ipInfoSubtitle,
                                  trend: "+8%",
                                  themeColor: AppColors.success,
                                ),
                                DoctorOverviewCard(
                                  icon: Icons.colorize_rounded,
                                  title: AppStrings.opProceduresTitle,
                                  count: stats.opProceduresCount
                                      .toString()
                                      .padLeft(2, '0'),
                                  subtitle: AppStrings.opProceduresSubtitle,
                                  trend: "+15%",
                                  themeColor: AppColors.purple,
                                ),
                                DoctorOverviewCard(
                                  icon: Icons.healing_rounded,
                                  title: AppStrings.ipProceduresTitle,
                                  count: stats.ipProceduresCount
                                      .toString()
                                      .padLeft(2, '0'),
                                  subtitle: AppStrings.ipProceduresSubtitle,
                                  trend: "+10%",
                                  themeColor: AppColors.orange,
                                ),
                                DoctorOverviewCard(
                                  icon: Icons.medical_services_rounded,
                                  title: AppStrings.surgeriesTitle,
                                  count: stats.surgeryCount.toString().padLeft(
                                    2,
                                    '0',
                                  ),
                                  subtitle: AppStrings.surgeriesSubtitle,
                                  trend: "+10%",
                                  themeColor: AppColors.warning,
                                ),
                                SlotConfigCard(
                                  availableSlotsCount: stats.availableSlotsCount
                                      .toString()
                                      .padLeft(2, '0'),
                                  onTap: () {
                                    context.read<DashboardTabCubit>().setTab(
                                      1,
                                    ); // Go to Schedule/Slots
                                  },
                                ),
                                MedicalCertificatesCard(
                                  count: stats.medicalCertificatesCount
                                      .toString()
                                      .padLeft(2, '0'),
                                  onViewAllTap: () {
                                    context.read<DashboardTabCubit>().setTab(
                                      3,
                                    ); // Go to certificates
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: 16.h),
                            PendingMrdBanner(
                              count: stats.pendingMrdCount.toString().padLeft(
                                2,
                                '0',
                              ),
                              onViewDetailsTap: () {
                                context.push(
                                  RouteNames.doctorPendingMrd,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
