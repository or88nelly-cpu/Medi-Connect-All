import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/dashboard_widgets_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/dashboard_widgets_state.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/dashboard_widgets_event.dart';
import 'package:medi_connect/core/utils/icon_utils.dart'; // We'll create this to map string to IconData
import 'package:medi_connect/core/utils/color_utils.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_dashboard/items/management_card_item.dart';

class AdminManagementCards extends StatefulWidget {
  const AdminManagementCards({super.key});

  @override
  State<AdminManagementCards> createState() => _AdminManagementCardsState();
}

class _AdminManagementCardsState extends State<AdminManagementCards> {
  @override
  void initState() {
    super.initState();
    context.read<DashboardWidgetsBloc>().add(const LoadDashboardWidgets());
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocBuilder<DashboardWidgetsBloc, DashboardWidgetsState>(
      builder: (context, state) {
        if (state is DashboardWidgetsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is DashboardWidgetsError) {
          return Center(child: Text(state.failure.message));
        } else if (state is DashboardWidgetsLoaded) {
          final cards = state.managementCards;

          if (cards.isEmpty) return const SizedBox.shrink();

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6, // 6 items in a row
              crossAxisSpacing: 16.w,
              mainAxisSpacing: 16.h,
              childAspectRatio: 1.0,
            ),
            itemCount: cards.length,
            itemBuilder: (context, index) {
              final card = cards[index];
              final color = ColorUtils.fromHex(card.colorCode);
              final icon = IconUtils.fromString(card.icon);

              return ManagementCardItem(
                title: card.title,
                iconData: icon,
                color: color,
                isDark: isDark,
                onTap: () {
                  context.pushNamed(card.route);
                },
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
