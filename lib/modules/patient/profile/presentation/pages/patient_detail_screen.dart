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

// Child components
import 'package:medi_connect/modules/patient/profile/presentation/widgets/patient_personal_info_card.dart';
import 'package:medi_connect/modules/patient/profile/presentation/widgets/patient_medical_info_card.dart';
import 'package:medi_connect/modules/patient/profile/presentation/widgets/patient_insurance_info_card.dart';
import 'package:medi_connect/modules/patient/profile/presentation/widgets/patient_guardian_info_card.dart';

class PatientDetailScreen extends StatefulWidget {
  final String userId;

  const PatientDetailScreen({super.key, required this.userId});

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
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
      customAppbar: const CommonAppBar(title: "Patient File Details"),
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
            final patient = appUser.patient;

            if (patient == null) {
              return Center(
                child: Text(
                  "No patient records associated with this profile.",
                  style: AppTextStyles.bodyMedium.copyWith(color: textColor),
                ),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  // Hero Header card
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 100.r,
                          height: 100.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.primary, width: 3),
                          ),
                          child: CustomImageView(
                            imagePath: ProfileImageHelper.resolveImagePath(
                              user.profilePhoto,
                              'patient',
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
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            "PATIENT FILE ACTIVE",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Detail widgets in separate files
                  PatientPersonalInfoCard(user: user, patient: patient),
                  SizedBox(height: 16.h),
                  PatientMedicalInfoCard(patient: patient),
                  SizedBox(height: 16.h),
                  PatientGuardianInfoCard(patient: patient),
                  SizedBox(height: 16.h),
                  PatientInsuranceInfoCard(patient: patient),
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
