import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class SpecialityDoctorListItem extends StatelessWidget {
  final Map<String, dynamic> doctor;
  final Color iconColor;

  const SpecialityDoctorListItem({
    super.key,
    required this.doctor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final emp = doctor['employees'] as Map<String, dynamic>?;
    final user = emp?['users'] as Map<String, dynamic>?;
    final firstName = (user?['first_name'] as String? ?? '').trim();
    final lastName = (user?['last_name'] as String? ?? '').trim();
    final name = [firstName, lastName].where((s) => s.isNotEmpty).join(' ');
    final photo = user?['profile_photo'] as String?;
    final qualification = doctor['qualification'] as String?;
    final expYears = doctor['experience_years'] as int? ?? 0;
    final fee = (doctor['consultation_fee'] as num?)?.toDouble() ?? 0;
    final isAvailable = doctor['is_available'] as bool? ?? false;

    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE5E7EB),
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 26.r,
          backgroundColor: iconColor.withValues(alpha: 0.1),
          backgroundImage: photo != null && photo.isNotEmpty
              ? NetworkImage(photo)
              : null,
          child: photo == null || photo.isEmpty
              ? Text(
                  name.isNotEmpty ? name[0].toUpperCase() : 'D',
                  style: TextStyle(
                    color: iconColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                )
              : null,
        ),
        title: Text(
          name.isNotEmpty ? 'Dr. $name' : 'Unknown Doctor',
          style: AppTextStyles.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary(context),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4.h),
            Text(
              [
                if (qualification != null && qualification.isNotEmpty)
                  qualification,
                if (expYears > 0) '$expYears yrs experience',
              ].join(' • '),
              style: AppTextStyles.labelSmall.copyWith(
                color: AppColors.textSecondary(context),
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              'Consultation Fee: ₹${fee.toStringAsFixed(0)}',
              style: AppTextStyles.labelSmall.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: isAvailable
                ? Colors.green.withValues(alpha: 0.12)
                : Colors.orange.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            isAvailable ? 'Available' : 'Busy',
            style: AppTextStyles.labelSmall.copyWith(
              color: isAvailable ? Colors.green : Colors.orange,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
