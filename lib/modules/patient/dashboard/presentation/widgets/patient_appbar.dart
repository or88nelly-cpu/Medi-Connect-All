import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:medi_connect/core/constants/app_assets.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';

class PatientAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PatientAppBar({
    super.key,
    this.notificationCount = 3,
    this.onNotificationTap,
    this.onProfileTap,
  });

  final int notificationCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;

  @override
  Size get preferredSize => Size.fromHeight(72.h);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      automaticallyImplyLeading: false,
      elevation: 0,
      backgroundColor: Colors.transparent,
      toolbarHeight: 72.h,
      titleSpacing: 16.w,
      title: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeOutCubic,
        tween: Tween(begin: -30, end: 0),
        builder: (_, value, child) {
          return Transform.translate(
            offset: Offset(0, value),
            child: Opacity(opacity: 1 - (value.abs() / 30), child: child),
          );
        },
        child: Row(
          children: [
            /// Logo
            Hero(
              tag: "app_logo",
              child: Image.asset(
                AppAssets.logoIconPng,
                width: 38.r,
                height: 38.r,
              ),
            ),

            SizedBox(width: 10.w),

            /// App Name
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "MediConnect",
                  style: TextStyle(
                    color: const Color(0xff0A3BB0),
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                Text(
                  "Connecting Care",
                  style: TextStyle(color: Colors.grey, fontSize: 9.sp),
                ),
              ],
            ),

            SizedBox(width: 12.w),

            /// Search
            Expanded(
              child: GestureDetector(
                onTap: () => context.push('/specialities'),
                child: Hero(
                  tag: "patient_search",
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 42.h,
                    padding: EdgeInsets.symmetric(horizontal: 14.w),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.terminalDarkCard
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search_rounded, color: Colors.grey),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            "Search doctors...",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 11.sp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(width: 12.w),

            /// Notification
            TweenAnimationBuilder<double>(
              tween: Tween(begin: .8, end: 1),
              duration: const Duration(milliseconds: 600),
              curve: Curves.elasticOut,
              builder: (_, scale, child) {
                return Transform.scale(scale: scale, child: child);
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(50),
                    onTap: onNotificationTap,
                    child: Container(
                      padding: EdgeInsets.all(9.r),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.terminalDarkCard
                            : Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.notifications_none_rounded, size: 22.r),
                    ),
                  ),
                  if (notificationCount > 0)
                    Positioned(
                      right: -2,
                      top: -2,
                      child: Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          notificationCount.toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            SizedBox(width: 10.w),

            /// Profile
            BlocBuilder<AuthBloc, AuthState>(
              builder: (_, state) {
                String? profile;
                String? gender;

                if (state is Authenticated) {
                  profile = state.user.profilePhoto;
                  gender = state.user.gender;
                }

                final image = profile != null
                    ? NetworkImage(profile)
                    : AssetImage(
                            gender == "Male"
                                ? AppAssets.maleAvatarPng
                                : AppAssets.femaleAvatarPng,
                          )
                          as ImageProvider;

                return TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 700),
                  tween: Tween(begin: .7, end: 1),
                  curve: Curves.elasticOut,
                  builder: (_, scale, child) {
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: GestureDetector(
                    onTap: onProfileTap,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Hero(
                          tag: "profile_avatar",
                          child: CircleAvatar(
                            radius: 20.r,
                            backgroundImage: image,
                          ),
                        ),

                        Positioned(
                          right: -2,
                          bottom: -2,
                          child: Container(
                            padding: EdgeInsets.all(3.r),
                            decoration: const BoxDecoration(
                              color: AppColors.secondary,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.workspace_premium_rounded,
                              color: Colors.white,
                              size: 10.r,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
