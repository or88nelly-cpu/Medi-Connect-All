import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/shared/dashboard/domain/entities/appointment_entity.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/doctor/doctor_appointments_bloc.dart';
import 'package:medi_connect/features/doctors/dashboard/presentation/widgets/doctor_dashboard/slot_management_grid.dart';
import 'package:medi_connect/features/doctors/dashboard/presentation/widgets/doctor_dashboard/schedule_status_chips.dart';
import 'package:medi_connect/features/doctors/dashboard/presentation/pages/patient_visit_detail_page.dart';
import 'package:medi_connect/features/admin/management/patient_management/presentation/bloc/patient_bloc.dart';
import 'package:medi_connect/shared/auth/domain/entities/user_entity.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/core/constants/app_enum.dart';

// Extracted Modular Sub-widgets
import 'schedule_header_banner.dart';
import 'schedule_date_picker_row.dart';
import 'schedule_appointment_item.dart';

class DoctorScheduleTab extends StatefulWidget {
  const DoctorScheduleTab({super.key});

  @override
  State<DoctorScheduleTab> createState() => _DoctorScheduleTabState();
}

class _DoctorScheduleTabState extends State<DoctorScheduleTab> {
  DateTime _selectedDate = DateTime.now();
  String _searchQuery = "";
  String _selectedStatus = "All";
  int _activeSubTab = 0; // 0 = Appointments, 1 = Slot Management
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }

  Future<void> _selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showConsultationCompleteSheet(BuildContext context, AppointmentEntity apt) {
    UserModel? patientUser;
    try {
      final patientState = context.read<PatientBloc>().state;
      if (patientState is PatientLoaded) {
        final matches = patientState.patients.where(
          (p) => p.id == apt.patientId || p.fullName.toLowerCase().trim() == apt.patientName.toLowerCase().trim(),
        );
        if (matches.isNotEmpty) {
          patientUser = matches.first;
        }
      }
    } catch (_) {}

    final patientEntity = patientUser != null
        ? UserEntity(
            id: patientUser.id,
            firstName: patientUser.firstName,
            lastName: patientUser.lastName,
            email: patientUser.email ?? '',
            gender: patientUser.gender,
            role: UserRole.patient,
            profilePhoto: patientUser.profilePhoto,
          )
        : UserEntity(
            id: apt.patientId ?? '',
            firstName: apt.patientName,
            lastName: '',
            email: '',
            gender: 'Male',
            role: UserRole.patient,
          );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientVisitDetailPage(
          appointment: apt,
          patient: patientEntity,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textCol = isDark ? Colors.white : AppColors.textDarkNavy;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;

    final authState = context.read<AuthBloc>().state;
    final doctor = authState is Authenticated ? authState.user : null;

    if (doctor == null) {
      return const Center(child: Text("Doctor details not found."));
    }

    return BlocBuilder<DoctorAppointmentsBloc, DoctorAppointmentsState>(
      builder: (context, state) {
        if (state is DoctorAppointmentsLoaded) {
          final allApts = state.appointments;

          // Compute Counts for Yesterday's Schedule banner overview
          final yesterday = DateTime.now().subtract(const Duration(days: 1));
          final yesterdayApts = allApts.where((a) => _isSameDay(a.appointmentDate, yesterday)).toList();
          final yesterdayTotal = yesterdayApts.length;
          final yesterdayCompleted = yesterdayApts.where((a) => a.status.toLowerCase() == 'completed').length;
          final yesterdayPending = yesterdayApts.where((a) => a.status.toLowerCase() == 'pending').length;
          final yesterdayCancelled = yesterdayApts.where((a) => a.status.toLowerCase() == 'cancelled').length;

          // Filter for selected date
          final dateApts = allApts.where((a) => _isSameDay(a.appointmentDate, _selectedDate)).toList();

          // Search + Status Filters
          final filteredApts = dateApts.where((a) {
            final matchesQuery = a.patientName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                a.specialty.toLowerCase().contains(_searchQuery.toLowerCase());
            final matchesStatus = _selectedStatus == "All" || a.status.toLowerCase() == _selectedStatus.toLowerCase();
            return matchesQuery && matchesStatus;
          }).toList();

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Sliding Selector: Appointments vs Slot Management
                Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _activeSubTab = 0),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            decoration: BoxDecoration(
                              color: _activeSubTab == 0
                                  ? (isDark ? const Color(0xFF0F6FFF) : Colors.white)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10.r),
                              boxShadow: _activeSubTab == 0
                                  ? [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))]
                                  : [],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Appointments",
                              style: TextStyle(
                                color: _activeSubTab == 0
                                    ? (isDark ? Colors.white : const Color(0xFF0F6FFF))
                                    : (isDark ? Colors.white60 : Colors.grey[600]),
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _activeSubTab = 1),
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            decoration: BoxDecoration(
                              color: _activeSubTab == 1
                                  ? (isDark ? const Color(0xFF0F6FFF) : Colors.white)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(10.r),
                              boxShadow: _activeSubTab == 1
                                  ? [BoxShadow(color: Colors.black12, blurRadius: 4, offset: const Offset(0, 2))]
                                  : [],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              "Slot Management",
                              style: TextStyle(
                                color: _activeSubTab == 1
                                    ? (isDark ? Colors.white : const Color(0xFF0F6FFF))
                                    : (isDark ? Colors.white60 : Colors.grey[600]),
                                fontWeight: FontWeight.bold,
                                fontSize: 12.sp,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16.h),

                if (_activeSubTab == 1) ...[
                  SlotManagementGrid(
                    selectedDate: _selectedDate,
                    doctor: doctor,
                  ),
                ] else ...[
                  // 2. Yesterday's Schedule banner card
                  ScheduleHeaderBanner(
                    totalCount: yesterdayTotal > 0 ? yesterdayTotal : 5,
                    completedCount: yesterdayCompleted,
                    pendingCount: yesterdayPending > 0 ? yesterdayPending : 1,
                    cancelledCount: yesterdayCancelled > 0 ? yesterdayCancelled : 1,
                    onViewCalendarTap: () => _selectDate(context),
                    isDark: isDark,
                  ),
                  SizedBox(height: 20.h),

                  // 3. Search Bar
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40.h,
                          decoration: BoxDecoration(
                            color: cardBg,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(color: AppColors.border(context)),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (val) => setState(() => _searchQuery = val),
                            style: TextStyle(color: textCol, fontSize: 12.sp),
                            decoration: InputDecoration(
                              hintText: "Search patient, or specialty...",
                              hintStyle: TextStyle(color: Colors.grey, fontSize: 12.sp),
                              prefixIcon: Icon(Icons.search, color: Colors.grey, size: 16.r),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12.r),
                        height: 40.h,
                        decoration: BoxDecoration(
                          color: cardBg,
                          borderRadius: BorderRadius.circular(12.r),
                          border: Border.all(color: AppColors.border(context)),
                        ),
                        child: Icon(Icons.filter_list, color: textCol, size: 20.r),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),

                  // 4. Status Chips Filters
                  ScheduleStatusChips(
                    selectedStatus: _selectedStatus,
                    onStatusSelected: (status) {
                      setState(() {
                        _selectedStatus = status;
                      });
                    },
                  ),
                  SizedBox(height: 20.h),

                  // 5. Date navigation picker row
                  ScheduleDatePickerRow(
                    selectedDate: _selectedDate,
                    onSelectCalendar: () => _selectDate(context),
                    onTodayTap: () => setState(() => _selectedDate = DateTime.now()),
                    onPrevDay: () => setState(() => _selectedDate = _selectedDate.subtract(const Duration(days: 1))),
                    onNextDay: () => setState(() => _selectedDate = _selectedDate.add(const Duration(days: 1))),
                    isDark: isDark,
                  ),
                  SizedBox(height: 20.h),

                  // 6. Timeline list items
                  filteredApts.isEmpty
                      ? Container(
                          height: 200.h,
                          alignment: Alignment.center,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.calendar_today_outlined, color: Colors.grey.withValues(alpha: 0.5), size: 40.r),
                              SizedBox(height: 12.h),
                              Text(
                                "No appointments found",
                                style: AppTextStyles.titleMedium.copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: filteredApts.length,
                          itemBuilder: (context, idx) {
                            final apt = filteredApts[idx];
                            return ScheduleAppointmentItem(
                              appointment: apt,
                              index: idx,
                              totalCount: filteredApts.length,
                              isDark: isDark,
                              onTap: () => _showConsultationCompleteSheet(context, apt),
                              onCancel: () {
                                context.read<DoctorAppointmentsBloc>().add(CancelDoctorAppointment(apt.id));
                              },
                              onComplete: () => _showConsultationCompleteSheet(context, apt),
                            );
                          },
                        ),
                ],
              ],
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
