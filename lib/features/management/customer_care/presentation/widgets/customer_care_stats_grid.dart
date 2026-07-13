import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class CustomerCareStatsGrid extends StatelessWidget {
  final Map<String, dynamic> stats;

  const CustomerCareStatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    int crossAxisCount = 4;
    if (width < 600) {
      crossAxisCount = 1;
    } else if (width < 1100) {
      crossAxisCount = 2;
    }

    final double childAspectRatio = width < 600
        ? 2.5
        : (width < 1100 ? 1.8 : 1.6);

    final statsItems = [
      _StatItem(
        title: AppStrings.totalRegistrations,
        value: stats['total_registrations']?.toString() ?? "1,245",
        trend:
            stats['total_registrations_trend']?.toString() ??
            "↑ 18.2% vs last 17 days",
        icon: Icons.people_alt_rounded,
        color: const Color(0xFF0F6FFF),
        lineData: [0.3, 0.45, 0.38, 0.6, 0.72, 0.85, 0.95],
      ),
      _StatItem(
        title: AppStrings.totalAppointments,
        value: stats['total_appointments']?.toString() ?? "986",
        trend:
            stats['total_appointments_trend']?.toString() ??
            "↑ 14.7% vs last 17 days",
        icon: Icons.calendar_today_rounded,
        color: const Color(0xFF7B61FF),
        lineData: [0.2, 0.3, 0.5, 0.45, 0.62, 0.75, 0.88],
      ),
      _StatItem(
        title: AppStrings.totalAdmissions,
        value: stats['total_admissions']?.toString() ?? "156",
        trend:
            stats['total_admissions_trend']?.toString() ??
            "↑ 9.5% vs last 17 days",
        icon: Icons.hotel_rounded,
        color: const Color(0xFF22C55E),
        lineData: [0.15, 0.25, 0.42, 0.38, 0.5, 0.65, 0.78],
      ),
      _StatItem(
        title: AppStrings.feedbackScore,
        value: "${stats['feedback_score']?.toString() ?? '4.7'} / 5",
        trend:
            stats['feedback_score_trend']?.toString() ??
            "↑ 0.4 vs last 17 days",
        icon: Icons.star_rounded,
        color: const Color(0xFFFF8A26),
        lineData: [0.5, 0.62, 0.58, 0.7, 0.8, 0.75, 0.9],
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: statsItems.length,
      itemBuilder: (context, index) {
        final item = statsItems[index];
        return _buildStatCard(context, item);
      },
    );
  }

  Widget _buildStatCard(BuildContext context, _StatItem item) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final widgetBg = AppColors.dashboardCardBg(context);
    final borderColor = AppColors.dashboardCardBorder(context);
    final textColor = AppColors.dashboardTextPrimary(context);
    final labelColor = AppColors.dashboardTextSecondary(context);

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: widgetBg,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.15)
                : Colors.black.withValues(alpha: 0.02),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Top Icon and label row
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: BoxDecoration(
                        color: item.color.withValues(
                          alpha: isDark ? 0.15 : 0.08,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(item.icon, color: item.color, size: 20.r),
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: Text(
                        item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: labelColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                // Stat Value
                Text(
                  item.value,
                  style: AppTextStyles.dashboardCardValue.copyWith(
                    color: textColor,
                    fontSize: 22.sp,
                    height: 1,
                  ),
                ),
                SizedBox(height: 6.h),
                // Trend marker
                Text(
                  item.trend,
                  style: AppTextStyles.bodyXSmall.copyWith(
                    color: const Color(0xFF22C55E),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          // Chart section
          Expanded(
            flex: 4,
            child: Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                width: 80.w,
                height: 50.h,
                child: CustomPaint(
                  painter: _MiniChartPainter(
                    color: item.color,
                    dataPoints: item.lineData,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem {
  final String title;
  final String value;
  final String trend;
  final IconData icon;
  final Color color;
  final List<double> lineData;

  _StatItem({
    required this.title,
    required this.value,
    required this.trend,
    required this.icon,
    required this.color,
    required this.lineData,
  });
}

class _MiniChartPainter extends CustomPainter {
  final Color color;
  final List<double> dataPoints;

  _MiniChartPainter({required this.color, required this.dataPoints});

  @override
  void paint(Canvas canvas, Size size) {
    if (dataPoints.isEmpty) return;

    final pathPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [color.withValues(alpha: 0.25), color.withValues(alpha: 0.0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final double stepX = size.width / (dataPoints.length - 1);
    final List<Offset> points = [];

    for (int i = 0; i < dataPoints.length; i++) {
      final double x = i * stepX;
      // Invert Y because canvas draws down
      final double y = size.height - (dataPoints[i] * size.height * 0.7) - 4;
      points.add(Offset(x, y));
    }

    final path = Path()..moveTo(points.first.dx, points.first.dy);

    for (int i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final current = points[i];
      path.cubicTo(
        prev.dx + (current.dx - prev.dx) / 2,
        prev.dy,
        prev.dx + (current.dx - prev.dx) / 2,
        current.dy,
        current.dx,
        current.dy,
      );
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, pathPaint);
  }

  @override
  bool shouldRepaint(covariant _MiniChartPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.dataPoints != dataPoints;
  }
}
