import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/dash_board/domain/entities/appointment_entity.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/doctor/doctor_appointments_bloc.dart';
import 'package:medi_connect/features/patient/presentation/bloc/patient_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/doctor_dashboard/patient_details_sheet.dart';

class DoctorPatientsTab extends StatelessWidget {
  const DoctorPatientsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is! Authenticated) {
          return const Center(child: Text("Please login to see patients"));
        }
        final doctor = authState.user;
        final docDisplayName =
            doctor.name ??
            "${doctor.firstName ?? ''} ${doctor.lastName ?? ''}".trim();

        return BlocBuilder<DoctorAppointmentsBloc, DoctorAppointmentsState>(
          builder: (context, aptState) {
            return BlocBuilder<PatientBloc, PatientState>(
              builder: (context, patientState) {
                if (aptState is DoctorAppointmentsLoading ||
                    patientState is PatientLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (aptState is DoctorAppointmentsError ||
                    patientState is PatientError) {
                  return Center(
                    child: Text(
                      "Error loading patients data",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.error,
                      ),
                    ),
                  );
                }
                if (aptState is DoctorAppointmentsLoaded &&
                    patientState is PatientLoaded) {
                  final appointments = aptState.appointments;
                  final allPatients = patientState.patients;

                  // Filter appointments for this doctor
                  final List<AppointmentEntity> doctorApts =
                      List<AppointmentEntity>.from(
                        appointments.where((a) {
                          final matchId = a.doctorId == doctor.id;
                          final matchName =
                              a.doctorName
                                  .toLowerCase()
                                  .replaceAll("dr.", "")
                                  .trim() ==
                              docDisplayName
                                  .toLowerCase()
                                  .replaceAll("dr.", "")
                                  .trim();
                          return matchId || matchName;
                        }),
                      );

                  // Get unique patients
                  final patientIds = doctorApts.map((a) => a.patientId).toSet();
                  final patientNames = doctorApts
                      .map((a) => a.patientName.toLowerCase().trim())
                      .toSet();

                  final myPatients = allPatients.where((p) {
                    final matchId =
                        patientIds.contains(p.id) ||
                        (p.patientId != null &&
                            patientIds.contains(p.patientId));
                    final displayName =
                        (p.name ??
                                "${p.firstName ?? ''} ${p.lastName ?? ''}"
                                    .trim())
                            .toLowerCase();
                    final matchName = patientNames.contains(displayName);
                    return matchId || matchName;
                  }).toList();

                  if (myPatients.isEmpty) {
                    return Padding(
                      padding: EdgeInsets.all(20.r),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "My Patients",
                            style: AppTextStyles.headingMedium.copyWith(
                              fontSize: 22.sp,
                            ),
                          ),
                          Expanded(
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.people_outline,
                                    color: Colors.grey[400],
                                    size: 48.r,
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    "No patients under your care",
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return Padding(
                    padding: EdgeInsets.all(20.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "My Patients",
                          style: AppTextStyles.headingMedium.copyWith(
                            fontSize: 22.sp,
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Expanded(
                          child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: myPatients.length,
                            itemBuilder: (context, idx) {
                              final p = myPatients[idx];
                              final displayName =
                                  p.name ??
                                  "${p.firstName ?? ''} ${p.lastName ?? ''}"
                                      .trim();
                              final gender = p.gender ?? "Not Specified";
                              final age = p.age != null
                                  ? "${p.age} years"
                                  : "N/A";

                              // Find appointment specialty/reason or fallback to chronic diseases
                              final AppointmentEntity? matchingApt = doctorApts
                                  .cast<AppointmentEntity?>()
                                  .firstWhere(
                                    (a) =>
                                        a?.patientName.toLowerCase().trim() ==
                                        displayName.toLowerCase(),
                                    orElse: () => null,
                                  );
                              final issue =
                                  p.chronicDiseases ??
                                  matchingApt?.specialty ??
                                  "General Consultation";

                              return Card(
                                margin: EdgeInsets.only(bottom: 12.h),
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.r),
                                  side:  BorderSide(
                                    color: AppColors.border(context),
                                  ),
                                ),
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(16.r),
                                  leading: CircleAvatar(
                                    backgroundColor: const Color(
                                      0xFF00C2A8,
                                    ).withValues(alpha: 0.1),
                                    child: const Icon(
                                      Icons.person,
                                      color: Color(0xFF00C2A8),
                                    ),
                                  ),
                                  title: Text(
                                    displayName,
                                    style: AppTextStyles.titleMedium.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.sp,
                                    ),
                                  ),
                                  subtitle: Text(
                                    "Age: $age | Gender: $gender \nIssue: $issue",
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  trailing: const Icon(Icons.chevron_right),
                                  isThreeLine: true,
                                  onTap: () {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      backgroundColor: Colors.transparent,
                                      builder: (_) => PatientDetailsSheet(
                                        patient: p,
                                        doctorApts: doctorApts,
                                        doctor: doctor,
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            );
          },
        );
      },
    );
  }
}
