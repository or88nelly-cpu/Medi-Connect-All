import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/appointments/admin_appointments_filter_cubit.dart';

class AppointmentsSearchBar extends StatefulWidget {
  const AppointmentsSearchBar({super.key});

  @override
  State<AppointmentsSearchBar> createState() => _AppointmentsSearchBarState();
}

class _AppointmentsSearchBarState extends State<AppointmentsSearchBar> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final cubit = context.read<AdminAppointmentsFilterCubit>();
    _controller = TextEditingController(text: cubit.state.searchQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AdminAppointmentsFilterCubit, AdminAppointmentsFilterState>(
      listenWhen: (prev, curr) => prev.searchQuery != curr.searchQuery,
      listener: (context, state) {
        if (_controller.text != state.searchQuery) {
          _controller.text = state.searchQuery;
        }
      },
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onChanged: (val) {
                context.read<AdminAppointmentsFilterCubit>().changeSearchQuery(val);
              },
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
              decoration: InputDecoration(
                hintText: "Search patient, doctor, or specialty...",
                hintStyle: TextStyle(
                  color: isDark ? Colors.white54 : AppColors.textSecondary,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDark ? Colors.white54 : AppColors.textSecondary,
                ),
                filled: true,
                fillColor: isDark ? AppColors.terminalDarkCard : Colors.white,
                contentPadding: EdgeInsets.all(12.r),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(
                    color: isDark ? AppColors.terminalDarkBorder : AppColors.border,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.terminalDarkCard : Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                color: isDark ? AppColors.terminalDarkBorder : AppColors.border,
              ),
            ),
            child: IconButton(
              icon: Icon(
                Icons.tune,
                color: isDark ? Colors.white70 : AppColors.textSecondary,
              ),
              onPressed: () {
                context.read<AdminAppointmentsFilterCubit>().resetFilters();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Search and filters reset to today."),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
