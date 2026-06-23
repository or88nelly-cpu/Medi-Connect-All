import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/widgets/appbar/common_app_bar.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/bloc/emrd_bloc.dart';
import 'package:medi_connect/modules/departments/emrd/presentation/widgets/emrd_dashboard_header.dart';
import 'package:medi_connect/modules/departments/emrd/presentation/widgets/emrd_operation_card.dart';
import 'package:medi_connect/modules/departments/emrd/presentation/widgets/emrd_ai_assistant_panel.dart';
import 'package:medi_connect/modules/departments/emrd/presentation/widgets/emrd_admin_analytics_section.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/pages/patient_registry_page.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/pages/medical_record_management_page.dart';

class EmrdDetailPage extends StatelessWidget {
  const EmrdDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => GetIt.I<EmrdBloc>()..add(LoadEmrdStats()),
      child: CustomScaffold(
        customAppbar: const CommonAppBar(title: "EMRD Operations"),
        body: BlocBuilder<EmrdBloc, EmrdState>(
          builder: (context, state) {
            if (state is EmrdLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is EmrdError) {
              return Center(
                child: Text(
                  state.message,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.error,
                  ),
                ),
              );
            } else if (state is EmrdLoaded) {
              final stats = state.stats;
              final double screenWidth = MediaQuery.of(context).size.width;
              final int crossAxisCount = screenWidth > 600 ? 4 : 2;

              return BlocBuilder<AuthBloc, AuthState>(
                builder: (context, authState) {
                  String userRole = 'staff';
                  String userName = 'Staff Member';
                  String? profileImage;
                  String? gender;

                  if (authState is Authenticated) {
                    userRole = authState.user.role;
                    userName = authState.user.name ?? 'Staff Member';
                    profileImage = authState.user.profileImage;
                    gender = authState.user.gender;
                  }

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. HEADER SECTION
                        EmrdDashboardHeader(
                          name: userName,
                          role: userRole,
                          profileImage: profileImage,
                          gender: gender,
                          stats: stats,
                          isDark: isDark,
                          onBack: () => context.pop(),
                        ),
                        
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // 2. OPERATIONS GRID TITLE
                              Text(
                                "Operations Modules",
                                style: AppTextStyles.titleMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.sp,
                                  color: AppColors.textPrimary(context),
                                ),
                              ),
                              SizedBox(height: 12.h),

                              // 3. 4x4 OPERATIONS GRID
                              GridView.count(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                crossAxisCount: crossAxisCount,
                                mainAxisSpacing: 12.h,
                                crossAxisSpacing: 12.w,
                                childAspectRatio: 1.1,
                                children: [
                                  EmrdOperationCard(
                                    title: "Patient Registry & Identification",
                                    value: NumberFormat('#,###').format(stats['total_patients'] ?? 245680),
                                    subtitle: "Total Patients",
                                    icon: Icons.badge_outlined,
                                    accentColor: const Color(0xFF0284C7),
                                    isDark: isDark,
                                    onTap: () {
                                      final emrdBloc = context.read<EmrdBloc>();
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => BlocProvider.value(
                                            value: emrdBloc,
                                            child: const PatientRegistryPage(),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  EmrdOperationCard(
                                    title: "Medical Record Management",
                                    value: NumberFormat('#,###').format(stats['total_records'] ?? 198420),
                                    subtitle: "Total Records",
                                    icon: Icons.folder_shared_outlined,
                                    accentColor: const Color(0xFF22C55E),
                                    isDark: isDark,
                                    onTap: () {
                                      final emrdBloc = context.read<EmrdBloc>();
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => BlocProvider.value(
                                            value: emrdBloc,
                                            child: const MedicalRecordManagementPage(),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  EmrdOperationCard(
                                    title: "Document Management",
                                    value: NumberFormat('#,###').format(stats['total_documents'] ?? 156240),
                                    subtitle: "Total Documents",
                                    icon: Icons.description_outlined,
                                    accentColor: const Color(0xFF8B5CF6),
                                    isDark: isDark,
                                  ),
                                  EmrdOperationCard(
                                    title: "Record Tracking",
                                    value: NumberFormat('#,###').format(stats['files_in_tracking'] ?? 2450),
                                    subtitle: "Files in Tracking",
                                    icon: Icons.location_on_outlined,
                                    accentColor: const Color(0xFFEF4444),
                                    isDark: isDark,
                                  ),
                                  EmrdOperationCard(
                                    title: "Coding & Statistics",
                                    value: NumberFormat('#,###').format(stats['coded_records'] ?? 18540),
                                    subtitle: "Coded Records",
                                    icon: Icons.bar_chart_outlined,
                                    accentColor: const Color(0xFF0D9488),
                                    isDark: isDark,
                                  ),
                                  EmrdOperationCard(
                                    title: "Discharge Record Management",
                                    value: NumberFormat('#,###').format(stats['pending_summaries'] ?? 1245),
                                    subtitle: "Pending Summaries",
                                    icon: Icons.assignment_turned_in_outlined,
                                    accentColor: const Color(0xFFEC4899),
                                    isDark: isDark,
                                  ),
                                  EmrdOperationCard(
                                    title: "Birth & Death Registry",
                                    value: NumberFormat('#,###').format(stats['total_registrations'] ?? 860),
                                    subtitle: "Total Registrations",
                                    icon: Icons.child_care_outlined,
                                    accentColor: const Color(0xFFF97316),
                                    isDark: isDark,
                                  ),
                                  EmrdOperationCard(
                                    title: "MLC Management",
                                    value: NumberFormat('#,###').format(stats['active_mlc_cases'] ?? 145),
                                    subtitle: "Active MLC Cases",
                                    icon: Icons.balance_outlined,
                                    accentColor: const Color(0xFF3B82F6),
                                    isDark: isDark,
                                  ),
                                  EmrdOperationCard(
                                    title: "Record Retention & Archiving",
                                    value: NumberFormat('#,###').format(stats['archived_records'] ?? 47260),
                                    subtitle: "Archived Records",
                                    icon: Icons.archive_outlined,
                                    accentColor: const Color(0xFF6366F1),
                                    isDark: isDark,
                                  ),
                                  EmrdOperationCard(
                                    title: "Reports & Dashboards",
                                    value: NumberFormat('#,###').format(stats['generated_reports'] ?? 320),
                                    subtitle: "Generated Reports",
                                    icon: Icons.pie_chart_outline,
                                    accentColor: const Color(0xFF475569),
                                    isDark: isDark,
                                  ),
                                  EmrdOperationCard(
                                    title: "NABH Compliance",
                                    value: "${stats['compliance_score'] ?? 92}%",
                                    subtitle: "Compliance Score",
                                    icon: Icons.verified_user_outlined,
                                    accentColor: const Color(0xFF10B981),
                                    isDark: isDark,
                                  ),
                                  EmrdOperationCard(
                                    title: "User Access Control",
                                    value: NumberFormat('#,###').format(stats['active_users'] ?? 486),
                                    subtitle: "Active Users",
                                    icon: Icons.lock_open_outlined,
                                    accentColor: const Color(0xFFD97706),
                                    isDark: isDark,
                                  ),
                                  EmrdOperationCard(
                                    title: "Alerts & Notifications",
                                    value: NumberFormat('#,###').format(stats['active_alerts'] ?? 58),
                                    subtitle: "Active Alerts",
                                    icon: Icons.notifications_active_outlined,
                                    accentColor: const Color(0xFFDC2626),
                                    isDark: isDark,
                                    badgeCount: stats['active_alerts'],
                                  ),
                                  EmrdOperationCard(
                                    title: "Audit Management",
                                    value: NumberFormat('#,###').format(stats['audit_records'] ?? 125),
                                    subtitle: "Audit Records",
                                    icon: Icons.gavel_outlined,
                                    accentColor: const Color(0xFF78350F),
                                    isDark: isDark,
                                  ),
                                  EmrdOperationCard(
                                    title: "Insurance Records",
                                    value: NumberFormat('#,###').format(stats['insurance_records'] ?? 2450),
                                    subtitle: "Insurance Records",
                                    icon: Icons.health_and_safety_outlined,
                                    accentColor: const Color(0xFF06B6D4),
                                    isDark: isDark,
                                  ),
                                  EmrdOperationCard(
                                    title: "AI Insights",
                                    value: NumberFormat('#,###').format(stats['active_insights'] ?? 15),
                                    subtitle: "Active Insights",
                                    icon: Icons.psychology_outlined,
                                    accentColor: const Color(0xFF7C3AED),
                                    isDark: isDark,
                                  ),
                                ],
                              ),
                              SizedBox(height: 24.h),

                              // 4. AI-POWERED MRD ASSISTANT PANEL
                              EmrdAIAssistantPanel(stats: stats, isDark: isDark),
                              SizedBox(height: 24.h),

                              // 5. ADMIN-ONLY ANALYTICAL TRENDS
                              if (userRole == 'admin') ...[
                                EmrdAdminAnalyticsSection(stats: stats, isDark: isDark),
                                SizedBox(height: 20.h),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
