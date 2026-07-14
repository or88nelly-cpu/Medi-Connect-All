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

    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AdminTopBanner(
            onMenuPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
          SizedBox(height: 20.h),
          
          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(child: AdminDepartmentsGrid()),
                SizedBox(width: 20.w),
                const Expanded(child: AdminSpecialitiesGrid()),
              ],
            )
          else
            const Column(
              children: [
                AdminDepartmentsGrid(),
                SizedBox(height: 20),
                AdminSpecialitiesGrid(),
              ],
            ),

          SizedBox(height: 20.h),
          const AdminManagementCards(),
          SizedBox(height: 20.h),

          if (isDesktop)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(flex: 2, child: AdminQuickActionsGrid()),
                SizedBox(width: 20.w),
                const Expanded(flex: 3, child: AdminRecentActivity()),
              ],
            )
          else
            const Column(
              children: [
                AdminQuickActionsGrid(),
                SizedBox(height: 20),
                AdminRecentActivity(),
              ],
            ),
            
          SizedBox(height: 40.h),
        ],
      ),
    );
  }
}
