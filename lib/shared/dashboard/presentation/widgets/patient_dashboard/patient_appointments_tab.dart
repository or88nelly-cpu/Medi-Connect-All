import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/modules/management/staff_management/data/datasource/doctor_staff_remote_datasource.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_event.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_state.dart';

class PatientAppointmentsTab extends StatefulWidget {
  const PatientAppointmentsTab({super.key});

  @override
  State<PatientAppointmentsTab> createState() => _PatientAppointmentsTabState();
}

class _PatientAppointmentsTabState extends State<PatientAppointmentsTab> {
  List<Map<String, String>> _resolveAppointments(UserModel user) {
    final metadataApts = user.metadata?['appointments'] as List<dynamic>?;
    final List<Map<String, String>> appointments = [];

    if (metadataApts != null) {
      for (var item in metadataApts) {
        if (item is Map) {
          appointments.add({
            'doctor': (item['doctor'] ?? '').toString(),
            'specialty': (item['specialty'] ?? '').toString(),
            'time': (item['time'] ?? '').toString(),
            'type': (item['type'] ?? '').toString(),
          });
        }
      }
    }

    if (appointments.isEmpty) {
      appointments.addAll([
        {
          'doctor': 'Dr. Sarah Johnson',
          'specialty': 'Cardiologist',
          'time': 'June 12, 10:30 AM',
          'type': 'Cardiology Clinic',
        },
        {
          'doctor': 'Dr. Michael Chen',
          'specialty': 'Neurologist',
          'time': 'June 15, 02:00 PM',
          'type': 'Neurology Clinic',
        },
      ]);
    }

    return appointments;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! Authenticated) {
          return const Center(child: CircularProgressIndicator());
        }

        final user = UserModel.fromEntity(state.user);
        final appointments = _resolveAppointments(user);

