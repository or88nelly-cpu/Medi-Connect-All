import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/navigation/route_names.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_dashboard/items/management_card_item.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_dashboard/models/management_card_data.dart';

/// Renders the 6-item management card grid on the admin dashboard.
/// Each card navigates to its respective management section.
class AdminManagementCards extends StatelessWidget {
  const AdminManagementCards({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);
    final cards = ManagementCardData.all;

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border(context)),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: AppColors.shadow(context),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ManagementSectionHeader(context: context),
          SizedBox(height: 16.h),
          _ManagementCardGrid(cards: cards),
        ],
      ),
    );
  }
}

/// Section header row with icon + label.
class _ManagementSectionHeader extends StatelessWidget {
  final BuildContext context;
  const _ManagementSectionHeader({required this.context});

  @override
  Widget build(BuildContext _) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.grid_view_rounded,
            color: AppColors.primary,
            size: 18,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'Management',
          style: AppTextStyles.titleSmall.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary(context),
          ),
        ),
      ],
    );
  }
}

/// Grid of 3 columns × 2 rows management cards.
class _ManagementCardGrid extends StatelessWidget {
  final List<ManagementCardData> cards;
  const _ManagementCardGrid({required this.cards});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: 3.2,
      ),
      itemCount: cards.length,
      itemBuilder: (context, index) {
        final card = cards[index];
        return ManagementCardItem(
          title: card.title,
          subtitle: card.subtitle,
          iconData: card.icon,
          accentColor: card.accentColor,
          onTap: () => context.push(card.route),
        );
      },
    );
  }
}
