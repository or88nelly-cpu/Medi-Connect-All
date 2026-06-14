import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/features/department/presentation/bloc/doctor_staff_state.dart';
import 'booking_wizard_cubit.dart';

class DoctorStep extends StatelessWidget {
  const DoctorStep({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.watch<BookingWizardCubit>();
    final state = cubit.state;

    if (state.selectedSection == null) {
      return Center(
        child: Text(
          "Please select a specialty section first.",
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDark ? Colors.white54 : AppColors.textSecondary,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: Text(
            "Select Doctor",
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
        ),
        Expanded(
          child: BlocBuilder<DoctorStaffBloc, DoctorStaffState>(
            builder: (context, staffState) {
              if (staffState is DoctorStaffLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (staffState is DoctorStaffError) {
                return Center(
                  child: Text(
                    "Error loading doctors: ${staffState.message}",
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                );
              }
              if (staffState is DoctorStaffLoaded) {
                final list = staffState.doctors;

                if (list.isEmpty) {
                  return Center(
                    child: Text(
                      "No doctors configured in ${state.selectedSection!.name}.",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isDark ? Colors.white54 : AppColors.textSecondary,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, idx) {
                    final doc = list[idx];
                    final isSelected = state.selectedDoctor?.id == doc.id;
                    final nameStr = doc.name ??
                        "${doc.firstName ?? ''} ${doc.lastName ?? ''}".trim();
                    final avatarUrl = doc.profileImage ??
                        "https://i.pravatar.cc/150?u=${doc.id}";

                    return Container(
                      margin: EdgeInsets.only(bottom: 8.h),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary.withOpacity(0.08)
                            : (isDark
                                ? AppColors.terminalDarkBg
                                : Colors.grey[50]),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : (isDark
                                  ? AppColors.terminalDarkBorder
                                  : AppColors.border),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: ListTile(
                        dense: true,
                        leading: Container(
                          width: 40.r,
                          height: 40.r,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20.r),
                            child: CustomImageView(
                              imagePath: avatarUrl,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: Text(
                          nameStr,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppColors.textPrimary,
                          ),
                        ),
                        subtitle: Text(
                          "${doc.specialization ?? 'General Specialist'}  |  Fee: ₹${doc.consultationFee ?? 500}",
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isDark ? Colors.white70 : AppColors.textSecondary,
                          ),
                        ),
                        trailing: isSelected
                            ? const Icon(Icons.check_circle, color: AppColors.primary)
                            : null,
                        onTap: () {
                          cubit.selectDoctor(doc);
                          cubit.setStep(3); // Navigate automatically to step 3 (Slots)
                        },
                      ),
                    );
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }
}
