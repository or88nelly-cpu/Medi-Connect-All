import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/constants/app_assets.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/features/patient/booking/presentation/bloc/speciality_booking_bloc.dart';
import 'package:medi_connect/features/patient/booking/presentation/bloc/speciality_booking_state.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Doctor Info Card
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class BookingDoctorInfoCard extends StatelessWidget {
  final dynamic user;
  final dynamic doc;
  final int exp;
  final Color cardBg;
  final Color textColor;
  final String specialityName;

  const BookingDoctorInfoCard({
    super.key,
    required this.user,
    required this.doc,
    required this.exp,
    required this.cardBg,
    required this.textColor,
    required this.specialityName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(36.r),
                child: CustomImageView(
                  imagePath: user.profilePhoto ?? "",
                  width: 72.r,
                  height: 72.r,
                  fit: BoxFit.cover,
                  errorWidget: Image.asset(
                    user.gender == 'Male'
                        ? AppAssets.maleAvatarPng
                        : AppAssets.femaleAvatarPng,
                    width: 72.r,
                    height: 72.r,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 14.r,
                  height: 14.r,
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.surface, width: 2),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.fullName,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 15.sp,
                        color: textColor,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(Icons.verified_rounded, color: const Color(0xFF3B5BFD), size: 14.r),
                  ],
                ),
                SizedBox(height: 3.h),
                Text(
                  doc?.qualification ?? 'Consultant Cardiologist',
                  style: TextStyle(color: Colors.grey, fontSize: 11.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.h),
                Wrap(
                  spacing: 6.w,
                  runSpacing: 4.h,
                  children: [
                    _buildBadge(Icons.business_center_outlined, '$exp+ Years Experience'),
                    _buildBadge(Icons.school_outlined, 'MBBS, MD, DM'),
                    _buildBadge(Icons.star_rounded, '4.9 (128 reviews)', iconColor: const Color(0xFFFFB000)),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFFECEF),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Icon(Icons.favorite_rounded, color: const Color(0xFFFF296D), size: 24.r),
                SizedBox(height: 4.h),
                Text(
                  specialityName,
                  style: TextStyle(color: const Color(0xFFFF296D), fontSize: 9.sp, fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label, {Color? iconColor}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(8.r)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10.r, color: iconColor ?? Colors.grey.shade600),
          SizedBox(width: 3.w),
          Text(label, style: TextStyle(color: Colors.grey.shade700, fontSize: 7.5.sp, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Reason For Visit (Stateless, Bloc-driven)
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class BookingReasonInput extends StatelessWidget {
  final Color cardBg;
  final Color textColor;

  const BookingReasonInput({super.key, required this.cardBg, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reason for Visit',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w900, color: const Color(0xFF0F172A)),
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.border(context)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                onChanged: (val) {
                  context.read<SpecialityBookingBloc>().add(UpdateReason(reason: val));
                },
                maxLines: 3,
                style: TextStyle(color: textColor, fontSize: 11.sp),
                decoration: InputDecoration(
                  hintText: "Tell us the reason for your visit (Optional)\nE.g. Chest pain, regular checkup...",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 10.sp),
                  border: InputBorder.none,
                ),
              ),
              BlocBuilder<SpecialityBookingBloc, SpecialityBookingState>(
                builder: (context, state) {
                  final len = state.reason?.length ?? 0;
                  return Text(
                    '$len/200',
                    style: TextStyle(color: Colors.grey, fontSize: 8.sp, fontWeight: FontWeight.bold),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Select Patient Section
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class BookingPatientSelector extends StatelessWidget {
  final Color cardBg;
  final Color textColor;

  const BookingPatientSelector({super.key, required this.cardBg, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Patient',
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w900, color: const Color(0xFF0F172A)),
        ),
        SizedBox(height: 10.h),
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            String patientName = 'Likhin Nelliyotan';
            String gender = 'Male';
            String? photo;
            if (authState is Authenticated) {
              patientName = authState.user.fullName;
              gender = authState.user.gender ?? 'Male';
              photo = authState.user.profilePhoto;
            }

            return Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFF3B5BFD)),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: CustomImageView(
                      imagePath: photo ?? "",
                      width: 40.r,
                      height: 40.r,
                      fit: BoxFit.cover,
                      errorWidget: Image.asset(
                        gender == 'Male' ? AppAssets.maleAvatarPng : AppAssets.femaleAvatarPng,
                        width: 40.r,
                        height: 40.r,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patientName,
                          style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w900, color: textColor),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '$gender Ã¢â‚¬Â¢ 31 Years Ã¢â‚¬Â¢ AB+',
                          style: TextStyle(fontSize: 9.sp, color: Colors.grey, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.check_circle_rounded, color: const Color(0xFF3B5BFD), size: 20.r),
                ],
              ),
            );
          },
        ),
        SizedBox(height: 10.h),
        Container(
          width: double.infinity,
          height: 44.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade400, style: BorderStyle.none),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, color: AppColors.primary, size: 16.r),
              SizedBox(width: 4.w),
              Text(
                'Add Another Patient',
                style: TextStyle(color: AppColors.primary, fontSize: 11.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
// Stats Row
// â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
class BookingStatsRow extends StatelessWidget {
  final bool isDark;

  const BookingStatsRow({super.key, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatBox(Icons.people_outline_rounded, '32+', 'Patients/Day'),
          _buildStatBox(Icons.calendar_today_outlined, '1200+', 'Appointments'),
          _buildStatBox(Icons.thumb_up_alt_outlined, '98%', 'Patient Satisfaction'),
          _buildStatBox(Icons.chat_bubble_outline_rounded, 'Eng, Hin, Mal', 'Languages'),
        ],
      ),
    );
  }

  Widget _buildStatBox(IconData icon, String val, String title) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 18.r),
        SizedBox(height: 4.h),
        Text(val, style: TextStyle(color: const Color(0xFF1E3A8A), fontSize: 11.sp, fontWeight: FontWeight.w900)),
        Text(title, style: TextStyle(color: Colors.grey, fontSize: 7.sp, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
