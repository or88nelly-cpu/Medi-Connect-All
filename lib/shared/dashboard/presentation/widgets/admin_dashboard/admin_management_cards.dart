import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/core/navigation/route_names.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/dashboard_widgets_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/dashboard_widgets_state.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/dashboard_widgets_event.dart';
import 'package:medi_connect/core/utils/icon_utils.dart'; // We'll create this to map string to IconData
import 'package:medi_connect/core/utils/color_utils.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_dashboard/items/management_card_item.dart';

class AdminManagementCards extends StatelessWidget {
  const AdminManagementCards({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, dynamic>> cards = [
      {
        'title': 'Staff Management',
        'subtitle': 'Manage doctors, nurses,\nemployees and staff details',
        'icon': Icons.group, // In a real app you could use an image/custom icon
        'color': const Color(0xFF0F6FFF),
        'route': '/admin/staff',
      },
      {
        'title': 'Patient Management',
        'subtitle': 'Manage patients, admissions,\nappointments and records',
        'icon': Icons.healing,
        'color': const Color(0xFF22C55E),
        'route': '/admin/patients',
      },
      {
        'title': 'Hospital Management',
        'subtitle': 'Manage hospital, branches,\nwards, rooms and facilities',
        'icon': Icons.business,
        'color': const Color(0xFF3B82F6),
        'route': RouteNames.adminDepartments,
      },
      {
        'title': 'Inventory Management',
        'subtitle': 'Manage medicines, inventory,\npurchase and stock',
        'icon': Icons.inventory,
        'color': const Color(0xFFF59E0B),
        'route': '/admin/inventory',
      },
      {
        'title': 'Finance Management',
        'subtitle': 'Manage billing, payments,\nexpenses and accounts',
        'icon': Icons.account_balance_wallet,
        'color': const Color(0xFF8B5CF6),
        'route': '/admin/finance',
      },
      {
        'title': 'Settings',
        'subtitle': 'System settings, roles, permissions\nand configurations',
        'icon': Icons.settings,
        'color': const Color(0xFF64748B),
        'route': RouteNames.adminSettings,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 6, // 6 items in a row exactly like the design
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 1.15, // Make them shorter and wider
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];

        return ManagementCardItem(
          title: card['title'],
          subtitle: card['subtitle'],
          iconData: card['icon'],
          color: card['color'],
          isDark: isDark,
          onTap: () {
            context.pushNamed(card['route']);
          },
        );
      },
    );
  }
}
