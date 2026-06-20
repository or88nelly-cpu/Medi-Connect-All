import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/custom_scaffold.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/utils/department_utils.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/modules/staff/department/pages/customer_care.dart';

class StaffOperationsPage extends StatelessWidget {
  const StaffOperationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String departmentTitle = 'Staff';
        if (state is Authenticated) {
          final dept = state.user.department;
          if (dept != null && dept.isNotEmpty) {
            departmentTitle = dept;
          }
        }

        return CustomScaffold(
          customAppbar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary(context),
                size: 20.r,
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  departmentTitle,
                  style: AppTextStyles.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary(context),
                    fontSize: 18.sp,
                  ),
                ),
                Text(
                  'Operations',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(1.h),
              child: Divider(height: 1, color: AppColors.border(context)),
            ),
          ),
          body: getWidgetForDepartment(departmentTitle),
        );
      },
    );
  }
}

Widget getWidgetForDepartment(String value) {
  final department = getDepartment(value);
  switch (department) {
    case Department.customerCare:
      return CustomerCare();
    case Department.marketing:
    case Department.finance:
    case Department.purchase:
    case Department.pharmacy:
    case Department.hr:
    default:
      return Container();
  }
}
