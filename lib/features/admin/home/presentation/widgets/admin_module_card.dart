import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/features/admin/home/domain/entities/admin_dashboard_module_entity.dart';
import 'package:medi_connect/features/admin/home/presentation/widgets/admin_module_card_badge.dart';
import 'package:medi_connect/features/admin/home/presentation/widgets/admin_module_card_body.dart';
import 'package:medi_connect/features/admin/home/presentation/widgets/admin_module_card_footer.dart';

/// Module card: proportional gradient badge (top 55%) + info section (bottom 45%).
/// Staggered entrance animation + hover lift.
class AdminModuleCard extends StatefulWidget {
  final AdminDashboardModuleEntity module;
  final VoidCallback onTap;
  final Duration entranceDelay;

  const AdminModuleCard({
    super.key,
    required this.module,
    required this.onTap,
    this.entranceDelay = Duration.zero,
  });

  @override
  State<AdminModuleCard> createState() => _AdminModuleCardState();
}

class _AdminModuleCardState extends State<AdminModuleCard>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late final AnimationController _ctrl;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 380),
    );
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    Future.delayed(widget.entranceDelay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = Color(widget.module.colorHex);

    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              transform: _hovered
                  ? Matrix4.translationValues(0, -5, 0)
                  : Matrix4.identity(),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(
                  color: _hovered
                      ? base.withValues(alpha: 0.3)
                      : Colors.black.withValues(alpha: isDark ? 0.0 : 0.06),
                ),
                boxShadow: [
                  BoxShadow(
                    color: _hovered
                        ? base.withValues(alpha: 0.22)
                        : Colors.black.withValues(alpha: isDark ? 0.3 : 0.07),
                    blurRadius: _hovered ? 24 : 10,
                    offset: Offset(0, _hovered ? 10 : 3),
                  ),
                ],
              ),
              // ── Layout: badge 55% / info 45% ──────────────────────────
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon badge — proportional top section
                    Expanded(
                      flex: 55,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 0),
                        child: AdminModuleCardBadge(module: widget.module),
                      ),
                    ),
                    // Info section — title, description, footer
                    Expanded(
                      flex: 45,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(12.w, 8.h, 12.w, 12.h),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AdminModuleCardBody(
                              module: widget.module,
                              isDark: isDark,
                            ),
                            AdminModuleCardFooter(
                              countText: widget.module.countText,
                              baseColor: base,
                              isDark: isDark,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
