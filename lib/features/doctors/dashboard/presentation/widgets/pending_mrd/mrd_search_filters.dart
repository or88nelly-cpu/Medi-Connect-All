import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';

class MrdSearchFilters extends StatelessWidget {
  final String selectedArea;
  final String selectedPriority;
  final String selectedStatus;
  final ValueChanged<String> onSearchChanged;
  final ValueChanged<String?> onAreaChanged;
  final ValueChanged<String?> onPriorityChanged;
  final ValueChanged<String?> onStatusChanged;
  final bool isDark;
  final Color cardBg;
  final Color borderCol;

  const MrdSearchFilters({
    super.key,
    required this.selectedArea,
    required this.selectedPriority,
    required this.selectedStatus,
    required this.onSearchChanged,
    required this.onAreaChanged,
    required this.onPriorityChanged,
    required this.onStatusChanged,
    required this.isDark,
    required this.cardBg,
    required this.borderCol,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                height: 38.h,
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(color: borderCol),
                ),
                child: TextField(
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    hintText: "Search patient name or MRD No...",
                    hintStyle: TextStyle(color: isDark ? Colors.white38 : Colors.grey, fontSize: 11.sp),
                    prefixIcon: Icon(Icons.search, color: Colors.grey, size: 16.r),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8.w),
            Container(
              height: 38.h,
              width: 38.h,
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(10.r),
                border: Border.all(color: borderCol),
              ),
              child: Icon(Icons.tune, color: isDark ? Colors.white70 : Colors.grey[700], size: 18.r),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: _buildDropdownSelector(
                selectedArea,
                ['All Areas', 'Ward 3B', 'Room 205', 'Surgery', 'HDU', 'ICU'],
                onAreaChanged,
                borderCol,
              ),
            ),
            SizedBox(width: 6.w),
            Expanded(
              child: _buildDropdownSelector(
                selectedPriority,
                ['All Priorities', 'High', 'Medium', 'Low'],
                onPriorityChanged,
                borderCol,
              ),
            ),
            SizedBox(width: 6.w),
            Expanded(
              child: _buildDropdownSelector(
                selectedStatus,
                ['All Status', 'Pending', 'Overdue', 'Returned'],
                onStatusChanged,
                borderCol,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDropdownSelector(
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
    Color borderCol,
  ) {
    return Container(
      height: 32.h,
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: borderCol),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          style: TextStyle(color: isDark ? Colors.white : AppColors.textDarkNavy, fontSize: 10.sp, fontWeight: FontWeight.bold),
          dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          icon: const Icon(Icons.arrow_drop_down, size: 18),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
