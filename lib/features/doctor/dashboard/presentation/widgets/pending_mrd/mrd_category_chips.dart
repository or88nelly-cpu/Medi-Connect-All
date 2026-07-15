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
      'Consultation',
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
          if (cat == 'All Pending') count = counts['total'] ?? 0;
          if (cat == 'Discharge Summary') count = counts['discharge'] ?? 0;
          if (cat == 'Operative Notes') count = counts['operative'] ?? 0;
          if (cat == 'Signatures') count = counts['signatures'] ?? 0;
          if (cat == 'Consultation') count = counts['consultation'] ?? 0;
          if (cat == 'Overdue') count = counts['overdue'] ?? 0;
          if (cat == 'Returned') count = counts['returned'] ?? 0;

          return Padding(
            padding: EdgeInsets.only(right: 8.w),
            child: ChoiceChip(
              avatar: Icon(
                _getIconForCategory(cat),
                size: 13.r,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
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
                  color: isSelected
                      ? const Color(0xFF0F6FFF)
                      : Colors.grey[300]!,
                  width: 0.8,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'All Pending':
        return Icons.folder_open;
      case 'Discharge Summary':
        return Icons.assignment_turned_in;
      case 'Operative Notes':
        return Icons.medical_services;
      case 'Signatures':
        return Icons.draw;
      case 'Consultation':
        return Icons.chat_bubble_outline;
      case 'Overdue':
        return Icons.error_outline;
      case 'Returned':
        return Icons.undo;
      default:
        return Icons.folder;
    }
  }
}
