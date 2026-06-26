import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/common/dashboard_tab_cubit.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/doctor/doctor_appointments_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/appointments/create_appointment_wizard_dialog.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_dashboard/doctor_welcome_banner.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_dashboard/doctor_consultations_card.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_dashboard/doctor_stat_card.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_dashboard/doctor_action_button.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_dashboard/doctor_alerts_banner.dart';

class DoctorHomeTab extends StatelessWidget {
  const DoctorHomeTab({super.key});

  void _showCreateAppointmentWizard(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const CreateAppointmentWizardBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! Authenticated) {
          return const Center(child: CircularProgressIndicator());
        }
        final doctor = authState.user;
        final docDisplayName =
            doctor.name ??
            "${doctor.firstName ?? ''} ${doctor.lastName ?? ''}".trim();

        return BlocBuilder<DoctorAppointmentsBloc, DoctorAppointmentsState>(
          builder: (context, state) {
            int totalAptsCount = 0;
            int completedAptsCount = 0;
            int newPatientsCount = 0;
            int pendingFollowUpsCount = 0;

            if (state is DoctorAppointmentsLoaded) {
              final appointments = state.appointments;

              // Filter for current logged-in doctor
              final doctorApts = appointments.where((a) {
                final matchId = a.doctorId == doctor.id;
                final matchName =
                    a.doctorName.toLowerCase().replaceAll("dr.", "").trim() ==
                    docDisplayName.toLowerCase().replaceAll("dr.", "").trim();
                return matchId || matchName;
              }).toList();

              totalAptsCount = doctorApts.length;
              completedAptsCount = doctorApts
                  .where((a) => a.status == 'Completed')
                  .length;
              newPatientsCount = doctorApts
                  .map((a) => a.patientId)
                  .toSet()
                  .length;
              pendingFollowUpsCount = doctorApts
                  .where((a) => a.status == 'Pending')
                  .length;
            }

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const DoctorWelcomeBanner(),
                  SizedBox(height: 24.h),

                  // Section Title: Quick Overview
                  Text(
                    "Quick Overview",
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: isDark
                          ? Colors.white
                          : AppColors.textPrimary(context),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Horizontal scrollable stats cards
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    child: SizedBox(
                      height: 100.r,
                      child: Row(
                        children: [
                          DoctorStatCard(
                            icon: Icons.calendar_today_outlined,
                            value: totalAptsCount.toString(),
                            label: "Total Appointments",
                            badgeText: "↑ 12% vs yesterday",
                            themeColor: const Color(0xFF1A73E8),
                          ),
                          SizedBox(width: 12.w),
                          DoctorStatCard(
                            icon: Icons.assignment_turned_in_outlined,
                            value: completedAptsCount.toString(),
                            label: "Completed Consults",
                            badgeText: "↑ 18% vs yesterday",
                            themeColor: const Color(0xFF137333),
                          ),
                          SizedBox(width: 12.w),
                          DoctorStatCard(
                            icon: Icons.people_outline,
                            value: newPatientsCount.toString(),
                            label: "New Patients",
                            badgeText: "Today",
                            themeColor: const Color(0xFF7E22CE),
                          ),
                          SizedBox(width: 12.w),
                          DoctorStatCard(
                            icon: Icons.access_time,
                            value: pendingFollowUpsCount.toString(),
                            label: "Pending Follow Ups",
                            badgeText: "Today",
                            themeColor: const Color(0xFFEA580C),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Section Title: Today's Schedule + View All
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Today's Schedule",
                        style: AppTextStyles.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                          color: isDark
                              ? Colors.white
                              : AppColors.textPrimary(context),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<DashboardTabCubit>().setTab(1);
                        },
                        child: Row(
                          children: [
                            Text(
                              "View All",
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF1A73E8),
                              ),
                            ),
                            SizedBox(width: 2.w),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 10.r,
                              color: const Color(0xFF1A73E8),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  const DoctorConsultationsCard(),
                  SizedBox(height: 24.h),

                  // Section Title: Quick Actions
                  Text(
                    "Quick Actions",
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                      color: isDark
                          ? Colors.white
                          : AppColors.textPrimary(context),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Grid of 8 Actions
                  GridView.count(
                    crossAxisCount: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 10.r,
                    crossAxisSpacing: 10.r,
                    childAspectRatio: 0.95,
                    children: [
                      DoctorActionButton(
                        icon: Icons.person_add_alt_1_outlined,
                        label: "New Consultation",
                        color: const Color(0xFF1A73E8),
                        onTap: () => _showCreateAppointmentWizard(context),
                      ),
                      DoctorActionButton(
                        icon: Icons.search_outlined,
                        label: "Patient Search",
                        color: const Color(0xFF137333),
                        onTap: () =>
                            context.read<DashboardTabCubit>().setTab(2),
                      ),
                      DoctorActionButton(
                        icon: Icons.description_outlined,
                        label: "Prescription",
                        color: const Color(0xFF7E22CE),
                        onTap: () =>
                            context.read<DashboardTabCubit>().setTab(3),
                      ),
                      DoctorActionButton(
                        icon: Icons.science_outlined,
                        label: "Lab Orders",
                        color: const Color(0xFFEA580C),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Lab Orders clicked")),
                          );
                        },
                      ),
                      DoctorActionButton(
                        icon: Icons.analytics_outlined,
                        label: "Reports",
                        color: const Color(0xFFEC4899),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Reports clicked")),
                          );
                        },
                      ),
                      DoctorActionButton(
                        icon: Icons.people_alt_outlined,
                        label: "My Patients",
                        color: const Color(0xFF06B6D4),
                        onTap: () =>
                            context.read<DashboardTabCubit>().setTab(2),
                      ),
                      DoctorActionButton(
                        icon: Icons.calendar_month_outlined,
                        label: "Calendar",
                        color: const Color(0xFF6366F1),
                        onTap: () =>
                            context.read<DashboardTabCubit>().setTab(1),
                      ),
                      DoctorActionButton(
                        icon: Icons.more_horiz_outlined,
                        label: "More",
                        color: const Color(0xFF6B7280),
                        onTap: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 24.h),

                  // Important Alerts Banner
                  const DoctorAlertsBanner(),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
