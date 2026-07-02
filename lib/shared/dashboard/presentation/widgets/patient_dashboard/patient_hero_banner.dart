import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_assets.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/hero_banner/patient_greeting.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/hero_banner/patient_id_chip.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/hero_banner/patient_tagline.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/hero_banner/patient_avatar.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/hero_banner/patient_date_card.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/hero_banner/patient_hospital_card.dart';

class PatientHeroBanner extends StatelessWidget {
  const PatientHeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgGradient = isDark
        ? const LinearGradient(
            colors: [Color(0xFF0D1B38), Color(0xFF10192C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [Color(0xFFEEF3FF), Color(0xFFF7F5FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );

    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String name = 'Patient';
        String patientId = 'MC00000';
        String? profileImage;
        String? gender;

        if (state is Authenticated) {
          final user = state.user;
          name = user.fullName;
          patientId = user.id;
          profileImage = user.profilePhoto;
          gender = user.gender;
        }

        if (profileImage == null && gender != null) {
          profileImage = gender == 'Male'
              ? AppAssets.maleAvatarPng
              : AppAssets.femaleAvatarPng;
        }

        return Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: 180.h),
          decoration: BoxDecoration(
            gradient: bgGradient,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColors.border(context), width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.08),
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
                          PatientGreeting(name: name),
                          SizedBox(height: 8.h),
                          PatientIdChip(patientId: patientId),
                          SizedBox(height: 12.h),
                          const PatientTagline(),
                          SizedBox(height: 14.h),
                          PatientAvatar(
                            profileImage: profileImage,
                            gender: gender,
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
                          const PatientDateCard(),
                          SizedBox(height: 8.h),
                          const PatientHospitalCard(),
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
