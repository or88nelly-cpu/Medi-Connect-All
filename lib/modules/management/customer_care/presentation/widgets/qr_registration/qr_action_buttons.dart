import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class QrActionButtons extends StatelessWidget {
  final String registrationId;
  final VoidCallback onGenerateNew;

  const QrActionButtons({
    super.key,
    required this.registrationId,
    required this.onGenerateNew,
  });

  void _handleShare(BuildContext context, String platform) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Sharing QR Link via $platform for ID: $registrationId"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 768;

    final List<Widget> items = [
      _buildActionButton(
        context,
        icon: Icons.share_rounded,
        title: "Share QR",
        subtitle: "Share with patient",
        color: const Color(0xFF3B82F6),
        onTap: () => _handleShare(context, "System Share"),
        isDark: isDark,
      ),
      _buildActionButton(
        context,
        icon: Icons.chat_bubble_outline_rounded,
        title: "WhatsApp",
        subtitle: "Send QR Link",
        color: const Color(0xFF22C55E),
        onTap: () => _handleShare(context, "WhatsApp"),
        isDark: isDark,
      ),
      _buildActionButton(
        context,
        icon: Icons.sms_outlined,
        title: "SMS",
        subtitle: "Send SMS Link",
        color: const Color(0xFFEAB308),
        onTap: () => _handleShare(context, "SMS"),
        isDark: isDark,
      ),
      _buildActionButton(
        context,
        icon: Icons.refresh_rounded,
        title: "Generate New",
        subtitle: "Refresh QR Code",
        color: AppColors.primary,
        onTap: onGenerateNew,
        isDark: isDark,
      ),
    ];

    if (isMobile) {
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 2.3,
        children: items,
      );
    } else {
      return Row(
        children: items
            .map(
              (w) => Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: w,
                ),
              ),
            )
            .toList(),
      );
    }
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    final cardBgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final borderCol = isDark
        ? Colors.white10
        : Colors.black.withValues(alpha: 0.05);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: cardBgColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: borderCol, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 18.r),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 12.sp,
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodyXSmall.copyWith(
                      color: isDark ? Colors.white38 : Colors.grey[500],
                      fontSize: 9.sp,
                    ),
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
