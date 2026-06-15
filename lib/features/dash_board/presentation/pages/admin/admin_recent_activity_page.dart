import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/common_app_bar.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/admin/admin_recent_activity_bloc.dart';

class AdminRecentActivityPage extends StatefulWidget {
  const AdminRecentActivityPage({super.key});

  @override
  State<AdminRecentActivityPage> createState() =>
      _AdminRecentActivityPageState();
}

class _AdminRecentActivityPageState extends State<AdminRecentActivityPage> {
  @override
  void initState() {
    super.initState();
    context.read<AdminRecentActivityBloc>().add(LoadRecentActivity());
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      customAppbar: const CommonAppBar(title: "Recent Activity"),
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
              return const Center(child: Text("No recent activities."));
            }

            return ListView.builder(
              padding: EdgeInsets.all(20.r),
              itemCount: logs.length,
              itemBuilder: (context, idx) {
                final log = logs[idx];
                Color iconColor;
                IconData icon;
                switch (log.category) {
                  case 'Record':
                    icon = Icons.folder_shared_outlined;
                    iconColor = AppColors.primary;
                    break;
                  case 'Patient':
                    icon = Icons.person_add_outlined;
                    iconColor = AppColors.secondary;
                    break;
                  case 'Lab':
                    icon = Icons.science_outlined;
                    iconColor = AppColors.accent;
                    break;
                  case 'Pharmacy':
                    icon = Icons.medication_outlined;
                    iconColor = AppColors.error;
                    break;
                  case 'Appointment':
                    icon = Icons.calendar_month_outlined;
                    iconColor = AppColors.success;
                    break;
                  default:
                    icon = Icons.info_outline;
                    iconColor = AppColors.textSecondary;
                }

                // Format time difference
                final now = DateTime.now();
                final diff = now.difference(log.createdAt);
                String timeAgo = "Just now";
                if (diff.inDays > 0) {
                  timeAgo = "${diff.inDays}d ago";
                } else if (diff.inHours > 0) {
                  timeAgo = "${diff.inHours}h ago";
                } else if (diff.inMinutes > 0) {
                  timeAgo = "${diff.inMinutes}m ago";
                }

                return Card(
                  margin: EdgeInsets.only(bottom: 12.h),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    side: const BorderSide(color: AppColors.border),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16.r),
                    leading: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Icon(icon, color: iconColor),
                    ),
                    title: Text(
                      log.message,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    subtitle: Text(
                      "${log.category} | $timeAgo",
                      style: AppTextStyles.bodySmall,
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
