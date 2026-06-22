import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/appointments/admin_appointments_filter_cubit.dart';

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

    return BlocListener<
      AdminAppointmentsFilterCubit,
      AdminAppointmentsFilterState
    >(
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
                context.read<AdminAppointmentsFilterCubit>().changeSearchQuery(
                  val,
                );
              },
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.textPrimary(context),
                fontSize: 12.sp,
              ),
              decoration: InputDecoration(
                hintText: "Search patient, doctor, or specialty...",
                hintStyle: TextStyle(
                  fontSize: 12.sp,
                  color: isDark
                      ? Colors.white54
                      : AppColors.textSecondary(context),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: isDark
                      ? Colors.white54
                      : AppColors.textSecondary(context),
                ),
                filled: true,
                fillColor: isDark ? AppColors.terminalDarkCard : Colors.white,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12.r,
                  vertical: 6.r,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  borderSide: BorderSide(color: AppColors.border(context)),
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
        ],
      ),
    );
  }
}
