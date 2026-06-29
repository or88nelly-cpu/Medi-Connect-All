import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/appointments/complete_consultation/complete_consultation_cubit.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/appointments/complete_consultation/consultation_section_header.dart';

class LabTestsSection extends StatelessWidget {
  final TextEditingController labNotesCtrl;

  const LabTestsSection({super.key, required this.labNotesCtrl});

  static const List<String> _availableTests = [
    'CBC (Blood Count)',
    'Blood Sugar (Fasting)',
    'Blood Sugar (PP)',
    'Lipid Profile',
    'HbA1c',
    'Thyroid Panel (T3/T4/TSH)',
    'Kidney Function Test',
    'Liver Function Test',
    'Urine Routine',
    'X-Ray Chest',
    'ECG',
    'Ultrasound Abdomen',
    'MRI Brain',
    'CT Scan',
    'Echocardiography',
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.watch<CompleteConsultationCubit>();
    final state = cubit.state;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ConsultationSectionHeader(
          icon: Icons.science_outlined,
          title: 'B. Lab Tests / Scanning',
          subtitle: 'Schedule investigations',
          color: AppColors.secondary,
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 6.h,
          children: _availableTests.map((test) {
            final isSelected = state.selectedTests.contains(test);
            return FilterChip(
              label: Text(
                test,
                style: AppTextStyles.bodySmall.copyWith(
                  color: isSelected
                      ? AppColors.secondary
                      : (AppColors.textPrimary(context)),
                ),
              ),
              selected: isSelected,
              onSelected: (val) {
                cubit.toggleLabTest(test);
              },
              selectedColor: AppColors.secondary.withValues(alpha: 0.15),
              checkmarkColor: AppColors.secondary,
              backgroundColor: isDark
                  ? AppColors.terminalDarkBg
                  : Colors.grey[100],
              side: BorderSide(
                color: isSelected
                    ? AppColors.secondary
                    : (AppColors.border(context)),
              ),
            );
          }).toList(),
        ),
        SizedBox(height: 12.h),
        OutlinedButton.icon(
          onPressed: () {
            final textCtrl = TextEditingController();
            showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                backgroundColor: isDark
                    ? AppColors.terminalDarkCard
                    : Colors.white,
                title: Text(
                  'Add Custom Lab Test',
                  style: TextStyle(
                    color: isDark
                        ? Colors.white
                        : AppColors.textPrimary(context),
                  ),
                ),
                content: TextField(
                  controller: textCtrl,
                  autofocus: true,
                  style: TextStyle(
                    color: isDark
                        ? Colors.white
                        : AppColors.textPrimary(context),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Enter test name (e.g. Urine Culture)',
                    hintStyle: TextStyle(
                      color: isDark
                          ? Colors.white38
                          : AppColors.textSecondary(context),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      if (textCtrl.text.trim().isNotEmpty) {
                        cubit.addCustomLabTest(textCtrl.text.trim());
                      }
                      Navigator.pop(ctx);
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            );
          },
          icon: Icon(Icons.add, size: 16.r, color: AppColors.secondary),
          label: Text(
            'Add Custom Test',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: AppColors.secondary),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
          ),
        ),
        SizedBox(height: 12.h),
        TextField(
          controller: labNotesCtrl,
          maxLines: 2,
          style: AppTextStyles.bodyMedium.copyWith(
            color: isDark ? Colors.white : AppColors.textPrimary(context),
          ),
          decoration: InputDecoration(
            hintText: 'Special instructions for lab...',
            hintStyle: AppTextStyles.bodySmall.copyWith(
              color: isDark ? Colors.white38 : AppColors.textSecondary(context),
            ),
            filled: true,
            fillColor: isDark ? AppColors.terminalDarkBg : Colors.grey[50],
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 10.h,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.border(context)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: const BorderSide(
                color: AppColors.primary,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
