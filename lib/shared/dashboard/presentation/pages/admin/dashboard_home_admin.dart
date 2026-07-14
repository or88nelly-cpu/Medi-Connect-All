import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/functions/app_responsive.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_dashboard/admin_top_banner.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_dashboard/admin_departments_grid.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_dashboard/admin_specialities_grid.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_dashboard/admin_management_cards.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_dashboard/admin_quick_actions.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_dashboard/admin_recent_activity.dart';

class DashboardHomeAdmin extends StatelessWidget {
  const DashboardHomeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = AppResponsive.isDesktop(context);

    final bodyContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AdminTopBanner(
          onMenuPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        SizedBox(height: 16.h),
        
        if (isDesktop) ...[
          const AdminDepartmentsGrid(),
          SizedBox(height: 16.h),
          const AdminSpecialitiesGrid(),
        ] else ...[
          const AdminDepartmentsGrid(),
          SizedBox(height: 16.h),
          const AdminSpecialitiesGrid(),
        ],

        SizedBox(height: 16.h),
        const AdminManagementCards(),
        SizedBox(height: 16.h),

        if (isDesktop)
          SizedBox(
            height: 250.h,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Expanded(flex: 2, child: AdminQuickActionsGrid(isExpanded: true)),
                SizedBox(width: 16.w),
                const Expanded(flex: 3, child: AdminRecentActivity(isExpanded: true)),
              ],
            ),
          )
        else
          const Column(
            children: [
              AdminQuickActionsGrid(),
              SizedBox(height: 16),
              AdminRecentActivity(),
            ],
          ),
          
        if (!isDesktop) SizedBox(height: 40.h),
      ],
    );

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: bodyContent,
    );
  }
}
