import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/router/route_names.dart';
import 'package:medi_connect/core/app_responsive.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/modules/departments/customer_care/presentation/bloc/customer_care_bloc.dart';
import 'package:medi_connect/modules/departments/customer_care/presentation/widgets/customer_care_header.dart';
import 'package:medi_connect/modules/departments/customer_care/presentation/widgets/customer_care_stats_grid.dart';
import 'package:medi_connect/modules/departments/customer_care/presentation/widgets/customer_care_actions_grid.dart';
import 'package:medi_connect/modules/departments/customer_care/presentation/widgets/customer_care_charts_section.dart';
import 'package:medi_connect/modules/departments/customer_care/presentation/widgets/customer_care_recent_activity.dart';
import 'package:medi_connect/modules/departments/customer_care/presentation/widgets/customer_care_footer.dart';

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
        appBarNeeded: false,
        //  customAppbar: const CommonAppBar(title: "Customer Care Department"),
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
                    CustomerCareHeader(
                      onReset: () {
                        context.read<CustomerCareBloc>().add(
                          LoadCustomerCareStats(),
                        );
                      },
                    ),
                    SizedBox(height: 20.h),
                    CustomerCareStatsGrid(stats: stats),
                    SizedBox(height: 20.h),
                    CustomerCareActionsGrid(
                      onActionClick: (title) {
                        if (title == AppStrings.register) {
                          context.push(RouteNames.patientRegistration);
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
