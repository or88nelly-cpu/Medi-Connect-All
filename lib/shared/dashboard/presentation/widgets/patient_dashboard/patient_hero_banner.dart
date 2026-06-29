import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/constants/app_assets.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/functions/profile_image_helper.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';

class PatientHeroBanner extends StatelessWidget {
  const PatientHeroBanner({super.key});

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String name = 'Patient';
        String patientId = 'MC00000';
        String? profileImage;
        String? gender;

        if (state is Authenticated) {
          final user = state.user;
          name =
              user.name ?? ('${user.firstName} ${user.lastName ?? ''}'.trim());
          patientId = user.patientId ?? user.id.substring(0, 7).toUpperCase();
          profileImage = user.profilePhoto;
          gender = user.gender;
        }

        if (profileImage == null && gender != null) {
          profileImage = gender == 'Male'
              ? AppAssets.maleAvatarPng
              : AppAssets.femaleAvatarPng;
        }

        final now = DateTime.now();
        final dayNames = [
          'Sunday',
          'Monday',
          'Tuesday',
          'Wednesday',
          'Thursday',
          'Friday',
          'Saturday',
        ];
        final monthNames = [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December',
        ];
        final dayName = dayNames[now.weekday % 7];
        final monthName = monthNames[now.month - 1];

        return Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 180.h),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFEEF3FF), Color(0xFFF7F5FF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: const Color(0xFFDDE5FF), width: 1),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4F2DFF).withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // ── Decorative wave at bottom ──────────────────────
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20.r),
                    bottomRight: Radius.circular(20.r),
                  ),
                  child: CustomPaint(
                    size: Size(double.infinity, 40.h),
                    painter: _WavePainter(),
                  ),
                ),
              ),

              // ── Main content ───────────────────────────────────
              Padding(
                padding: EdgeInsets.all(18.r),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Left: text info + patient avatar
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Greeting
                          Text(
                            _greeting(),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: const Color(0xFF6B7280),
                              fontSize: 13.sp,
                            ),
                          ),
                          SizedBox(height: 2.h),

                          // Name + wave emoji
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Flexible(
                                child: Text(
                                  name,
                                  style: AppTextStyles.headingMedium.copyWith(
                                    color: const Color(0xFF0F2C59),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.sp,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Text('👋', style: TextStyle(fontSize: 18.sp)),
                            ],
                          ),
                          SizedBox(height: 8.h),

                          // Patient ID chip
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: const Color(0xFFDDE5FF),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.07,
                                  ),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.person_outline,
                                  size: 13.r,
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'Patient ID: $patientId',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12.h),

                          // Tagline
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.favorite_outline,
                                size: 16.r,
                                color: AppColors.primary,
                              ),
                              SizedBox(width: 6.w),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'We are here to',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: const Color(0xFF6B7280),
                                      fontSize: 11.sp,
                                    ),
                                  ),
                                  Text(
                                    'care for you',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          SizedBox(height: 14.h),

                          // Patient avatar
                          Container(
                            width: 70.r,
                            height: 70.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primary.withValues(alpha: 0.2),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.12,
                                  ),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: CustomImageView(
                                imagePath: ProfileImageHelper.resolveImagePath(
                                  profileImage,
                                  'patient',
                                  state is Authenticated
                                      ? state.user.gender
                                      : null,
                                ),
                                borderRadius: 35.r,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 12.w),

                    // Right: date card + hospital image
                    Expanded(
                      flex: 4,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Date card
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 10.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14.r),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.10,
                                  ),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Icon(
                                  Icons.calendar_month_rounded,
                                  color: AppColors.primary,
                                  size: 22.r,
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  '${now.day}',
                                  style: TextStyle(
                                    fontSize: 28.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF0F2C59),
                                    height: 1.1,
                                  ),
                                ),
                                Text(
                                  '$monthName ${now.year}',
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: const Color(0xFF6B7280),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Container(
                                  height: 2.h,
                                  width: 24.w,
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(2.r),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  dayName,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 8.h),

                          // Hospital illustration placeholder
                          Container(
                            height: 80.h,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.r),
                              gradient: const LinearGradient(
                                colors: [Color(0xFFECF3FF), Color(0xFFF0F8FF)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Stack(
                              children: [
                                // Sky background
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.r),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            Color(0xFFDBECFF),
                                            Color(0xFFEDF5FF),
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // Hospital building (simplified icon)
                                Center(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 38.r,
                                        height: 38.r,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            8.r,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFFDDE5FF),
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.local_hospital_rounded,
                                          color: AppColors.primary,
                                          size: 22.r,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        'HOSPITAL',
                                        style: TextStyle(
                                          fontSize: 8.sp,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF4F6E9A),
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF4F2DFF).withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.6);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.2,
      size.width * 0.5,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.8,
      size.width,
      size.height * 0.4,
    );
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_WavePainter oldDelegate) => false;
}
