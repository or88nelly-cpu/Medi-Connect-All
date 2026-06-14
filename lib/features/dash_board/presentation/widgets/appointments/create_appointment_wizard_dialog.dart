import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/admin_appointments_bloc.dart';
import 'package:medi_connect/features/department/presentation/bloc/department_bloc.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_event.dart';
import 'package:medi_connect/features/patient/presentation/bloc/patient_bloc.dart';

import 'booking_wizard/booking_wizard_cubit.dart';
import 'booking_wizard/step_indicator.dart';
import 'booking_wizard/patient_step.dart';
import 'booking_wizard/specialty_step.dart';
import 'booking_wizard/doctor_step.dart';
import 'booking_wizard/slot_step.dart';
import 'booking_wizard/confirm_step.dart';
import 'booking_wizard/wizard_footer_buttons.dart';

class CreateAppointmentWizardDialog extends StatefulWidget {
  const CreateAppointmentWizardDialog({super.key});

  @override
  State<CreateAppointmentWizardDialog> createState() =>
      _CreateAppointmentWizardDialogState();
}

class _CreateAppointmentWizardDialogState
    extends State<CreateAppointmentWizardDialog> {
  final _patientFormKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _ageController = TextEditingController();

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

  void _submitAppointment(BookingWizardCubit cubit) {
    final state = cubit.state;
    if (state.selectedPatient == null ||
        state.selectedSection == null ||
        state.selectedDoctor == null ||
        state.selectedSlotTime == null) {
      return;
    }

    final dateStr = state.selectedDate.toIso8601String().split('T').first;
    final patientName = state.selectedPatient!.name ??
        '${state.selectedPatient!.firstName} ${state.selectedPatient!.lastName}'.trim();
    final doctorName = state.selectedDoctor!.name ??
        '${state.selectedDoctor!.firstName} ${state.selectedDoctor!.lastName}'.trim();

    final isLikhin = doctorName == "Likhin Nelliyotan" ||
        (doctorName.contains("Likhin") && doctorName.contains("Nelliyotan"));

    String? token;
    if (isLikhin) {
      if (state.isWaitingList) {
        if (state.currentWaitingCount >= 10) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Error: Waiting list is full (maximum 10 waiting list slots reached)."),
              backgroundColor: AppColors.error,
            ),
          );
          return;
        }
        token = 'LNW${(state.currentWaitingCount + 1).toString().padLeft(2, '0')}';
      } else {
        token = 'LNA${(state.currentNormalCount + 1).toString().padLeft(2, '0')}';
      }
    }

    // 1. Dispatch CreateAppointmentEvent to AdminAppointmentsBloc
    context.read<AdminAppointmentsBloc>().add(
      CreateAppointmentEvent({
        'patient_id': state.selectedPatient!.id,
        'patient_name': patientName,
        'doctor_id': state.selectedDoctor!.id,
        'doctor_name': doctorName,
        'specialty': state.selectedSection!.name,
        'appointment_date': dateStr,
        'appointment_time': state.selectedSlotTime!,
        'status': 'Confirmed',
        'type': state.selectedType,
        if (token != null) 'token': token,
      }),
    );

    // 2. Dynamically update doctor's slots configuration metadata
    final formattedDate = DateFormat('dd MMM yyyy').format(state.selectedDate);
    final updatedMetadata = Map<String, dynamic>.from(
      state.selectedDoctor!.metadata ?? {},
    );
    final slotsByDate = Map<String, dynamic>.from(
      updatedMetadata['slots_by_date'] ?? {},
    );
    final dateData = Map<String, dynamic>.from(
      slotsByDate[formattedDate] ?? {},
    );

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
      if (s['time'] == state.selectedSlotTime) {
        s['status'] = 'Booked';
        found = true;
        break;
      }
    }
    if (!found) {
      for (var s in afternoonSlots) {
        if (s['time'] == state.selectedSlotTime) {
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

    final updatedDoctor = state.selectedDoctor!.copyWith(metadata: updatedMetadata);
    context.read<DoctorStaffBloc>().add(UpdateDoctorStaffMember(updatedDoctor));

    // 3. Show confirmation snackbar and pop wizard
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Appointment successfully booked for $patientName on $formattedDate at ${state.selectedSlotTime}",
        ),
        backgroundColor: AppColors.success,
      ),
    );
    Navigator.pop(context);
  }

  Widget _buildActiveStepContent(int step) {
    switch (step) {
      case 0:
        return PatientStep(
          patientFormKey: _patientFormKey,
          firstNameController: _firstNameController,
          lastNameController: _lastNameController,
          emailController: _emailController,
          phoneController: _phoneController,
          ageController: _ageController,
        );
      case 1:
        return const SpecialtyStep();
      case 2:
        return const DoctorStep();
      case 3:
        return const SlotStep();
      case 4:
        return const ConfirmStep();
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocProvider(
      create: (context) => BookingWizardCubit(),
      child: Builder(
        builder: (context) {
          final cubit = context.read<BookingWizardCubit>();

          return BlocListener<PatientBloc, PatientState>(
            listener: (context, patientState) {
              if (patientState is PatientActionSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Patient registered successfully."),
                    backgroundColor: AppColors.success,
                  ),
                );
              } else if (patientState is PatientLoaded && _emailController.text.isNotEmpty) {
                final registered = patientState.patients.where(
                  (p) =>
                      p.email.toLowerCase() ==
                      _emailController.text.trim().toLowerCase(),
                );
                if (registered.isNotEmpty) {
                  cubit.selectPatient(registered.first);
                  _firstNameController.clear();
                  _lastNameController.clear();
                  _emailController.clear();
                  _phoneController.clear();
                  _ageController.clear();
                }
              } else if (patientState is PatientError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("Patient error: ${patientState.message}"),
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
                child: BlocBuilder<BookingWizardCubit, BookingWizardState>(
                  builder: (context, state) {
                    return Column(
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
                        const StepIndicator(),
                        SizedBox(height: 16.h),

                        // Active Step Content Container
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: _buildActiveStepContent(state.currentStep),
                          ),
                        ),
                        SizedBox(height: 12.h),

                        // Footer Navigation Buttons
                        WizardFooterButtons(
                          onSubmit: () => _submitAppointment(cubit),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
