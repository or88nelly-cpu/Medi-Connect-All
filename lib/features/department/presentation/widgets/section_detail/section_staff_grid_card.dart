import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/utils/profile_image_helper.dart';

class SectionStaffGridCard extends StatelessWidget {
  final UserModel stf;
  final VoidCallback onTap;
  final VoidCallback onView;
  final VoidCallback onEdit;

  const SectionStaffGridCard({
    super.key,
    required this.stf,
    required this.onTap,
    required this.onView,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : AppColors.terminalLightCard;
    final borderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;
    final textColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;

    final status = stf.status;

    return Container(
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor, width: 1.2),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Stack(
          children: [
            // Top Right Options
            Positioned(
              top: 4.r,
              right: 4.r,
              child: PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: labelColor, size: 20.r),
                color: cardBg,
                onSelected: (action) {
                  if (action == 'view') {
                    onView();
                  } else if (action == 'edit') {
                    onEdit();
                  }
                },
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                    value: 'view',
                    child: Text("View Profile", style: TextStyle(color: textColor)),
                  ),
                  PopupMenuItem(
                    value: 'edit',
                    child: Text("Edit Staff", style: TextStyle(color: textColor)),
                  ),
                ],
              ),
            ),
            // Card Content
            Padding(
              padding: EdgeInsets.all(12.r),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 28.r,
                    backgroundColor: isDark ? Colors.white12 : Colors.black12,
                    child: ClipOval(
                      child: CustomImageView(
                        imagePath: ProfileImageHelper.resolveImagePath(
                          stf.profileImage,
                          'staff',
                          stf.gender,
                        ),
                        width: 56.r,
                        height: 56.r,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    stf.name ?? '',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: textColor,
                      fontSize: 13.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 4.h),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      stf.staffRole ?? 'Support Staff',
                      style: TextStyle(
                        color: AppColors.secondary,
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "Shift: Rotational",
                    style: TextStyle(
                      color: labelColor,
                      fontSize: 10.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  _buildStatusPill(status),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusPill(String status) {
    Color dotColor = AppColors.success;
    Color bgPillColor = AppColors.success.withValues(alpha: 0.1);
    String label = "Active";

    if (status.toLowerCase().contains("away")) {
      dotColor = AppColors.accent;
      bgPillColor = AppColors.accent.withValues(alpha: 0.1);
      label = "Away";
    } else if (status.toLowerCase().contains("inactive")) {
      dotColor = AppColors.error;
      bgPillColor = AppColors.error.withValues(alpha: 0.1);
      label = "Inactive";
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: bgPillColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: dotColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 5.r,
            height: 5.r,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              color: dotColor,
              fontSize: 9.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
