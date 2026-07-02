import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/modules/patient/speciality/presentation/bloc/speciality_bloc.dart';
import 'package:medi_connect/modules/patient/speciality/presentation/widgets/speciality_horizontal_list.dart';

class PatientSpecialitiesSection extends StatefulWidget {
  const PatientSpecialitiesSection({super.key});

  @override
  State<PatientSpecialitiesSection> createState() => _PatientSpecialitiesSectionState();
}

class _PatientSpecialitiesSectionState extends State<PatientSpecialitiesSection> {
  final ValueNotifier<String> _searchQuery = ValueNotifier<String>('');

  @override
  void initState() {
    super.initState();
    context.read<SpecialityBloc>().add(LoadSpecialities());
  }

  @override
  void dispose() {
    _searchQuery.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Input
          Container(
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10.r,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              onChanged: (val) => _searchQuery.value = val,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: "Search Medical Specialties...",
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary(context),
                ),
                prefixIcon: const Icon(Icons.search, color: AppColors.primary),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.send_rounded, color: AppColors.primary),
                  onPressed: () {
                    context.push('/specialities', extra: _searchQuery.value);
                  },
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 14.h),
              ),
            ),
          ),
          SizedBox(height: 12.h),

          // Horizontal List builder
          BlocBuilder<SpecialityBloc, SpecialityState>(
            builder: (context, state) {
              if (state is SpecialityLoading || state is SpecialityInitial) {
                return Container(
                  height: 100.h,
                  alignment: Alignment.center,
                  child: const CircularProgressIndicator(),
                );
              }

              if (state is SpecialityError) {
                return Container(
                  height: 90.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.terminalDarkCard : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Failed to load specialties",
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      TextButton(
                        onPressed: () {
                          context.read<SpecialityBloc>().add(LoadSpecialities());
                        },
                        child: Text(
                          "Retry",
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              final list = state is SpecialitiesLoaded
                  ? state.specialities
                  : (state is SpecialityActionSuccess ? state.updatedList : []);

              return ValueListenableBuilder<String>(
                valueListenable: _searchQuery,
                builder: (context, query, _) {
                  final filteredList = list.where((item) {
                    return item.name.toLowerCase().contains(query.toLowerCase());
                  }).toList();

                  return SpecialityHorizontalList(
                    specialities: filteredList.cast(),
                    title: "Medical Specialties",
                    isAdmin: false,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
