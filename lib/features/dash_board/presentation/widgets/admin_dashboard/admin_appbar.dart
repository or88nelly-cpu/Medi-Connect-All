import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/utils/constants/app_assets.dart';
import 'package:medi_connect/core/utils/constants/app_fonts.dart';
import 'package:medi_connect/core/utils/dashboard_utils.dart';
import 'package:medi_connect/core/utils/profile_image_helper.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/dashboard_tab_cubit.dart';

import 'package:shimmer/shimmer.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_strings.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';

class AdminAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDashoard;
  const AdminAppbar({super.key, required this.isDashoard});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      flexibleSpace: isDashoard ? _body() : null,
    );
  }

  Widget _body() {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading || state is AuthInitial) {
          return _loader();
        }

        String name = "Administrator";
        String? profileImage;
        String accessLevel = "Super Admin";

        if (state is Authenticated) {
          final user = state.user;
          name =
              user.name ??
              (user.firstName != null
                  ? "${user.firstName} ${user.lastName ?? ''}".trim()
                  : "Administrator");

          accessLevel =
              user.accessLevel ??
              (user.role == 'admin' ? "Super Admin" : user.role.toUpperCase());

          profileImage = ProfileImageHelper.resolveImagePath(
            user.profileImage,

            user.role,
            user.gender,
          );
        }
        bool isDark = Theme.of(context).brightness == Brightness.dark;

        return InkWell(
          splashColor: AppColors.surface,
          hoverColor: AppColors.surface,
          onTap: () {
            context.read<DashboardTabCubit>().setTab(4);
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 8.h,
            ).copyWith(left: 60.w),
            decoration: BoxDecoration(
              color: isDark ? Color(0xff171F33) : Color(0xffF7F9FB),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DashboardUtils.getWelcomeMessage(),
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontFamily: AppFonts.inter,
                        fontSize: 10.sp,
                        height: 1,
                      ),
                    ),
                    Text(
                      name,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontFamily: AppFonts.inter,
                        fontSize: 13.sp,
                        height: 1.5,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CustomImageView(
                          imagePath: profileImage ?? "",
                          borderRadius: 100.r,
                          fit: BoxFit.cover,
                          width: 40.r,
                          height: 40.r,
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.admin_panel_settings,
                          size: 12.r,
                          color: AppColors.primary,
                        ),
                        Text(
                          accessLevel,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontFamily: AppFonts.inter,
                            fontSize: 10.sp,
                            height: 1,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    // Text(
                    //   DashboardUtils.getCurrentDate(),
                    //   style: AppTextStyles.bodyMedium.copyWith(
                    //     fontFamily: AppFonts.inter,
                    //     fontSize: 10.sp,

                    //     color: AppColors.textPrimary,
                    //   ),
                    // ),
                    // Text(
                    //   DashboardUtils.getCurrentTime(),
                    //   style: AppTextStyles.bodyMedium.copyWith(
                    //     fontFamily: AppFonts.inter,
                    //     fontSize: 10.sp,
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        );
        //width: double.infinity,
        //padding: EdgeInsets.all(20.r),
      },
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(75.h);
  Widget _loader() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: double.infinity,
        height: 70.h,
        color: Colors.white,
      ),
    );
  }
}
