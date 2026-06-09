import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/loaders/loaders.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/dashboard_analytics_bloc.dart';
import 'analytics/stat_card.dart';
import 'analytics/revenue_chart.dart';
import 'analytics/department_distribution.dart';

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
          final int videos = stats['onlineConsultations'] ?? 0;
          final double revenue =
              (stats['totalRevenue'] as num?)?.toDouble() ?? 0.0;
          final deptStats = stats['departmentStats'] as List<dynamic>? ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.analyticsOverview,
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16.h),
              // Grid of counts
              LayoutBuilder(
                builder: (context, constraints) {
                  int crossAxisCount;

                  if (constraints.maxWidth >= 1400) {
                    crossAxisCount = 6;
                  } else if (constraints.maxWidth >= 1000) {
                    crossAxisCount = 4;
                  } else if (constraints.maxWidth >= 700) {
                    crossAxisCount = 3;
                  } else {
                    crossAxisCount = 2;
                  }
                  final List<Widget> statusCard = [
                    StatCard(
                      label: AppStrings.doctors,
                      value: docs.toString(),
                      icon: Icons.local_hospital_rounded,
                      color: AppColors.primary,
                    ),
                    StatCard(
                      label: AppStrings.staff,
                      value: staff.toString(),
                      icon: Icons.badge_rounded,
                      color: AppColors.infoIndigo,
                    ),
                    StatCard(
                      label: AppStrings.patients,
                      value: patients.toString(),
                      icon: Icons.people_alt_rounded,
                      color: AppColors.infoTeal,
                    ),
                    StatCard(
                      label: AppStrings.appointments,
                      value: appts.toString(),
                      icon: Icons.calendar_month_rounded,
                      color: AppColors.infoOrange,
                    ),
                    StatCard(
                      label: AppStrings.videoConsults,
                      value: videos.toString(),
                      icon: Icons.video_call_rounded,
                      color: AppColors.infoPurple,
                    ),
                    StatCard(
                      label: AppStrings.totalRevenue,
                      value: '\$${revenue.toStringAsFixed(0)}',
                      icon: Icons.payments_rounded,
                      color: AppColors.success,
                    ),
                  ];
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: statusCard.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 16.w,
                      mainAxisSpacing: 16.h,
                      childAspectRatio: 1.35,
                    ),
                    itemBuilder: (context, index) => statusCard[index],
                  );
                },
              ),
              SizedBox(height: 20.h),
              // Line Chart and Dept Stats
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 700;
                  final children = [
                    Expanded(flex: isWide ? 4 : 0, child: const RevenueChart()),
                    if (isWide) SizedBox(width: 16.w),
                    Expanded(
                      flex: isWide ? 3 : 0,
                      child: DepartmentDistribution(deptStats: deptStats),
                    ),
                  ];

                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: children,
                    );
                  } else {
                    return Column(
                      children: [
                        const RevenueChart(),
                        SizedBox(height: 16.h),
                        DepartmentDistribution(deptStats: deptStats),
                      ],
                    );
                  }
                },
              ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
