import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class CustomerCareFooter extends StatelessWidget {
  final Map<String, dynamic> stats;

  const CustomerCareFooter({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final double width = MediaQuery.of(context).size.width;

    final widgetBg = AppColors.dashboardCardBg(context);
    final borderColor = AppColors.dashboardCardBorder(context);
    final textColor = AppColors.dashboardTextPrimary(context);
    final labelColor = AppColors.dashboardTextSecondary(context);

    final items = [
      _FooterItem(
        label: AppStrings.walkInPatients,
        value: stats['walk_in_patients']?.toString() ?? "632",
        trend: stats['walk_in_patients_trend']?.toString() ?? "↑ 12.6%",
        icon: Icons.directions_walk_rounded,
        iconBg: const Color(0xFF0F6FFF),
        isTrendPositive: true,
      ),
      _FooterItem(
        label: AppStrings.followUpVisits,
        value: stats['follow_up_visits']?.toString() ?? "413",
        trend: stats['follow_up_visits_trend']?.toString() ?? "↑ 8.4%",
        icon: Icons.sync_rounded,
        iconBg: const Color(0xFF00C2A8),
        isTrendPositive: true,
      ),
      _FooterItem(
        label: AppStrings.avgWaitingTime,
        value:
            "${stats['avg_waiting_time']?.toString() ?? '18'} ${AppStrings.minsSuffix}",
        trend: stats['avg_waiting_time_trend']?.toString() ?? "↓ 3 mins",
        icon: Icons.access_time_rounded,
        iconBg: const Color(0xFF7B61FF),
        isTrendPositive:
            true, // wait, down average waiting time is good, so green text
      ),
      _FooterItem(
        label: AppStrings.enquiriesHandled,
        value: stats['enquiries_handled']?.toString() ?? "286",
        trend: stats['enquiries_handled_trend']?.toString() ?? "↑ 9.7%",
        icon: Icons.headset_mic_rounded,
        iconBg: const Color(0xFFEC4899),
        isTrendPositive: true,
      ),
    ];

    if (width < 750) {
      // Mobile & small tablet: 2x2 grid
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: width < 450 ? 1 : 2,
          crossAxisSpacing: 12.w,
          mainAxisSpacing: 12.h,
          childAspectRatio: 2.6,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          return _buildFooterCard(
            context,
            items[index],
            widgetBg,
            borderColor,
            textColor,
            labelColor,
          );
        },
      );
    } else {
      // Desktop & large tablet: Row of 4 cards
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        decoration: BoxDecoration(
          color: widgetBg,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: borderColor, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.15)
                  : Colors.black.withValues(alpha: 0.02),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: items
              .map(
                (item) => Expanded(
                  child: InkWell(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Clicking Metric: ${item.label}'),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      decoration: BoxDecoration(
                        border: items.indexOf(item) == items.length - 1
                            ? null
                            : Border(
                                right: BorderSide(
                                  color: borderColor,
                                  width: 1.2,
                                ),
                              ),
                      ),
                      child: _buildFooterCardContent(
                        context,
                        item,
                        textColor,
                        labelColor,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );
    }
  }

  Widget _buildFooterCard(
    BuildContext context,
    _FooterItem item,
    Color bg,
    Color borderCol,
    Color textCol,
    Color labelCol,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Clicking Metric: ${item.label}')),
        );
      },
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: borderCol, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: isDark
                  ? Colors.black.withValues(alpha: 0.1)
                  : Colors.black.withValues(alpha: 0.01),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: _buildFooterCardContent(context, item, textCol, labelCol),
      ),
    );
  }

  Widget _buildFooterCardContent(
    BuildContext context,
    _FooterItem item,
    Color textCol,
    Color labelCol,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        // Left Icon in colored circle
        Container(
          width: 44.r,
          height: 44.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: item.iconBg.withValues(alpha: isDark ? 0.15 : 0.08),
          ),
          child: Center(
            child: Icon(item.icon, color: item.iconBg, size: 22.r),
          ),
        ),
        SizedBox(width: 14.w),
        // Metrics texts
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodyXSmall.copyWith(
                  color: labelCol,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 3.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    item.value,
                    style: AppTextStyles.dashboardStatValueSmall.copyWith(
                      color: textCol,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    item.trend,
                    style: AppTextStyles.bodyXSmall.copyWith(
                      color: item.isTrendPositive
                          ? const Color(0xFF22C55E)
                          : const Color(0xFFEF4444),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FooterItem {
  final String label;
  final String value;
  final String trend;
  final IconData icon;
  final Color iconBg;
  final bool isTrendPositive;

  _FooterItem({
    required this.label,
    required this.value,
    required this.trend,
    required this.icon,
    required this.iconBg,
    required this.isTrendPositive,
  });
}
