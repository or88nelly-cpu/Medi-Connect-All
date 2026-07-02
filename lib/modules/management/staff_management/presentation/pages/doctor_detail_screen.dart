import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/core/widgets/appbar/common_app_bar.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/functions/profile_image_helper.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/user_details_bloc.dart';

// Components
import 'package:medi_connect/modules/management/staff_management/presentation/widgets/employee_personal_card.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/widgets/doctor_license_card.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/widgets/doctor_fee_schedule_card.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/widgets/doctor_biography_card.dart';

class DoctorDetailScreen extends StatefulWidget {
  final String userId;

  const DoctorDetailScreen({super.key, required this.userId});

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserDetailsBloc>().add(FetchUserDetails(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;

    return CustomScaffold(
      customAppbar: const CommonAppBar(title: "Doctor Profile Details"),
      body: BlocBuilder<UserDetailsBloc, UserDetailsState>(
        builder: (context, state) {
          if (state is UserDetailsLoading || state is UserDetailsInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserDetailsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64.r, color: AppColors.error),
                  SizedBox(height: 16.h),
                  Text("Error: ${state.error}", style: AppTextStyles.bodyMedium),
                ],
              ),
            );
          }

          if (state is UserDetailsLoaded) {
            final appUser = state.appUser;
            final user = appUser.user;
            final employee = appUser.employee;
            final doctor = appUser.doctor;

            if (employee == null || doctor == null) {
              return Center(
                child: Text(
                  "No doctor records associated with this profile.",
                  style: AppTextStyles.bodyMedium.copyWith(color: textColor),
                ),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  // Hero Card
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 100.r,
                          height: 100.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.secondary, width: 3),
                          ),
                          child: CustomImageView(
                            imagePath: ProfileImageHelper.resolveImagePath(
                              doctor.profilePhoto ?? user.profilePhoto,
                              'doctor',
                              user.gender,
                            ),
                            borderRadius: 50.r,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          user.fullName.trim(),
                          style: AppTextStyles.titleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          user.email ?? '',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary(context),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            "DOCTOR - ACTIVE CLINICAL STAFF",
                            style: TextStyle(
                              color: AppColors.secondary,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Child components
                  EmployeePersonalCard(user: user, employee: employee),
                  SizedBox(height: 16.h),
                  DoctorLicenseCard(doctor: doctor),
                  SizedBox(height: 16.h),
                  DoctorFeeScheduleCard(doctor: doctor),
                  SizedBox(height: 16.h),
                  DoctorBiographyCard(doctor: doctor),
                  SizedBox(height: 24.h),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
