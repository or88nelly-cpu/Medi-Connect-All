import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/department/domain/entities/department_entity.dart';
import 'package:medi_connect/features/department/presentation/bloc/department_bloc.dart';
import 'package:medi_connect/features/department/presentation/widgets/department_horizontal_list.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/patient_dashboard/patient_welcome_banner.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/patient_dashboard/patient_quick_stats.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/patient_dashboard/upcoming_appointments_card.dart';

class PatientHomeTab extends StatelessWidget {
  const PatientHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Welcome Banner ──────────────────────────────
          const PatientWelcomeBanner(),
          SizedBox(height: 24.h),

          // ── Quick Stats ─────────────────────────────────
          Text(
            AppStrings.patientQuickActions,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          const PatientQuickStats(),
          SizedBox(height: 24.h),

          // ── Upcoming Appointments ───────────────────────
          Text(
            AppStrings.upcomingAppointments,
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),
          const UpcomingAppointmentsCard(),
          SizedBox(height: 24.h),

          // ── Departments ─────────────────────────────────
          BlocBuilder<DepartmentBloc, DepartmentState>(
            builder: (context, state) {
              final List<DepartmentEntity> departments =
                  state is DepartmentsLoaded
                  ? state.sections
                  : state is DepartmentActionSuccess
                  ? (state.updatedDepartments)
                        .where((e) => !e.consultation)
                        .toList()
                  : [];
              return DepartmentHorizontalList(
                departments: departments,
                title: AppStrings.sections,
                isAdmin: false,
              );
            },
          ),
          SizedBox(height: 80.h),
        ],
      ),
    );
  }
}
