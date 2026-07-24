import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_dimensions.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/features/authentication/data/models/user_model.dart';
import 'package:medi_connect/core/constants/app_enum.dart';
import 'package:medi_connect/features/admin/staff_management/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/features/admin/staff_management/presentation/bloc/doctor_staff_event.dart';
import 'package:medi_connect/features/admin/staff_management/presentation/bloc/doctor_staff_state.dart';
import 'package:medi_connect/features/patient/booking/presentation/pages/booking_flow_page.dart';

class DoctorStep extends StatelessWidget {
  final SpecialtyEntry? specialty;
  final UserModel? selected;
  final ValueChanged<UserModel> onSelect;

  const DoctorStep({
    super.key,
    required this.specialty,
    required this.selected,
    required this.onSelect,
  });

  List<UserModel> _filtered(List<UserModel> all) {
    if (specialty == null) {
      return all.where((d) => d.role == UserRole.doctor).toList();
    }
    final res = all.where((d) {
      return d.role == UserRole.doctor;
    }).toList();
    return res.isEmpty ? kFallbackDoctors : res;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            AppDimensions.paddingL,
            AppDimensions.paddingM,
            AppDimensions.paddingL,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose a Doctor',
                style: AppTextStyles.headingSmall.copyWith(
                  color: AppColors.textPrimary(context),
                ),
              ),
              if (specialty != null) ...[
                SizedBox(height: AppDimensions.spaceXS),
                Text(
                  'Showing ${specialty!.name} specialists',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(height: AppDimensions.spaceM),
        Expanded(
          child: BlocBuilder<DoctorStaffBloc, DoctorStaffState>(
            builder: (context, state) {
              final docs =
                  state is DoctorStaffLoaded && state.doctors.isNotEmpty
                  ? _filtered(state.doctors)
                  : kFallbackDoctors;

              if (state is DoctorStaffLoading && docs.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.separated(
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingL,
                  vertical: AppDimensions.paddingXS,
                ),
                itemCount: docs.length,
                separatorBuilder: (context, _) =>
                    SizedBox(height: AppDimensions.spaceS),
                itemBuilder: (context, i) {
                  final doc = docs[i];
                  final isSelected = selected?.id == doc.id;
                  final color = specialty?.gradient.first ?? AppColors.primary;
                  return GestureDetector(
                    onTap: () => onSelect(doc),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.all(AppDimensions.paddingM + 2),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color.withValues(alpha: 0.07)
                            : AppColors.card(context),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusM + 2,
                        ),
                        border: Border.all(
                          color: isSelected ? color : AppColors.border(context),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors:
                                    specialty?.gradient ??
                                    [AppColors.primary, AppColors.secondary],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                          SizedBox(width: AppDimensions.spaceWM),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doc.fullName,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary(context),
                                  ),
                                ),
                                SizedBox(height: AppDimensions.spaceXS),
                                Text(
                                  'General Medicine',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: color,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: AppDimensions.spaceXS),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      color: AppColors.accent,
                                      size: 12,
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                      '4.8',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary(context),
                                      ),
                                    ),
                                    SizedBox(width: AppDimensions.spaceWS),
                                    Text(
                                      '5 yrs · ₹500',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textSecondary(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? color : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? color
                                    : AppColors.border(context),
                                width: 1.5,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 14,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
