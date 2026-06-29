import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/widgets/appbar/common_app_bar.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_recent_activity_bloc.dart';

class AdminAuditLogsPage extends StatefulWidget {
  const AdminAuditLogsPage({super.key});

  @override
  State<AdminAuditLogsPage> createState() => _AdminAuditLogsPageState();
}

class _AdminAuditLogsPageState extends State<AdminAuditLogsPage> {
  @override
  void initState() {
    super.initState();
    context.read<AdminRecentActivityBloc>().add(LoadRecentActivity());
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      customAppbar: const CommonAppBar(title: "System Audit Logs"),
      body: BlocBuilder<AdminRecentActivityBloc, AdminRecentActivityState>(
        builder: (context, state) {
          if (state is AdminRecentActivityLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AdminRecentActivityError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    style: const TextStyle(color: AppColors.error),
                  ),
                  SizedBox(height: 12.h),
                  ElevatedButton(
                    onPressed: () => context
                        .read<AdminRecentActivityBloc>()
                        .add(LoadRecentActivity()),
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          if (state is AdminRecentActivityLoaded) {
            final logs = state.logs;
            if (logs.isEmpty) {
              return const Center(child: Text("No audit records found."));
            }

            return ListView.builder(
              padding: EdgeInsets.all(20.r),
              itemCount: logs.length,
              itemBuilder: (context, idx) {
                final log = logs[idx];
                final dateStr =
                    "${log.createdAt.day}/${log.createdAt.month}/${log.createdAt.year} ${log.createdAt.hour.toString().padLeft(2, '0')}:${log.createdAt.minute.toString().padLeft(2, '0')}";

                return Card(
                  margin: EdgeInsets.only(bottom: 12.h),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: BorderSide(color: AppColors.border(context)),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.r),
                    leading: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: AppColors.adminPrimary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        color: AppColors.adminPrimary,
                      ),
                    ),
                    title: Text(
                      log.message,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 4.h),
                        Text(
                          "Category: ${log.category}",
                          style: AppTextStyles.bodySmall,
                        ),
                        Text(
                          "Timestamp: $dateStr",
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
