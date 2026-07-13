import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/buttons/animated_gradient_button.dart';

class PatientActionCard extends StatefulWidget {
  final String title;
  final String description;
  final String buttonText;
  final String status;

  final IconData icon;

  final Color startColor;
  final Color endColor;

  final String? amount;

  final Widget? illustration;

  final VoidCallback onPressed;

  const PatientActionCard({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.status,
    required this.icon,
    required this.startColor,
    required this.endColor,
    required this.onPressed,
    this.amount,
    this.illustration,
  });

  @override
  State<PatientActionCard> createState() => _PatientActionCardState();
}

class _PatientActionCardState extends State<PatientActionCard>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;

  @override
  void initState() {
    super.initState();

    // _floatingController = AnimationController(
    //   vsync: this,
    //   duration: const Duration(seconds: 3),
    // )..repeat(reverse: true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? .98 : 1,
        duration: const Duration(milliseconds: 120),
        child: Container(
          height: 200.h,
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                widget.startColor.withValues(alpha: .10),
                widget.endColor.withValues(alpha: .03),
              ],
            ),
            border: Border.all(color: widget.startColor.withValues(alpha: .18)),
            boxShadow: [
              BoxShadow(
                color: widget.startColor.withValues(alpha: .12),
                blurRadius: 30,
                spreadRadius: 1,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: Stack(
            children: [
              /// Background Glow
              Positioned(
                right: -15.w,
                top: 30.r,
                child: Container(
                  width: 70.r,
                  height: 70.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.startColor.withValues(alpha: .05),
                  ),
                ),
              ),

              Positioned(
                left: -12.5.w,
                bottom: -15.h,
                child: Container(
                  width: 45.r,
                  height: 45.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: widget.startColor.withValues(alpha: .04),
                  ),
                ),
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Top
                  Row(
                    children: [
                      Container(
                        width: 27.r,
                        height: 27.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.surface.withValues(alpha: .8),
                          boxShadow: [
                            BoxShadow(
                              color: widget.startColor.withValues(alpha: .15),
                              blurRadius: 18,
                            ),
                          ],
                        ),
                        child: Icon(
                          widget.icon,
                          color: widget.startColor,
                          size: 14.r,
                        ),
                      ),

                      const Spacer(),

                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7.w,
                          vertical: 3.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: widget.startColor.withValues(alpha: .10),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 4.r,
                              height: 4.r,
                              decoration: BoxDecoration(
                                color: widget.startColor,
                                shape: BoxShape.circle,
                              ),
                            ),

                            SizedBox(width: 4.w),

                            Text(
                              widget.status,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: widget.startColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 6.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  Text(
                    widget.title,
                    style: AppTextStyles.headingSmall.copyWith(
                      fontWeight: FontWeight.w900,
                      fontSize: 12.sp,
                      color: isDark ? AppColors.surface : const Color(0xff1C2333),
                    ),
                  ),

                  SizedBox(height: 4.h),

                  Text(
                    widget.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: Colors.grey.shade700,
                      height: 1.45,
                      fontSize: 7.sp,
                    ),
                  ),

                  SizedBox(height: 8.h),

                  if (widget.illustration != null)
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: widget.illustration!,
                      ),
                    ),

                  // Illustration / Amount Panel
                  const Spacer(),

                  AnimatedGradientButton(
                    text: widget.buttonText,
                    height: 36.h,

                    startColor: widget.startColor,
                    endColor: widget.endColor,
                    onPressed: widget.onPressed,
                  ),

                  SizedBox(height: 4.h),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
