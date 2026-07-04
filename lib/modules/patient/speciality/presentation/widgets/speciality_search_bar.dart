import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class SpecialitySearchBar extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback? onFilterTap;

  const SpecialitySearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    this.onFilterTap,
  });

  @override
  State<SpecialitySearchBar> createState() => _SpecialitySearchBarState();
}

class _SpecialitySearchBarState extends State<SpecialitySearchBar> {
  final FocusNode _focusNode = FocusNode();

  bool _focused = false;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      setState(() {
        _focused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 18.h, 16.w, 12.h),
      child: Row(
        children: [
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              height: 56.h,
              decoration: BoxDecoration(
                color: isDark ? AppColors.terminalDarkCard : Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: _focused
                      ? AppColors.primary
                      : AppColors.border(context),
                  width: _focused ? 1.5 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: _focused
                        ? AppColors.primary.withValues(alpha: .12)
                        : Colors.black.withValues(alpha: .05),
                    blurRadius: _focused ? 18 : 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  SizedBox(width: 14.w),

                  Icon(
                    Icons.search_rounded,
                    color: AppColors.primary,
                    size: 22.r,
                  ),

                  SizedBox(width: 10.w),

                  Expanded(
                    child: TextField(
                      controller: widget.controller,
                      focusNode: _focusNode,
                      onChanged: widget.onChanged,
                      style: AppTextStyles.bodyMedium.copyWith(fontSize: 13.sp),
                      decoration: InputDecoration(
                        hintText: "Search Specialities...",
                        hintStyle: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary(context),
                          fontSize: 12.sp,
                        ),
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),

                  if (widget.controller.text.isNotEmpty)
                    GestureDetector(
                      onTap: () {
                        widget.controller.clear();
                        widget.onChanged("");
                        setState(() {});
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Icon(
                          Icons.close_rounded,
                          color: Colors.grey,
                          size: 20.r,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          SizedBox(width: 12.w),

          InkWell(
            borderRadius: BorderRadius.circular(18.r),
            onTap: widget.onFilterTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: 56.r,
              height: 56.r,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff2563EB), Color(0xff1D4ED8)],
                ),
                borderRadius: BorderRadius.circular(18.r),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff2563EB).withValues(alpha: .25),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(Icons.tune_rounded, color: Colors.white, size: 24.r),
            ),
          ),
        ],
      ),
    );
  }
}
