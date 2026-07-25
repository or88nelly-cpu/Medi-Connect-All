import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/features/admin/home/domain/entities/admin_dashboard_module_entity.dart';
import 'package:medi_connect/features/admin/home/presentation/widgets/admin_module_icon_mapper.dart';

/// Gradient icon badge — fills the top portion of the module card.
/// Full-width, proportional height via [Expanded] from parent.
class AdminModuleCardBadge extends StatelessWidget {
  final AdminDashboardModuleEntity module;

  const AdminModuleCardBadge({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    final base = Color(module.colorHex);
    final accent = Color(module.accentColorHex);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [base, accent],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: base.withValues(alpha: 0.4),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          AdminModuleIconMapper.fromKey(module.iconKey),
          size: 52.r,
          color: Colors.white,
        ),
      ),
    );
  }
}
