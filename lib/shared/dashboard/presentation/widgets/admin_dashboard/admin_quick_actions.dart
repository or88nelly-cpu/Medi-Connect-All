import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/dashboard_widgets_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/dashboard_widgets_state.dart';
import 'package:medi_connect/core/utils/icon_utils.dart';
import 'package:medi_connect/core/utils/color_utils.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_dashboard/items/quick_action_item.dart';

class AdminQuickActionsGrid extends StatefulWidget {
  const AdminQuickActionsGrid({super.key});

  @override
  State<AdminQuickActionsGrid> createState() => _AdminQuickActionsGridState();
}

class _AdminQuickActionsGridState extends State<AdminQuickActionsGrid> {
  @override
  void initState() {
    super.initState();
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
            children: [
              Icon(Icons.bolt, color: AppColors.primary, size: 24.sp),
              SizedBox(width: 8.w),
              Text(
                "Quick Actions", // Fallback string
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : Colors.black87,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          BlocBuilder<DashboardWidgetsBloc, DashboardWidgetsState>(
            builder: (context, state) {
              if (state is DashboardWidgetsLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is DashboardWidgetsError) {
                return Center(child: Text(state.failure.message));
              } else if (state is DashboardWidgetsLoaded) {
                final actions = state.quickActions;

                if (actions.isEmpty) {
                  return const Center(child: Text("No Quick Actions Available"));
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 2.5,
                  ),
                  itemCount: actions.length,
                  itemBuilder: (context, index) {
                    final action = actions[index];
                    final color = ColorUtils.fromHex(action.colorCode);
                    final icon = IconUtils.fromString(action.icon);

                    return QuickActionItem(
                      title: action.title,
                      iconData: icon,
                      color: color,
                      isDark: isDark,
                      onTap: () {
                        context.pushNamed(action.route);
                      },
                    );
                  },
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}
