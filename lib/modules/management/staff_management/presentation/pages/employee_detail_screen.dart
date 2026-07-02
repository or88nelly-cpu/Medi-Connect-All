import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/core/widgets/appbar/common_app_bar.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/functions/profile_image_helper.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/user_details_bloc.dart';

// Components
import 'package:medi_connect/modules/management/staff_management/presentation/widgets/employee_personal_card.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/widgets/employee_work_card.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final String userId;

  const EmployeeDetailScreen({super.key, required this.userId});

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<UserDetailsBloc>().add(FetchUserDetails(widget.userId));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;

    return CustomScaffold(
      customAppbar: const CommonAppBar(title: "Staff Member Details"),
      body: BlocBuilder<UserDetailsBloc, UserDetailsState>(
        builder: (context, state) {
          if (state is UserDetailsLoading || state is UserDetailsInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is UserDetailsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64.r, color: AppColors.error),
                  SizedBox(height: 16.h),
                  Text("Error: ${state.error}", style: AppTextStyles.bodyMedium),
                ],
              ),
            );
          }

          if (state is UserDetailsLoaded) {
            final appUser = state.appUser;
            final user = appUser.user;
            final employee = appUser.employee;

            if (employee == null) {
              return Center(
                child: Text(
                  "No staff/employee records associated with this profile.",
                  style: AppTextStyles.bodyMedium.copyWith(color: textColor),
                ),
              );
            }

            return SingleChildScrollView(
              padding: EdgeInsets.all(16.r),
              child: Column(
                children: [
                  // Hero Card
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 100.r,
                          height: 100.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.accent, width: 3),
                          ),
                          child: CustomImageView(
                            imagePath: ProfileImageHelper.resolveImagePath(
                              user.profilePhoto,
                              'staff',
                              user.gender,
                            ),
                            borderRadius: 50.r,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          user.fullName.trim(),
                          style: AppTextStyles.titleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                        Text(
                          user.email ?? '',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary(context),
                          ),
                        ),
                        SizedBox(height: 8.h),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                          child: Text(
                            "HOSPITAL SUPPORT STAFF",
                            style: TextStyle(
                              color: AppColors.accent,
                              fontWeight: FontWeight.bold,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Child components
                  EmployeePersonalCard(user: user, employee: employee),
                  SizedBox(height: 16.h),
                  EmployeeWorkCard(employee: employee),
                  SizedBox(height: 24.h),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
