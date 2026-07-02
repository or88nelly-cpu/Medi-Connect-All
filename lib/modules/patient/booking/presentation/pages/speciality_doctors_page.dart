import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/constants/app_assets.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/modules/patient/speciality/domain/entities/speciality_entity.dart';
import 'package:medi_connect/modules/patient/booking/presentation/bloc/speciality_booking_cubit.dart';
import 'package:medi_connect/modules/patient/booking/presentation/bloc/speciality_booking_state.dart';
import 'package:medi_connect/modules/patient/booking/presentation/pages/doctor_detail_booking_page.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/navigation/patient_bottom_nav_bar.dart';

class SpecialityDoctorsPage extends StatelessWidget {
  final SpecialityEntity speciality;

  const SpecialityDoctorsPage({super.key, required this.speciality});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;

    final gradientColors = speciality.isSurgical
        ? [const Color(0xFFEF4444), const Color(0xFFB91C1C)]
        : [const Color(0xFF3B82F6), const Color(0xFF1D4ED8)];

    final services = _getServices(speciality.name);

    return BlocProvider(
      create: (context) =>
          SpecialityBookingCubit()..loadDoctors(speciality.id, speciality.name),
      child: Builder(
        builder: (context) {
          return CustomScaffold(
            appBarNeeded: true,
            customAppbar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: false,
              toolbarHeight: 64.h,
              titleSpacing: 0,
              title: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    // Circular Back Button
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(8.r),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 8,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.primary,
                          size: 16.r,
                        ),
                      ),
                    ),
                    SizedBox(width: 12.w),
                    // Brand Logo
                    Image.asset(
                      AppAssets.logoIconPng,
                      width: 32.r,
                      height: 32.r,
                    ),
                    SizedBox(width: 6.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'MediConnect',
                          style: TextStyle(
                            color: const Color(0xFF0A3BB0),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          'Connecting Care. Empowering Health.',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 7.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),

                    // Search Button
                    Container(
                      padding: EdgeInsets.all(6.r),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.terminalDarkCard
                            : Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.search,
                        color: isDark ? Colors.white70 : Colors.black87,
                        size: 20.r,
                      ),
                    ),
                    SizedBox(width: 8.w),

                    // Notification Bell
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: EdgeInsets.all(6.r),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.terminalDarkCard
                                : Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.notifications_none_rounded,
                            color: isDark ? Colors.white70 : Colors.black87,
                            size: 20.r,
                          ),
                        ),
                        Positioned(
                          top: -2,
                          right: -2,
                          child: Container(
                            padding: EdgeInsets.all(4.r),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '3',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 7.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 10.w),

                    // Profile Avatar
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, authState) {
                        String? profilePhoto;
                        String? gender;
                        if (authState is Authenticated) {
                          profilePhoto = authState.user.profilePhoto;
                          gender = authState.user.gender;
                        }
                        return Stack(
                          clipBehavior: Clip.none,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(18.r),
                              child: CustomImageView(
                                imagePath: profilePhoto ?? "",
                                width: 36.r,
                                height: 36.r,
                                fit: BoxFit.cover,
                                errorWidget: Image.asset(
                                  gender == 'Male'
                                      ? AppAssets.maleAvatarPng
                                      : AppAssets.femaleAvatarPng,
                                  width: 36.r,
                                  height: 36.r,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: -2,
                              right: -2,
                              child: Container(
                                padding: EdgeInsets.all(2.r),
                                decoration: const BoxDecoration(
                                  color: AppColors.secondary,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.workspace_premium_rounded,
                                  color: Colors.white,
                                  size: 8.r,
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: PatientBottomNavBar(
              currentIndex: 0,
              onTap: (index) {
                context.go('/patient/dashboard');
              },
            ),
            body: BlocBuilder<SpecialityBookingCubit, SpecialityBookingState>(
              builder: (context, state) {
                if (state.status == SpecialityBookingStatus.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docCount = state.doctors.length;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── 2. Top Banner Header with Illustration & Title ──
                      _buildHeaderBanner(context, isDark),

                      // ── 3. Stats Row (Dynamic Doctor Count) ──
                      _buildStatsRow(context, isDark, docCount),
                      SizedBox(height: 24.h),

                      // ── 4. Shortcuts Row ──
                      _buildShortcutsRow(context, isDark),
                      SizedBox(height: 24.h),

                      // ── 5. Our Doctors Section (Only Database Data) ──
                      _buildDoctorsSection(
                        context,
                        state,
                        isDark,
                        cardBg,
                        textColor,
                        gradientColors,
                      ),
                      SizedBox(height: 24.h),

                      // ── 6. Services We Offer ──
                      _buildServicesSection(
                        context,
                        services,
                        isDark,
                        cardBg,
                        textColor,
                      ),
                      SizedBox(height: 24.h),

                      // ── 7. About Section ──
                      _buildAboutSection(context, isDark),
                      SizedBox(height: 24.h),

                      // ── 8. Bottom Support Help Bar ──
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: _buildSupportCard(context, isDark),
                      ),
                      SizedBox(height: 48.h),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderBanner(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF131A2D), const Color(0xFF1F2B48)]
              : [const Color(0xFFF0F6FF), const Color(0xFFE3EDFD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Row(
        children: [
          // Left: anatomical image from database
          SizedBox(
            width: 80.r,
            height: 80.r,
            child: CustomImageView(
              imagePath: speciality.imageUrl ?? "",
              fit: BoxFit.contain,
              errorWidget: Container(
                color: AppColors.primary.withValues(alpha: 0.05),
                child: Icon(
                  Icons.medical_services_outlined,
                  color: AppColors.primary,
                  size: 40.r,
                ),
              ),
            ),
          ),
          SizedBox(width: 20.w),

          // Right: Title & Subtitle descriptions
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  speciality.name,
                  style: AppTextStyles.headingLarge.copyWith(
                    fontWeight: FontWeight.w900,
                    fontSize: 24.sp,
                    color: isDark ? Colors.white : const Color(0xFF0F172A),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  speciality.description ??
                      'Comprehensive expert diagnostics, advanced surgical care, treatment, and lifestyle preventative management.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark ? Colors.white60 : const Color(0xFF475569),
                    fontSize: 11.5.sp,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, bool isDark, int docCount) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        border: Border(bottom: BorderSide(color: AppColors.border(context))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatItem(
            Icons.person_outline_rounded,
            '${docCount}+',
            'Doctors',
          ),
          _buildStatItem(
            Icons.calendar_today_outlined,
            '1200+',
            'Appointments',
          ),
          _buildStatItem(Icons.group_outlined, '15K+', 'Patients'),
          _buildStatItem(Icons.verified_user_outlined, '98%', 'Satisfaction'),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String val, String desc) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.primary, size: 18.r),
        ),
        SizedBox(height: 6.h),
        Text(
          val,
          style: TextStyle(
            color: const Color(0xFF1E3A8A),
            fontSize: 13.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          desc,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 9.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildShortcutsRow(BuildContext context, bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildShortcutItem(
          Icons.calendar_month_outlined,
          'Book Appointment',
          const Color(0xFF3B5BFD),
        ),
        _buildShortcutItem(
          Icons.chat_bubble_outline_rounded,
          'Consult Online',
          const Color(0xFF10B981),
        ),
        _buildShortcutItem(
          Icons.info_outline_rounded,
          'About Department',
          const Color(0xFF8B5CF6),
        ),
        _buildShortcutItem(
          Icons.favorite_border_rounded,
          'Health Packages',
          const Color(0xFFEC4899),
        ),
      ],
    );
  }

  Widget _buildShortcutItem(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 50.r,
          height: 50.r,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Icon(icon, color: color, size: 22.r),
        ),
        SizedBox(height: 6.h),
        SizedBox(
          width: 74.w,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 8.5.sp,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF475569),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorsSection(
    BuildContext context,
    SpecialityBookingState state,
    bool isDark,
    Color cardBg,
    Color textColor,
    List<Color> gradientColors,
  ) {
    final titleWord = speciality.name.toLowerCase().contains('cardio')
        ? 'Cardiologists'
        : (speciality.name.toLowerCase().contains('neuro')
              ? 'Neurologists'
              : 'Doctors');

    // No dummy data as requested
    if (state.doctors.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 24.h),
          child: Text(
            "No doctors registered under ${speciality.name} yet.",
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary(context),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Our $titleWord',
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: 16.sp,
                  color: textColor,
                ),
              ),
              Text(
                'View All >',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),

        // Horizontal scroll row of real database doctors
        SizedBox(
          height: 190.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: state.doctors.length,
            itemBuilder: (context, index) {
              final docInfo = state.doctors[index];
              final exp =
                  docInfo.doctorInfo?.yearsOfExperience ??
                  docInfo.doctorInfo?.experienceYears ??
                  5;

              return Container(
                width: 146.w,
                margin: EdgeInsets.only(right: 12.w),
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: AppColors.border(context)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 10.r,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Avatar bubble with active dot
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(26.r),
                          child: CustomImageView(
                            imagePath: docInfo.user.profilePhoto ?? "",
                            width: 52.r,
                            height: 52.r,
                            fit: BoxFit.cover,
                            errorWidget: Image.asset(
                              docInfo.user.gender == 'Male'
                                  ? AppAssets.maleAvatarPng
                                  : AppAssets.femaleAvatarPng,
                              width: 52.r,
                              height: 52.r,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 11.r,
                            height: 11.r,
                            decoration: BoxDecoration(
                              color: const Color(0xFF22C55E),
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),

                    // Names
                    Text(
                      docInfo.user.fullName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 10.5.sp,
                        color: textColor,
                      ),
                    ),
                    Text(
                      docInfo.doctorInfo?.qualification ?? 'Specialist MD',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 8.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),

                    // Reviews / Exp line
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: const Color(0xFFFFB000),
                          size: 10.r,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '4.9 (128) • ${exp}+ Yrs',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 7.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),

                    // Book Now Button
                    GestureDetector(
                      onTap: () {
                        context.read<SpecialityBookingCubit>().selectDoctor(
                          docInfo,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) => BlocProvider.value(
                              value: context.read<SpecialityBookingCubit>(),
                              child: DoctorDetailBookingPage(
                                gradientColors: gradientColors,
                                specialityName: speciality.name,
                              ),
                            ),
                          ),
                        );
                      },
                      child: Container(
                        height: 26.h,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFF3B5BFD),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Book Now',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildServicesSection(
    BuildContext context,
    List<Map<String, String>> services,
    bool isDark,
    Color cardBg,
    Color textColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Services We Offer',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: 16.sp,
              color: textColor,
            ),
          ),
        ),
        SizedBox(height: 12.h),

        // Grid view
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          itemCount: services.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.w,
            mainAxisSpacing: 10.h,
            childAspectRatio: 2.8,
          ),
          itemBuilder: (context, index) {
            final item = services[index];
            final colorIdx = index % 4;
            final itemColor = colorIdx == 0
                ? const Color(0xFFFF296D)
                : (colorIdx == 1
                      ? const Color(0xFF3B5BFD)
                      : (colorIdx == 2
                            ? const Color(0xFF10B981)
                            : const Color(0xFFF59E0B)));

            return Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppColors.border(context)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: itemColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.medical_services_outlined,
                      color: itemColor,
                      size: 14.r,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item['name']!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9.5.sp,
                            fontWeight: FontWeight.w900,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          item['desc']!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 7.5.sp,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAboutSection(BuildContext context, bool isDark) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.terminalDarkCard : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Organ image (uses speciality imageUrl directly)
          Container(
            width: 70.r,
            height: 70.r,
            padding: EdgeInsets.all(6.r),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.r),
              child: CustomImageView(
                imagePath: speciality.imageUrl ?? "",
                fit: BoxFit.contain,
                errorWidget: Icon(
                  Icons.health_and_safety_outlined,
                  color: AppColors.primary,
                  size: 30.r,
                ),
              ),
            ),
          ),
          SizedBox(width: 14.w),

          // Bullet points Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'About ${speciality.name}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1E3A8A),
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'This department is fully equipped with advanced clinical machinery and a dedicated healthcare response team.',
                  style: TextStyle(
                    fontSize: 9.5.sp,
                    height: 1.3,
                    color: Colors.grey.shade700,
                  ),
                ),
                SizedBox(height: 12.h),

                // Grid of bullets
                GridView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 4,
                  ),
                  children: [
                    _buildCheckRow('Advanced Tech'),
                    _buildCheckRow('Personalized Care'),
                    _buildCheckRow('Expert Team'),
                    _buildCheckRow('24/7 Response'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckRow(String label) {
    return Row(
      children: [
        Icon(
          Icons.check_circle_outline_rounded,
          color: AppColors.primary,
          size: 10.r,
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 8.sp,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSupportCard(BuildContext context, bool isDark) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: isDark ? AppColors.terminalDarkCard : const Color(0xFFEEF2F6),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.r),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.headset_mic_outlined,
              color: AppColors.primary,
              size: 24.r,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need help choosing a specialist?',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1E3A8A),
                  ),
                ),
                Text(
                  'Talk to our care team for suggestions.',
                  style: TextStyle(fontSize: 9.sp, color: Colors.grey),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Support line connecting...')),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: const Color(0xFF1D4ED8),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Text(
                'Talk to Care Team',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> _getServices(String name) {
    final clean = name.toLowerCase();
    if (clean.contains('cardio')) {
      return [
        {'name': 'ECG', 'desc': 'Electrocardiogram'},
        {'name': 'ECHO', 'desc': 'Echocardiogram'},
        {'name': 'TMT', 'desc': 'Treadmill Test'},
        {'name': 'Holter Monitor', 'desc': '24/48 Hour Monitoring'},
        {'name': 'Angiography', 'desc': 'Advanced Imaging'},
        {'name': 'Pacemaker', 'desc': 'Implantation'},
        {'name': 'Heart Checkup', 'desc': 'Comprehensive'},
        {'name': 'Preventive Care', 'desc': 'Lifestyle Management'},
      ];
    } else if (clean.contains('neuro')) {
      return [
        {'name': 'EEG', 'desc': 'Brainwave Monitoring'},
        {'name': 'MRI Scan', 'desc': 'High-Res Neuro Imaging'},
        {'name': 'EMG Test', 'desc': 'Muscle & Nerve Function'},
        {'name': 'Sleep Study', 'desc': 'Polysomnography'},
        {'name': 'Stroke Care', 'desc': 'Emergency Management'},
        {'name': 'Epilepsy Clinic', 'desc': 'Seizure Control'},
        {'name': 'Neuropathy Care', 'desc': 'Peripheral Nerve Care'},
        {'name': 'Rehabilitation', 'desc': 'Physical Recovery'},
      ];
    } else if (clean.contains('ortho')) {
      return [
        {'name': 'X-Ray', 'desc': 'Bone Scan & Imaging'},
        {'name': 'Joint Injection', 'desc': 'Pain Management'},
        {'name': 'Cast & Splint', 'desc': 'Fracture Support'},
        {'name': 'Physiotherapy', 'desc': 'Guided Exercises'},
        {'name': 'Arthroscopy', 'desc': 'Joint Surgery'},
        {'name': 'Spine Care', 'desc': 'Back & Neck Therapy'},
        {'name': 'Bone Density', 'desc': 'Osteoporosis Scan'},
        {'name': 'Arthroplasty', 'desc': 'Joint Replacement'},
      ];
    }
    return [
      {'name': 'General Consultation', 'desc': 'Doctor Appointment'},
      {'name': 'Preventive Screening', 'desc': 'Regular Diagnostics'},
      {'name': 'Therapy Session', 'desc': 'Expert Guidance'},
      {'name': 'Lab Referrals', 'desc': 'Blood & Pathology Tests'},
      {'name': 'Prescription Refills', 'desc': 'Medicine Management'},
      {'name': 'Wellness Counsel', 'desc': 'Lifestyle & Diet Tips'},
      {'name': 'Emergency Check', 'desc': 'Priority Diagnostics'},
      {'name': 'Vaccination Plan', 'desc': 'Immunization Checks'},
    ];
  }
}
