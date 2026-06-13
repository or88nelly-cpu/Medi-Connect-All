import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/dash_board/domain/entities/appointment_entity.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/admin_appointments_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/appointments/consultation_complete_sheet.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/appointments/create_appointment_wizard_dialog.dart';

class AdminAppointmentsPage extends StatefulWidget {
  const AdminAppointmentsPage({super.key});

  @override
  State<AdminAppointmentsPage> createState() => _AdminAppointmentsPageState();
}

class _AdminAppointmentsPageState extends State<AdminAppointmentsPage> {
  String _filterStatus = 'All';
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    context.read<AdminAppointmentsBloc>().add(LoadAppointments());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppStrings.appointments,
                style: AppTextStyles.headingMedium.copyWith(
                  fontSize: 22.sp,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showCreateAppointmentWizard(context),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text(
                  "Book New",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 2,
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 12.h,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Search & Filter
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            style: TextStyle(
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
            decoration: InputDecoration(
              hintText: "Search patient, doctor, or specialty...",
              hintStyle: TextStyle(
                color: isDark ? Colors.white54 : AppColors.textSecondary,
              ),
              prefixIcon: Icon(
                Icons.search,
                color: isDark ? Colors.white54 : AppColors.textSecondary,
              ),
              filled: true,
              fillColor: isDark ? AppColors.terminalDarkCard : Colors.white,
              contentPadding: EdgeInsets.all(12.r),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: BorderSide(
                  color: isDark
                      ? AppColors.terminalDarkBorder
                      : AppColors.border,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.r),
                borderSide: const BorderSide(
                  color: AppColors.primary,
                  width: 1.5,
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  ['All', 'Confirmed', 'Pending', 'Completed', 'Cancelled'].map(
                    (status) {
                      final isSelected = _filterStatus == status;
                      return Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: ChoiceChip(
                          label: Text(status),
                          selected: isSelected,
                          onSelected: (val) {
                            if (val) setState(() => _filterStatus = status);
                          },
                          backgroundColor: isDark
                              ? AppColors.terminalDarkCard
                              : Colors.white,
                          selectedColor: AppColors.primary.withOpacity(0.2),
                          checkmarkColor: AppColors.primary,
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.primary
                                : (isDark
                                      ? AppColors.terminalDarkBorder
                                      : AppColors.border),
                          ),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? AppColors.primary
                                : (isDark
                                      ? Colors.white70
                                      : AppColors.textSecondary),
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ).toList(),
            ),
          ),
          SizedBox(height: 16.h),

          Expanded(
            child: BlocBuilder<AdminAppointmentsBloc, AdminAppointmentsState>(
              builder: (context, state) {
                if (state is AdminAppointmentsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is AdminAppointmentsError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: AppColors.error,
                          size: 48.r,
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          "Failed to load appointments",
                          style: AppTextStyles.titleMedium.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(state.message, style: AppTextStyles.bodyMedium),
                        SizedBox(height: 16.h),
                        ElevatedButton(
                          onPressed: () {
                            context.read<AdminAppointmentsBloc>().add(
                              LoadAppointments(),
                            );
                          },
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  );
                }
                if (state is AdminAppointmentsLoaded) {
                  final appointments = state.appointments;
                  final filteredList = appointments.where((apt) {
                    final matchesStatus =
                        _filterStatus == 'All' ||
                        apt.status.toLowerCase() == _filterStatus.toLowerCase();
                    final matchesSearch =
                        apt.patientName.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ) ||
                        apt.doctorName.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        ) ||
                        apt.specialty.toLowerCase().contains(
                          _searchQuery.toLowerCase(),
                        );
                    return matchesStatus && matchesSearch;
                  }).toList();

                  if (filteredList.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            color: isDark
                                ? Colors.white30
                                : AppColors.textSecondary.withOpacity(0.5),
                            size: 48.r,
                          ),
                          SizedBox(height: 12.h),
                          Text(
                            AppStrings.noRecords,
                            style: AppTextStyles.titleMedium.copyWith(
                              color: isDark
                                  ? Colors.white54
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: filteredList.length,
                    itemBuilder: (context, idx) {
                      final apt = filteredList[idx];
                      Color statusColor;
                      switch (apt.status) {
                        case 'Confirmed':
                          statusColor = AppColors.success;
                          break;
                        case 'Pending':
                          statusColor = AppColors.warning;
                          break;
                        case 'Completed':
                          statusColor = AppColors.primary;
                          break;
                        default:
                          statusColor = AppColors.error;
                      }

                      final formattedDate = DateFormat(
                        'dd MMM yyyy',
                      ).format(apt.appointmentDate);

                      return Card(
                        margin: EdgeInsets.only(bottom: 12.h),
                        elevation: 0,
                        color: isDark
                            ? AppColors.terminalDarkCard
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                          side: BorderSide(
                            color: isDark
                                ? AppColors.terminalDarkBorder
                                : AppColors.border,
                          ),
                        ),
                        child: Theme(
                          data: Theme.of(
                            context,
                          ).copyWith(dividerColor: Colors.transparent),
                          child: ExpansionTile(
                            childrenPadding: EdgeInsets.fromLTRB(
                              16.r,
                              0,
                              16.r,
                              16.r,
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    apt.patientName,
                                    style: AppTextStyles.titleMedium.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: isDark
                                          ? Colors.white
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 8.w,
                                    vertical: 4.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: statusColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(6.r),
                                  ),
                                  child: Text(
                                    apt.status,
                                    style: TextStyle(
                                      color: statusColor,
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 4.h),
                                Text(
                                  "Doctor: ${apt.doctorName} (${apt.specialty})",
                                  style: TextStyle(
                                    color: isDark
                                        ? Colors.white70
                                        : AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      size: 12.r,
                                      color: isDark
                                          ? Colors.white54
                                          : AppColors.textSecondary,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      formattedDate,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: isDark
                                            ? Colors.white54
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    Icon(
                                      Icons.access_time,
                                      size: 12.r,
                                      color: isDark
                                          ? Colors.white54
                                          : AppColors.textSecondary,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      apt.appointmentTime,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: isDark
                                            ? Colors.white54
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            children: [
                              const Divider(height: 16),
                              // Consultation type label row
                              Row(
                                children: [
                                  Icon(apt.type == 'Video'
                                      ? Icons.video_call
                                      : Icons.local_hospital_outlined,
                                    size: 14.r,
                                    color: isDark ? Colors.white54 : AppColors.textSecondary,
                                  ),
                                  SizedBox(width: 6.w),
                                  Text(
                                    apt.type,
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                      color: isDark ? Colors.white70 : AppColors.textPrimary,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              // Action buttons
                              if (apt.status != 'Cancelled' && apt.status != 'Completed')
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    // Cancel
                                    OutlinedButton.icon(
                                      onPressed: () {
                                        context
                                            .read<AdminAppointmentsBloc>()
                                            .add(CancelAppointment(apt.id));
                                      },
                                      icon: const Icon(Icons.cancel_outlined,
                                          size: 14, color: AppColors.error),
                                      label: const Text('Cancel',
                                          style: TextStyle(
                                              color: AppColors.error,
                                              fontWeight: FontWeight.bold)),
                                      style: OutlinedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10.w, vertical: 7.h),
                                        side: const BorderSide(color: AppColors.error),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(6.r)),
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    // Complete
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        _showConsultationCompleteSheet(
                                            context, apt);
                                      },
                                      icon: const Icon(Icons.check_circle_outline,
                                          size: 14, color: Colors.white),
                                      label: const Text('Complete Consultation',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: AppColors.success,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 12.w, vertical: 7.h),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(6.r)),
                                      ),
                                    ),
                                  ],
                                ),
                              if (apt.status == 'Completed')
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.w, vertical: 5.h),
                                    decoration: BoxDecoration(
                                      color: AppColors.success.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(6.r),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.check_circle,
                                            size: 14, color: AppColors.success),
                                        SizedBox(width: 4.w),
                                        Text('Consultation Completed',
                                            style: TextStyle(
                                                color: AppColors.success,
                                                fontSize: 11.sp,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateAppointmentWizard(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const CreateAppointmentWizardDialog(),
    );
  }

  void _showConsultationCompleteSheet(
      BuildContext context, AppointmentEntity apt) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ConsultationCompleteSheet(appointment: apt),
    );
  }
}
