import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/doctor/dashboard/presentation/bloc/pending_mrd/pending_mrd_bloc.dart';
import 'package:medi_connect/features/doctor/dashboard/presentation/bloc/pending_mrd/pending_mrd_event.dart';
import 'package:medi_connect/features/doctor/dashboard/presentation/bloc/pending_mrd/pending_mrd_state.dart';
import 'package:medi_connect/features/doctor/dashboard/presentation/widgets/pending_mrd/mrd_category_chips.dart';
import 'package:medi_connect/features/doctor/dashboard/presentation/widgets/pending_mrd/mrd_date_switcher.dart';
import 'package:medi_connect/features/doctor/dashboard/presentation/widgets/pending_mrd/mrd_footer.dart';
import 'package:medi_connect/features/doctor/dashboard/presentation/widgets/pending_mrd/mrd_intro_banner.dart';
import 'package:medi_connect/features/doctor/dashboard/presentation/widgets/pending_mrd/mrd_patient_table.dart';
import 'package:medi_connect/features/doctor/dashboard/presentation/widgets/pending_mrd/mrd_quick_actions.dart';
import 'package:medi_connect/features/doctor/dashboard/presentation/widgets/pending_mrd/mrd_search_filters.dart';
import 'package:medi_connect/features/doctor/dashboard/presentation/widgets/pending_mrd/mrd_stats_grid.dart';

// Extracted Sub-widgets

class PendingMrdPage extends StatefulWidget {
  const PendingMrdPage({super.key});

  @override
  State<PendingMrdPage> createState() => _PendingMrdPageState();
}

class _PendingMrdPageState extends State<PendingMrdPage> {
  @override
  void initState() {
    super.initState();
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      context.read<PendingMrdBloc>().add(
        LoadPendingMrdEvent(authState.user.id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final pageBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC);
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final primaryTextColor = isDark ? Colors.white : AppColors.textDarkNavy;
    final borderCol = AppColors.border(context);

    return Scaffold(
      backgroundColor: pageBg,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: primaryTextColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Pending MRD Records',
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: primaryTextColor,
          ),
        ),
      ),
      body: BlocBuilder<PendingMrdBloc, PendingMrdState>(
        builder: (context, state) {
          if (state is PendingMrdLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (state is PendingMrdError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, color: AppColors.error, size: 48.r),
                  SizedBox(height: 12.h),
                  Text(state.message, style: AppTextStyles.bodyMedium),
                  SizedBox(height: 16.h),
                  ElevatedButton(
                    onPressed: () {
                      final authState = context.read<AuthBloc>().state;
                      if (authState is Authenticated) {
                        context.read<PendingMrdBloc>().add(
                          LoadPendingMrdEvent(authState.user.id),
                        );
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is PendingMrdLoaded) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Premium Date Switcher Banner
                  MrdDateSwitcher(
                    selectedDate: state.selectedDate,
                    onPrevPressed: () => context.read<PendingMrdBloc>().add(
                      const ChangeDateEvent(-1),
                    ),
                    onNextPressed: () => context.read<PendingMrdBloc>().add(
                      const ChangeDateEvent(1),
                    ),
                    isDark: isDark,
                  ),
                  SizedBox(height: 20.h),

                  // 2. Pending MRD Banner Section
                  MrdIntroBanner(isDark: isDark),
                  SizedBox(height: 20.h),

                  // 3. Stats Summary Grid Section
                  state.counts.isEmpty
                      ? const CircularProgressIndicator(
                          color: AppColors.primary,
                        )
                      : MrdStatsGrid(counts: state.counts, isDark: isDark),
                  SizedBox(height: 20.h),

                  // 4. Quick Action Buttons Grid
                  MrdQuickActions(
                    isDark: isDark,
                    cardBg: cardBg,
                    borderCol: borderCol,
                  ),
                  SizedBox(height: 20.h),

                  // 5. Search, Filter Bars & Category Chips
                  MrdSearchFilters(
                    selectedArea: state.selectedArea,
                    selectedPriority: state.selectedPriority,
                    selectedStatus: state.selectedStatus,
                    onSearchChanged: (val) => context
                        .read<PendingMrdBloc>()
                        .add(SetSearchQueryEvent(val)),
                    onAreaChanged: (val) => context.read<PendingMrdBloc>().add(
                      SetAreaFilterEvent(val!),
                    ),
                    onPriorityChanged: (val) => context
                        .read<PendingMrdBloc>()
                        .add(SetPriorityFilterEvent(val!)),
                    onStatusChanged: (val) => context
                        .read<PendingMrdBloc>()
                        .add(SetStatusFilterEvent(val!)),
                    isDark: isDark,
                    cardBg: cardBg,
                    borderCol: borderCol,
                  ),
                  SizedBox(height: 16.h),

                  MrdCategoryChips(
                    selectedCategory: state.selectedCategory,
                    counts: state.counts,
                    onCategorySelected: (val) => context
                        .read<PendingMrdBloc>()
                        .add(SetCategoryEvent(val)),
                  ),
                  SizedBox(height: 20.h),

                  // 6. Patients Table / Lists
                  MrdPatientTable(
                    records: state.filteredRecords,
                    isDark: isDark,
                    cardBg: cardBg,
                    borderCol: borderCol,
                  ),
                  SizedBox(height: 24.h),

                  // 7. Footer Timely completion banner
                  MrdFooter(isDark: isDark),
                  SizedBox(height: 24.h),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
