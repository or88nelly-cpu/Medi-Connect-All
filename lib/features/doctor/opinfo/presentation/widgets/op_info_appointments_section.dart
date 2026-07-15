import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/constants/app_enum.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/features/authentication/domain/entities/user_entity.dart';
import 'package:medi_connect/features/common/dashboard/domain/entities/appointment_entity.dart';
import 'package:medi_connect/features/doctor/dashboard/presentation/pages/patient_visit_detail_page.dart';
import 'package:medi_connect/features/doctor/opinfo/domain/entities/op_procedure_entity.dart';
import 'package:medi_connect/features/doctor/opinfo/presentation/widgets/op_info_appointment_item.dart';

class OpInfoAppointmentsSection extends StatelessWidget {
  final List<OpProcedureEntity> procedures;
  final int totalCount;
  final DateTime selectedDate;
  final String doctorName;
  final String specialty;

  const OpInfoAppointmentsSection({
    super.key,
    required this.procedures,
    required this.totalCount,
    required this.selectedDate,
    required this.doctorName,
    required this.specialty,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppStrings.opInfoTodaysAppointments} ($totalCount)',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(height: 12.h),
          if (procedures.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32.h),
                child: Text(
                  AppStrings.noScheduleToday,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ),
            )
          else
            ...procedures.map(
              (p) => OpInfoAppointmentItem(
                procedure: p,
                onTap: () {
                  final parts = p.patientName.trim().split(' ');
                  final fName = parts.isNotEmpty ? parts.first : p.patientName;
                  final lName = parts.length > 1 ? parts.sublist(1).join(' ') : '';

                  final patientEntity = UserEntity(
                    id: p.patientId,
                    firstName: fName,
                    lastName: lName,
                    email: '',
                    gender: p.gender,
                    role: UserRole.patient,
                    profilePhoto: p.profilePhoto,
                  );

                  final appointmentEntity = AppointmentEntity(
                    id: p.id,
                    patientId: p.patientId,
                    patientName: p.patientName,
                    doctorId: '',
                    doctorName: doctorName,
                    specialty: specialty,
                    appointmentDate: selectedDate,
                    appointmentTime: p.appointmentTime,
                    status: p.status,
                    type: 'OPD',
                    token: 'OPD - ${p.tokenNumber}',
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PatientVisitDetailPage(
                        appointment: appointmentEntity,
                        patient: patientEntity,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
