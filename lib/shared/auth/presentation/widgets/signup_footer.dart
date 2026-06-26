import 'package:medi_connect/core/routes/route_names.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class SignUpFooter extends StatelessWidget {
  const SignUpFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 10.r),
        Row(
          children: [
            Expanded(child: Divider(color: AppColors.border(context))),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                AppStrings.orDivider,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary(context),
                ),
              ),
            ),
            Expanded(child: Divider(color: AppColors.border(context))),
          ],
        ),
        SizedBox(height: 10.r),
        GestureDetector(
          onTap: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go(RouteNames.login);
            }
          },
          child: RichText(
            text: TextSpan(
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary(context),
              ),
              children: [
                const TextSpan(text: AppStrings.alreadyHaveAccount),
                TextSpan(
                  text: AppStrings.login,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
