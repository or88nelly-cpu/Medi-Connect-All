import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class StepsInfo extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final String stepTitle;
  const StepsInfo({super.key, required this.currentStep, required this.totalSteps, required this.stepTitle});

  @override
  Widget build(BuildContext context) {
    return Container(child: Column(
      children: [
        Row(
          children: [
            Text("Step $currentStep of $totalSteps", style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              fontSize: 10.sp,
            ),),
            SizedBox(width: 8.w,),
            Text(stepTitle, style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
              fontSize: 10.sp,
            ),),
          ],
        )
      ],
    ));
  }
}
