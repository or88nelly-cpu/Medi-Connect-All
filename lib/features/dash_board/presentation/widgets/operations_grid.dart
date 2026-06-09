import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class OperationsGrid extends StatelessWidget {
  const OperationsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: MediaQuery.of(context).size.width > 600.w ? 4 : 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12.w,
      mainAxisSpacing: 12.h,
      childAspectRatio: MediaQuery.of(context).size.width > 600.w ? 1.8 : 1.4,
      children: const [
        _NavCardMini(
          title: AppStrings.slotConfig,
          subtitle: AppStrings.slotConfigDesc,
          icon: Icons.calendar_month_outlined,
          route: '/admin/slot-config',
        ),
        _NavCardMini(
          title: AppStrings.auditLogs,
          subtitle: AppStrings.auditLogsDesc,
          icon: Icons.analytics_outlined,
          route: '/admin/audit-logs',
        ),
        _NavCardMini(
          title: AppStrings.notificationLogs,
          subtitle: AppStrings.notificationLogsDesc,
          icon: Icons.history_toggle_off_outlined,
          route: '/admin/notifications',
        ),
        _NavCardMini(
          title: AppStrings.masterData,
          subtitle: AppStrings.masterDataDesc,
          icon: Icons.settings_suggest_outlined,
          route: '/admin/master-data',
        ),
      ],
    );
  }
}

class _NavCardMini extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final String route;

  const _NavCardMini({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.route,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: () => context.push(route),
        child: Padding(
          padding: EdgeInsets.all(12.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
             Row(
               children: [
                 Icon(icon, size: 20.r, color: AppColors.primary),
                 SizedBox(width: 6.w,),
                 Expanded(
                   child: Text(
                     title.toUpperCase(),
                     style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold,
                     fontSize: 10.sp, ),
                     maxLines: 1,
                     overflow: TextOverflow.ellipsis,
                   ),
                 )
               ],
             )
             ,
              SizedBox(height: 2.h),
              Text(
                subtitle,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10.sp,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
