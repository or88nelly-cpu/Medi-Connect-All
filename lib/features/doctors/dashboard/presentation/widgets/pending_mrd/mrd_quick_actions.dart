import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class MrdQuickActions extends StatelessWidget {
  final bool isDark;
  final Color cardBg;
  final Color borderCol;

  const MrdQuickActions({
    super.key,
    required this.isDark,
    required this.cardBg,
    required this.borderCol,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Action Buttons",
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppColors.textDarkNavy,
            fontSize: 13.sp,
          ),
        ),
        SizedBox(height: 10.h),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 8.h,
          childAspectRatio: 2.8,
          children: [
            _buildActionCard(context, "Complete Record", "Mark record as complete", Icons.check_circle, const Color(0xFF10B981)),
            _buildActionCard(context, "Edit Record", "Edit and update patient record", Icons.edit_note_outlined, const Color(0xFF8B5CF6)),
            _buildActionCard(context, "Sign Document", "Digitally sign documents", Icons.draw_outlined, const Color(0xFFF59E0B)),
            _buildActionCard(context, "Generate Discharge Summary", "Create discharge summary", Icons.description_outlined, const Color(0xFF3B82F6)),
            _buildActionCard(context, "View Deficiency Remarks", "Check deficiency and remarks", Icons.feedback_outlined, const Color(0xFFEF4444)),
            _buildActionCard(context, "Submit to MRD", "Submit record to MRD dept", Icons.send_outlined, const Color(0xFF14B8A6)),
            _buildActionCard(context, "View Patient Record", "View complete patient record", Icons.folder_shared_outlined, const Color(0xFF6366F1)),
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: isDark ? Colors.white10 : const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: borderCol),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.folder_copy, size: 28.r, color: const Color(0xFF3B82F6)),
                  SizedBox(width: 8.w),
                  Text(
                    "All Archives",
                    style: TextStyle(color: isDark ? Colors.white70 : const Color(0xFF1D4ED8), fontSize: 10.sp, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color iconColor,
  ) {
    final textCol = isDark ? Colors.white : AppColors.textDarkNavy;

    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Action: '$title' initiated"),
            backgroundColor: AppColors.primary,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderCol),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 18.r),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: textCol, fontSize: 10.5.sp, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(color: isDark ? Colors.white38 : Colors.grey[500], fontSize: 8.sp),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
