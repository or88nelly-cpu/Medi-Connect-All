import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';

/// "Your Health, Our Priority" promotional banner shown at the
/// bottom of the patient home page.
class PatientPromoFooter extends StatelessWidget {
  const PatientPromoFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: AppColors.isDark(context)
              ? const [Color(0xFF0D1B38), Color(0xFF10192C)]
              : const [Color(0xFFEEF3FF), Color(0xFFF5EDFF)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: AppColors.isDark(context)
              ? const Color(0xFF26324D)
              : const Color(0xFFDDE5FF),
        ),
      ),
      child: Row(
        children: [
          // Left decorative icon stack
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 52.r,
                height: 52.r,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A8CFF).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.family_restroom_rounded,
                  color: const Color(0xFF1A8CFF),
                  size: 28.r,
                ),
              ),
              Positioned(
                bottom: -4,
                right: -4,
                child: Container(
                  width: 22.r,
                  height: 22.r,
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E).withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.isDark(context)
                          ? const Color(0xFF10192C)
                          : Colors.white,
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.check_circle_rounded,
                    color: const Color(0xFF22C55E),
                    size: 14.r,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 16.w),

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Your Health, Our Priority',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Quality care, anytime anywhere.',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppColors.textSecondary(context),
                  ),
                ),
                SizedBox(height: 6.h),
                // Small decorative heartbeat line
                CustomPaint(
                  size: Size(80.w, 14.h),
                  painter: _HeartbeatPainter(
                    color: AppColors.primary.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 12.w),

          // Right decorative icons
          Column(
            children: [
              Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  color: const Color(0xFF4F2DFF).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.local_hospital_rounded,
                  color: AppColors.primary,
                  size: 20.r,
                ),
              ),
              SizedBox(height: 6.h),
              Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  color: const Color(0xFF1A8CFF).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.shield_rounded,
                  color: const Color(0xFF1A8CFF),
                  size: 20.r,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeartbeatPainter extends CustomPainter {
  final Color color;
  const _HeartbeatPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final h = size.height;
    final w = size.width;

    path.moveTo(0, h * 0.5);
    path.lineTo(w * 0.15, h * 0.5);
    path.lineTo(w * 0.25, h * 0.1);
    path.lineTo(w * 0.35, h * 0.9);
    path.lineTo(w * 0.45, h * 0.3);
    path.lineTo(w * 0.55, h * 0.5);
    path.lineTo(w, h * 0.5);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_HeartbeatPainter old) => old.color != color;
}
