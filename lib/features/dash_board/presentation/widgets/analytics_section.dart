import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/common_widgets/loaders/loaders.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/admin/dashboard_analytics_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/common/dashboard_tab_cubit.dart';

import 'analytics/analytics_overview_section.dart';
import 'analytics/pharmacy_summary_card.dart';
import 'analytics/department_overview_card.dart';
import 'analytics/lab_summary_card.dart';
import 'analytics/staff_attendance_card.dart';
import 'analytics/recent_activity_card.dart';
import 'analytics/quick_actions_grid.dart';
import 'analytics/emergency_alert_banner.dart';

class AnalyticsSection extends StatelessWidget {
  const AnalyticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardAnalyticsBloc, DashboardAnalyticsState>(
      builder: (context, state) {
        if (state is DashboardAnalyticsLoading) {
          return const ShimmerLoader(count: 2);
        } else if (state is DashboardAnalyticsError) {
          return Center(
            child: Text(
              "${AppStrings.errorFetchingAnalytics}${state.message}",
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
            ),
          );
        } else if (state is DashboardAnalyticsLoaded) {
          final stats = state.stats;
          final int docs = stats['totalDoctors'] ?? 0;
          final int staff = stats['totalStaff'] ?? 0;
          final int patients = stats['totalPatients'] ?? 0;
          final int appts = stats['todayAppointments'] ?? 0;
          final double revenue =
              (stats['totalRevenue'] as num?)?.toDouble() ?? 0.0;
          final deptStats = stats['departmentStats'] as List<dynamic>? ?? [];

          // final List<double> weeklyRevenueTrend =
          //     (stats['weeklyRevenueTrend'] as List<dynamic>?)
          //         ?.map((e) => (e as num).toDouble())
          //         .toList() ??
          //     [400.0, 600.0, 800.0, 700.0, 900.0, 1100.0, 900.0];

          // final List<int> weeklyAppointmentTrend =
          //     (stats['weeklyAppointmentTrend'] as List<dynamic>?)
          //         ?.map((e) => (e as num).toInt())
          //         .toList() ??
          //     [30, 35, 40, 38, 45, 48, 42];

          final pharmacy =
              stats['pharmacySummary'] as Map<String, dynamic>? ?? {};
          final lab = stats['labSummary'] as Map<String, dynamic>? ?? {};
          final attendance =
              stats['staffAttendance'] as Map<String, dynamic>? ?? {};
          final activities = stats['recentActivities'] as List<dynamic>? ?? [];
          final emergencies = stats['emergencyAlerts'] as List<dynamic>? ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Analytics Overview (Grid of 6 stats cards)
              AnalyticsOverviewSection(
                patients: patients,
                appointments: appts,
                availableBeds: 182,
                doctors: docs,
                staff: staff,
                revenue: revenue,
                onPatientsTap: () =>
                    context.read<DashboardTabCubit>().setTab(2),
                onAppointmentsTap: () =>
                    context.read<DashboardTabCubit>().setTab(1),
                onBedsTap: () => _handleQuickAction(context, 'admission'),
                onDoctorsTap: () => context.push('/admin/doctors'),
                onStaffTap: () => context.push('/admin/staff'),
                onRevenueTap: () => context.read<DashboardTabCubit>().setTab(3),
              ),
              SizedBox(height: 16.h),
              if (emergencies.isNotEmpty) ...[
                EmergencyAlertBanner(
                  emergencies: emergencies,
                  onViewAll: () => context.push('/admin/emergencies'),
                ),
                SizedBox(height: 16.h),
              ],
              // 2. Weekly Revenue Trend Card
              Row(
                children: [
                  // Expanded(
                  //   flex: 1,
                  //   child: WeeklyRevenueTrendCard(
                  //     weeklyRevenue: revenue,
                  //     dailyRevenues: weeklyRevenueTrend,
                  //   ),
                  // ),
                  Expanded(
                    flex: 1,
                    child: PharmacySummaryCard(
                      pharmacy: pharmacy,
                      onViewAll: () => context.push('/admin/pharmacy'),
                    ),
                  ),

                  // Expanded(
                  //   flex: 1,
                  //   child: AppointmentSummaryGraphCard(
                  //     weeklyAppointments: weeklyAppointmentTrend,
                  //   ),
                  // ),
                ],
              ),
              SizedBox(height: 8.r),
              LabSummaryCard(
                lab: lab,
                onViewAll: () => context.push("admin/lab"),
              ),
              SizedBox(height: 8.r),
              DepartmentOverviewCard(deptStats: deptStats),
              SizedBox(height: 8.r),
              StaffAttendanceCard(
                attendance: attendance,
                onViewAll: () => context.push('/admin/staff-attendance'),
              ),
              // SizedBox(height: 12.h),
              SizedBox(height: 8.r),
              // // 9. Quick Actions Grid
              QuickActionsGrid(
                onActionTap: (action) => _handleQuickAction(context, action),
              ),
              // SizedBox(height: 20.h),
              SizedBox(height: 8.r),
              RecentActivityCard(
                activities: activities,
                onViewAll: () => context.push('/admin/recent-activity'),
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _handleQuickAction(BuildContext context, String action) {
    if (action == 'more') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Additional action features coming soon."),
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          "Quick Action: Create ${action.toUpperCase()}",
          style: AppTextStyles.titleLarge,
        ),
        content: Text(
          "Are you sure you want to trigger the $action creation form?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("Form submitted successfully for $action."),
                ),
              );
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }
}
