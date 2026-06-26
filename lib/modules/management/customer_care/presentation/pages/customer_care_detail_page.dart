import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/routes/route_names.dart';
import 'package:medi_connect/core/functions/app_responsive.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/modules/management/customer_care/presentation/bloc/customer_care_bloc.dart';
import 'package:medi_connect/modules/management/customer_care/presentation/widgets/customer_care_header.dart';
import 'package:medi_connect/modules/management/customer_care/presentation/widgets/customer_care_stats_grid.dart';
import 'package:medi_connect/modules/management/customer_care/presentation/widgets/customer_care_actions_grid.dart';
import 'package:medi_connect/modules/management/customer_care/presentation/widgets/customer_care_charts_section.dart';
import 'package:medi_connect/modules/management/customer_care/presentation/widgets/customer_care_recent_activity.dart';
import 'package:medi_connect/modules/management/customer_care/presentation/widgets/customer_care_footer.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/bloc/emrd_bloc.dart';
import 'package:medi_connect/modules/departments/emrd/presentation/pages/medical_record_management_page.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/appointments/create_appointment_wizard_dialog.dart';

class CustomerCareDetailPage extends StatefulWidget {
  const CustomerCareDetailPage({super.key});

  @override
  State<CustomerCareDetailPage> createState() => _CustomerCareDetailPageState();
}

class _CustomerCareDetailPageState extends State<CustomerCareDetailPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          GetIt.I<CustomerCareBloc>()..add(LoadCustomerCareStats()),
      child: CustomScaffold(
        appBarNeeded: true,
        customAppbar: PreferredSize(
          preferredSize: Size(double.infinity, 120.h),

          child: CustomerCareHeader(
            onReset: () {
              context.read<CustomerCareBloc>().add(LoadCustomerCareStats());
            },
          ),
        ),
        body: BlocBuilder<CustomerCareBloc, CustomerCareState>(
          builder: (context, state) {
            if (state is CustomerCareLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CustomerCareError) {
              return Center(
                child: Text(
                  state.message,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
              );
            } else if (state is CustomerCareLoaded) {
              final stats = state.stats;
              final activities =
                  stats['recent_activities'] as List<dynamic>? ?? [];

              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: AppResponsive.horizontalPadding(context),
                  vertical: 24.h,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.h),
                    CustomerCareStatsGrid(stats: stats),
                    SizedBox(height: 20.h),
                    CustomerCareActionsGrid(
                      onActionClick: (title) {
                        if (title == AppStrings.register) {
                          context.push(RouteNames.patientRegistration);
                        } else if (title == AppStrings.patientSearch) {
                          context.push(RouteNames.patientSearch);
                        } else if (title == AppStrings.appointment) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            builder: (ctx) =>
                                const CreateAppointmentWizardBottomSheet(),
                          );
                        } else if (title == "Consultation") {
                          final emrdBloc = context.read<EmrdBloc>();
                          emrdBloc.add(LoadEmrdStats());
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BlocProvider.value(
                                value: emrdBloc,
                                child: const MedicalRecordManagementPage(),
                              ),
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 20.h),
                    CustomerCareChartsSection(stats: stats),
                    SizedBox(height: 20.h),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth > 950) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: CustomerCareRecentActivity(
                                  activities: activities,
                                ),
                              ),
                              SizedBox(width: 16.w),
                              const Expanded(flex: 1, child: SizedBox.shrink()),
                            ],
                          );
                        } else {
                          return CustomerCareRecentActivity(
                            activities: activities,
                          );
                        }
                      },
                    ),
                    SizedBox(height: 20.h),
                    CustomerCareFooter(stats: stats),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
