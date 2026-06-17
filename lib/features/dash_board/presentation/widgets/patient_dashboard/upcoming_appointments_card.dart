import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/widgets/patient_dashboard/appointment_row.dart';

class UpcomingAppointmentsCard extends StatelessWidget {
  const UpcomingAppointmentsCard({super.key});

  List<Map<String, String>> _resolveAppointments(AuthState state) {
    final List<Map<String, String>> appointments = [];

    if (state is Authenticated) {
      final metadataApts =
          state.user.metadata?['appointments'] as List<dynamic>?;
      if (metadataApts != null) {
        for (var item in metadataApts) {
          if (item is Map) {
            appointments.add({
              'doctorName': (item['doctor'] ?? '').toString(),
              'specialty': (item['specialty'] ?? '').toString(),
              'time': (item['time'] ?? '').toString(),
            });
          }
        }
      }
    }

    if (appointments.isEmpty) {
      appointments.addAll([
        {
          'doctorName': 'Dr. Sarah Johnson',
          'specialty': 'Cardiologist',
          'time': 'Today, 10:30 AM',
        },
        {
          'doctorName': 'Dr. Michael Chen',
          'specialty': 'Neurologist',
          'time': 'Tomorrow, 2:00 PM',
        },
      ]);
    }

    return appointments;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        final appointments = _resolveAppointments(state);
        final displayCount = appointments.length > 2 ? 2 : appointments.length;

        return Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: AppColors.border),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: List.generate(displayCount, (idx) {
              final apt = appointments[idx];
              return Column(
                children: [
                  if (idx > 0) Divider(color: AppColors.border, height: 20.h),
                  AppointmentRow(
                    doctorName: apt['doctorName']!,
                    specialty: apt['specialty']!,
                    time: apt['time']!,
                    color: idx == 0 ? AppColors.primary : AppColors.secondary,
                  ),
                ],
              );
            }),
          ),
        );
      },
    );
  }
}
