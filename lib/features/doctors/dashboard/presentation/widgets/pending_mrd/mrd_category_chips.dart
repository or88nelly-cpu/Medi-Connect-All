import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MrdCategoryChips extends StatelessWidget {
  final String selectedCategory;
  final Map<String, int> counts;
  final ValueChanged<String> onCategorySelected;

  const MrdCategoryChips({
    super.key,
    required this.selectedCategory,
    required this.counts,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      'All Pending',
      'Discharge Summary',
      'Operative Notes',
      'Signatures',
      'Overdue',
      'Returned',
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: categories.map((cat) {
          final isSelected = selectedCategory == cat;
          int count = 0;
          if (cat == 'All Pending') count = counts['total'] ?? 330;
          if (cat == 'Discharge Summary') count = counts['discharge'] ?? 128;
          if (cat == 'Operative Notes') count = counts['operative'] ?? 82;
          if (cat == 'Signatures') count = counts['signatures'] ?? 64;
          if (cat == 'Overdue') count = counts['overdue'] ?? 37;
          if (cat == 'Returned') count = counts['returned'] ?? 19;

          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: ChoiceChip(
              label: Text('$cat ($count)'),
              selected: isSelected,
              onSelected: (val) {
                if (val) {
                  onCategorySelected(cat);
                }
              },
              backgroundColor: Colors.transparent,
              selectedColor: const Color(0xFF0F6FFF),
              labelStyle: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[600],
                fontSize: 10.sp,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
                side: BorderSide(
                  color: isSelected ? const Color(0xFF0F6FFF) : Colors.grey[300]!,
                  width: 0.8,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
