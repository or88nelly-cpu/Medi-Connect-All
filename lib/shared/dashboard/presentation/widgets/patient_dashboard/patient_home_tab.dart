import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/patient_action_banners.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/patient_banner_carousel.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/patient_specialities_section.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/patient_health_overview.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/patient_premium_banner.dart';

/// The patient home tab — redesigned to match the MediConnect app mockup.
///
/// Layout (top to bottom):
/// 1. [PatientActionBanners]   – Complete Registration and Payment Pending cards side-by-side
/// 2. [PatientBannerCarousel]   – dynamic promotional banner slider
/// 3. [PatientSpecialitiesSection] – 2x4 grid layout of medical specialties
/// 4. [PatientHealthOverview] – Track Health Card and list of 4 vitals side-by-side
/// 5. [PatientPremiumBanner]  – Purple "Go Premium for Better Care" banner
class PatientHomeTab extends StatelessWidget {
  const PatientHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Top Action Banners (Registration & Payment) ────
          const PatientActionBanners(),
          SizedBox(height: 20.h),

          // ── Dynamic Promo Banners (Taller Carousel) ───────────────────────
          const PatientBannerCarousel(),
          SizedBox(height: 20.h),

          // ── Specialties section (2x4 Grid) ──
          const PatientSpecialitiesSection(),
          SizedBox(height: 20.h),

          // ── Health Overview (Vitals & Track Health Card) ──
          const PatientHealthOverview(),
          SizedBox(height: 20.h),

          // ── Purple Promo Premium Banner ────────────────────────────────
          const PatientPremiumBanner(),
          SizedBox(height: 80.h),
        ],
      ),
    );
  }
}
