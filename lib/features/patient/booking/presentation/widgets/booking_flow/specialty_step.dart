import 'package:flutter/material.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_dimensions.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/features/patient/booking/presentation/pages/booking_flow_page.dart';

class SpecialtyStep extends StatelessWidget {
  final SpecialtyEntry? selected;
  final ValueChanged<SpecialtyEntry> onSelect;

  const SpecialtyStep({
    super.key,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.paddingL),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose a Specialty',
            style: AppTextStyles.headingSmall.copyWith(
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(height: AppDimensions.spaceXS),
          Text(
            'Select the type of doctor you want to see',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary(context),
            ),
          ),
          SizedBox(height: AppDimensions.spaceL),
          LayoutBuilder(
            builder: (context, constraints) {
              final cols = constraints.maxWidth > 500 ? 3 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  crossAxisSpacing: AppDimensions.spaceWM,
                  mainAxisSpacing: AppDimensions.spaceM,
                  childAspectRatio: 1.0,
                ),
                itemCount: kSpecialties.length,
                itemBuilder: (context, i) {
                  final sp = kSpecialties[i];
                  final isSelected = selected?.name == sp.name;
                  return GestureDetector(
                    onTap: () => onSelect(sp),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isSelected
                              ? sp.gradient
                              : [
                                  sp.gradient.first.withValues(alpha: 0.12),
                                  sp.gradient.last.withValues(alpha: 0.06),
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusL,
                        ),
                        border: Border.all(
                          color: isSelected
                              ? sp.gradient.first
                              : sp.gradient.first.withValues(alpha: 0.2),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: sp.gradient.first.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(AppDimensions.paddingM),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white.withValues(alpha: 0.25)
                                    : sp.gradient.first.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(
                                  AppDimensions.radiusM,
                                ),
                              ),
                              child: Icon(
                                sp.icon,
                                color: isSelected
                                    ? Colors.white
                                    : sp.gradient.first,
                                size: 22,
                              ),
                            ),
                            SizedBox(height: AppDimensions.spaceS),
                            Text(
                              sp.name,
                              style: TextStyle(
                                fontSize: AppTextStyles.s12,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textPrimary(context),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 3),
                            Text(
                              sp.description,
                              style: TextStyle(
                                fontSize: AppTextStyles.s10 - 1, // 9.sp
                                color: isSelected
                                    ? Colors.white70
                                    : AppColors.textSecondary(context),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (isSelected) ...[
                              SizedBox(height: AppDimensions.spaceXS + 2),
                              Icon(
                                Icons.check_circle_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
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
