import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/constants/app_assets.dart';
import 'package:medi_connect/core/functions/profile_image_helper.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';

// --- OPERATIONS MODULE HEADER ---
class EmrdDashboardHeader extends StatelessWidget {
  final String name;
  final String role;
  final String? profileImage;
  final String? gender;
  final Map<String, dynamic> stats;
  final bool isDark;
  final VoidCallback onBack;

  const EmrdDashboardHeader({
    super.key,
    required this.name,
    required this.role,
    required this.profileImage,
    required this.gender,
    required this.stats,
    required this.isDark,
    required this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    final alertCount = stats['active_alerts'] ?? 5;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark 
              ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
              : [const Color(0xFFE0F2FE), const Color(0xFFF0F9FF)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
      ),
      child: Stack(
        children: [
          // ECG heartbeat background line
          Positioned(
            bottom: 40.h,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 60.h,
              child: CustomPaint(
                painter: ECGPainter(
                  color: isDark 
                      ? Colors.white.withOpacity(0.04) 
                      : AppColors.primary.withOpacity(0.08),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: onBack,
                      borderRadius: BorderRadius.circular(30.r),
                      child: Container(
                        padding: EdgeInsets.all(10.r),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.white10 : Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          size: 20.r,
                          color: isDark ? Colors.white : AppColors.textPrimary(context),
                        ),
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Operations",
                            style: AppTextStyles.headingMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 22.sp,
                              color: isDark ? Colors.white : AppColors.textPrimary(context),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            "Manage daily medical record operations",
                            style: AppTextStyles.bodySmall.copyWith(
                              fontSize: 11.sp,
                              color: isDark ? Colors.white54 : AppColors.textSecondary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Notification Bell
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.r),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.white10 : Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.notifications_none_outlined,
                            size: 22.r,
                            color: isDark ? Colors.white : AppColors.textPrimary(context),
                          ),
                        ),
                        if (alertCount > 0)
                          Positioned(
                            top: -2.h,
                            right: -2.w,
                            child: Container(
                              padding: EdgeInsets.all(4.r),
                              decoration: const BoxDecoration(
                                color: Color(0xFFDC2626),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                "$alertCount",
                                style: TextStyle(
                                  fontSize: 8.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    SizedBox(width: 10.w),
                    // Profile Image
                    Stack(
                      children: [
                        Container(
                          width: 42.r,
                          height: 42.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark ? Colors.white24 : AppColors.primary,
                              width: 1.5,
                            ),
                          ),
                          child: CustomImageView(
                            imagePath: ProfileImageHelper.resolveImagePath(
                              profileImage,
                              role,
                              gender,
                            ),
                            borderRadius: 21.r,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 12.r,
                            height: 12.r,
                            decoration: BoxDecoration(
                              color: const Color(0xFF22C55E),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                
                // Hospital banner overlapping/glassmorphism
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.r),
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white.withOpacity(0.05) : Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: isDark ? Colors.white10 : Colors.white,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                "Aster MIMS Center",
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10.sp,
                                ),
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              "Department of Health Records",
                              style: AppTextStyles.titleMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.sp,
                                color: isDark ? Colors.white : AppColors.textPrimary(context),
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              "System is online. All records are fully encrypted and HIPAA compliant.",
                              style: AppTextStyles.bodySmall.copyWith(
                                fontSize: 10.sp,
                                color: isDark ? Colors.white54 : AppColors.textSecondary(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12.w),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r),
                        child: Image.asset(
                          AppAssets.hospitalPng,
                          width: 80.w,
                          height: 70.h,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 80.w,
                            height: 70.h,
                            color: AppColors.primary.withOpacity(0.1),
                            child: Icon(
                              Icons.local_hospital_outlined,
                              color: AppColors.primary,
                              size: 32.r,
                            ),
                          ),
                        ),
                      ),
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

// --- OPERATIONS MODULE CARD ---
class EmrdOperationCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final bool isDark;
  final VoidCallback? onTap;
  final int? badgeCount;

  const EmrdOperationCard({
    super.key,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.isDark,
    this.onTap,
    this.badgeCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.terminalDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isDark ? Colors.white10 : AppColors.border(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16.r),
          child: Padding(
            padding: EdgeInsets.all(12.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: accentColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(
                            icon,
                            color: accentColor,
                            size: 20.r,
                          ),
                        ),
                        if (badgeCount != null && badgeCount! > 0)
                          Positioned(
                            top: -4.h,
                            right: -4.w,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
                              decoration: const BoxDecoration(
                                color: Color(0xFFDC2626),
                                borderRadius: BorderRadius.all(Radius.circular(8)),
                              ),
                              child: Text(
                                "$badgeCount",
                                style: TextStyle(
                                  fontSize: 8.sp,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        size: 14.r,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  value,
                  style: AppTextStyles.headingSmall.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                    color: isDark ? Colors.white : AppColors.textPrimary(context),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 10.sp,
                    color: isDark ? Colors.white54 : AppColors.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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

// --- ADMIN ANALYTICS SECTION ---
class EmrdAdminAnalyticsSection extends StatelessWidget {
  final Map<String, dynamic> stats;
  final bool isDark;

  const EmrdAdminAnalyticsSection({
    super.key,
    required this.stats,
    required this.isDark,
  });

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 10.r,
          height: 10.r,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[500],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.terminalDarkCard : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDark ? Colors.white10 : AppColors.border(context),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.insights,
                color: AppColors.primary,
                size: 20.r,
              ),
              SizedBox(width: 10.w),
              Text(
                "EMRD Performance & Trend Analytics",
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.sp,
                  color: isDark ? Colors.white : AppColors.textPrimary(context),
                ),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          Text(
            "Visual trend analysis for digitization rate and storage utilization",
            style: AppTextStyles.bodySmall.copyWith(
              fontSize: 11.sp,
              color: isDark ? Colors.white30 : AppColors.textSecondary(context),
            ),
          ),
          SizedBox(height: 20.h),

          SizedBox(
            height: 150.h,
            width: double.infinity,
            child: CustomPaint(
              painter: EMRDAnalyticsPainter(
                values: [45.0, 58.0, 72.0, 68.0, 85.0, 92.0],
                labels: ["Jan", "Feb", "Mar", "Apr", "May", "Jun"],
                primaryColor: const Color(0xFF6366F1),
                secondaryColor: const Color(0xFF10B981),
                isDark: isDark,
              ),
            ),
          ),
          SizedBox(height: 18.h),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildLegendItem("Digitization Accuracy (%)", const Color(0xFF6366F1)),
              SizedBox(width: 20.w),
              _buildLegendItem("Storage Optimization (%)", const Color(0xFF10B981)),
            ],
          ),
        ],
      ),
    );
  }
}

// --- CUSTOM PAINTERS ---

class ECGPainter extends CustomPainter {
  final Color color;
  const ECGPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final h = size.height;
    final w = size.width;

    path.moveTo(0, h * 0.5);
    path.lineTo(w * 0.2, h * 0.5);
    path.lineTo(w * 0.23, h * 0.45);
    path.lineTo(w * 0.26, h * 0.55);
    path.lineTo(w * 0.29, h * 0.5);
    path.lineTo(w * 0.45, h * 0.5);
    path.lineTo(w * 0.48, h * 0.65);
    path.lineTo(w * 0.52, h * 0.15);
    path.lineTo(w * 0.56, h * 0.85);
    path.lineTo(w * 0.6, h * 0.5);
    path.lineTo(w * 0.65, h * 0.4);
    path.lineTo(w * 0.7, h * 0.5);
    path.lineTo(w, h * 0.5);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
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

class EMRDAnalyticsPainter extends CustomPainter {
  final List<double> values;
  final List<String> labels;
  final Color primaryColor;
  final Color secondaryColor;
  final bool isDark;

  EMRDAnalyticsPainter({
    required this.values,
    required this.labels,
    required this.primaryColor,
    required this.secondaryColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paintGrid = Paint()
      ..color = isDark ? Colors.white10 : Colors.black.withOpacity(0.05)
      ..strokeWidth = 1;

    final paintLine = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final paintLine2 = Paint()
      ..color = secondaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final fillPaint = Paint()
      ..style = PaintingStyle.fill;

    const rows = 4;
    for (int i = 0; i <= rows; i++) {
      final y = size.height * (i / rows);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paintGrid);
    }

    final double stepX = size.width / (values.length - 1);
    final double maxVal = 100.0;

    final path = Path();
    final fillPath = Path();

    final path2 = Path();
    final fillPath2 = Path();

    for (int i = 0; i < values.length; i++) {
      final x = i * stepX;
      final y = size.height - (values[i] / maxVal) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }

      if (i == values.length - 1) {
        fillPath.lineTo(x, size.height);
        fillPath.close();
      }
    }

    final List<double> values2 = [60, 68, 70, 75, 78, 85];
    for (int i = 0; i < values2.length; i++) {
      final x = i * stepX;
      final y = size.height - (values2[i] / maxVal) * size.height;

      if (i == 0) {
        path2.moveTo(x, y);
        fillPath2.moveTo(x, size.height);
        fillPath2.lineTo(x, y);
      } else {
        path2.lineTo(x, y);
        fillPath2.lineTo(x, y);
      }

      if (i == values2.length - 1) {
        fillPath2.lineTo(x, size.height);
        fillPath2.close();
      }
    }

    final gradient = LinearGradient(
      colors: [primaryColor.withOpacity(0.3), primaryColor.withOpacity(0.0)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    fillPaint.shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath, fillPaint);

    final gradient2 = LinearGradient(
      colors: [secondaryColor.withOpacity(0.2), secondaryColor.withOpacity(0.0)],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
    final fillPaint2 = Paint()
      ..style = PaintingStyle.fill
      ..shader = gradient2.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fillPath2, fillPaint2);

    canvas.drawPath(path, paintLine);
    canvas.drawPath(path2, paintLine2);

    final textPainter = TextPainter(
      //textDirection: TextDirection.ltr,
    );

    for (int i = 0; i < values.length; i++) {
      final x = i * stepX;
      final y = size.height - (values[i] / maxVal) * size.height;

      canvas.drawCircle(Offset(x, y), 5, Paint()..color = primaryColor);
      canvas.drawCircle(Offset(x, y), 3, Paint()..color = Colors.white);

      final y2 = size.height - (values2[i] / maxVal) * size.height;
      canvas.drawCircle(Offset(x, y2), 5, Paint()..color = secondaryColor);
      canvas.drawCircle(Offset(x, y2), 3, Paint()..color = Colors.white);

      textPainter.text = TextSpan(
        text: labels[i],
        style: TextStyle(
          color: isDark ? Colors.white30 : Colors.black38,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, size.height + 6));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
