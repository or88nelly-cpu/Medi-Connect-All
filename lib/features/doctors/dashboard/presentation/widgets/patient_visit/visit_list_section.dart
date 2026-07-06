import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class VisitListSection extends StatelessWidget {
  final List<String> points;
  final String title;
  final String? description;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onAddPressed;
  final ValueChanged<int> onRemovePressed;
  final bool isEditable;

  const VisitListSection({
    super.key,
    required this.points,
    required this.title,
    this.description,
    required this.icon,
    required this.iconColor,
    required this.onAddPressed,
    required this.onRemovePressed,
    this.isEditable = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final primaryTextColor = isDark ? Colors.white : AppColors.textDarkNavy;
    final secondaryTextColor = isDark ? Colors.white60 : Colors.grey[600];
    final borderCol = AppColors.border(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconColor.withValues(alpha: 0.15),
              ),
              child: Icon(icon, color: iconColor, size: 18.r),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                      fontSize: 14.sp,
                    ),
                  ),
                  if (description != null)
                    Text(
                      description!,
                      style: TextStyle(
                        color: isDark ? Colors.white38 : Colors.grey[500],
                        fontSize: 9.sp,
                      ),
                    ),
                ],
              ),
            ),
            if (isEditable) ...[
              IconButton(
                icon: Icon(
                  Icons.keyboard_alt_outlined,
                  size: 18.r,
                  color: secondaryTextColor,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.mic_none_outlined,
                  size: 18.r,
                  color: secondaryTextColor,
                ),
                onPressed: () {},
              ),
            ],
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: borderCol),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (points.isEmpty)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h),
                  child: Text(
                    'No clinical records entered.',
                    style: TextStyle(
                      color: secondaryTextColor,
                      fontSize: 11.sp,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: points.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(vertical: 4.h),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '• ',
                            style: TextStyle(
                              color: isDark ? Colors.white70 : Colors.grey[800],
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              points[index],
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white70
                                    : Colors.grey[800],
                                fontSize: 11.sp,
                              ),
                            ),
                          ),
                          if (isEditable)
                            IconButton(
                              icon: const Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.grey,
                              ),
                              onPressed: () => onRemovePressed(index),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              if (isEditable) ...[
                SizedBox(height: 8.h),
                TextButton.icon(
                  onPressed: onAddPressed,
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Add Point'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
