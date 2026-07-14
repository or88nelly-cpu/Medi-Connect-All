import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/navigation/route_names.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_recent_activity_bloc.dart';
import 'package:medi_connect/shared/dashboard/domain/entities/activity_log_entity.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_dashboard/items/recent_activity_item.dart';

class AdminRecentActivity extends StatefulWidget {
  final bool isExpanded;
  const AdminRecentActivity({super.key, this.isExpanded = false});

  @override
  State<AdminRecentActivity> createState() => _AdminRecentActivityState();
}

class _AdminRecentActivityState extends State<AdminRecentActivity> {
  @override
  void initState() {
    super.initState();
    context.read<AdminRecentActivityBloc>().add(LoadRecentActivity());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surface : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.history, color: AppColors.adminPrimary, size: 24.sp),
                  SizedBox(width: 8.w),
                  Text(
                    AppStrings.recentActivity,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.dashboardTextPrimary(context),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  context.pushNamed(RouteNames.adminAuditLogs);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      AppStrings.dashboard, // Temporarily using dashboard string for "View All"
                      style: AppTextStyles.labelMedium.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.arrow_forward,
                      size: 16.sp,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          BlocBuilder<AdminRecentActivityBloc, AdminRecentActivityState>(
            builder: (context, state) {
              if (state is AdminRecentActivityLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is AdminRecentActivityError) {
                return Center(child: Text(state.message));
              } else if (state is AdminRecentActivityLoaded) {
                final logs = state.logs.take(5).toList();

                if (logs.isEmpty) {
                  return const Center(child: Text("No Recent Activity"));
                }

                Widget list = ListView.separated(
                  shrinkWrap: !widget.isExpanded,
                  physics: widget.isExpanded ? const BouncingScrollPhysics() : const NeverScrollableScrollPhysics(),
                  itemCount: logs.length,
                  separatorBuilder: (context, index) => Divider(
                    height: 24.h,
                    color: AppColors.border(context),
                  ),
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    return RecentActivityItem(log: log, isDark: isDark);
                  },
                );

                if (widget.isExpanded) {
                  return Expanded(child: list);
                } else {
                  return list;
                }
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
