import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

// --- AI ASSISTANT PANEL ---
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
    required String text,
    required Color color,
    required bool isDark,
  }) {
    return Container(
      margin: EdgeInsets.only(right: 8.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.04) : Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: isDark ? Colors.white10 : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 13.r),
          SizedBox(width: 6.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white70 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(BuildContext context, String text, bool isDark) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.check_circle,
            color: const Color(0xFF3B82F6),
            size: 14.r,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 10.5.sp,
                fontWeight: FontWeight.w500,
                color: isDark ? Colors.white54 : AppColors.textSecondary(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pendingSummaries = stats['pending_summaries'] ?? 12;
    final complianceScore = stats['compliance_score'] ?? 92;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark 
              ? [const Color(0xFF1E1E38), const Color(0xFF13132B)]
              : [const Color(0xFFEEF2FF), const Color(0xFFE0E7FF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark 
              ? const Color(0xFF312E81) 
              : const Color(0xFFC7D2FE),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                  ),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.white,
                  size: 16,
                ),
              ),
              SizedBox(width: 10.w),
              Text(
                "AI-Powered MRD Assistant",
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                  color: isDark ? Colors.white : const Color(0xFF312E81),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(4.r),
                ),
                child: Text(
                  "AI-",
                  style: TextStyle(
                    fontSize: 8.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF3B82F6),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            "Real-time insights and intelligent recommendations",
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 11.sp,
              color: isDark ? Colors.white54 : const Color(0xFF4F46E5),
            ),
          ),
          SizedBox(height: 16.h),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            child: Row(
              children: [
                _buildAIPill(
                  icon: Icons.hourglass_empty,
                  text: "$pendingSummaries Pending Discharge Summaries",
                  color: const Color(0xFFF59E0B),
                  isDark: isDark,
                ),
                _buildAIPill(
                  icon: Icons.assignment_late_outlined,
                  text: "12 Missing Consent Forms",
                  color: const Color(0xFFEF4444),
                  isDark: isDark,
                ),
                _buildAIPill(
                  icon: Icons.balance_outlined,
                  text: "5 MLC Cases Pending",
                  color: const Color(0xFF3B82F6),
                  isDark: isDark,
                ),
                _buildAIPill(
                  icon: Icons.archive_outlined,
                  text: "320 Records Due for Archive",
                  color: const Color(0xFF8B5CF6),
                  isDark: isDark,
                ),
                _buildAIPill(
                  icon: Icons.trending_up,
                  text: "8% Improvement in NABH",
                  color: const Color(0xFF10B981),
                  isDark: isDark,
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Text(
                    "MRD Health Score",
                    style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white70 : const Color(0xFF312E81),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  SizedBox(
                    width: 90.r,
                    height: 90.r,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          size: Size(90.r, 90.r),
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
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: isDark ? Colors.white : Colors.black87,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981).withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                "Excellent",
                                style: TextStyle(
                                  fontSize: 8.sp,
                                  fontWeight: FontWeight.bold,
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
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Top Recommendations",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white70 : const Color(0xFF312E81),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildCheckItem(context, "$pendingSummaries Discharge Summaries pending verification", isDark),
                    _buildCheckItem(context, "12 Consent forms missing for recent admissions", isDark),
                    _buildCheckItem(context, "320 Records are due for archival this month", isDark),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.03) : Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[200]!,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18.r,
                  backgroundColor: const Color(0xFF6366F1).withOpacity(0.15),
                  child: const Icon(Icons.smart_toy_outlined, color: Color(0xFF6366F1), size: 18),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Smart Actions",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                      ),
                      Text(
                        "Ask about pending files or audits",
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: isDark ? Colors.white38 : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("AI Assistant: Summarizing completed records for compliance verification..."),
                        backgroundColor: Color(0xFF6366F1),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Ask AI Assistant",
                        style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 4.w),
                      const Icon(Icons.arrow_forward, size: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
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
    final double strokeWidth = 8.0;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.width - strokeWidth) / 2;

    final Paint bgPaint = Paint()
      ..color = isDark ? Colors.white10 : Colors.grey.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 - 0.5,
      3.14159 + 1.0,
      false,
      bgPaint,
    );

    final Paint progressPaint = Paint()
      ..shader = SweepGradient(
        colors: [primaryColor.withOpacity(0.5), primaryColor],
        startAngle: 0,
        endAngle: 3.14159 * 2,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final double sweepAngle = (percentage / 100.0) * (3.14159 + 1.0);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 - 0.5,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
