import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Count text + circle arrow button row for the module card footer.
class AdminModuleCardFooter extends StatelessWidget {
  final String countText;
  final Color baseColor;
  final bool isDark;

  const AdminModuleCardFooter({
    super.key,
    required this.countText,
    required this.baseColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            countText,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: baseColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Container(
          width: 26.r,
          height: 26.r,
          decoration: BoxDecoration(
            color: baseColor.withValues(alpha: isDark ? 0.22 : 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_forward_rounded,
            size: 14.r,
            color: baseColor,
          ),
        ),
      ],
    );
  }
}
