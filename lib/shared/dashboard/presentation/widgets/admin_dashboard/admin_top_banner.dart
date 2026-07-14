import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';

class AdminTopBanner extends StatelessWidget {
  final VoidCallback? onMenuPressed;
  final String adminName;

  const AdminTopBanner({
    super.key,
    this.onMenuPressed,
    this.adminName = "Super Admin",
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    return Container(
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF312E81), // Deep indigo/blue matching design
            Color(0xFF4338CA),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (onMenuPressed != null) ...[
            Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: IconButton(
                icon: const Icon(Icons.menu, color: Colors.white),
                onPressed: onMenuPressed,
              ),
            ),
            SizedBox(width: 16.w),
          ],
          // Logo & Title
          Container(
            padding: EdgeInsets.all(8.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.health_and_safety,
              color: AppColors.primary,
              size: 28.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                String name = adminName;
                String? profilePhoto;

                if (state is Authenticated) {
                  final user = state.user;
                  final first = user.firstName.trim();
                  final last = user.lastName.trim();
                  if (first.isNotEmpty || last.isNotEmpty) {
                    name = [first, last].where((s) => s.isNotEmpty).join(' ');
                  }
                  if (user.profilePhoto != null &&
                      user.profilePhoto!.trim().isNotEmpty) {
                    profilePhoto = user.profilePhoto!.trim();
                  }
                }

                return Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Good Afternoon,",
                            style: AppTextStyles.labelMedium.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          Text(
                            name.isEmpty ? adminName : name,
                            style: AppTextStyles.titleLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Welcome back to Hospital Management System",
                            style: AppTextStyles.labelSmall.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Date & Time
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Row(
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                DateFormat('MMM').format(now).toUpperCase(),
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormat('dd').format(now),
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 12.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                DateFormat('dd MMMM yyyy').format(now),
                                style: AppTextStyles.labelMedium.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormat('EEEE').format(now),
                                style: AppTextStyles.labelSmall.copyWith(
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.w),
                    // Avatar
                    CircleAvatar(
                      radius: 24.r,
                      backgroundColor: Colors.white,
                      child: profilePhoto != null
                          ? ClipOval(
                              child: CustomImageView(
                                imagePath: profilePhoto,
                                width: 44.r,
                                height: 44.r,
                                fit: BoxFit.cover,
                              ),
                            )
                          : CircleAvatar(
                              radius: 22.r,
                              backgroundColor: AppColors.primary,
                              child: Text(
                                name.isNotEmpty ? name[0].toUpperCase() : 'A',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
