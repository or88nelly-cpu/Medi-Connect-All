import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/core/widgets/appbar/common_app_bar.dart';
import 'package:medi_connect/modules/patient/speciality/domain/entities/speciality_entity.dart';
import 'package:medi_connect/modules/patient/booking/presentation/bloc/speciality_booking_cubit.dart';
import 'package:medi_connect/modules/patient/booking/presentation/bloc/speciality_booking_state.dart';
import 'package:medi_connect/modules/patient/booking/presentation/pages/doctor_detail_booking_page.dart';

class SpecialityDoctorsPage extends StatelessWidget {
  final SpecialityEntity speciality;

  const SpecialityDoctorsPage({super.key, required this.speciality});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;

    // Harmonious gradient based on specialty details
    final gradientColors = speciality.isSurgical
        ? [const Color(0xFFEF4444), const Color(0xFFB91C1C)]
        : [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)];

    return BlocProvider(
      create: (context) =>
          SpecialityBookingCubit()..loadDoctors(speciality.id, speciality.name),
      child: Builder(
        builder: (context) {
          return CustomScaffold(
            customAppbar: CommonAppBar(title: "${speciality.name} Doctors"),
            body: BlocBuilder<SpecialityBookingCubit, SpecialityBookingState>(
              builder: (context, state) {
                if (state.status == SpecialityBookingStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state.status == SpecialityBookingStatus.error) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.r),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline_rounded,
                            color: AppColors.error,
                            size: 48.r,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            state.errorMessage ?? "An error occurred",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.error,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          TextButton.icon(
                            onPressed: () => context
                                .read<SpecialityBookingCubit>()
                                .loadDoctors(speciality.id, speciality.name),
                            icon: const Icon(Icons.refresh),
                            label: const Text("Retry"),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state.doctors.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(24.r),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline_rounded,
                            color: AppColors.textSecondary(
                              context,
                            ).withValues(alpha: 0.5),
                            size: 64.r,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            "No doctors registered under ${speciality.name} yet.",
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary(context),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(16.r),
                  itemCount: state.doctors.length,
                  itemBuilder: (context, index) {
                    final docInfo = state.doctors[index];
                    final exp =
                        docInfo.doctorInfo?.yearsOfExperience ??
                        docInfo.doctorInfo?.experienceYears ??
                        5;
                    final fee =
                        docInfo.doctorInfo?.consultationFee ??
                        speciality.defaultConsultationFee ??
                        500.0;

                    return Card(
                      margin: EdgeInsets.only(bottom: 16.h),
                      color: cardBg,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                        side: BorderSide(color: AppColors.border(context)),
                      ),
                      child: InkWell(
                        onTap: () {
                          // Select doctor and go to details booking
                          context.read<SpecialityBookingCubit>().selectDoctor(
                            docInfo,
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (ctx) => BlocProvider.value(
                                value: context.read<SpecialityBookingCubit>(),
                                child: DoctorDetailBookingPage(
                                  gradientColors: gradientColors,
                                  specialityName: speciality.name,
                                ),
                              ),
                            ),
                          );
                        },
                        borderRadius: BorderRadius.circular(16.r),
                        child: Padding(
                          padding: EdgeInsets.all(16.r),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 64.r,
                                height: 64.r,
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: CustomImageView(
                                  imagePath: docInfo.user.profilePhoto ?? "",
                                ),
                              ),
                              SizedBox(width: 16.w),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      docInfo.user.fullName,
                                      style: AppTextStyles.titleMedium.copyWith(
                                        color: textColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      docInfo.doctorInfo?.qualification ??
                                          "Specialist MD",
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textSecondary(context),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    Row(
                                      children: [
                                        _MetaBadge(
                                          icon: Icons.work_outline,
                                          label: "$exp Yrs Exp",
                                        ),
                                        SizedBox(width: 8.w),
                                        _MetaBadge(
                                          icon: Icons.payments_outlined,
                                          label: "\$${fee.toStringAsFixed(2)}",
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: AppColors.textSecondary(context),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

class _MetaBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _MetaBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.r, color: AppColors.primary),
          SizedBox(width: 4.w),
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
              fontSize: 10.sp,
            ),
          ),
        ],
      ),
    );
  }
}
