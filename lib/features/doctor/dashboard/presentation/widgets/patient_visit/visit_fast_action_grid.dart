import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';

class VisitFastActionGrid extends StatelessWidget {
  const VisitFastActionGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderCol = AppColors.border(context);

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 8.w,
      mainAxisSpacing: 8.h,
      childAspectRatio: 2.2,
      children: [
        _buildGridActionCard(
          context,
          'Investigation Order',
          Icons.science_outlined,
          AppColors.info,
          isDark,
          cardBg,
          borderCol,
        ),
        _buildGridActionCard(
          context,
          'Investigation Reports',
          Icons.insert_chart_outlined,
          const Color(0xFF10B981),
          isDark,
          cardBg,
          borderCol,
        ),
        _buildGridActionCard(
          context,
          'Cross Consultations',
          Icons.group_outlined,
          const Color(0xFF8B5CF6),
          isDark,
          cardBg,
          borderCol,
        ),
        _buildGridActionCard(
          context,
          'Surgery Order',
          Icons.medical_services_outlined,
          AppColors.error,
          isDark,
          cardBg,
          borderCol,
        ),
        _buildGridActionCard(
          context,
          'Procedures Order',
          Icons.playlist_add_check_circle_outlined,
          const Color(0xFFEC4899),
          isDark,
          cardBg,
          borderCol,
        ),
        _buildGridActionCard(
          context,
          'IP Registration',
          Icons.airline_seat_flat_angled_outlined,
          const Color(0xFF14B8A6),
          isDark,
          cardBg,
          borderCol,
        ),
        _buildGridActionCard(
          context,
          'Book Next Visit',
          Icons.event_note_outlined,
          const Color(0xFF6366F1),
          isDark,
          cardBg,
          borderCol,
        ),
        _buildGridActionCard(
          context,
          'Diet',
          Icons.restaurant_outlined,
          AppColors.warning,
          isDark,
          cardBg,
          borderCol,
        ),
        _buildGridActionCard(
          context,
          'Physio',
          Icons.directions_run_outlined,
          const Color(0xFF8B5CF6),
          isDark,
          cardBg,
          borderCol,
        ),
      ],
    );
  }

  Widget _buildGridActionCard(
    BuildContext context,
    String label,
    IconData icon,
    Color iconColor,
    bool isDark,
    Color cardBg,
    Color borderCol,
  ) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label placed successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: borderCol),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 16.r, color: iconColor),
            SizedBox(height: 3.h),
            Text(
              label,
              style: TextStyle(
                color: isDark ? Colors.white70 : AppColors.textDarkNavy,
                fontSize: 8.sp,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