        return Padding(
          padding: EdgeInsets.all(20.r),
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
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _showBookDoctorDialog(context),
                    icon: const Icon(Icons.search, color: Colors.white),
                    label: const Text(
                      'Book Doctor',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Text(
                'My Scheduled Bookings',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),
              Expanded(
                child: ListView.builder(
                  itemCount: appointments.length,
                  itemBuilder: (context, idx) {
                    final apt = appointments[idx];
                    return Card(
                      margin: EdgeInsets.only(bottom: 12.h),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        side: BorderSide(color: AppColors.border(context)),
                      ),
                      child: ListTile(
                        contentPadding: EdgeInsets.all(16.r),
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withValues(
                            alpha: 0.1,
                          ),
                          child: Icon(Icons.person, color: AppColors.primary),
                        ),
                        title: Text(
                          apt['doctor']!,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary(context),
                          ),
                        ),
                        subtitle: Text(
                          "${apt['specialty']!} | ${apt['type']!}",
                        ),
                        trailing: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Text(
                            apt['time']!,
                            style: TextStyle(
                              color: AppColors.primary,
                              fontSize: 9.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBookDoctorDialog(BuildContext context) {
    context.read<DoctorStaffBloc>().add(const LoadDoctorStaff('All'));
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      builder: (ctx) {
        return BlocProvider.value(
          value: context.read<DoctorStaffBloc>(),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.8,
            padding: EdgeInsets.all(20.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Find & Choose Doctor',
                      style: AppTextStyles.titleLarge,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                Divider(color: AppColors.border(context)),
                SizedBox(height: 12.h),
                Expanded(
                  child: BlocBuilder<DoctorStaffBloc, DoctorStaffState>(
                    builder: (context, state) {
                      if (state is DoctorStaffLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (state is DoctorStaffError ||
                          state is! DoctorStaffLoaded) {
                        return _buildFallbackDoctorsList(ctx);
                      }
                      final doctors = state.doctors;
                      if (doctors.isEmpty) {
                        return _buildFallbackDoctorsList(ctx);
                      }
                      return ListView.builder(
                        itemCount: doctors.length,
                        itemBuilder: (_, idx) =>
                            _buildDoctorBookingTile(ctx, doctors[idx]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFallbackDoctorsList(BuildContext ctx) {
    final fallbackDocs = [
      const UserModel(
        id: 'doc-1',
        email: 'sarah.j@mediconnect.com',
        name: 'Dr. Sarah Johnson',
        role: 'doctor',
        specialization: 'Cardiologist',
        department: 'Cardiology',
        consultationFee: 1200.0,
        experience: 12,
      ),
      const UserModel(
        id: 'doc-2',
        email: 'michael.c@mediconnect.com',
        name: 'Dr. Michael Chen',
        role: 'doctor',
        specialization: 'Neurologist',
        department: 'Neurology',
        consultationFee: 1500.0,
        experience: 9,
      ),
      const UserModel(
        id: 'doc-3',
        email: 'james.w@mediconnect.com',
        name: 'Dr. James Wilson',
        role: 'doctor',
        specialization: 'Pediatrician',
        department: 'Pediatrics',
        consultationFee: 1000.0,
        experience: 15,
      ),
    ];
    return ListView.builder(
      itemCount: fallbackDocs.length,
      itemBuilder: (_, idx) => _buildDoctorBookingTile(ctx, fallbackDocs[idx]),
    );
  }

  Widget _buildDoctorBookingTile(BuildContext ctx, UserModel doc) {
    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(color: AppColors.border(context)),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.r),
        leading: CircleAvatar(
          backgroundColor: AppColors.secondary.withValues(alpha: 0.1),
          child: Icon(
            Icons.local_hospital_outlined,
            color: AppColors.secondary,
          ),
        ),
        title: Text(
          doc.name ?? 'Dr. Specialist',
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary(context),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 2.h),
            Text(
              "${doc.specialization ?? 'General Medicine'} | Exp: ${doc.experience ?? 5} Yrs",
            ),
            Text("Fee: ₹ ${doc.consultationFee ?? 500}"),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () {
            Navigator.pop(ctx);
            _confirmBooking(doc);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.r),
            ),
          ),
          child: const Text('Book', style: TextStyle(color: Colors.white)),
        ),
      ),
    );
  }

  void _confirmBooking(UserModel doc) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirm Appointment', style: AppTextStyles.titleLarge),
        content: Text(
          "Do you want to book an appointment with ${doc.name}?\nConsultation Fee: ₹ ${doc.consultationFee ?? 500}",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final authState = context.read<AuthBloc>().state;
              if (authState is Authenticated) {
                final user = UserModel.fromEntity(authState.user);
                final updatedMetadata = Map<String, dynamic>.from(
                  user.metadata ?? {},
                );
                final currentApts = List<dynamic>.from(
                  updatedMetadata['appointments'] ??
                      [
                        {
                          'doctor': 'Dr. Sarah Johnson',
                          'specialty': 'Cardiologist',
                          'time': 'June 12, 10:30 AM',
                          'type': 'Cardiology Clinic',
                        },
                        {
                          'doctor': 'Dr. Michael Chen',
                          'specialty': 'Neurologist',
                          'time': 'June 15, 02:00 PM',
                          'type': 'Neurology Clinic',
                        },
                      ],
                );

                currentApts.insert(0, {
                  'doctor': doc.name ?? 'Dr. Specialist',
                  'specialty': doc.specialization ?? 'General Medicine',
                  'time': 'June 18, 09:30 AM',
                  'type': doc.department ?? 'General Clinic',
                });

                updatedMetadata['appointments'] = currentApts;
                final updatedUser = user.copyWith(metadata: updatedMetadata);

                await GetIt.instance<DoctorStaffRemoteDataSource>()
                    .updateDoctorStaffMember(updatedUser);

                if (context.mounted) {
                  context.read<AuthBloc>().add(UserUpdated(updatedUser));
                }
              }
              Navigator.pop(ctx);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Appointment booked with ${doc.name} successfully.",
                    ),
                  ),
                );
              }
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
