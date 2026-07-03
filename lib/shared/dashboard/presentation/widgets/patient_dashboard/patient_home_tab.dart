import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/widgets/animations/fade_in_slide.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/patient_action_banners.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/patient_banner_carousel.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/patient_specialities_section.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/patient_upcoming_appointments.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/patient_health_overview.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/patient_premium_banner.dart';

/// The patient home tab — redesigned to match the MediConnect app mockup.
class PatientHomeTab extends StatelessWidget {
  const PatientHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top Action Banners ──
          const FadeInSlide(
            delay: Duration.zero,
            child: PatientActionBanners(),
          ),
          SizedBox(height: 20.h),

          // ── Promo Banners Carousel ──
          const FadeInSlide(
            delay: Duration(milliseconds: 100),
            child: PatientBannerCarousel(),
          ),
          SizedBox(height: 20.h),

          // ── Specialties section ──
          const FadeInSlide(
            delay: Duration(milliseconds: 200),
            child: PatientSpecialitiesSection(),
          ),
          SizedBox(height: 20.h),

          // ── Upcoming Appointments ──
          const FadeInSlide(
            delay: Duration(milliseconds: 300),
            child: PatientUpcomingAppointments(),
          ),
          SizedBox(height: 20.h),

          // ── Health Overview ──
          const FadeInSlide(
            delay: Duration(milliseconds: 400),
            child: PatientHealthOverview(),
          ),
          SizedBox(height: 20.h),

          // ── Purple Promo Premium Banner ──
          const FadeInSlide(
            delay: Duration(milliseconds: 500),
            child: PatientPremiumBanner(),
          ),
          SizedBox(height: 80.h),
        ],
      ),
    );
  }
}
