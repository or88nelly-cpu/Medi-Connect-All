import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/functions/profile_image_helper.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/features/doctor/opinfo/domain/entities/op_procedure_entity.dart';
import 'package:medi_connect/features/doctor/opinfo/presentation/widgets/op_info_status_badge.dart';

class OpInfoAppointmentItem extends StatelessWidget {
  final OpProcedureEntity procedure;
  final VoidCallback? onTap;

  const OpInfoAppointmentItem({super.key, required this.procedure, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isBlocked = procedure.status == 'Blocked' || procedure.patientName == 'System Blocked';

    if (isBlocked) {
      final bg = isDark
          ? const Color(0xFF881337).withValues(alpha: 0.1)
          : const Color(0xFFFFF1F2);
      final border = isDark ? Colors.white10 : const Color(0xFFFDA4AF);
      final textCol = isDark ? Colors.white : AppColors.textDarkNavy;

      return Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: bg,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Row(
          children: [
            Container(
              width: 36.r,
              height: 36.r,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xFFEF4444).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(Icons.block, color: const Color(0xFFEF4444), size: 18.r),
            ),
            SizedBox(width: 10.w),
            // Mock Doctor Unavailable avatar/icon
            Container(
              width: 40.r,
              height: 40.r,
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFCA5A5)),
              ),
              child: Icon(Icons.lock, color: const Color(0xFFEF4444), size: 18.r),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "DOCTOR UNAVAILABLE",
                    style: TextStyle(
                      color: const Color(0xFFEF4444),
                      fontSize: 8.5.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Slot blocked by Doctor",
                    style: TextStyle(
                      color: textCol,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "Doctor is not available at this time.",
                    style: TextStyle(
                      color: isDark ? Colors.white60 : Colors.grey[500],
                      fontSize: 9.sp,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  procedure.appointmentTime,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: textCol,
                  ),
                ),
                SizedBox(height: 4.h),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCA5A5).withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: Text(
                    "Blocked",
                    style: TextStyle(
                      color: const Color(0xFFB91C1C),
                      fontSize: 9.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.lightShadow,
              blurRadius: 6.r,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36.r,
              height: 36.r,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.infoPurple.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Text(
                procedure.tokenNumber.toString(),
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.infoPurple,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            ClipOval(
              child: CustomImageView(
                imagePath: ProfileImageHelper.resolveImagePath(
                  procedure.profilePhoto,
                  'patient',
                  procedure.gender,
                ),
                width: 40.r,
                height: 40.r,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    procedure.patientName,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  Text(
                    procedure.patientId.length > 8
                        ? 'PAT-${procedure.patientId.substring(0, 8).toUpperCase()}'
                        : procedure.patientId,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                  Text(
                    '${AppStrings.ageLabel}: ${procedure.age} • ${procedure.gender}',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  procedure.appointmentTime,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                SizedBox(height: 4.h),
                OpInfoStatusBadge(status: procedure.status),
              ],
            ),
            SizedBox(width: 4.w),
            Icon(
              Icons.chevron_right,
              color: AppColors.textSecondary(context),
              size: 20.r,
            ),
          ],
        ),
      ),
    );
  }
}
