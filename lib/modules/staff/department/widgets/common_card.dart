import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class CommonCard extends StatelessWidget {
  final String title;
  final Color color;
  final String subTitle;
  final IconData icon;
  const CommonCard({
    super.key,
    required this.title,
    required this.color,
    required this.subTitle,
    required this.icon,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 165.w,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withAlpha(38), const Color(0xff07112D)],
        ),
        border: Border.all(color: color.withAlpha(80), width: 1.5),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: color.withAlpha(40),
            blurRadius: 25,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 62.r,
            width: 62.r,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(colors: [color, color.withAlpha(185)]),
              boxShadow: [
                BoxShadow(color: color.withAlpha(102), blurRadius: 20),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 28.r),
          ),

          Text(
            title,
            style: AppTextStyles.titleMedium.copyWith(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            subTitle,
            style: AppTextStyles.bodySmall.copyWith(
              color: Colors.white.withAlpha(150),
              fontSize: 10.sp,
              height: 1.5,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 46.r,
              width: 46.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.accent),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: color,
                size: 18.r,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
