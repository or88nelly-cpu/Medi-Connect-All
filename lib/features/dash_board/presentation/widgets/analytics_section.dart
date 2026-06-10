import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/common_widgets/loaders/loaders.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/utils/constants/app_assets.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/dashboard_analytics_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/dashboard_tab_cubit.dart';
import 'analytics/stat_card.dart';
import 'analytics/revenue_chart.dart';
import 'analytics/custom_line_chart.dart';

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
          final double revenue = (stats['totalRevenue'] as num?)?.toDouble() ?? 0.0;
          final deptStats = stats['departmentStats'] as List<dynamic>? ?? [];

          // Retriving our new mock stats
          final pharmacy = stats['pharmacySummary'] as Map<String, dynamic>? ?? {};
          final lab = stats['labSummary'] as Map<String, dynamic>? ?? {};
          final attendance = stats['staffAttendance'] as Map<String, dynamic>? ?? {};
          final activities = stats['recentActivities'] as List<dynamic>? ?? [];
          final emergencies = stats['emergencyAlerts'] as List<dynamic>? ?? [];

          final List<Widget> statusCards = [
            StatCard(
              label: AppStrings.patients,
              value: patients.toString(),
              icon: AppAssets.femaleAvatarPng,
              color: AppColors.primary,
              onTap: () => context.read<DashboardTabCubit>().setTab(2),
            ),
            StatCard(
              label: AppStrings.appointments,
              value: appts.toString(),
              icon: AppAssets.appointments,
              color: AppColors.infoTeal,
              onTap: () => context.read<DashboardTabCubit>().setTab(1),
            ),
            StatCard(
              label: AppStrings.availableBeds,
              value: "182",
              icon: AppAssets.bed,
              color: AppColors.accent,
              onTap: () => _handleQuickAction(context, 'admission'),
            ),
            StatCard(
              label: AppStrings.doctors,
              value: docs.toString(),
              icon: AppAssets.femaleDoctorAvatarPng,
              color: AppColors.infoPurple,
              onTap: () => context.push('/admin/doctors'),
            ),
            StatCard(
              label: AppStrings.staff,
              value: staff.toString(),
              icon: AppAssets.femaleStaffAvatarPng,
              color: AppColors.infoOrange,
              onTap: () => context.push('/admin/staff'),
            ),
            StatCard(
              label: AppStrings.totalRevenue,
              value: "₹ $revenue",
              icon: AppAssets.revenue,
              color: AppColors.infoIndigo,
              onTap: () => context.read<DashboardTabCubit>().setTab(3),
            ),
          ];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Emergency Alerts Banner
              if (emergencies.isNotEmpty) ...[
                _buildEmergencyBanner(context, emergencies),
                SizedBox(height: 16.h),
              ],

              // 2. Quick Actions
              _buildQuickActions(context),
              SizedBox(height: 20.h),

              Text(
                AppStrings.analyticsOverview,
                style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.h),
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 12.r,
                runSpacing: 12.r,
                children: statusCards,
              ),
              SizedBox(height: 16.h),

              // 3. Revenue Chart & Appointment Summary Graph
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: RevenueChart(weeklyRevenue: revenue),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              _buildAppointmentGraph(),
              SizedBox(height: 16.h),

              // 4. Pharmacy Summary Card
              _buildPharmacySummaryCard(context, pharmacy),
              SizedBox(height: 16.h),

              // 5. Department Overview Card
              _buildDepartmentOverviewCard(deptStats),
              SizedBox(height: 16.h),

              // 6. Lab Summary Card
              _buildLabSummaryCard(context, lab),
              SizedBox(height: 16.h),

              // 7. Staff Attendance Card
              _buildStaffAttendanceCard(context, attendance),
              SizedBox(height: 16.h),

              // 8. Recent Activity Card
              _buildRecentActivityCard(context, activities),
              SizedBox(height: 20.h),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  // ─────────────────────────────────────────────────────────────────────────────
  // Helper Component Widgets
  // ─────────────────────────────────────────────────────────────────────────────

  Widget _buildEmergencyBanner(BuildContext context, List<dynamic> emergencies) {
    final first = emergencies.first;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.error, width: 1.5),
      ),
      child: Row(
        children: [
          Icon(Icons.gpp_bad, color: AppColors.error, size: 28.r),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "EMERGENCY ALERT: ${first['message']}",
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.error,
                  ),
                ),
                Text(
                  "Triggered ${first['time']}",
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () => context.push('/admin/emergencies'),
            child: Text(
              "View All",
              style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 12.sp),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'label': 'Appt', 'icon': Icons.calendar_today, 'action': 'appointment'},
      {'label': 'Lab Test', 'icon': Icons.science_outlined, 'action': 'lab'},
      {'label': 'Patient', 'icon': Icons.person_add_outlined, 'action': 'patient'},
      {'label': 'Admission', 'icon': Icons.bed_outlined, 'action': 'admission'},
      {'label': 'More', 'icon': Icons.more_horiz, 'action': 'more'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions",
          style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: actions.map((act) {
            return Column(
              children: [
                InkWell(
                  onTap: () => _handleQuickAction(context, act['action'] as String),
                  borderRadius: BorderRadius.circular(14.r),
                  child: Container(
                    padding: EdgeInsets.all(14.r),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: AppColors.primary.withOpacity(0.15)),
                    ),
                    child: Icon(act['icon'] as IconData, color: AppColors.primary, size: 24.r),
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  act['label'] as String,
                  style: AppTextStyles.bodySmall.copyWith(fontSize: 10.sp, fontWeight: FontWeight.bold),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }

  void _handleQuickAction(BuildContext context, String action) {
    if (action == 'more') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Additional action features coming soon.")),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Quick Action: Create ${action.toUpperCase()}", style: AppTextStyles.titleLarge),
        content: Text("Are you sure you want to trigger the ${action} creation form?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Form submitted successfully for $action.")),
              );
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentGraph() {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Appointment Summary Graph",
            style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 16.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            "Weekly consultation appointments count trend",
            style: AppTextStyles.bodySmall,
          ),
          SizedBox(height: 16.h),
          SizedBox(
            height: 120.h,
            width: double.infinity,
            child: CustomPaint(
              painter: CustomLineChartPainter(
                lineColor: AppColors.secondary,
                shadowColor: AppColors.secondary,
                strokeWidth: 3.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPharmacySummaryCard(BuildContext context, Map<String, dynamic> pharmacy) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.medication_outlined, color: AppColors.primary, size: 22.r),
                    SizedBox(width: 8.w),
                    Text(
                      "Pharmacy Summary",
                      style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 15.sp),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => context.push('/admin/pharmacy'),
                  child: const Text("View All"),
                ),
              ],
            ),
            const Divider(color: AppColors.border),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMiniStat("Total Meds", pharmacy['totalMedicines']?.toString() ?? '0', AppColors.primary),
                _buildMiniStat("Low Stock", pharmacy['lowStock']?.toString() ?? '0', AppColors.warning),
                _buildMiniStat("Out of Stock", pharmacy['outOfStock']?.toString() ?? '0', AppColors.error),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDepartmentOverviewCard(List<dynamic> deptStats) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.local_hospital_outlined, color: AppColors.infoTeal, size: 22.r),
                SizedBox(width: 8.w),
                Text(
                  "Department Overview",
                  style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 15.sp),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Text("Patients consulted by department", style: AppTextStyles.bodySmall),
            const Divider(color: AppColors.border),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: deptStats.length,
              itemBuilder: (context, idx) {
                final dept = deptStats[idx];
                final count = dept['count'] as int? ?? 0;
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 6.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(dept['department'] as String? ?? 'General'),
                      Row(
                        children: [
                          Container(
                            width: 100.w,
                            height: 6.h,
                            decoration: BoxDecoration(
                              color: AppColors.border,
                              borderRadius: BorderRadius.circular(3.r),
                            ),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Container(
                                width: (count * 10).w,
                                height: 6.h,
                                decoration: BoxDecoration(
                                  color: AppColors.infoTeal,
                                  borderRadius: BorderRadius.circular(3.r),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text("$count consulted"),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabSummaryCard(BuildContext context, Map<String, dynamic> lab) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.science_outlined, color: AppColors.infoPurple, size: 22.r),
                    SizedBox(width: 8.w),
                    Text(
                      "Lab Summary",
                      style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 15.sp),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => context.push('/admin/labs'),
                  child: const Text("View All"),
                ),
              ],
            ),
            const Divider(color: AppColors.border),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMiniStat("Total Tests", lab['totalTests']?.toString() ?? '0', AppColors.infoPurple),
                _buildMiniStat("Pending", lab['pending']?.toString() ?? '0', AppColors.warning),
                _buildMiniStat("Critical Alerts", lab['criticalAlerts']?.toString() ?? '0', AppColors.error),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStaffAttendanceCard(BuildContext context, Map<String, dynamic> attendance) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.badge_outlined, color: AppColors.infoOrange, size: 22.r),
                    SizedBox(width: 8.w),
                    Text(
                      "Staff Attendance",
                      style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 15.sp),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => context.push('/admin/staff-attendance'),
                  child: const Text("View All"),
                ),
              ],
            ),
            const Divider(color: AppColors.border),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMiniStat("Present", attendance['present']?.toString() ?? '0', AppColors.success),
                _buildMiniStat("Absent", attendance['absent']?.toString() ?? '0', AppColors.error),
                _buildMiniStat("On Leave", attendance['onLeave']?.toString() ?? '0', AppColors.warning),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityCard(BuildContext context, List<dynamic> activities) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.history_toggle_off_outlined, color: AppColors.infoIndigo, size: 22.r),
                    SizedBox(width: 8.w),
                    Text(
                      "Recent Activity",
                      style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold, fontSize: 15.sp),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () => context.push('/admin/recent-activity'),
                  child: const Text("View All"),
                ),
              ],
            ),
            const Divider(color: AppColors.border),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: activities.length > 3 ? 3 : activities.length,
              itemBuilder: (context, idx) {
                final act = activities[idx];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Row(
                    children: [
                      Container(
                        width: 8.r,
                        height: 8.r,
                        decoration: const BoxDecoration(
                          color: AppColors.infoIndigo,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              act['message'] as String? ?? '',
                              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                            ),
                            Text(
                              act['time'] as String? ?? '',
                              style: AppTextStyles.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.titleLarge.copyWith(fontWeight: FontWeight.bold, color: color),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(fontSize: 10.sp),
        ),
      ],
    );
  }
}
