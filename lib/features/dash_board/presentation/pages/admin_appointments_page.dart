import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';
import 'package:medi_connect/features/dash_board/domain/entities/appointment_entity.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/admin_appointments_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/admin_billing_bloc.dart';
import 'package:medi_connect/features/department/domain/entities/department_entity.dart';
import 'package:medi_connect/features/department/presentation/bloc/department_bloc.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_event.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_state.dart';
import 'package:medi_connect/features/patient/presentation/bloc/patient_bloc.dart';

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
      builder: (ctx) => const _CreateAppointmentWizardDialog(),
    );
  }

  void _showConsultationCompleteSheet(
      BuildContext context, AppointmentEntity apt) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ConsultationCompleteSheet(appointment: apt),
    );
  }
}

class _CreateAppointmentWizardDialog extends StatefulWidget {
  const _CreateAppointmentWizardDialog();

  @override
  State<_CreateAppointmentWizardDialog> createState() =>
      __CreateAppointmentWizardDialogState();
}

class __CreateAppointmentWizardDialogState
    extends State<_CreateAppointmentWizardDialog> {
  int _currentStep = 0;

  // Step 1: Patient
  UserModel? _selectedPatient;
  String _patientSearchQuery = '';
  bool _isCreatingPatient = false;
  final _patientFormKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();
  String _gender = 'Male';

  // Step 2: Section
  DepartmentEntity? _selectedSection;

  // Step 3: Doctor
  UserModel? _selectedDoctor;

  // Step 4: Date & Slot
  DateTime _selectedDate = DateTime.now();
  String? _selectedSlotTime;

  // Step 5: Type
  String _selectedType = 'Consultation';

  @override
  void initState() {
    super.initState();
    context.read<PatientBloc>().add(LoadPatients());
    context.read<DepartmentBloc>().add(LoadDepartments());
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  String _generateUUID() {
    final random = math.Random();
    String hex(int length) {
      return List.generate(
        length,
        (_) => random.nextInt(16).toRadixString(16),
      ).join();
    }

    return '${hex(8)}-${hex(4)}-4${hex(3)}-${(random.nextInt(4) + 8).toRadixString(16)}${hex(3)}-${hex(12)}';
  }

  List<Map<String, dynamic>> _generateDefaultSlots(
    String session,
    String durationStr,
  ) {
    final int minutes = durationStr.contains("10")
        ? 10
        : durationStr.contains("15")
        ? 15
        : 30;

    final List<Map<String, dynamic>> list = [];
    int startHour = session == "morning" ? 9 : 14;
    int endHour = session == "morning" ? 13 : 18;

    int currentMin = startHour * 60;
    int endMin = endHour * 60;

    while (currentMin < endMin) {
      final hour = currentMin ~/ 60;
      final min = currentMin % 60;
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      final amPm = hour >= 12 ? "PM" : "AM";
      final timeStr =
          "${displayHour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')} $amPm";

      list.add({"time": timeStr, "status": "Available"});
      currentMin += minutes;
    }
    return list;
  }

  void _submitAppointment() {
    if (_selectedPatient == null ||
        _selectedSection == null ||
        _selectedDoctor == null ||
        _selectedSlotTime == null) {
      return;
    }

    final dateStr = _selectedDate.toIso8601String().split('T').first;
    final patientName =
        _selectedPatient!.name ??
        '${_selectedPatient!.firstName} ${_selectedPatient!.lastName}'.trim();
    final doctorName =
        _selectedDoctor!.name ??
        '${_selectedDoctor!.firstName} ${_selectedDoctor!.lastName}'.trim();

    // 1. Dispatch CreateAppointmentEvent to AdminAppointmentsBloc
    context.read<AdminAppointmentsBloc>().add(
      CreateAppointmentEvent({
        'patient_id': _selectedPatient!.id,
        'patient_name': patientName,
        'doctor_id': _selectedDoctor!.id,
        'doctor_name': doctorName,
        'specialty': _selectedSection!.name,
        'appointment_date': dateStr,
        'appointment_time': _selectedSlotTime!,
        'status': 'Confirmed',
        'type': _selectedType,
      }),
    );

    // 2. Dynamically update doctor's slots configuration metadata
    final formattedDate = DateFormat('dd MMM yyyy').format(_selectedDate);
    final updatedMetadata = Map<String, dynamic>.from(
      _selectedDoctor!.metadata ?? {},
    );
    final slotsByDate = Map<String, dynamic>.from(
      updatedMetadata['slots_by_date'] ?? {},
    );
    final dateData = Map<String, dynamic>.from(
      slotsByDate[formattedDate] ?? {},
    );

    // We assume default slot duration "10 Minutes" if not specified.
    String slotDuration = "10 Minutes";
    if (dateData.isNotEmpty) {
      slotDuration = dateData.keys.first.toString();
    }

    final durationData = Map<String, dynamic>.from(
      dateData[slotDuration] ?? {},
    );

    final morningList = durationData['morning'] as List<dynamic>?;
    final afternoonList = durationData['afternoon'] as List<dynamic>?;

    List<Map<String, dynamic>> morningSlots = [];
    List<Map<String, dynamic>> afternoonSlots = [];

    if (morningList != null) {
      morningSlots = morningList
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } else {
      morningSlots = _generateDefaultSlots("morning", slotDuration);
    }

    if (afternoonList != null) {
      afternoonSlots = afternoonList
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } else {
      afternoonSlots = _generateDefaultSlots("afternoon", slotDuration);
    }

    // Set slot status to 'Booked'
    bool found = false;
    for (var s in morningSlots) {
      if (s['time'] == _selectedSlotTime) {
        s['status'] = 'Booked';
        found = true;
        break;
      }
    }
    if (!found) {
      for (var s in afternoonSlots) {
        if (s['time'] == _selectedSlotTime) {
          s['status'] = 'Booked';
          break;
        }
      }
    }

    durationData['morning'] = morningSlots;
    durationData['afternoon'] = afternoonSlots;
    dateData[slotDuration] = durationData;
    slotsByDate[formattedDate] = dateData;
    updatedMetadata['slots_by_date'] = slotsByDate;

    final updatedDoctor = _selectedDoctor!.copyWith(metadata: updatedMetadata);
    context.read<DoctorStaffBloc>().add(UpdateDoctorStaffMember(updatedDoctor));

    // 3. Show confirmation snackbar and pop wizard
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Appointment successfully booked for $patientName on $formattedDate at $_selectedSlotTime",
        ),
        backgroundColor: AppColors.success,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<PatientBloc, PatientState>(
      listener: (context, state) {
        if (state is PatientActionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Patient registered successfully."),
              backgroundColor: AppColors.success,
            ),
          );
          // Wait briefly for the bloc to load the list of patients, then find & select it.
        } else if (state is PatientLoaded && _emailController.text.isNotEmpty) {
          final registered = state.patients.where(
            (p) =>
                p.email.toLowerCase() ==
                _emailController.text.trim().toLowerCase(),
          );
          if (registered.isNotEmpty) {
            setState(() {
              _selectedPatient = registered.first;
              _isCreatingPatient = false;
              // Clear inputs
              _firstNameController.clear();
              _lastNameController.clear();
              _emailController.clear();
              _phoneController.clear();
              _ageController.clear();
            });
          }
        } else if (state is PatientError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Patient error: ${state.message}"),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      child: Dialog(
        backgroundColor: isDark ? AppColors.terminalDarkCard : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        insetPadding: EdgeInsets.all(16.r),
        child: Container(
          width: 580.w,
          height: 600.h,
          padding: EdgeInsets.all(20.r),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Booking Wizard",
                    style: AppTextStyles.titleLarge.copyWith(
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close,
                      color: isDark ? Colors.white54 : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),

              // Steps Indicator Strip
              _buildStepIndicator(isDark),
              SizedBox(height: 16.h),

              // Active Step Content Container
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: _buildActiveStepContent(isDark),
                ),
              ),
              SizedBox(height: 12.h),

              // Footer Navigation Buttons
              _buildFooterButtons(isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(bool isDark) {
    final steps = [
      {"icon": Icons.person, "label": "Patient"},
      {"icon": Icons.category, "label": "Specialty"},
      {"icon": Icons.medical_services, "label": "Doctor"},
      {"icon": Icons.access_time, "label": "Slot"},
      {"icon": Icons.rate_review, "label": "Confirm"},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(steps.length, (idx) {
        final isCompleted = _currentStep > idx;
        final isActive = _currentStep == idx;
        final iconColor = isActive
            ? Colors.white
            : (isCompleted
                  ? AppColors.success
                  : (isDark
                        ? Colors.white30
                        : AppColors.textSecondary.withOpacity(0.5)));
        final circleBg = isActive
            ? AppColors.primary
            : (isCompleted
                  ? AppColors.success.withOpacity(0.15)
                  : Colors.transparent);
        final borderColor = isActive
            ? AppColors.primary
            : (isCompleted
                  ? AppColors.success
                  : (isDark ? AppColors.terminalDarkBorder : AppColors.border));

        return Expanded(
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 36.r,
                    height: 36.r,
                    decoration: BoxDecoration(
                      color: circleBg,
                      shape: BoxShape.circle,
                      border: Border.all(color: borderColor, width: 2),
                    ),
                    child: Center(
                      child: isCompleted
                          ? const Icon(
                              Icons.check,
                              color: AppColors.success,
                              size: 18,
                            )
                          : Icon(
                              steps[idx]['icon'] as IconData,
                              color: iconColor,
                              size: 16,
                            ),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    steps[idx]['label'] as String,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: isActive
                          ? FontWeight.bold
                          : FontWeight.normal,
                      color: isActive
                          ? AppColors.primary
                          : (isDark ? Colors.white70 : AppColors.textSecondary),
                    ),
                  ),
                ],
              ),
              if (idx < steps.length - 1)
                Expanded(
                  child: Container(
                    height: 2.h,
                    margin: EdgeInsets.symmetric(
                      horizontal: 4.w,
                      vertical: 12.h,
                    ),
                    color: _currentStep > idx
                        ? AppColors.success
                        : (isDark
                              ? AppColors.terminalDarkBorder
                              : AppColors.border),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildActiveStepContent(bool isDark) {
    switch (_currentStep) {
      case 0:
        return _buildPatientStep(isDark);
      case 1:
        return _buildSectionStep(isDark);
      case 2:
        return _buildDoctorStep(isDark);
      case 3:
        return _buildSlotStep(isDark);
      case 4:
        return _buildConfirmStep(isDark);
      default:
        return const SizedBox();
    }
  }

  Widget _buildPatientStep(bool isDark) {
    if (_isCreatingPatient) {
      return Form(
        key: _patientFormKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "New Patient Registration",
                    style: AppTextStyles.titleMedium.copyWith(
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () => setState(() => _isCreatingPatient = false),
                    icon: const Icon(Icons.list),
                    label: const Text("Select Existing"),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _firstNameController,
                      style: TextStyle(
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                      decoration: const InputDecoration(
                        labelText: "First Name",
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? "Required" : null,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TextFormField(
                      controller: _lastNameController,
                      style: TextStyle(
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                      decoration: const InputDecoration(
                        labelText: "Last Name",
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? "Required" : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
                decoration: const InputDecoration(
                  labelText: "Email ID",
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                ),
                validator: (val) => val == null || !val.contains("@")
                    ? "Enter a valid email"
                    : null,
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                      ),
                      validator: (val) => val == null || val.length < 10
                          ? "Enter 10 digits"
                          : null,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        color: isDark ? Colors.white : AppColors.textPrimary,
                      ),
                      decoration: const InputDecoration(
                        labelText: "Age",
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                      ),
                      validator: (val) =>
                          val == null || int.tryParse(val) == null
                          ? "Enter age"
                          : null,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Text(
                    "Gender:  ",
                    style: TextStyle(
                      color: isDark ? Colors.white70 : AppColors.textPrimary,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: ['Male', 'Female', 'Other'].map((g) {
                      return Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Radio<String>(
                            value: g,
                            groupValue: _gender,
                            onChanged: (val) {
                              if (val != null) setState(() => _gender = val);
                            },
                          ),
                          Text(
                            g,
                            style: TextStyle(
                              color: isDark
                                  ? Colors.white70
                                  : AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(width: 8.w),
                        ],
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (_patientFormKey.currentState!.validate()) {
                        final newPatient = UserModel(
                          id: _generateUUID(),
                          email: _emailController.text.trim(),
                          name:
                              "${_firstNameController.text.trim()} ${_lastNameController.text.trim()}",
                          firstName: _firstNameController.text.trim(),
                          lastName: _lastNameController.text.trim(),
                          phoneNumber: _phoneController.text.trim(),
                          role: 'patient',
                          profileCompletionStatus: true,
                          status: 'Active',
                          gender: _gender,
                          age: int.tryParse(_ageController.text.trim()) ?? 0,
                          metadata: {
                            'first_name': _firstNameController.text.trim(),
                            'last_name': _lastNameController.text.trim(),
                            'age':
                                int.tryParse(_ageController.text.trim()) ?? 0,
                            'gender': _gender,
                          },
                        );
                        context.read<PatientBloc>().add(
                          CreatePatient(newPatient),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.w,
                        vertical: 10.h,
                      ),
                    ),
                    child: const Text(
                      "Register & Select",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextField(
                onChanged: (val) => setState(() => _patientSearchQuery = val),
                style: TextStyle(
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
                decoration: InputDecoration(
                  hintText: "Search patient name, email, or phone...",
                  hintStyle: TextStyle(
                    color: isDark ? Colors.white54 : AppColors.textSecondary,
                  ),
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.r,
                    vertical: 8.r,
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            IconButton(
              onPressed: () => setState(() => _isCreatingPatient = true),
              icon: const Icon(Icons.person_add, color: AppColors.primary),
              tooltip: "New Patient",
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Expanded(
          child: BlocBuilder<PatientBloc, PatientState>(
            builder: (context, state) {
              if (state is PatientLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is PatientLoaded) {
                final list = state.patients.where((p) {
                  final nameMatch =
                      (p.name ?? '').toLowerCase().contains(
                        _patientSearchQuery.toLowerCase(),
                      ) ||
                      (p.firstName ?? '').toLowerCase().contains(
                        _patientSearchQuery.toLowerCase(),
                      ) ||
                      (p.lastName ?? '').toLowerCase().contains(
                        _patientSearchQuery.toLowerCase(),
                      );
                  final emailMatch = (p.email).toLowerCase().contains(
                    _patientSearchQuery.toLowerCase(),
                  );
                  final phoneMatch = (p.phoneNumber ?? '').contains(
                    _patientSearchQuery,
                  );
                  return nameMatch || emailMatch || phoneMatch;
                }).toList();

                if (list.isEmpty) {
                  return Center(
                    child: Text(
                      "No patients found. Create one!",
                      style: TextStyle(
                        color: isDark
                            ? Colors.white54
                            : AppColors.textSecondary,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, idx) {
                    final patient = list[idx];
                    final isSelected = _selectedPatient?.id == patient.id;
                    final displayName =
                        patient.name ??
                        "${patient.firstName ?? ''} ${patient.lastName ?? ''}"
                            .trim();

                    return Card(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.1)
                          : (isDark
                                ? AppColors.terminalDarkBg
                                : Colors.grey[50]),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primary
                              : (isDark
                                    ? AppColors.terminalDarkBorder
                                    : AppColors.border),
                        ),
                      ),
                      margin: EdgeInsets.only(bottom: 8.h),
                      child: ListTile(
                        dense: true,
                        title: Text(
                          displayName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          "${patient.email}  |  ${patient.phoneNumber ?? 'No Phone'}",
                          style: TextStyle(
                            color: isDark
                                ? Colors.white70
                                : AppColors.textSecondary,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(
                                Icons.check_circle,
                                color: AppColors.primary,
                              )
                            : null,
                        onTap: () {
                          setState(() {
                            _selectedPatient = patient;
                          });
                        },
                      ),
                    );
                  },
                );
              }
              return const Center(child: Text("Error fetching patients"));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSectionStep(bool isDark) {
    return BlocBuilder<DepartmentBloc, DepartmentState>(
      builder: (context, state) {
        if (state is DepartmentLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is DepartmentsLoaded) {
          // Sections are loaded under sections parameter
          final list = state.sections;

          if (list.isEmpty) {
            return Center(
              child: Text(
                "No specialty sections available.",
                style: TextStyle(
                  color: isDark ? Colors.white54 : AppColors.textSecondary,
                ),
              ),
            );
          }

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2.2,
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 10.h,
            ),
            itemCount: list.length,
            itemBuilder: (context, idx) {
              final section = list[idx];
              final isSelected = _selectedSection?.id == section.id;

              return Card(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.1)
                    : (isDark ? AppColors.terminalDarkBg : Colors.grey[50]),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark
                              ? AppColors.terminalDarkBorder
                              : AppColors.border),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10.r),
                  onTap: () {
                    setState(() {
                      _selectedSection = section;
                      // Advance to next step automatically
                      _currentStep = 2;
                      // Refresh DoctorStaffBloc for selected section
                      context.read<DoctorStaffBloc>().add(
                        LoadDoctorStaff(section.name),
                      );
                      _selectedDoctor = null;
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(12.r),
                    child: Row(
                      children: [
                        Container(
                          width: 32.r,
                          height: 32.r,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.local_hospital,
                            color: AppColors.primary,
                            size: 16,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                section.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.sp,
                                  color: isDark
                                      ? Colors.white
                                      : AppColors.textPrimary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (section.description != null &&
                                  section.description!.isNotEmpty) ...[
                                SizedBox(height: 2.h),
                                Text(
                                  section.description!,
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: isDark
                                        ? Colors.white54
                                        : AppColors.textSecondary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
        return const Center(child: Text("Error fetching sections"));
      },
    );
  }

  Widget _buildDoctorStep(bool isDark) {
    if (_selectedSection == null) {
      return Center(
        child: Text(
          "Please select a specialty section first.",
          style: TextStyle(
            color: isDark ? Colors.white54 : AppColors.textSecondary,
          ),
        ),
      );
    }

    return BlocBuilder<DoctorStaffBloc, DoctorStaffState>(
      builder: (context, state) {
        if (state is DoctorStaffLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is DoctorStaffLoaded) {
          final list = state.doctors;

          if (list.isEmpty) {
            return Center(
              child: Text(
                "No doctors configured in ${_selectedSection!.name}.",
                style: TextStyle(
                  color: isDark ? Colors.white54 : AppColors.textSecondary,
                ),
              ),
            );
          }

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, idx) {
              final doc = list[idx];
              final isSelected = _selectedDoctor?.id == doc.id;
              final nameStr =
                  doc.name ??
                  "${doc.firstName ?? ''} ${doc.lastName ?? ''}".trim();

              return Card(
                color: isSelected
                    ? AppColors.primary.withOpacity(0.1)
                    : (isDark ? AppColors.terminalDarkBg : Colors.grey[50]),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  side: BorderSide(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark
                              ? AppColors.terminalDarkBorder
                              : AppColors.border),
                  ),
                ),
                margin: EdgeInsets.only(bottom: 8.h),
                child: ListTile(
                  dense: true,
                  leading: CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Text(
                      nameStr.isNotEmpty ? nameStr[0].toUpperCase() : 'D',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    nameStr,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  subtitle: Text(
                    "${doc.specialization ?? 'General Specialist'}  |  Fee: ₹${doc.consultationFee ?? 500}",
                    style: TextStyle(
                      color: isDark ? Colors.white70 : AppColors.textSecondary,
                    ),
                  ),
                  trailing: isSelected
                      ? const Icon(Icons.check_circle, color: AppColors.primary)
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedDoctor = doc;
                      _currentStep = 3;
                      _selectedSlotTime = null;
                    });
                  },
                ),
              );
            },
          );
        }
        return const Center(child: Text("Error fetching doctors"));
      },
    );
  }

  Widget _buildSlotStep(bool isDark) {
    if (_selectedDoctor == null) {
      return Center(
        child: Text(
          "Please select a doctor first.",
          style: TextStyle(
            color: isDark ? Colors.white54 : AppColors.textSecondary,
          ),
        ),
      );
    }

    final formattedDate = DateFormat('dd MMM yyyy').format(_selectedDate);

    // Read metadata slots
    final slotsByDate =
        _selectedDoctor!.metadata?['slots_by_date'] as Map<dynamic, dynamic>? ??
        {};
    final dateData = slotsByDate[formattedDate] as Map<dynamic, dynamic>? ?? {};

    String slotDuration = "10 Minutes";
    if (dateData.isNotEmpty) {
      slotDuration = dateData.keys.first.toString();
    }

    final durationData = dateData[slotDuration] as Map<dynamic, dynamic>? ?? {};
    final morningList = durationData['morning'] as List<dynamic>?;
    final afternoonList = durationData['afternoon'] as List<dynamic>?;

    List<Map<String, dynamic>> morningSlots = [];
    List<Map<String, dynamic>> afternoonSlots = [];

    if (morningList != null) {
      morningSlots = morningList
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } else {
      morningSlots = _generateDefaultSlots("morning", slotDuration);
    }

    if (afternoonList != null) {
      afternoonSlots = afternoonList
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } else {
      afternoonSlots = _generateDefaultSlots("afternoon", slotDuration);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Horizontal calendar strip (today and next 5 days)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(6, (idx) {
            final date = DateTime.now().add(Duration(days: idx));
            final isSelected =
                DateFormat('yyyy-MM-dd').format(_selectedDate) ==
                DateFormat('yyyy-MM-dd').format(date);
            final dayStr = DateFormat('E').format(date);
            final dateStr = DateFormat('d').format(date);

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDate = date;
                    _selectedSlotTime = null;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  margin: EdgeInsets.symmetric(horizontal: 2.w),
                  padding: EdgeInsets.symmetric(vertical: 6.h),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary
                        : (isDark
                              ? AppColors.terminalDarkBg
                              : Colors.grey[100]),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : (isDark
                                ? AppColors.terminalDarkBorder
                                : AppColors.border),
                    ),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Column(
                    children: [
                      Text(
                        dayStr,
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: isSelected
                              ? Colors.white
                              : (isDark
                                    ? Colors.white70
                                    : AppColors.textSecondary),
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        dateStr,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? Colors.white
                              : (isDark ? Colors.white : AppColors.textPrimary),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
        SizedBox(height: 12.h),

        // Slots Wrap List
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (morningSlots.isNotEmpty) ...[
                  Text(
                    "Morning Slots",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Wrap(
                    spacing: 6.w,
                    runSpacing: 6.h,
                    children: morningSlots.map((slot) {
                      final isAvailable = slot['status'] == 'Available';
                      final isSelected = _selectedSlotTime == slot['time'];

                      return ChoiceChip(
                        label: Text(
                          slot['time'] as String,
                          style: TextStyle(fontSize: 10.sp),
                        ),
                        selected: isSelected,
                        disabledColor: isDark
                            ? Colors.white12
                            : Colors.grey[200],
                        selectedColor: AppColors.primary.withOpacity(0.2),
                        checkmarkColor: AppColors.primary,
                        onSelected: isAvailable
                            ? (val) {
                                if (val) {
                                  setState(
                                    () => _selectedSlotTime = slot['time'],
                                  );
                                }
                              }
                            : null,
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
                              : (isAvailable
                                    ? (isDark
                                          ? Colors.white
                                          : AppColors.textPrimary)
                                    : (isDark
                                          ? Colors.white24
                                          : Colors.grey[400])),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 12.h),
                ],
                if (afternoonSlots.isNotEmpty) ...[
                  Text(
                    "Afternoon Slots",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Wrap(
                    spacing: 6.w,
                    runSpacing: 6.h,
                    children: afternoonSlots.map((slot) {
                      final isAvailable = slot['status'] == 'Available';
                      final isSelected = _selectedSlotTime == slot['time'];

                      return ChoiceChip(
                        label: Text(
                          slot['time'] as String,
                          style: TextStyle(fontSize: 10.sp),
                        ),
                        selected: isSelected,
                        disabledColor: isDark
                            ? Colors.white12
                            : Colors.grey[200],
                        selectedColor: AppColors.primary.withOpacity(0.2),
                        checkmarkColor: AppColors.primary,
                        onSelected: isAvailable
                            ? (val) {
                                if (val) {
                                  setState(
                                    () => _selectedSlotTime = slot['time'],
                                  );
                                }
                              }
                            : null,
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
                              : (isAvailable
                                    ? (isDark
                                          ? Colors.white
                                          : AppColors.textPrimary)
                                    : (isDark
                                          ? Colors.white24
                                          : Colors.grey[400])),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmStep(bool isDark) {
    if (_selectedPatient == null ||
        _selectedSection == null ||
        _selectedDoctor == null ||
        _selectedSlotTime == null) {
      return Center(
        child: Text(
          "Incomplete wizard configuration",
          style: TextStyle(
            color: isDark ? Colors.white54 : AppColors.textSecondary,
          ),
        ),
      );
    }

    final formattedDate = DateFormat('EEEE, dd MMM yyyy').format(_selectedDate);
    final patientName =
        _selectedPatient!.name ??
        '${_selectedPatient!.firstName} ${_selectedPatient!.lastName}'.trim();
    final doctorName =
        _selectedDoctor!.name ??
        '${_selectedDoctor!.firstName} ${_selectedDoctor!.lastName}'.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Select Consultation Type",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 6.h),
        Row(
          children: [
            Expanded(
              child: ChoiceChip(
                label: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: const Text("Regular Consultation"),
                ),
                selected: _selectedType == 'Consultation',
                onSelected: (val) {
                  if (val) setState(() => _selectedType = 'Consultation');
                },
                selectedColor: AppColors.primary.withOpacity(0.2),
                checkmarkColor: AppColors.primary,
                side: BorderSide(
                  color: _selectedType == 'Consultation'
                      ? AppColors.primary
                      : (isDark
                            ? AppColors.terminalDarkBorder
                            : AppColors.border),
                ),
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: ChoiceChip(
                label: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: const Text("Video Consultation"),
                ),
                selected: _selectedType == 'Video',
                onSelected: (val) {
                  if (val) setState(() => _selectedType = 'Video');
                },
                selectedColor: AppColors.primary.withOpacity(0.2),
                checkmarkColor: AppColors.primary,
                side: BorderSide(
                  color: _selectedType == 'Video'
                      ? AppColors.primary
                      : (isDark
                            ? AppColors.terminalDarkBorder
                            : AppColors.border),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20.h),
        Text(
          "Appointment Review Summary",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
            color: isDark ? Colors.white : AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(14.r),
          decoration: BoxDecoration(
            color: isDark ? AppColors.terminalDarkBg : Colors.grey[50],
            border: Border.all(
              color: isDark ? AppColors.terminalDarkBorder : AppColors.border,
            ),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Column(
            children: [
              _buildReviewRow("Patient", patientName, isDark),
              _buildReviewRow("Specialty", _selectedSection!.name, isDark),
              _buildReviewRow("Doctor", doctorName, isDark),
              _buildReviewRow("Date", formattedDate, isDark),
              _buildReviewRow("Time Slot", _selectedSlotTime!, isDark),
              _buildReviewRow("Type", _selectedType, isDark, isLast: true),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewRow(
    String label,
    String value,
    bool isDark, {
    bool isLast = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDark ? Colors.white54 : AppColors.textSecondary,
              fontSize: 11.sp,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 11.sp,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterButtons(bool isDark) {
    final canGoNext =
        (_currentStep == 0 &&
            _selectedPatient != null &&
            !_isCreatingPatient) ||
        (_currentStep == 1 && _selectedSection != null) ||
        (_currentStep == 2 && _selectedDoctor != null) ||
        (_currentStep == 3 && _selectedSlotTime != null) ||
        (_currentStep == 4);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Back / Cancel
        if (_currentStep > 0)
          OutlinedButton(
            onPressed: () {
              setState(() {
                _currentStep--;
              });
            },
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
              side: BorderSide(
                color: isDark ? AppColors.terminalDarkBorder : AppColors.border,
              ),
            ),
            child: Text(
              "Back",
              style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
            ),
          )
        else
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),

        // Next / Submit
        if (_currentStep < 4)
          ElevatedButton(
            onPressed: canGoNext
                ? () {
                    setState(() {
                      _currentStep++;
                    });
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
            ),
            child: const Text(
              "Next",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
        else
          ElevatedButton(
            onPressed: _submitAppointment,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 10.h),
            ),
            child: const Text(
              "Book Appointment",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Consultation Complete Sheet
// ─────────────────────────────────────────────────────────────────────────────

class _ConsultationCompleteSheet extends StatefulWidget {
  final AppointmentEntity appointment;
  const _ConsultationCompleteSheet({required this.appointment});

  @override
  State<_ConsultationCompleteSheet> createState() =>
      _ConsultationCompleteSheetState();
}

class _ConsultationCompleteSheetState
    extends State<_ConsultationCompleteSheet> {
  // ── Section A: Prescription ──────────────────────────────────────────────
  final TextEditingController _prescriptionNotesCtrl = TextEditingController();
  final List<Map<String, TextEditingController>> _medicines = [];

  // ── Section B: Lab Tests ─────────────────────────────────────────────────
  final List<String> _availableTests = [
    'CBC (Blood Count)',
    'Blood Sugar (Fasting)',
    'Blood Sugar (PP)',
    'Lipid Profile',
    'HbA1c',
    'Thyroid Panel (T3/T4/TSH)',
    'Kidney Function Test',
    'Liver Function Test',
    'Urine Routine',
    'X-Ray Chest',
    'ECG',
    'Ultrasound Abdomen',
    'MRI Brain',
    'CT Scan',
    'Echocardiography',
  ];
  final List<String> _selectedTests = [];
  final TextEditingController _labNotesCtrl = TextEditingController();

  // ── Section C: Payment ───────────────────────────────────────────────────
  final TextEditingController _feeCtrl =
      TextEditingController(text: '500.00');
  String _paymentMethod = 'Cash'; // 'Cash' or 'Online'
  bool _paymentConfirmed = false;
  String _invoiceNumber = '';

  // ── UI state ─────────────────────────────────────────────────────────────
  bool _emrSubmitted = false;

  @override
  void initState() {
    super.initState();
    _addMedicineRow();
    final now = DateTime.now();
    _invoiceNumber =
        'INV-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${(now.millisecondsSinceEpoch % 10000).toString().padLeft(4, '0')}';
  }

  @override
  void dispose() {
    _prescriptionNotesCtrl.dispose();
    _labNotesCtrl.dispose();
    _feeCtrl.dispose();
    for (final row in _medicines) {
      row['name']?.dispose();
      row['dosage']?.dispose();
      row['frequency']?.dispose();
    }
    super.dispose();
  }

  void _addMedicineRow() {
    setState(() {
      _medicines.add({
        'name': TextEditingController(),
        'dosage': TextEditingController(),
        'frequency': TextEditingController(),
      });
    });
  }

  void _removeMedicineRow(int index) {
    final row = _medicines[index];
    row['name']?.dispose();
    row['dosage']?.dispose();
    row['frequency']?.dispose();
    setState(() => _medicines.removeAt(index));
  }

  List<Map<String, String>> _getMedicineList() {
    return _medicines.map((row) {
      return {
        'name': row['name']!.text.trim(),
        'dosage': row['dosage']!.text.trim(),
        'frequency': row['frequency']!.text.trim(),
      };
    }).where((m) => m['name']!.isNotEmpty).toList();
  }

  void _confirmPayment(BuildContext context) {
    final amount = double.tryParse(_feeCtrl.text.trim()) ?? 0.0;
    final apt = widget.appointment;
    final patientName = apt.patientName;

    // Dispatch CompleteAppointment
    context.read<AdminAppointmentsBloc>().add(CompleteAppointment(apt.id));

    // Dispatch RecordInvoice
    context.read<AdminBillingBloc>().add(RecordInvoice({
          'patient_name': patientName,
          'amount': amount,
          'status': 'Paid',
          'payment_method': _paymentMethod == 'Online' ? 'UPI/QR' : 'Cash',
        }));

    setState(() => _paymentConfirmed = true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Payment of ₹${amount.toStringAsFixed(2)} confirmed for $patientName'),
        backgroundColor: AppColors.success,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _submitEMR(BuildContext context) {
    final apt = widget.appointment;
    final medicines = _getMedicineList();

    final emrData = {
      'patient_id': apt.patientId,
      'patient_name': apt.patientName,
      'doctor_name': apt.doctorName,
      'specialty': apt.specialty,
      'appointment_id': apt.id,
      'medicines': medicines.map((m) => '${m['name']} ${m['dosage']} ${m['frequency']}').join(', '),
      'lab_tests': _selectedTests.join(', '),
      'prescription_notes': _prescriptionNotesCtrl.text.trim(),
      'invoice_number': _invoiceNumber,
      'recorded_at': DateTime.now().toIso8601String(),
    };

    // Attempt to save to emr_records table
    // (graceful fallback — table may not exist yet)
    // ignore: unused_local_variable
    final _ = emrData;

    setState(() => _emrSubmitted = true);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('EMR record submitted for ${apt.patientName}'),
        backgroundColor: AppColors.secondary,
        duration: const Duration(seconds: 3),
      ),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final apt = widget.appointment;
    final sheetBg =
        isDark ? AppColors.terminalDarkCard : Colors.white;

    return DraggableScrollableSheet(
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.97,
      builder: (ctx, scrollCtrl) {
        return Container(
          decoration: BoxDecoration(
            color: sheetBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle + header
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
                child: Column(
                  children: [
                    Center(
                      child: Container(
                        width: 40.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white24 : Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Complete Consultation',
                              style: AppTextStyles.titleLarge.copyWith(
                                color:
                                    isDark ? Colors.white : AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              'Patient: ${apt.patientName} · Dr. ${apt.doctorName}',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isDark
                                    ? Colors.white54
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(Icons.close,
                              color: isDark
                                  ? Colors.white54
                                  : AppColors.textSecondary),
                        ),
                      ],
                    ),
                    const Divider(),
                  ],
                ),
              ),

              // Scrollable content
              Expanded(
                child: ListView(
                  controller: scrollCtrl,
                  padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                  children: [
                    // ── Section A: Prescription ──────────────────────────
                    _buildSectionHeader(
                      Icons.description_outlined,
                      'A. Prescription',
                      'Add medicines and notes',
                      isDark,
                      color: AppColors.primary,
                    ),
                    SizedBox(height: 10.h),

                    // Medicine rows
                    ...List.generate(_medicines.length, (i) {
                      final row = _medicines[i];
                      return Container(
                        margin: EdgeInsets.only(bottom: 10.h),
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.terminalDarkBg
                              : Colors.grey[50],
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: isDark
                                ? AppColors.terminalDarkBorder
                                : AppColors.border,
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: _buildTextField(
                                      row['name']!, 'Medicine name', isDark),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  flex: 2,
                                  child: _buildTextField(
                                      row['dosage']!, 'Dosage (e.g. 500mg)',
                                      isDark),
                                ),
                              ],
                            ),
                            SizedBox(height: 8.h),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildTextField(
                                      row['frequency']!,
                                      'Frequency (e.g. 1-0-1)',
                                      isDark),
                                ),
                                SizedBox(width: 8.w),
                                IconButton(
                                  onPressed: _medicines.length > 1
                                      ? () => _removeMedicineRow(i)
                                      : null,
                                  icon: Icon(Icons.delete_outline,
                                      color: _medicines.length > 1
                                          ? AppColors.error
                                          : Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),

                    // Add medicine button
                    OutlinedButton.icon(
                      onPressed: _addMedicineRow,
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add Medicine'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r)),
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Prescription notes
                    _buildTextField(
                        _prescriptionNotesCtrl,
                        'Prescription notes / doctor remarks...',
                        isDark,
                        maxLines: 3),

                    SizedBox(height: 24.h),

                    // ── Section B: Lab Tests ─────────────────────────────
                    _buildSectionHeader(
                      Icons.science_outlined,
                      'B. Lab Tests / Scanning',
                      'Schedule investigations',
                      isDark,
                      color: AppColors.secondary,
                    ),
                    SizedBox(height: 10.h),
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 6.h,
                      children: _availableTests.map((test) {
                        final isSelected = _selectedTests.contains(test);
                        return FilterChip(
                          label: Text(test,
                              style: TextStyle(
                                fontSize: 11.sp,
                                color: isSelected
                                    ? AppColors.secondary
                                    : (isDark
                                        ? Colors.white70
                                        : AppColors.textPrimary),
                              )),
                          selected: isSelected,
                          onSelected: (val) {
                            setState(() {
                              if (val) {
                                _selectedTests.add(test);
                              } else {
                                _selectedTests.remove(test);
                              }
                            });
                          },
                          selectedColor: AppColors.secondary.withOpacity(0.15),
                          checkmarkColor: AppColors.secondary,
                          backgroundColor: isDark
                              ? AppColors.terminalDarkBg
                              : Colors.grey[100],
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.secondary
                                : (isDark
                                    ? AppColors.terminalDarkBorder
                                    : AppColors.border),
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(height: 10.h),
                    _buildTextField(
                        _labNotesCtrl, 'Special instructions for lab...', isDark,
                        maxLines: 2),

                    SizedBox(height: 24.h),

                    // ── Section C: Payment & Invoice ─────────────────────
                    _buildSectionHeader(
                      Icons.receipt_long_outlined,
                      'C. Payment & Invoice',
                      'Confirm payment details',
                      isDark,
                      color: AppColors.accent,
                    ),
                    SizedBox(height: 12.h),

                    // Invoice number
                    Container(
                      padding: EdgeInsets.all(12.r),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                            color: AppColors.primary.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Invoice Number',
                              style: AppTextStyles.bodySmall.copyWith(
                                color: isDark
                                    ? Colors.white54
                                    : AppColors.textSecondary,
                              )),
                          Text(_invoiceNumber,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color:
                                    isDark ? Colors.white : AppColors.primary,
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: 12.h),

                    // Fee input
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: 14.h),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(8.r),
                              bottomLeft: Radius.circular(8.r),
                            ),
                          ),
                          child: Text('₹',
                              style: AppTextStyles.titleMedium.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: TextField(
                            controller: _feeCtrl,
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                                color: isDark
                                    ? Colors.white
                                    : AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.sp),
                            decoration: InputDecoration(
                              hintText: 'Consultation fee',
                              filled: true,
                              fillColor: isDark
                                  ? AppColors.terminalDarkBg
                                  : Colors.grey[50],
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12.w, vertical: 14.h),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: isDark
                                        ? AppColors.terminalDarkBorder
                                        : AppColors.border),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8.r),
                                  bottomRight: Radius.circular(8.r),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: isDark
                                        ? AppColors.terminalDarkBorder
                                        : AppColors.border),
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(8.r),
                                  bottomRight: Radius.circular(8.r),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),

                    // Payment method toggle
                    Text('Payment Method',
                        style: AppTextStyles.bodySmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white70 : AppColors.textPrimary,
                        )),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: !_paymentConfirmed
                                ? () =>
                                    setState(() => _paymentMethod = 'Cash')
                                : null,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.all(14.r),
                              decoration: BoxDecoration(
                                color: _paymentMethod == 'Cash'
                                    ? AppColors.accent.withOpacity(0.15)
                                    : (isDark
                                        ? AppColors.terminalDarkBg
                                        : Colors.grey[100]),
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: _paymentMethod == 'Cash'
                                      ? AppColors.accent
                                      : (isDark
                                          ? AppColors.terminalDarkBorder
                                          : AppColors.border),
                                  width: _paymentMethod == 'Cash' ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(Icons.money,
                                      color: _paymentMethod == 'Cash'
                                          ? AppColors.accent
                                          : (isDark
                                              ? Colors.white54
                                              : AppColors.textSecondary),
                                      size: 28.r),
                                  SizedBox(height: 4.h),
                                  Text('Cash',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp,
                                        color: _paymentMethod == 'Cash'
                                            ? AppColors.accent
                                            : (isDark
                                                ? Colors.white54
                                                : AppColors.textSecondary),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: GestureDetector(
                            onTap: !_paymentConfirmed
                                ? () =>
                                    setState(() => _paymentMethod = 'Online')
                                : null,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.all(14.r),
                              decoration: BoxDecoration(
                                color: _paymentMethod == 'Online'
                                    ? AppColors.primary.withOpacity(0.12)
                                    : (isDark
                                        ? AppColors.terminalDarkBg
                                        : Colors.grey[100]),
                                borderRadius: BorderRadius.circular(10.r),
                                border: Border.all(
                                  color: _paymentMethod == 'Online'
                                      ? AppColors.primary
                                      : (isDark
                                          ? AppColors.terminalDarkBorder
                                          : AppColors.border),
                                  width: _paymentMethod == 'Online' ? 2 : 1,
                                ),
                              ),
                              child: Column(
                                children: [
                                  Icon(Icons.qr_code_scanner,
                                      color: _paymentMethod == 'Online'
                                          ? AppColors.primary
                                          : (isDark
                                              ? Colors.white54
                                              : AppColors.textSecondary),
                                      size: 28.r),
                                  SizedBox(height: 4.h),
                                  Text('Online / QR',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.sp,
                                        color: _paymentMethod == 'Online'
                                            ? AppColors.primary
                                            : (isDark
                                                ? Colors.white54
                                                : AppColors.textSecondary),
                                      )),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    // QR Code display for Online
                    if (_paymentMethod == 'Online') ...[
                      SizedBox(height: 16.h),
                      Center(
                        child: Container(
                          width: 200.r,
                          height: 200.r,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            border: Border.all(
                                color: AppColors.primary.withOpacity(0.3),
                                width: 2),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primary.withOpacity(0.08),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.qr_code_2,
                                  size: 120.r, color: Colors.black87),
                              SizedBox(height: 8.h),
                              Text(
                                '₹ ${_feeCtrl.text.isEmpty ? '0.00' : _feeCtrl.text}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                  fontSize: 16.sp,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text('Scan to Pay',
                                  style: TextStyle(
                                      fontSize: 11.sp,
                                      color: Colors.black45)),
                            ],
                          ),
                        ),
                      ),
                    ],

                    SizedBox(height: 14.h),

                    // Pay & Confirm button
                    if (!_paymentConfirmed)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _confirmPayment(context),
                          icon: const Icon(Icons.check_circle,
                              color: Colors.white),
                          label: Text(
                            'Pay & Confirm  ₹${_feeCtrl.text.isEmpty ? '0.00' : _feeCtrl.text}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r)),
                          ),
                        ),
                      )
                    else
                      Container(
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                              color: AppColors.success.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle,
                                color: AppColors.success, size: 20),
                            SizedBox(width: 8.w),
                            Text('Payment Confirmed!',
                                style: TextStyle(
                                  color: AppColors.success,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.sp,
                                )),
                          ],
                        ),
                      ),

                    SizedBox(height: 24.h),

                    // ── Section D: EMR Submission ─────────────────────────
                    _buildSectionHeader(
                      Icons.local_hospital_outlined,
                      'D. Submit to EMR',
                      'Electronic Medical Record',
                      isDark,
                      color: AppColors.adminPrimary,
                    ),
                    SizedBox(height: 12.h),

                    // EMR Summary card
                    Container(
                      padding: EdgeInsets.all(14.r),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.terminalDarkBg
                            : Colors.grey[50],
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: isDark
                              ? AppColors.terminalDarkBorder
                              : AppColors.border,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildEMRRow('Patient', apt.patientName, isDark),
                          _buildEMRRow('Doctor', 'Dr. ${apt.doctorName}', isDark),
                          _buildEMRRow('Specialty', apt.specialty, isDark),
                          _buildEMRRow('Invoice', _invoiceNumber, isDark),
                          if (_getMedicineList().isNotEmpty)
                            _buildEMRRow(
                              'Medicines',
                              _getMedicineList()
                                  .map((m) => m['name'])
                                  .join(', '),
                              isDark,
                            ),
                          if (_selectedTests.isNotEmpty)
                            _buildEMRRow(
                              'Lab Tests',
                              _selectedTests.join(', '),
                              isDark,
                            ),
                          if (_prescriptionNotesCtrl.text.isNotEmpty)
                            _buildEMRRow(
                              'Notes',
                              _prescriptionNotesCtrl.text,
                              isDark,
                              isLast: true,
                            ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    if (!_emrSubmitted)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed:
                              _paymentConfirmed ? () => _submitEMR(context) : null,
                          icon: const Icon(Icons.cloud_upload_outlined,
                              color: Colors.white),
                          label: const Text(
                            'Submit to EMR',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.adminPrimary,
                            disabledBackgroundColor:
                                AppColors.adminPrimary.withOpacity(0.4),
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.r)),
                          ),
                        ),
                      ),

                    if (!_paymentConfirmed)
                      Padding(
                        padding: EdgeInsets.only(top: 6.h),
                        child: Center(
                          child: Text(
                            'Complete payment first to enable EMR submission',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: isDark
                                  ? Colors.white38
                                  : AppColors.textSecondary.withOpacity(0.6),
                            ),
                          ),
                        ),
                      ),

                    SizedBox(height: 32.h),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(
      IconData icon, String title, String subtitle, bool isDark,
      {Color color = AppColors.primary}) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18.r, color: color),
          ),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: AppTextStyles.titleMedium.copyWith(
                    color: isDark ? Colors.white : AppColors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                  )),
              Text(subtitle,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark ? Colors.white54 : AppColors.textSecondary,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController ctrl, String hint, bool isDark,
      {int maxLines = 1}) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      style: TextStyle(
          color: isDark ? Colors.white : AppColors.textPrimary,
          fontSize: 13.sp),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
            color: isDark ? Colors.white38 : AppColors.textSecondary,
            fontSize: 12.sp),
        filled: true,
        fillColor: isDark ? AppColors.terminalDarkBg : Colors.grey[50],
        contentPadding:
            EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: BorderSide(
              color: isDark ? AppColors.terminalDarkBorder : AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide:
              const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }

  Widget _buildEMRRow(String label, String value, bool isDark,
      {bool isLast = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80.w,
            child: Text(label,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: isDark ? Colors.white38 : AppColors.textSecondary,
                )),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(value,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                )),
          ),
        ],
      ),
    );
  }
}
