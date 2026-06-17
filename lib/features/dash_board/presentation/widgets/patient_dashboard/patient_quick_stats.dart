import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/patient_dashboard/quick_stat_card.dart';

class PatientQuickStats extends StatelessWidget {
  const PatientQuickStats({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        int aptCount = 3;
        int recCount = 12;
        int presCount = 5;

        if (state is Authenticated) {
          final user = state.user;
          final apts = user.metadata?['appointments'] as List<dynamic>?;
          if (apts != null) aptCount = apts.length;

          final recs = user.metadata?['records'] as List<dynamic>?;
          if (recs != null) recCount = recs.length;

          final prescriptions =
              user.metadata?['prescriptions'] as List<dynamic>?;
          if (prescriptions != null) presCount = prescriptions.length;
        }

        return Row(
          children: [
            QuickStatCard(
              icon: Icons.calendar_today,
              label: 'Appointments',
              value: '$aptCount',
              color: AppColors.primary,
            ),
            SizedBox(width: 12.w),
            QuickStatCard(
              icon: Icons.folder_open,
              label: 'Records',
              value: '$recCount',
              color: AppColors.secondary,
            ),
            SizedBox(width: 12.w),
            QuickStatCard(
              icon: Icons.medical_services_outlined,
              label: 'Prescriptions',
              value: '$presCount',
              color: AppColors.accent,
            ),
          ],
        );
      },
    );
  }
}
