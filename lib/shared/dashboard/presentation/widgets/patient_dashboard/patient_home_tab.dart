import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/patient_hero_banner.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/patient_services_grid.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/patient_promo_footer.dart';

/// The patient home tab — redesigned to match the MediConnect app mockup.
///
/// Layout (top to bottom):
/// 1. [PatientHeroBanner]   – greeting card with name, patient ID, date
/// 2. [PatientServicesGrid] – 12 quick-access service cards in a 2 or 4-col grid
/// 3. [PatientPromoFooter]  – "Your Health, Our Priority" banner
class PatientHomeTab extends StatelessWidget {
  const PatientHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Hero banner ─────────────────────────────────
          const PatientHeroBanner(),
          SizedBox(height: 24.h),

          // ── 12-item services grid ───────────────────────
          const PatientServicesGrid(),
          SizedBox(height: 24.h),

          // ── Promo footer ────────────────────────────────
          const PatientPromoFooter(),
          SizedBox(height: 80.h),
        ],
      ),
    );
  }
}
