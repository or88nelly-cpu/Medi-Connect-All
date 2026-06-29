import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class CustomerCareActionsGrid extends StatelessWidget {
  final Function(String)? onActionClick;

  const CustomerCareActionsGrid({super.key, this.onActionClick});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    int crossAxisCount = 6;
    if (width < 600) {
      crossAxisCount = 2;
    } else if (width < 1100) {
      crossAxisCount = 3;
    }

    final double childAspectRatio = width < 600
        ? 0.95
        : (width < 1100 ? 0.95 : 0.85);

    final actions = [
      _ActionItem(
        title: AppStrings.register,
        description: AppStrings.registrationDesc,
        icon: Icons.person_add_alt_1_rounded,
        gradient: AppColors.registrationGradient,
      ),
      _ActionItem(
        title: AppStrings.qrRegistration,
        description: AppStrings.qrRegistrationDesc,
        icon: Icons.qr_code_2_rounded,
        gradient: AppColors.qrRegistrationGradient,
      ),
      _ActionItem(
        title: AppStrings.appointment,
        description: AppStrings.appointmentDesc,
        icon: Icons.edit_calendar_rounded,
        gradient: AppColors.appointmentGradient,
      ),
      _ActionItem(
        title: AppStrings.patientSearch,
        description: AppStrings.patientSearchDesc,
        icon: Icons.person_search_rounded,
        gradient: AppColors.patientSearchGradient,
      ),
      _ActionItem(
        title: AppStrings.admission,
        description: AppStrings.admissionDesc,
        icon: Icons.hotel_rounded,
        gradient: AppColors.admissionGradient,
      ),
      _ActionItem(
        title: AppStrings.feedback,
        description: AppStrings.feedbackDesc,
        icon: Icons.rate_review_rounded,
        gradient: AppColors.feedbackGradient,
      ),
      _ActionItem(
        title: "Consultation",
        description: "View completed consultations (EMR)",
        icon: Icons.assignment_rounded,
        gradient: AppColors.greenGradient,
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 14.w,
        mainAxisSpacing: 14.h,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final action = actions[index];
        return _buildActionCard(context, action);
      },
    );
  }

  Widget _buildActionCard(BuildContext context, _ActionItem action) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () {
        onActionClick?.call(action.title);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Clicking Action: ${action.title}')),
        );
      },
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        padding: EdgeInsets.all(18.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          gradient: LinearGradient(
            colors: action.gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: action.gradient.last.withValues(
                alpha: isDark ? 0.3 : 0.25,
              ),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon in a semi-transparent container
            Container(
              padding: EdgeInsets.all(10.r),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Icon(action.icon, color: Colors.white, size: 26.r),
            ),
            const Spacer(),
            // Title
            Text(
              action.title,
              style: AppTextStyles.dashboardActionTitle.copyWith(
                color: Colors.white,
                fontSize: 15.sp,
              ),
            ),
            SizedBox(height: 4.h),
            // Description
            Text(
              action.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.dashboardActionDesc.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 11.sp,
                height: 1.25,
              ),
            ),
            SizedBox(height: 12.h),
            // Bottom Action Arrow Button
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: action.gradient.last,
                    size: 14.r,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionItem {
  final String title;
  final String description;
  final IconData icon;
  final List<Color> gradient;

  _ActionItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.gradient,
  });
}
