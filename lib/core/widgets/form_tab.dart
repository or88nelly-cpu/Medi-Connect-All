import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class FormTab extends StatelessWidget {
  final List<Widget> children;
  final String tilte;
  final String? subTitle;
  const FormTab({
    super.key,
    required this.children,
    required this.tilte,
    this.subTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.background(context),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.textDarkNavy.withValues(alpha: 0.1),
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            tilte,
            style: AppTextStyles.headingMedium.copyWith(
              color: AppColors.textDarkNavy,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subTitle != null) ...[
            SizedBox(height: 4.h),
            Text(
              subTitle!,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary(context),
                fontSize: 12.sp,
              ),
              textAlign: TextAlign.center,
            ),
          ],
          SizedBox(height: 20.r),
          ...children,
        ],
      ),
    );
  }
}
