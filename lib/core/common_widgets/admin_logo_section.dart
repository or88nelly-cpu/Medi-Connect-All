import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/utils/constants/app_assets.dart';

class AdminLogoSection extends StatelessWidget {
  final double? size;
  final double? padding;
  final Color? bgColor;
  final String? imagePath;
  final bool decorationNeeded;
  const AdminLogoSection({
    super.key,
    this.size,
    this.padding,
    this.bgColor,
    this.imagePath,
    this.decorationNeeded = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size ?? 90.r,
      width: size ?? 90.r,
      decoration: decorationNeeded
          ? BoxDecoration(
              color: bgColor ?? AppColors.background(context),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  blurRadius: 20.r,
                  color: AppColors.textDarkNavy,
                  offset: Offset(0, 10),
                ),
              ],
            )
          : null,
      child: Padding(
        padding: EdgeInsets.all(padding ?? 16.r),
        child: CustomImageView(imagePath: imagePath ?? AppAssets.logoIconPng),
      ),
    );
  }
}
