import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/shared/auth/domain/entities/user_entity.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/admin_drawer.dart';
import 'package:medi_connect/modules/admin/home/widgets/dashboard_header.dart';
import 'package:medi_connect/modules/admin/home/widgets/department_list_home.dart';
import 'package:medi_connect/modules/admin/home/widgets/extra_card.dart';

class AdminHomeMobile extends StatelessWidget {
  final UserEntity? user;

  const AdminHomeMobile({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      drawer: const AdminDrawer(),
      appBarNeeded: false,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          vertical: 20.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: DashboardHeader(user: user),
            ),
            SizedBox(height: 20.h),
            const DepartmentListHome(),
            SizedBox(height: 20.h),
            const ExtraCard(),
          ],
        ),
      ),
    );
  }
}
