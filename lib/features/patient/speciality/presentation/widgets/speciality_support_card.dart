import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class SpecialitySupportCard extends StatefulWidget {
  final VoidCallback onContact;

  const SpecialitySupportCard({super.key, required this.onContact});

  @override
  State<SpecialitySupportCard> createState() => _SpecialitySupportCardState();
}

class _SpecialitySupportCardState extends State<SpecialitySupportCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  bool _pressed = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedBuilder(
      animation: _controller,
      builder: (_, child) {
        return Transform.translate(
          offset: Offset(0, -4 * _controller.value),
          child: child,
        );
      },
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedScale(
          scale: _pressed ? .98 : 1,
          duration: const Duration(milliseconds: 120),
          child: Container(
            padding: EdgeInsets.all(20.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28.r),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? const [Color(0xff162033), Color(0xff0F172A)]
                    : const [Color(0xffEEF6FF), Color(0xffD8ECFF)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .08),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 78.r,
                  height: 78.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surface.withValues(alpha: .9),
                  ),
                  child: Icon(
                    Icons.support_agent_rounded,
                    size: 40.r,
                    color: AppColors.primary,
                  ),
                ),

                SizedBox(width: 18.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Need Help?",
                        style: AppTextStyles.titleLarge.copyWith(
                          fontWeight: FontWeight.w900,
                          fontSize: 18.sp,
                          color: isDark
                              ? AppColors.surface
                              : const Color(0xff0F172A),
                        ),
                      ),

                      SizedBox(height: 6.h),

                      Text(
                        "Can't find the right speciality?\nOur healthcare team is here to help you choose the right doctor.",
                        style: AppTextStyles.bodySmall.copyWith(
                          fontSize: 11.sp,
                          height: 1.5,
                          color: isDark
                              ? AppColors.surface70
                              : Colors.grey.shade700,
                        ),
                      ),

                      SizedBox(height: 16.h),

                      SizedBox(
                        height: 42.h,
                        child: ElevatedButton(
                          onPressed: widget.onContact,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            elevation: 8,
                            shadowColor: AppColors.primary.withValues(
                              alpha: .35,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.call,
                                color: AppColors.surface,
                                size: 18,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                "Contact Support",
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.surface,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 10.w),

                Icon(
                  Icons.medical_services_rounded,
                  size: 70.r,
                  color: AppColors.primary.withValues(alpha: .12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
