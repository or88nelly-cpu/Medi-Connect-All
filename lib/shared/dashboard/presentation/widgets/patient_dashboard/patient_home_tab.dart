import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/patient_hero_banner.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/patient_services_grid.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/patient_promo_footer.dart';

/// The patient home tab — redesigned to match the MediConnect app mockup.
///
/// Layout (top to bottom):
/// 1. Warning banner (if profile is incomplete)
/// 2. [PatientHeroBanner]   – greeting card with name, patient ID, date
/// 3. [PatientServicesGrid] – 12 quick-access service cards in a 2 or 4-col grid
/// 4. [PatientPromoFooter]  – "Your Health, Our Priority" banner
class PatientHomeTab extends StatelessWidget {
  const PatientHomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Warning banner for incomplete profile ────────
          // BlocBuilder<AuthBloc, AuthState>(
          //   builder: (context, state) {
          //     if (state is Authenticated) {
          //       final user = UserModel.fromEntity(state.user);
          //       if (!user.profileCompletionStatus) {
          //         return Container(
          //           margin: EdgeInsets.only(bottom: 16.h),
          //           padding: EdgeInsets.all(16.r),
          //           decoration: BoxDecoration(
          //             color: AppColors.error.withValues(alpha: 0.08),
          //             borderRadius: BorderRadius.circular(16.r),
          //             border: Border.all(
          //               color: AppColors.error.withValues(alpha: 0.2),
          //             ),
          //           ),
          //           child: Row(
          //             children: [
          //               Icon(
          //                 Icons.warning_amber_rounded,
          //                 color: AppColors.error,
          //                 size: 24.r,
          //               ),
          //               SizedBox(width: 12.w),
          //               Expanded(
          //                 child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Text(
          //                       "Profile Incomplete",
          //                       style: AppTextStyles.bodyMedium.copyWith(
          //                         fontWeight: FontWeight.bold,
          //                         color: AppColors.error,
          //                       ),
          //                     ),
          //                     SizedBox(height: 2.h),
          //                     Text(
          //                       "Please complete your remaining steps to generate your UHID.",
          //                       style: AppTextStyles.bodySmall.copyWith(
          //                         color: Colors.grey.shade700,
          //                       ),
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //               SizedBox(width: 8.w),
          //               ElevatedButton(
          //                 onPressed: () {
          //                   context.push(
          //                     RouteNames.patientRegistration,
          //                     extra: {
          //                       'isPatientMode': true,
          //                       'user': user,
          //                     },
          //                   );
          //                 },
          //                 style: ElevatedButton.styleFrom(
          //                   backgroundColor: AppColors.error,
          //                   padding: EdgeInsets.symmetric(
          //                     horizontal: 12.w,
          //                     vertical: 8.h,
          //                   ),
          //                   shape: RoundedRectangleBorder(
          //                     borderRadius: BorderRadius.circular(8.r),
          //                   ),
          //                 ),
          //                 child: Text(
          //                   "Complete Now",
          //                   style: AppTextStyles.bodySmall.copyWith(
          //                     color: Colors.white,
          //                     fontWeight: FontWeight.bold,
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         );
          //       }
          //     }
          //     return const SizedBox.shrink();
          //   },
          // ),

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
