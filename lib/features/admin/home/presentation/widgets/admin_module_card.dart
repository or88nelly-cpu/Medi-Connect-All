import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_dimensions.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/features/admin/home/domain/entities/admin_dashboard_module_entity.dart';
import 'package:medi_connect/features/admin/home/presentation/widgets/admin_module_icon_mapper.dart';

/// Interactive Control Center Module Card matching the specification design.
class AdminModuleCard extends StatefulWidget {
  final AdminDashboardModuleEntity module;
  final VoidCallback onTap;

  const AdminModuleCard({super.key, required this.module, required this.onTap});

  @override
  State<AdminModuleCard> createState() => _AdminModuleCardState();
}

class _AdminModuleCardState extends State<AdminModuleCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = Color(widget.module.colorHex);
    final accentColor = Color(widget.module.accentColorHex);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: _isHovered
              ? Matrix4.translationValues(0.0, -4.0, 0.0)
              : Matrix4.identity(),
          padding: EdgeInsets.all(AppDimensions.paddingL),
          decoration: _cardDecoration(isDark, baseColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _ModuleIconBadge(
                baseColor: baseColor,
                accentColor: accentColor,
                isDark: isDark,
                iconKey: widget.module.iconKey,
              ),
              SizedBox(height: AppDimensions.spaceS),
              _ModuleLabels(module: widget.module, isDark: isDark),
              SizedBox(height: AppDimensions.spaceM),
              _ModuleFooter(
                module: widget.module,
                baseColor: baseColor,
                isDark: isDark,
              ),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration(bool isDark, Color baseColor) {
    return BoxDecoration(
      color: isDark ? AppColors.darkCard : Colors.white,
      borderRadius: BorderRadius.circular(24.r),
      border: Border.all(
        color: _isHovered
            ? baseColor.withValues(alpha: 0.5)
            : (isDark
                  ? Colors.white.withValues(alpha: 0.06)
                  : Colors.black.withValues(alpha: 0.04)),
        width: _isHovered ? 1.5 : 1.0,
      ),
      boxShadow: [
        BoxShadow(
          color: _isHovered
              ? baseColor.withValues(alpha: 0.15)
              : (isDark
                    ? Colors.black.withValues(alpha: 0.25)
                    : Colors.black.withValues(alpha: 0.03)),
          blurRadius: _isHovered ? 24 : 12,
          offset: Offset(0, _isHovered ? 10 : 4),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Sub-widgets
// ---------------------------------------------------------------------------

class _ModuleIconBadge extends StatelessWidget {
  final Color baseColor;
  final Color accentColor;
  final bool isDark;
  final String iconKey;

  const _ModuleIconBadge({
    required this.baseColor,
    required this.accentColor,
    required this.isDark,
    required this.iconKey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56.r,
      height: 56.r,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            baseColor.withValues(alpha: isDark ? 0.25 : 0.12),
            accentColor.withValues(alpha: isDark ? 0.4 : 0.22),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: baseColor.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          AdminModuleIconMapper.fromKey(iconKey),
          size: 28.r,
          color: baseColor,
        ),
      ),
    );
  }
}

class _ModuleLabels extends StatelessWidget {
  final AdminDashboardModuleEntity module;
  final bool isDark;

  const _ModuleLabels({required this.module, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          module.title,
          style: AppTextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.w900,
            fontSize: 16.sp,
            color: isDark ? Colors.white : AppColors.textDarkNavy,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        SizedBox(height: 4.h),
        Text(
          module.description,
          style: AppTextStyles.bodySmall.copyWith(
            fontSize: 11.sp,
            color: isDark
                ? Colors.white.withValues(alpha: 0.6)
                : Colors.grey.shade600,
            height: 1.3,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _ModuleFooter extends StatelessWidget {
  final AdminDashboardModuleEntity module;
  final Color baseColor;
  final bool isDark;

  const _ModuleFooter({
    required this.module,
    required this.baseColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          module.countText,
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: baseColor,
          ),
        ),
        Container(
          width: 32.r,
          height: 32.r,
          decoration: BoxDecoration(
            color: baseColor.withValues(alpha: isDark ? 0.2 : 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.arrow_forward_rounded,
            size: 16.r,
            color: baseColor,
          ),
        ),
      ],
    );
  }
}
