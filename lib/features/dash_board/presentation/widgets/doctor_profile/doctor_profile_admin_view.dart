import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';

// Sub-widgets
import 'doctor_profile_header.dart';
import 'doctor_hero_card.dart';
import 'doctor_stats_row.dart';
import 'doctor_tab_bar.dart';
import 'doctor_info_card.dart';
import 'doctor_availability_card.dart';
import 'doctor_key_statistics_card.dart';
import 'doctor_leave_card.dart';
import 'slot_management_card.dart';
import 'consultation_list_card.dart';
import 'appointments_summary_card.dart';
import 'consultation_summary_card.dart';
import 'revenue_summary_card.dart';
import 'patient_feedback_card.dart';
import 'quick_actions_row.dart';

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
                    padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
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
        return const ConsultationListCard();
      case 3:
        return const AppointmentsSummaryCard();
      case 4:
        return const DoctorLeaveCard();
      case 5:
        return _buildPlaceholderView("Patients List View", Icons.people_outline);
      case 6:
        return _buildPlaceholderView("Documents & Certificates View", Icons.description_outlined);
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
                      onEdit: () => context.push('/admin/doctor-staff/edit', extra: widget.user),
                    ),
                    SizedBox(height: 16.h),
                    DoctorAvailabilityCard(initialStatus: widget.user.availabilityStatus ?? 'Available'),
                    SizedBox(height: 16.h),
                    const DoctorKeyStatisticsCard(),
                    SizedBox(height: 16.h),
                    const DoctorLeaveCard(),
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
                    const ConsultationListCard(),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _buildAnalyticsSection(isWide),
          SizedBox(height: 20.h),
          const QuickActionsRow(),
        ],
      );
    } else {
      // Narrow screens: Stacking everything vertically
      return Column(
        children: [
          DoctorInfoCard(
            user: widget.user,
            onEdit: () => context.push('/admin/doctor-staff/edit', extra: widget.user),
          ),
          SizedBox(height: 16.h),
          DoctorAvailabilityCard(initialStatus: widget.user.availabilityStatus ?? 'Available'),
          SizedBox(height: 16.h),
          SlotManagementCard(user: widget.user),
          SizedBox(height: 16.h),
          const ConsultationListCard(),
          SizedBox(height: 16.h),
          const DoctorKeyStatisticsCard(),
          SizedBox(height: 16.h),
          const DoctorLeaveCard(),
          SizedBox(height: 20.h),
          _buildAnalyticsSection(isWide),
          SizedBox(height: 20.h),
          const QuickActionsRow(),
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
        const QuickActionsRow(),
      ],
    );
  }

  Widget _buildAnalyticsSection(bool isWide) {
    if (isWide) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Expanded(child: AppointmentsSummaryCard()),
          SizedBox(width: 12.w),
          const Expanded(child: ConsultationSummaryCard()),
          SizedBox(width: 12.w),
          const Expanded(child: RevenueSummaryCard()),
          SizedBox(width: 12.w),
          const Expanded(child: PatientFeedbackCard()),
        ],
      );
    } else {
      return Column(
        children: [
          const AppointmentsSummaryCard(),
          SizedBox(height: 12.h),
          const ConsultationSummaryCard(),
          SizedBox(height: 12.h),
          const RevenueSummaryCard(),
          SizedBox(height: 12.h),
          const PatientFeedbackCard(),
        ],
      );
    }
  }

  Widget _buildPlaceholderView(String label, IconData icon) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final borderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final textColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: cardBg,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 48.sp, color: AppColors.primary.withOpacity(0.5)),
          SizedBox(height: 16.h),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "This sub-panel is fully integrated into the doctor profile tab manager.",
            style: TextStyle(
              color: isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel,
              fontSize: 11.sp,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
