import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';

class DoctorStatsRow extends StatelessWidget {
  final UserModel user;
  const DoctorStatsRow({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;
    final valueColor = isDark ? AppColors.terminalAccentCyan : AppColors.primary;
    final borderColor = isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder;

    final expString = user.experience != null ? "${user.experience}+" : "12+";
    final qualString = user.qualification ?? "MBBS, MD (Cardiology)";
    final specString = user.specialization ?? "Cardiology";

    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: borderColor),
          bottom: BorderSide(color: borderColor),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;

          if (isWide) {
            return Row(
              children: [
                Expanded(child: _buildStatItem(expString, "Years Experience", valueColor, labelColor)),
                _buildDivider(borderColor),
                Expanded(child: _buildStatItem(qualString, "Qualification", valueColor, labelColor)),
                _buildDivider(borderColor),
                Expanded(child: _buildStatItem(specString, "Specialization", valueColor, labelColor)),
                _buildDivider(borderColor),
                Expanded(child: _buildRatingItem("4.8", "128", labelColor)),
              ],
            );
          } else {
            return Wrap(
              spacing: 8.w,
              runSpacing: 16.h,
              alignment: WrapAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: (constraints.maxWidth - 20.w) / 2,
                  child: _buildStatItem(expString, "Years Experience", valueColor, labelColor),
                ),
                SizedBox(
                  width: (constraints.maxWidth - 20.w) / 2,
                  child: _buildStatItem(qualString, "Qualification", valueColor, labelColor),
                ),
                SizedBox(
                  width: (constraints.maxWidth - 20.w) / 2,
                  child: _buildStatItem(specString, "Specialization", valueColor, labelColor),
                ),
                SizedBox(
                  width: (constraints.maxWidth - 20.w) / 2,
                  child: _buildRatingItem("4.8", "128", labelColor),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildDivider(Color color) {
    return Container(
      width: 1.w,
      height: 32.h,
      color: color,
    );
  }

  Widget _buildStatItem(String value, String label, Color valueColor, Color labelColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontWeight: FontWeight.bold,
            fontSize: 15.sp,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            color: labelColor,
            fontSize: 11.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRatingItem(String rating, String reviewCount, Color labelColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.star,
              color: Colors.amber,
              size: 16.sp,
            ),
            SizedBox(width: 4.w),
            Text(
              rating,
              style: TextStyle(
                color: Colors.amber,
                fontWeight: FontWeight.bold,
                fontSize: 15.sp,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              "($reviewCount)",
              style: TextStyle(
                color: labelColor,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
        Text(
          "Patient Rating",
          style: TextStyle(
            color: labelColor,
            fontSize: 11.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
