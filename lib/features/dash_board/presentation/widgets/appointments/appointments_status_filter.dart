import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/appointments/admin_appointments_filter_cubit.dart';

class AppointmentsStatusFilter extends StatelessWidget {
  final Map<String, int> statusCounts;

  const AppointmentsStatusFilter({
    super.key,
    required this.statusCounts,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<AdminAppointmentsFilterCubit, AdminAppointmentsFilterState>(
      buildWhen: (prev, curr) => prev.filterStatus != curr.filterStatus,
      builder: (context, state) {
        final currentFilter = state.filterStatus;

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              'All',
              'Confirmed',
              'Pending',
              'Completed',
              'Cancelled',
            ].map((status) {
              final isSelected = currentFilter == status;
              final count = statusCounts[status] ?? 0;
              return Padding(
                padding: EdgeInsets.only(right: 8.w),
                child: ChoiceChip(
                  label: Text("$status  $count"),
                  selected: isSelected,
                  onSelected: (val) {
                    if (val) {
                      context
                          .read<AdminAppointmentsFilterCubit>()
                          .changeFilterStatus(status);
                    }
                  },
                  backgroundColor:
                      isDark ? AppColors.terminalDarkCard : Colors.white,
                  selectedColor: AppColors.primary.withOpacity(0.2),
                  checkmarkColor: AppColors.primary,
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark
                            ? AppColors.terminalDarkBorder
                            : AppColors.border),
                  ),
                  labelStyle: TextStyle(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark ? Colors.white70 : AppColors.textSecondary),
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
