import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/features/admin/department_details/presentation/widgets/department_card_badge.dart';
import 'package:medi_connect/features/admin/staff_management/domain/entities/department_entity.dart';

/// Compact department card: gradient badge + name + arrow.
/// Colors resolved from [AppColors.deptGradientPalette] — zero hardcoded Color().
class DepartmentGridCard extends StatefulWidget {
  final DepartmentEntity department;
  final VoidCallback? onTap;
  final double height;
  final double width;

  const DepartmentGridCard({
    super.key,
    required this.department,
    this.onTap,
    required this.height,
    required this.width,
  });

  @override
  State<DepartmentGridCard> createState() => _DepartmentGridCardState();
}

class _DepartmentGridCardState extends State<DepartmentGridCard> {
  bool _hovered = false;

  List<Color> get _gradient {
    final idx =
        widget.department.name.hashCode.abs() %
        AppColors.deptGradientPalette.length;
    return AppColors.deptGradientPalette[idx];
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final grad = _gradient;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          height: widget.height,
          width: widget.width,
          transform: _hovered
              ? Matrix4.translationValues(0, -4, 0)
              : Matrix4.identity(),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 14.h),
          decoration: _decoration(isDark),
          child: Stack(
            children: [
              SizedBox(
                width: widget.width,
                height: widget.height,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    DepartmentCardBadge(
                      department: widget.department,
                      height: widget.height * 0.6,
                    ),
                    // SizedBox(height: 10.h),
                    Text(
                      widget.department.name,
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.surface,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: _ArrowButton(
                  color: grad[0],
                  isDark: isDark,
                  size: widget.width * 0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _decoration(bool isDark) => BoxDecoration(
    gradient: LinearGradient(colors: _gradient),
    borderRadius: BorderRadius.circular(16.r),
    // border: Border.all(
    //   color: _hovered
    //       ? _gradient[1].withValues(alpha: 0.3)
    //       : AppColors.lightBorder.withValues(alpha: isDark ? 0.0 : 1.0),
    // ),
    //boxShadow: [
    //   BoxShadow(
    //     color: _hovered
    //         ? accent.withValues(alpha: 0.18)
    //         : AppColors.lightShadow,
    //     blurRadius: _hovered ? 18 : 8,
    //     offset: Offset(0, _hovered ? 8 : 2),
    //   ),
    // ],
  );
}

class _ArrowButton extends StatelessWidget {
  final Color color;
  final bool isDark;
  final double size;
  const _ArrowButton({
    required this.color,
    required this.isDark,
    required this.size,
  });

  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      color: color.withValues(alpha: isDark ? 0.22 : 0.1),
      shape: BoxShape.circle,
      border: Border.all(color: Colors.white),
    ),
    child: Icon(
      Icons.arrow_forward_ios_rounded,
      size: size * 0.6,
      color: Colors.white,
    ),
  );
}
