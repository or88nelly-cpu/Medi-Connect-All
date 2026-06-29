import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmrdAIAssistantPanel extends StatelessWidget {
  final Map<String, dynamic> stats;
  final bool isDark;

  const EmrdAIAssistantPanel({
    super.key,
    required this.stats,
    required this.isDark,
  });

  Widget _buildAIPill({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
    required bool isDark,
  }) {
    final Color pillBg = isDark ? Colors.white.withValues(alpha: 0.03) : Colors.white;
    final Color iconBg = color.withValues(alpha: 0.12);
    final Color textColor = isDark ? Colors.white : const Color(0xFF1E293B);
    final Color subColor = isDark ? Colors.white38 : const Color(0xFF64748B);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: pillBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey[200]!,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 14.r),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w900,
                    color: textColor,
                    height: 1.1,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 8.5.sp,
                    fontWeight: FontWeight.w600,
                    color: subColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(BuildContext context, String text, bool isDark) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 2.h),
            decoration: const BoxDecoration(
              color: Color(0xFF3B82F6),
              shape: BoxShape.circle,
            ),
            padding: EdgeInsets.all(1.5.r),
            child: Icon(Icons.check, color: Colors.white, size: 9.r),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.bold,
                height: 1.25,
                color: isDark ? Colors.white70 : const Color(0xFF334155),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingSummaries = stats['pending_summaries'] ?? 25;
    final complianceScore = stats['compliance_score'] ?? 92;
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive grid configuration
    final bool useWideLayout = screenWidth > 900;
    final int statsCrossAxisCount = useWideLayout
        ? 5
        : (screenWidth > 600 ? 3 : 2);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF1E1E38), const Color(0xFF13132B)]
              : [
                  const Color(0xFFF3F7FF),
                  const Color(0xFFE8F1FF),
                  Colors.white,
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isDark ? const Color(0xFF312E81) : const Color(0xFFDBEAFE),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 14,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                "AI-Powered MRD Assistant",
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 14.5.sp,
                  color: isDark ? Colors.white : const Color(0xFF1E3A8A),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(5.r),
                ),
                child: Text(
                  "AI-",
                  style: TextStyle(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF3B82F6),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Text(
            "Real-time insights and intelligent recommendations",
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w500,
              color: isDark ? Colors.white54 : const Color(0xFF2563EB),
            ),
          ),
          SizedBox(height: 14.h),

          // Horizontal/Grid Mini Stats Cards
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: statsCrossAxisCount,
            mainAxisSpacing: 8.h,
            crossAxisSpacing: 8.w,
            childAspectRatio: useWideLayout ? 2.4 : 2.7,
            children: [
              _buildAIPill(
                icon: Icons.hourglass_empty_rounded,
                value: "$pendingSummaries",
                label: "Pending Discharge",
                color: const Color(0xFF3B82F6),
                isDark: isDark,
              ),
              _buildAIPill(
                icon: Icons.assignment_late_outlined,
                value: "12",
                label: "Missing Consent Forms",
                color: const Color(0xFFF59E0B),
                isDark: isDark,
              ),
              _buildAIPill(
                icon: Icons.balance_rounded,
                value: "5",
                label: "MLC Cases Pending",
                color: const Color(0xFF8B5CF6),
                isDark: isDark,
              ),
              _buildAIPill(
                icon: Icons.archive_rounded,
                value: "320",
                label: "Records Due for Archive",
                color: const Color(0xFF06B6D4),
                isDark: isDark,
              ),
              _buildAIPill(
                icon: Icons.trending_up_rounded,
                value: "8%",
                label: "NABH Score Improvement",
                color: const Color(0xFF10B981),
                isDark: isDark,
              ),
            ],
          ),
          SizedBox(height: 18.h),

          // 3-Column Actions Section
          LayoutBuilder(
            builder: (context, constraints) {
              final widgets = [
                // 1. MRD Health Score
                _buildCardContainer(
                  isDark: isDark,
                  flexWidth: useWideLayout,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "MRD Health Score",
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white70
                                  : const Color(0xFF475569),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          SizedBox(
                            width: 76.r,
                            height: 76.r,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                CustomPaint(
                                  size: Size(76.r, 76.r),
                                  painter: MRDGaugePainter(
                                    percentage: complianceScore.toDouble(),
                                    primaryColor: const Color(0xFF10B981),
                                    isDark: isDark,
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "$complianceScore%",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w900,
                                        color: isDark
                                            ? Colors.white
                                            : const Color(0xFF1E293B),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 5.w,
                                        vertical: 1.5.h,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(
                                          0xFF10B981,
                                        ).withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(
                                          6.r,
                                        ),
                                      ),
                                      child: Text(
                                        "Excellent",
                                        style: TextStyle(
                                          fontSize: 7.sp,
                                          fontWeight: FontWeight.w900,
                                          color: const Color(0xFF10B981),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Your department is performing well. Keep maintaining document accuracy and compliance.",
                              style: TextStyle(
                                fontSize: 9.5.sp,
                                fontWeight: FontWeight.w500,
                                color: isDark
                                    ? Colors.white54
                                    : const Color(0xFF64748B),
                                height: 1.35,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Row(
                              children: [
                                Text(
                                  "View Details",
                                  style: TextStyle(
                                    fontSize: 9.5.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF3B82F6),
                                  ),
                                ),
                                SizedBox(width: 2.w),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Color(0xFF3B82F6),
                                  size: 10,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // 2. Top Recommendations Checklist
                _buildCardContainer(
                  isDark: isDark,
                  flexWidth: useWideLayout,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Top Recommendations",
                        style: TextStyle(
                          fontSize: 11.5.sp,
                          fontWeight: FontWeight.w900,
                          color: isDark
                              ? Colors.white70
                              : const Color(0xFF1E293B),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      _buildCheckItem(
                        context,
                        "$pendingSummaries Discharge Summaries pending verification",
                        isDark,
                      ),
                      _buildCheckItem(
                        context,
                        "12 Consent forms missing for recent admissions",
                        isDark,
                      ),
                      _buildCheckItem(
                        context,
                        "320 Records are due for archival this month",
                        isDark,
                      ),
                    ],
                  ),
                ),

                // 3. Smart Actions AI Chatbot
                _buildCardContainer(
                  isDark: isDark,
                  flexWidth: useWideLayout,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 13.r,
                            backgroundColor: const Color(
                              0xFF3B82F6,
                            ).withValues(alpha: 0.12),
                            child: const Icon(
                              Icons.smart_toy_outlined,
                              color: Color(0xFF3B82F6),
                              size: 14,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Smart Actions",
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w900,
                                  color: isDark
                                      ? Colors.white
                                      : const Color(0xFF1E293B),
                                ),
                              ),
                              Text(
                                "Ask AI assistant for assistance",
                                style: TextStyle(
                                  fontSize: 8.5.sp,
                                  color: isDark ? Colors.white38 : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 12.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "AI Assistant: Summarizing completed records for compliance...",
                                ),
                                backgroundColor: Color(0xFF3B82F6),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF3B82F6),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 10.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Ask AI Assistant",
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              const Icon(Icons.arrow_forward_rounded, size: 12),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ];

              if (useWideLayout) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widgets[0],
                    SizedBox(width: 10.w),
                    widgets[1],
                    SizedBox(width: 10.w),
                    widgets[2],
                  ],
                );
              } else {
                return Column(
                  children: [
                    widgets[0],
                    SizedBox(height: 10.h),
                    widgets[1],
                    SizedBox(height: 10.h),
                    widgets[2],
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCardContainer({
    required Widget child,
    required bool isDark,
    required bool flexWidth,
  }) {
    final card = Container(
      height: 110.h,
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withValues(alpha: 0.02) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[200]!),
      ),
      child: child,
    );

    if (flexWidth) {
      return Expanded(child: card);
    }
    return card;
  }
}

class MRDGaugePainter extends CustomPainter {
  final double percentage;
  final Color primaryColor;
  final bool isDark;

  MRDGaugePainter({
    required this.percentage,
    required this.primaryColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 5.5;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.width - strokeWidth) / 2;

    final Paint bgPaint = Paint()
      ..color = isDark ? Colors.white10 : Colors.grey.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, radius, bgPaint);

    final Paint progressPaint = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final double sweepAngle = (percentage / 100.0) * 3.14159265 * 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159265 / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant MRDGaugePainter oldDelegate) {
    return oldDelegate.percentage != percentage ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.isDark != isDark;
  }
}
