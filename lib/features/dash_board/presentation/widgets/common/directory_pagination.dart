import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';

class DirectoryPagination extends StatelessWidget {
  const DirectoryPagination({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPageChanged,
  });

  final int currentPage;
  final int totalPages;
  final ValueChanged<int> onPageChanged;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark ? AppColors.terminalDarkLabel : AppColors.terminalLightLabel;
    final textColor = isDark ? AppColors.terminalDarkText : AppColors.terminalLightText;
    final activeBg = AppColors.primary;
    final inactiveBg = isDark ? Colors.white.withValues(alpha: 0.05) : Colors.black.withValues(alpha: 0.05);

    return Padding(
      padding: EdgeInsets.only(top: 12.h, bottom: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "$currentPage of ${totalPages > 0 ? totalPages : 1}",
            style: TextStyle(color: labelColor, fontSize: 12.sp, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              // Back arrow
              _buildPaginationArrow(
                context,
                Icons.chevron_left,
                currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
              ),
              SizedBox(width: 6.w),

              // Page Numbers
              ...List.generate(totalPages, (index) {
                final pageNum = index + 1;
                final isActive = pageNum == currentPage;
                return GestureDetector(
                  onTap: () => onPageChanged(pageNum),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 3.w),
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      color: isActive ? activeBg : inactiveBg,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      pageNum.toString(),
                      style: TextStyle(
                        color: isActive ? Colors.white : textColor,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }),

              SizedBox(width: 6.w),
              // Next arrow
              _buildPaginationArrow(
                context,
                Icons.chevron_right,
                currentPage < totalPages ? () => onPageChanged(currentPage + 1) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPaginationArrow(BuildContext context, IconData icon, VoidCallback? onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = onTap != null
        ? (isDark ? Colors.white : AppColors.terminalLightText)
        : (isDark ? Colors.white30 : Colors.black26);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4.r),
      child: Container(
        padding: EdgeInsets.all(4.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(
            color: isDark ? AppColors.terminalDarkBorder : AppColors.terminalLightBorder,
            width: 1,
          ),
        ),
        child: Icon(icon, color: iconColor, size: 16.r),
      ),
    );
  }
}
