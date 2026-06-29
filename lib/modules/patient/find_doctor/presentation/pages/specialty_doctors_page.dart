import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/constants/app_enum.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_event.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_state.dart';
import 'package:medi_connect/modules/patient/booking/presentation/pages/doctor_profile_detail_page.dart';
import 'package:medi_connect/modules/patient/booking/presentation/pages/booking_flow_page.dart';

/// Shows doctors filtered by [specialty].
class SpecialtyDoctorsPage extends StatefulWidget {
  final String specialty;
  final List<Color> gradientColors;

  const SpecialtyDoctorsPage({
    super.key,
    required this.specialty,
    required this.gradientColors,
  });

  @override
  State<SpecialtyDoctorsPage> createState() => _SpecialtyDoctorsPageState();
}

class _SpecialtyDoctorsPageState extends State<SpecialtyDoctorsPage> {
  @override
  void initState() {
    super.initState();
    context.read<DoctorStaffBloc>().add(const LoadDoctorStaff('All'));
  }

  static final List<UserModel> _mockDoctors = [
    const UserModel(
      id: 'doc-1',
      email: 'sarah.j@mediconnect.com',
      firstName: 'Dr. Sarah',
      lastName: 'Johnson',
      role: UserRole.doctor,
    ),
    const UserModel(
      id: 'doc-2',
      email: 'michael.c@mediconnect.com',
      firstName: 'Dr. Michael',
      lastName: 'Chen',
      role: UserRole.doctor,
    ),
    const UserModel(
      id: 'doc-3',
      email: 'james.w@mediconnect.com',
      firstName: 'Dr. James',
      lastName: 'Wilson',
      role: UserRole.doctor,
    ),
    const UserModel(
      id: 'doc-4',
      email: 'priya.s@mediconnect.com',
      firstName: 'Dr. Priya',
      lastName: 'Sharma',
      role: UserRole.doctor,
    ),
    const UserModel(
      id: 'doc-5',
      email: 'raj.k@mediconnect.com',
      firstName: 'Dr. Rajesh',
      lastName: 'Kumar',
      role: UserRole.doctor,
    ),
  ];

  List<UserModel> _filterDoctors(List<UserModel> all) {
    final filtered = all.where((d) => d.role == UserRole.doctor).toList();
    return filtered.isEmpty ? _mockDoctors : filtered;
  }

  double _mockRating(String id) {
    final ratings = {
      'doc-1': 4.9,
      'doc-2': 4.7,
      'doc-3': 4.8,
      'doc-4': 4.5,
      'doc-5': 4.9,
    };
    return ratings[id] ?? 4.5 + (id.hashCode % 5) * 0.1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary(context),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.specialty,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Specialists',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary(context),
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<DoctorStaffBloc, DoctorStaffState>(
        builder: (context, state) {
          List<UserModel> doctors;
          if (state is DoctorStaffLoaded && state.doctors.isNotEmpty) {
            doctors = _filterDoctors(state.doctors);
          } else if (state is DoctorStaffLoading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            doctors = _mockDoctors;
          }

          return ListView.separated(
            padding: EdgeInsets.all(16.r),
            itemCount: doctors.length,
            separatorBuilder: (context, _) => SizedBox(height: 12.h),
            itemBuilder: (context, index) {
              final doc = doctors[index];
              return _DoctorCard(
                doctor: doc,
                rating: _mockRating(doc.id),
                gradientColors: widget.gradientColors,
                onViewProfile: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => BlocProvider.value(
                        value: context.read<AuthBloc>(),
                        child: DoctorProfileDetailPage(
                          doctor: doc,
                          gradientColors: widget.gradientColors,
                        ),
                      ),
                    ),
                  );
                },
                onBook: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => MultiBlocProvider(
                        providers: [
                          BlocProvider.value(
                            value: context.read<DoctorStaffBloc>(),
                          ),
                          BlocProvider.value(value: context.read<AuthBloc>()),
                        ],
                        child: BookingFlowPage(
                          preselectedDoctor: doc,
                          preselectedSpecialty: widget.specialty,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _DoctorCard extends StatelessWidget {
  final UserModel doctor;
  final double rating;
  final List<Color> gradientColors;
  final VoidCallback onViewProfile;
  final VoidCallback onBook;

  const _DoctorCard({
    required this.doctor,
    required this.rating,
    required this.gradientColors,
    required this.onViewProfile,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border(context)),
        boxShadow: [
          BoxShadow(
            color: gradientColors.first.withValues(alpha: 0.07),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Doctor avatar
              Container(
                width: 56.r,
                height: 56.r,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_rounded,
                  color: Colors.white,
                  size: 28.r,
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      doctor.fullName,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary(context),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'General Medicine',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: gradientColors.first,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: const Color(0xFFFFB547),
                          size: 14.r,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          rating.toStringAsFixed(1),
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary(context),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Icon(
                          Icons.work_outline_rounded,
                          color: AppColors.textSecondary(context),
                          size: 12.r,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          '5 yrs exp',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Fee badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: gradientColors.first.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Column(
                  children: [
                    Text(
                      '₹500',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: gradientColors.first,
                      ),
                    ),
                    Text(
                      'fee',
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 14.h),
          // Availability chip
          Row(
            children: [
              Container(
                width: 8.r,
                height: 8.r,
                decoration: const BoxDecoration(
                  color: Color(0xFF22C55E),
                  shape: BoxShape.circle,
                ),
              ),
              SizedBox(width: 4.w),
              Text(
                'Available Today',
                style: AppTextStyles.bodySmall.copyWith(
                  color: const Color(0xFF22C55E),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onViewProfile,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: gradientColors.first),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                  child: Text(
                    'View Profile',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: gradientColors.first,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: ElevatedButton(
                  onPressed: onBook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: gradientColors.first,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                  ),
                  child: Text(
                    'Book Now',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
