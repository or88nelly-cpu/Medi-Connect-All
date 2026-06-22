import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/appointments/admin_appointments_filter_cubit.dart';

class AppointmentsStatusFilter extends StatelessWidget {
  final Map<String, int> statusCounts;

  const AppointmentsStatusFilter({super.key, required this.statusCounts});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<
      AdminAppointmentsFilterCubit,
      AdminAppointmentsFilterState
    >(
      buildWhen: (prev, curr) => prev.filterStatus != curr.filterStatus,
      builder: (context, state) {
        final currentFilter = state.filterStatus;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: ['All', 'Confirmed', 'Pending', 'Completed', 'Cancelled']
                .map((status) {
                  final isSelected = currentFilter == status;
                  final count = statusCounts[status] ?? 0;
                  return Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: _buildStatusFilterCard(
                      context,
                      status: status,
                      isSelected: isSelected,
                      count: count,
                      isDark: isDark,
                    ),
                  );
                })
                .toList(),
          ),
        );
      },
    );
  }

  Widget _buildStatusFilterCard(
    BuildContext context, {
    required String status,
    required bool isSelected,
    required int count,
    required bool isDark,
  }) {
    IconData icon;
    Color statusColor;
    switch (status) {
      case 'All':
        icon = Icons.grid_view_outlined;
        statusColor = Colors.blue;
        break;
      case 'Confirmed':
        icon = Icons.check_circle_outlined;
        statusColor = Colors.green;
        break;
      case 'Pending':
        icon = Icons.schedule_outlined;
        statusColor = Colors.orange;
        break;
      case 'Completed':
        icon = Icons.check_circle_outlined;
        statusColor = Colors.purple;
        break;
      case 'Cancelled':
        icon = Icons.cancel_outlined;
        statusColor = Colors.red;
        break;
      default:
        icon = Icons.help_outline;
        statusColor = Colors.grey;
    }

    final cardBg = isDark ? AppColors.terminalDarkCard : Colors.white;
    final borderCol = isSelected ? statusColor : (AppColors.border(context));

    return GestureDetector(
      onTap: () {
        context.read<AdminAppointmentsFilterCubit>().changeFilterStatus(status);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: borderCol, width: isSelected ? 1.5 : 1),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: statusColor.withValues(alpha: 0.08),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16.r, color: statusColor),
            SizedBox(width: 6.w),
            Text(
              status,
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isDark ? Colors.white : AppColors.textPrimary(context),
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: count > 0
                    ? statusColor.withValues(alpha: 0.12)
                    : (isDark ? Colors.white12 : Colors.grey[100]),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 9.sp,
                  fontWeight: FontWeight.bold,
                  color: count > 0
                      ? statusColor
                      : (isDark
                            ? Colors.white38
                            : AppColors.textSecondary(context)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
