import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/widgets/buttons/common_button.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/doctor/opinfo/presentation/bloc/op_info_bloc.dart';
import 'package:medi_connect/features/doctor/opinfo/presentation/bloc/op_info_event.dart';
import 'package:medi_connect/features/doctor/opinfo/presentation/bloc/op_info_state.dart';
import 'package:medi_connect/features/doctor/opinfo/presentation/widgets/op_info_appointments_section.dart';
import 'package:medi_connect/features/doctor/opinfo/presentation/widgets/op_info_date_card.dart';
import 'package:medi_connect/features/doctor/opinfo/presentation/widgets/op_info_filter_chips.dart';
import 'package:medi_connect/features/doctor/opinfo/presentation/widgets/op_info_header.dart';
import 'package:medi_connect/features/doctor/opinfo/presentation/widgets/op_info_search_bar.dart';
import 'package:medi_connect/features/doctor/opinfo/presentation/widgets/op_info_summary_card.dart';

class OpInfoPage extends StatelessWidget {
  final DateTime? initialDate;

  const OpInfoPage({super.key, this.initialDate});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final bloc = GetIt.I<OpInfoBloc>();
        final authState = context.read<AuthBloc>().state;
        if (authState is Authenticated) {
          bloc.add(
            OpInfoLoadRequested(
              doctorId: authState.user.id,
              date: initialDate ?? DateTime.now(),
            ),
          );
        }
        return bloc;
      },
      child: const _OpInfoBody(),
    );
  }
}

class _OpInfoBody extends StatelessWidget {
  const _OpInfoBody();

  void _retry(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      final state = context.read<OpInfoBloc>().state;
      final date = state is OpInfoLoaded ? state.selectedDate : DateTime.now();
      context.read<OpInfoBloc>().add(
        OpInfoLoadRequested(doctorId: authState.user.id, date: date),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      //  backgroundColor: AppColors.lightScaffold,
      body: SafeArea(
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            if (authState is! Authenticated) {
              return const Center(child: CircularProgressIndicator());
            }

            return BlocBuilder<OpInfoBloc, OpInfoState>(
              builder: (context, state) {
                if (state is OpInfoLoading || state is OpInfoInitial) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is OpInfoError) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(state.message),
                        CommonButton(
                          text: AppStrings.retry,
                          width: 120,
                          onPressed: () => _retry(context),
                        ),
                      ],
                    ),
                  );
                }
                if (state is! OpInfoLoaded) return const SizedBox.shrink();

                final bloc = context.read<OpInfoBloc>();
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OpInfoHeader(
                        doctor: authState.user,
                        onSearchTap: () {},
                        onNotificationsTap: () {},
                      ),
                      OpInfoDateCard(
                        selectedDate: state.selectedDate,
                        onPrevious: () => bloc.add(const OpInfoPreviousDay()),
                        onNext: () => bloc.add(const OpInfoNextDay()),
                      ),
                      OpInfoSummaryCard(
                        total: state.summary.total,
                        pending: state.summary.pending,
                        completed: state.summary.completed,
                        cancelled: state.summary.cancelled,
                      ),
                      OpInfoSearchBar(
                        query: state.searchQuery,
                        onChanged: (q) => bloc.add(OpInfoSearchChanged(q)),
                        onFilterTap: () {},
                      ),
                      OpInfoFilterChips(
                        activeFilter: state.activeFilter,
                        total: state.summary.total,
                        pending: state.summary.pending,
                        completed: state.summary.completed,
                        cancelled: state.summary.cancelled,
                        onFilterChanged: (f) =>
                            bloc.add(OpInfoFilterChanged(f)),
                      ),
                      OpInfoAppointmentsSection(
                        procedures: state.filteredProcedures,
                        totalCount: state.summary.total,
                        selectedDate: state.selectedDate,
                        doctorName: authState.user.fullName,
                        specialty: 'General Physician',
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
