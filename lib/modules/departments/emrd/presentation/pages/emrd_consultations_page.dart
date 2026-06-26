import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/appbar/common_app_bar.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/shared/dashboard/domain/entities/appointment_entity.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_appointments_bloc.dart';
import 'package:medi_connect/modules/departments/emrd/presentation/widgets/consultations/consultation_list_item.dart';
import 'package:medi_connect/modules/departments/emrd/presentation/widgets/consultations/record_vitals_dialog.dart';
import 'package:medi_connect/modules/departments/emrd/presentation/widgets/consultations/complete_consultation_sheet.dart';

class EmrdConsultationsPage extends StatefulWidget {
  final int initialTab;

  const EmrdConsultationsPage({
    super.key,
    this.initialTab = 0,
  });

  @override
  State<EmrdConsultationsPage> createState() => _EmrdConsultationsPageState();
}

class _EmrdConsultationsPageState extends State<EmrdConsultationsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: widget.initialTab,
    );
    context.read<AdminAppointmentsBloc>().add(LoadAppointments());
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return CustomScaffold(
      customAppbar: const CommonAppBar(title: "EMRD Consultations"),
      body: Column(
        children: [
          // Search & Filter header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: isDark ? AppColors.terminalDarkCard : Colors.white,
              border: Border(
                bottom: BorderSide(color: AppColors.border(context)),
              ),
            ),
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  style: TextStyle(color: isDark ? Colors.white : Colors.black87),
                  decoration: InputDecoration(
                    hintText: "Search by Patient or Doctor...",
                    hintStyle: TextStyle(
                      color: isDark ? Colors.white38 : Colors.black38,
                    ),
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: isDark
                        ? AppColors.terminalDarkFieldFill
                        : AppColors.terminalLightFieldFill,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(color: AppColors.border(context)),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 10.h,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                // Tabs
                TabBar(
                  controller: _tabController,
                  labelColor: AppColors.primary,
                  unselectedLabelColor: isDark ? Colors.white60 : Colors.black54,
                  indicatorColor: AppColors.primary,
                  indicatorSize: TabBarIndicatorSize.tab,
                  labelStyle: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  tabs: const [
                    Tab(text: "Scheduled"),
                    Tab(text: "Completed"),
                    Tab(text: "All"),
                  ],
                ),
              ],
            ),
          ),

          // Content List
          Expanded(
            child: BlocBuilder<AdminAppointmentsBloc, AdminAppointmentsState>(
              builder: (context, state) {
                if (state is AdminAppointmentsLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is AdminAppointmentsError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  );
                } else if (state is AdminAppointmentsLoaded) {
                  return TabBarView(
                    controller: _tabController,
                    children: [
                      _buildAppointmentsList(state.appointments, 'scheduled', isDark),
                      _buildAppointmentsList(state.appointments, 'completed', isDark),
                      _buildAppointmentsList(state.appointments, 'all', isDark),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentsList(
    List<AppointmentEntity> list,
    String filterStatus,
    bool isDark,
  ) {
    // Filter by status
    var filtered = list;
    if (filterStatus == 'scheduled') {
      filtered = list.where((a) => a.status.toLowerCase() == 'scheduled').toList();
    } else if (filterStatus == 'completed') {
      filtered = list.where((a) => a.status.toLowerCase() == 'completed').toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((a) {
        return a.patientName.toLowerCase().contains(_searchQuery) ||
            a.doctorName.toLowerCase().contains(_searchQuery) ||
            a.specialty.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.calendar_today_outlined,
              size: 48.r,
              color: isDark ? Colors.white24 : Colors.black26,
            ),
            SizedBox(height: 12.h),
            Text(
              "No Consultations Found",
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark ? Colors.white38 : Colors.black45,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(20.r),
      physics: const BouncingScrollPhysics(),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final appointment = filtered[index];
        return ConsultationListItem(
          appointment: appointment,
          onRecordVitals: () => _openRecordVitalsDialog(appointment),
          onComplete: () => _openCompleteConsultationSheet(appointment),
          onViewDetails: () => _openDetailsDialog(appointment, isDark),
        );
      },
    );
  }

  void _openRecordVitalsDialog(AppointmentEntity appointment) {
    showDialog(
      context: context,
      builder: (_) => RecordVitalsDialog(
        appointment: appointment,
        onSave: (vitals) {
          context.read<AdminAppointmentsBloc>().add(
                UpdateAppointmentVitals(appointment.id, vitals),
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Patient vitals saved successfully."),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _openCompleteConsultationSheet(AppointmentEntity appointment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CompleteConsultationSheet(
        appointment: appointment,
        onComplete: () {
          context.read<AdminAppointmentsBloc>().add(
                CompleteAppointment(appointment.id),
              );
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Consultation completed successfully."),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _openDetailsDialog(AppointmentEntity appointment, bool isDark) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.terminalDarkCard : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
        title: Text("Consultation Details", style: AppTextStyles.titleLarge),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem("Patient Name", appointment.patientName, isDark),
              _buildDetailItem("Doctor Name", appointment.doctorName, isDark),
              _buildDetailItem("Specialty", appointment.specialty, isDark),
              _buildDetailItem("Status", appointment.status, isDark),
              _buildDetailItem("Slot Time", appointment.appointmentTime, isDark),
              _buildDetailItem("Type", appointment.type, isDark),
              const Divider(),
              Text(
                "Recorded Vitals",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.sp,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 8.h),
              _buildDetailItem("Blood Pressure", appointment.bp ?? "Not recorded", isDark),
              _buildDetailItem("Weight", appointment.weight ?? "Not recorded", isDark),
              _buildDetailItem("Height", appointment.height ?? "Not recorded", isDark),
              _buildDetailItem("Temperature", appointment.fever ?? "Not recorded", isDark),
              _buildDetailItem(
                "Head Circumference",
                appointment.headCircumference ?? "Not recorded",
                isDark,
              ),
              _buildDetailItem(
                "Additional Notes",
                appointment.additionalVitals ?? "None",
                isDark,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(String label, String value, bool isDark) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130.w,
            child: Text(
              "$label:",
              style: AppTextStyles.bodySmall.copyWith(
                color: isDark ? Colors.white60 : Colors.black54,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
