import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/loaders/loaders.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/utils/constants/app_assets.dart';
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
          //final int videos = stats['onlineConsultations'] ?? 0;
          final double revenue =
              (stats['totalRevenue'] as num?)?.toDouble() ?? 0.0;
          final deptStats = stats['departmentStats'] as List<dynamic>? ?? [];
          final List<Widget> statusCard = [
            StatCard(
              label: AppStrings.patients,
              value: patients.toString(),
              icon: AppAssets.femaleAvatarPng,
              color: AppColors.primary,
            ),
            StatCard(
              label: AppStrings.appointments,
              value: appts.toString(),
              icon: AppAssets.appointments,
              color: AppColors.infoTeal,
            ),
            StatCard(
              label: AppStrings.availableBeds,
              value: "182",
              icon: AppAssets.bed,
              color: AppColors.accent,
            ),
            StatCard(
              label: AppStrings.doctors,
              value: docs.toString(),
              icon: AppAssets.femaleDoctorAvatarPng,
              color: AppColors.infoPurple,
            ),
            StatCard(
              label: AppStrings.staff,
              value: staff.toString(),
              icon: AppAssets.femaleStaffAvatarPng,
              color: AppColors.infoOrange,
            ),
            StatCard(
              label: AppStrings.totalRevenue,
              value: "₹ $revenue",
              icon: AppAssets.revenue,
              color: AppColors.infoIndigo,
            ),
          ];
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
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: 12.r,
                runSpacing: 12.r,
                children: statusCard,
              ),
              SizedBox(height: 12.r),
              Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: RevenueChart(weeklyRevenue: revenue),
                  ),
                ],
              ),

              // SizedBox(height: 20.h),
              // // Line Chart and Dept Stats
              // LayoutBuilder(
              //   builder: (context, constraints) {
              //     final isWide = constraints.maxWidth > 700;
              //     final children = [
              //       Expanded(flex: isWide ? 4 : 0, child: const RevenueChart()),
              //       if (isWide) SizedBox(width: 16.w),
              //       Expanded(
              //         flex: isWide ? 3 : 0,
              //         child: DepartmentDistribution(deptStats: deptStats),
              //       ),
              //     ];

              //     if (isWide) {
              //       return Row(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: children,
              //       );
              //     } else {
              //       return Column(
              //         children: [
              //           const RevenueChart(),
              //           SizedBox(height: 16.h),
              //           //DepartmentDistribution(deptStats: deptStats),
              //         ],
              //       );
              //     }
              //   },
              // ),
            ],
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
