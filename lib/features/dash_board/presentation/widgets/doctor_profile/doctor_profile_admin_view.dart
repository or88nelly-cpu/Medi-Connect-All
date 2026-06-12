import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_event.dart';

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
        return ConsultationListCard(user: widget.user);
      case 3:
        return AppointmentsSummaryCard(user: widget.user);
      case 4:
        return DoctorLeaveCard(user: widget.user);
      case 5:
        return _buildPatientsTab();
      case 6:
        return _buildDocumentsTab();
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
                        final res = await context.push('/admin/doctor-staff/edit', extra: widget.user);
                        if (res == true && context.mounted) {
                          context.read<DoctorStaffBloc>().add(LoadDoctorStaff(widget.user.department ?? 'All'));
                        }
                      },
                    ),
                    SizedBox(height: 16.h),
                    DoctorAvailabilityCard(
                      initialStatus: widget.user.availabilityStatus ?? 'Available',
                      onStatusChanged: (newStatus) {
                        final updated = widget.user.copyWith(availabilityStatus: newStatus);
                        context.read<DoctorStaffBloc>().add(UpdateDoctorStaffMember(updated));
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
              final res = await context.push('/admin/doctor-staff/edit', extra: widget.user);
              if (res == true && context.mounted) {
                context.read<DoctorStaffBloc>().add(LoadDoctorStaff(widget.user.department ?? 'All'));
              }
            },
          ),
          SizedBox(height: 16.h),
          DoctorAvailabilityCard(
            initialStatus: widget.user.availabilityStatus ?? 'Available',
            onStatusChanged: (newStatus) {
              final updated = widget.user.copyWith(availabilityStatus: newStatus);
              context.read<DoctorStaffBloc>().add(UpdateDoctorStaffMember(updated));
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

  Widget _buildPatientsTab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final borderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;

    final metadataConsultations = widget.user.metadata?['consultations'] as List<dynamic>?;
    final List<Map<String, dynamic>> patients = [];
    final Set<String> uniqueNames = {};

    if (metadataConsultations != null) {
      for (var item in metadataConsultations) {
        if (item is Map) {
          final name = (item['name'] ?? '').toString();
          if (name.isNotEmpty && !uniqueNames.contains(name)) {
            uniqueNames.add(name);
            patients.add({
              'name': name,
              'age': int.tryParse(item['age']?.toString() ?? '') ?? 30,
              'gender': (item['gender'] ?? 'Male').toString(),
              'lastVisit': (item['time'] ?? '09:00 AM').toString(),
              'type': (item['type'] ?? 'Regular').toString(),
            });
          }
        }
      }
    }

    if (patients.isEmpty) {
      patients.addAll([
        {'name': 'Ramesh Kumar', 'age': 45, 'gender': 'Male', 'lastVisit': '10:00 AM', 'type': 'Follow Up'},
        {'name': 'Anita Sharma', 'age': 38, 'gender': 'Female', 'lastVisit': '09:20 AM', 'type': 'New Consultation'},
        {'name': 'Vikram Singh', 'age': 52, 'gender': 'Male', 'lastVisit': '09:40 AM', 'type': 'Follow Up'},
        {'name': 'Pooja Mehta', 'age': 29, 'gender': 'Female', 'lastVisit': '11:00 AM', 'type': 'New Consultation'},
      ]);
    }

    return Card(
      elevation: 0,
      color: cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: borderColor),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Consulted Patients",
              style: AppTextStyles.titleMedium.copyWith(color: textColor, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: patients.length,
              separatorBuilder: (context, idx) => Divider(color: borderColor, height: 1),
              itemBuilder: (context, idx) {
                final p = patients[idx];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    backgroundColor: isDark ? Colors.white10 : Colors.black12,
                    child: Icon(
                      p['gender'] == 'Male' ? Icons.male : Icons.female,
                      color: AppColors.primary,
                    ),
                  ),
                  title: Text(
                    p['name']!,
                    style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13.sp),
                  ),
                  subtitle: Text(
                    "Age: ${p['age']} • ${p['gender']} • Last Visit: ${p['lastVisit']}",
                    style: TextStyle(color: labelColor, fontSize: 11.sp),
                  ),
                  trailing: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      p['type']!,
                      style: TextStyle(color: AppColors.primary, fontSize: 10.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDocumentsTab() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final borderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;

    final metadataDocs = widget.user.metadata?['documents'] as List<dynamic>?;
    final List<Map<String, dynamic>> documents = [];
    if (metadataDocs != null) {
      for (var item in metadataDocs) {
        if (item is Map) {
          documents.add({
            'name': (item['name'] ?? '').toString(),
            'issueDate': (item['issueDate'] ?? '').toString(),
            'status': (item['status'] ?? '').toString(),
          });
        }
      }
    }

    if (documents.isEmpty) {
      documents.addAll([
        {'name': 'Medical Registration Certificate', 'issueDate': '12 Jan 2018', 'status': 'Verified'},
        {'name': 'Specialization Degree (MD)', 'issueDate': '24 Jun 2021', 'status': 'Verified'},
        {'name': 'Board Certification in Medicine', 'issueDate': '15 Aug 2022', 'status': 'Verified'},
      ]);
    }

    return Card(
      elevation: 0,
      color: cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: borderColor),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Verification Documents",
                  style: AppTextStyles.titleMedium.copyWith(color: textColor, fontWeight: FontWeight.bold),
                ),
                TextButton.icon(
                  onPressed: () => _showUploadDocumentDialog(),
                  icon: const Icon(Icons.upload, size: 14),
                  label: const Text("Upload Doc"),
                  style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: documents.length,
              separatorBuilder: (context, idx) => Divider(color: borderColor, height: 1),
              itemBuilder: (context, idx) {
                final d = documents[idx];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.verified_user, color: AppColors.success, size: 24.sp),
                  title: Text(
                    d['name']!,
                    style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13.sp),
                  ),
                  subtitle: Text(
                    "Issued: ${d['issueDate']} • Status: ${d['status']}",
                    style: TextStyle(color: labelColor, fontSize: 11.sp),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.remove_red_eye, color: AppColors.primary, size: 18.sp),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Viewing ${d['name']}...")),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showUploadDocumentDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Upload Verification Document"),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: "Document Name",
              hintText: "e.g. Fellowship Certificate",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                final docName = controller.text.trim();
                if (docName.isEmpty) return;
                Navigator.pop(ctx);

                final updatedMetadata = Map<String, dynamic>.from(widget.user.metadata ?? {});
                final currentDocs = List<dynamic>.from(updatedMetadata['documents'] ?? [
                  {'name': 'Medical Registration Certificate', 'issueDate': '12 Jan 2018', 'status': 'Verified'},
                  {'name': 'Specialization Degree (MD)', 'issueDate': '24 Jun 2021', 'status': 'Verified'},
                  {'name': 'Board Certification in Medicine', 'issueDate': '15 Aug 2022', 'status': 'Verified'},
                ]);

                final days = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
                final now = DateTime.now();
                final dateStr = "${now.day} ${days[now.month - 1]} ${now.year}";

                currentDocs.add({
                  'name': docName,
                  'issueDate': dateStr,
                  'status': 'Pending Verification',
                });

                updatedMetadata['documents'] = currentDocs;
                final updatedUser = widget.user.copyWith(metadata: updatedMetadata);

                context.read<DoctorStaffBloc>().add(UpdateDoctorStaffMember(updatedUser));
              },
              child: const Text("Upload"),
            ),
          ],
        );
      },
    );
  }
}
