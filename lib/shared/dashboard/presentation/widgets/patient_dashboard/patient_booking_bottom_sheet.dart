import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_event.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_state.dart';
import 'package:medi_connect/modules/management/staff_management/data/datasource/doctor_staff_remote_datasource.dart';

class PatientBookingBottomSheet extends StatefulWidget {
  const PatientBookingBottomSheet({super.key});

  @override
  State<PatientBookingBottomSheet> createState() =>
      _PatientBookingBottomSheetState();
}

class _PatientBookingBottomSheetState extends State<PatientBookingBottomSheet> {
  @override
  void initState() {
    super.initState();
    context.read<DoctorStaffBloc>().add(const LoadDoctorStaff('All'));
  }

  void _confirmBooking(BuildContext context, UserModel doc) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: isDark ? AppColors.terminalDarkCard : Colors.white,
        title: Text("Confirm Appointment", style: AppTextStyles.titleLarge),
        content: Text(
          "Do you want to book an appointment with ${doc.name}?\nConsultation Fee: ₹ ${doc.consultationFee ?? 500}",
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
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

                final newApt = {
                  'doctor': doc.name ?? 'Dr. Specialist',
                  'specialty': doc.specialization ?? 'General Medicine',
                  'time': 'June 18, 09:30 AM',
                  'type': doc.department ?? 'General Clinic',
                };

                currentApts.insert(0, newApt);
                updatedMetadata['appointments'] = currentApts;

                final updatedUser = user.copyWith(metadata: updatedMetadata);

                // Save to database
                await GetIt.instance<DoctorStaffRemoteDataSource>()
                    .updateDoctorStaffMember(updatedUser);

                // Update local auth state
                if (context.mounted) {
                  context.read<AuthBloc>().add(UserUpdated(updatedUser));
                }
              }
              if (ctx.mounted) Navigator.pop(ctx); // Close dialog
              if (context.mounted) Navigator.pop(context); // Close bottom sheet

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Appointment booked with ${doc.name} successfully.",
                    ),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.terminalDarkCard : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Find & Choose Doctor",
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF0F2C59),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          Divider(color: AppColors.border(context)),
          SizedBox(height: 12.h),

          // Doctor List
          Expanded(
            child: BlocBuilder<DoctorStaffBloc, DoctorStaffState>(
              builder: (context, state) {
                if (state is DoctorStaffLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is DoctorStaffError ||
                    state is! DoctorStaffLoaded) {
                  return _buildFallbackDoctorsList(context);
                }

                final doctors = state.doctors
                    .where((u) => u.role == 'doctor')
                    .toList();
                if (doctors.isEmpty) {
                  return _buildFallbackDoctorsList(context);
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: doctors.length,
                  itemBuilder: (context, idx) {
                    final doc = doctors[idx];
                    return _buildDoctorBookingTile(context, doc);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFallbackDoctorsList(BuildContext context) {
    final List<UserModel> fallbackDocs = [
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
      physics: const BouncingScrollPhysics(),
      itemCount: fallbackDocs.length,
      itemBuilder: (context, idx) {
        final doc = fallbackDocs[idx];
        return _buildDoctorBookingTile(context, doc);
      },
    );
  }

  Widget _buildDoctorBookingTile(BuildContext context, UserModel doc) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      margin: EdgeInsets.only(bottom: 12.h),
      elevation: 0,
      color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r),
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
            color: isDark ? Colors.white : AppColors.textPrimary(context),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text(
              "${doc.specialization ?? 'General Medicine'} | Exp: ${doc.experience ?? 5} Yrs",
              style: TextStyle(fontSize: 12.sp),
            ),
            SizedBox(height: 2.h),
            Text(
              "Fee: ₹ ${doc.consultationFee ?? 500}",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
        trailing: ElevatedButton(
          onPressed: () => _confirmBooking(context, doc),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
          ),
          child: const Text(
            "Book",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
