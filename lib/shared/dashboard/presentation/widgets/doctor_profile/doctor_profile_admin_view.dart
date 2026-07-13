import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/features/management/staff_management/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/features/management/staff_management/presentation/bloc/doctor_staff_event.dart';

// Sub-widgets
import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_profile/doctor_profile_header.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_profile/doctor_hero_card.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_profile/doctor_stats_row.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_profile/doctor_tab_bar.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_profile/doctor_info_card.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_profile/doctor_availability_card.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_profile/doctor_key_statistics_card.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_profile/doctor_leave_card.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_profile/slot_management_card.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_profile/consultation_list_card.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_profile/appointments_summary_card.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_profile/consultation_summary_card.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_profile/revenue_summary_card.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_profile/patient_feedback_card.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_profile/quick_actions_row.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_profile/doctor_profile_tabs.dart';

class DoctorProfileAdminView extends StatefulWidget {
  final UserModel user;
  const DoctorProfileAdminView({super.key, required this.user});

  @override
  State<DoctorProfileAdminView> createState() => _DoctorProfileAdminViewState();
}

class _DoctorProfileAdminViewState extends State<DoctorProfileAdminView> {
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Premium background gradient matching the user's theme request
    final bgGradient = isDark
        ? const LinearGradient(
            colors: [Color(0xFF03070E), Color(0xFF091629), Color(0xFF030914)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Color(0xFFF4F7FA), Color(0xFFE2EAF4), Color(0xFFF3F7FD)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: bgGradient),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 800;

              return Column(
                children: [
                  // 1. Top Header with Back button and profile options
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 12.h,
                    ),
                    child: const DoctorProfileHeader(),
                  ),

                  // Scrollable Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // 2. Doctor main details highlight card
                          DoctorHeroCard(user: widget.user),
                          SizedBox(height: 12.h),

                          // 3. Highlight numbers/statistics row
                          DoctorStatsRow(user: widget.user),
                          SizedBox(height: 12.h),

                          // 4. Custom segmented tabs
                          DoctorTabBar(
                            selectedIndex: _currentTab,
                            onTabChanged: (idx) {
                              setState(() {
                                _currentTab = idx;
                              });
                            },
                          ),
                          SizedBox(height: 16.h),

                          // 5. Tab Views Content
                          _buildTabContent(isWide),

                          SizedBox(height: 24.h),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTabContent(bool isWide) {
    switch (_currentTab) {
      case 0:
        return _buildOverviewTab(isWide);
      case 1:
        return SlotManagementCard(user: widget.user);
      case 2:
        return ConsultationListCard(user: widget.user);
      case 3:
        return AppointmentsSummaryCard(user: widget.user);
      case 4:
        return DoctorLeaveCard(user: widget.user);
      case 5:
        return DoctorProfileTabs.buildPatientsTab(context);
      case 6:
        return DoctorProfileTabs.buildDocumentsTab(context);
      case 7:
        return _buildAnalyticsTab(isWide);
      default:
        return _buildOverviewTab(isWide);
    }
  }

  Widget _buildOverviewTab(bool isWide) {
    if (isWide) {
      // Wide screens: Left side details, Right side slots/consultations
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Left Column
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    DoctorInfoCard(
                      user: widget.user,
                      onEdit: () async {
                        final res = await context.push(
                          '/admin/doctor-staff/edit',
                          extra: widget.user,
                        );
                        if (res == true && context.mounted) {
                          context.read<DoctorStaffBloc>().add(
                            const LoadDoctorStaff('All'),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 16.h),
                    DoctorAvailabilityCard(
                      initialStatus: 'Available',
                      onStatusChanged: (newStatus) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("Availability changed to $newStatus"),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 16.h),
                    DoctorKeyStatisticsCard(user: widget.user),
                    SizedBox(height: 16.h),
                    DoctorLeaveCard(user: widget.user),
                  ],
                ),
              ),
              SizedBox(width: 16.w),
              // Right Column
              Expanded(
                flex: 7,
                child: Column(
                  children: [
                    SlotManagementCard(user: widget.user),
                    SizedBox(height: 16.h),
                    ConsultationListCard(user: widget.user),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _buildAnalyticsSection(isWide),
          SizedBox(height: 20.h),
          QuickActionsRow(user: widget.user),
        ],
      );
    } else {
      // Narrow screens: Stacking everything vertically
      return Column(
        children: [
          DoctorInfoCard(
            user: widget.user,
            onEdit: () async {
              final res = await context.push(
                '/admin/doctor-staff/edit',
                extra: widget.user,
              );
              if (res == true && context.mounted) {
                context.read<DoctorStaffBloc>().add(
                  const LoadDoctorStaff('All'),
                );
              }
            },
          ),
          SizedBox(height: 16.h),
          DoctorAvailabilityCard(
            initialStatus: 'Available',
            onStatusChanged: (newStatus) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Availability changed to $newStatus")),
              );
            },
          ),
          SizedBox(height: 16.h),
          SlotManagementCard(user: widget.user),
          SizedBox(height: 16.h),
          ConsultationListCard(user: widget.user),
          SizedBox(height: 16.h),
          DoctorKeyStatisticsCard(user: widget.user),
          SizedBox(height: 16.h),
          DoctorLeaveCard(user: widget.user),
          SizedBox(height: 20.h),
          _buildAnalyticsSection(isWide),
          SizedBox(height: 20.h),
          QuickActionsRow(user: widget.user),
        ],
      );
    }
  }

  Widget _buildAnalyticsTab(bool isWide) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAnalyticsSection(isWide),
        SizedBox(height: 20.h),
        QuickActionsRow(user: widget.user),
      ],
    );
  }

  Widget _buildAnalyticsSection(bool isWide) {
    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: AppointmentsSummaryCard(user: widget.user)),
          SizedBox(width: 12.w),
          Expanded(child: ConsultationSummaryCard(user: widget.user)),
          SizedBox(width: 12.w),
          Expanded(child: RevenueSummaryCard(user: widget.user)),
          SizedBox(width: 12.w),
          Expanded(child: PatientFeedbackCard(user: widget.user)),
        ],
      );
    } else {
      return Column(
        children: [
          AppointmentsSummaryCard(user: widget.user),
          SizedBox(height: 12.h),
          ConsultationSummaryCard(user: widget.user),
          SizedBox(height: 12.h),
          RevenueSummaryCard(user: widget.user),
          SizedBox(height: 12.h),
          PatientFeedbackCard(user: widget.user),
        ],
      );
    }
  }
}
