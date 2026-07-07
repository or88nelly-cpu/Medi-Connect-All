import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';

class MrdStatsGrid extends StatelessWidget {
  final Map<String, int> counts;
  final bool isDark;

  const MrdStatsGrid({
    super.key,
    required this.counts,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8.w,
      mainAxisSpacing: 8.h,
      childAspectRatio: 1.15,
      children: [
        _buildStatCard('Pending Discharge', counts['discharge'] ?? 128, const Color(0xFFE11D48)),
        _buildStatCard('Pending Operative', counts['operative'] ?? 82, const Color(0xFFF59E0B)),
        _buildStatCard('Digital Signatures', counts['signatures'] ?? 64, const Color(0xFF8B5CF6)),
        _buildStatCard('Overdue MRD Files', counts['overdue'] ?? 37, const Color(0xFFEF4444)),
        _buildStatCard('Returned Correction', counts['returned'] ?? 19, const Color(0xFF3B82F6)),
        _buildStatCard('Total Pending Records', counts['total'] ?? 330, const Color(0xFF10B981)),
      ],
    );
  }

  Widget _buildStatCard(String label, int val, Color indicatorColor) {
    final bg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textCol = isDark ? Colors.white : AppColors.textDarkNavy;

    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: isDark ? Colors.white10 : Colors.grey[150]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 4.w,
            height: 12.h,
            decoration: BoxDecoration(
              color: indicatorColor,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            val.toString(),
            style: TextStyle(
              color: textCol,
              fontSize: 18.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 2.h),
          Text(
            label,
            style: TextStyle(
              color: isDark ? Colors.white38 : Colors.grey[500],
              fontSize: 8.5.sp,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
