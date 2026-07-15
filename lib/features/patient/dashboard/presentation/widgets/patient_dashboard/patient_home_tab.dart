import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/widgets/animations/fade_in_slide.dart';
import 'package:medi_connect/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/patient/dashboard/presentation/widgets/patient_dashboard/patient_action_banners.dart';
import 'package:medi_connect/features/patient/dashboard/presentation/widgets/patient_dashboard/patient_banner_carousel.dart';
import 'package:medi_connect/features/patient/dashboard/presentation/widgets/patient_dashboard/patient_health_overview.dart';
import 'package:medi_connect/features/patient/dashboard/presentation/widgets/patient_dashboard/patient_premium_banner.dart';
import 'package:medi_connect/features/patient/dashboard/presentation/widgets/patient_dashboard/patient_specialities_section.dart';
import 'package:medi_connect/features/patient/dashboard/presentation/widgets/patient_dashboard/patient_upcoming_appointments.dart';

class PatientHomeTab extends StatelessWidget {
  const PatientHomeTab({super.key});

  static const _sections = [
    PatientActionBanners(),
    PatientBannerCarousel(),
    PatientSpecialitiesSection(),
    PatientUpcomingAppointments(),
    PatientHealthOverview(),
    PatientPremiumBanner(),
  ];

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<AuthBloc>().add(AuthCheckRequested());
      },
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 16.h),
            sliver: SliverList.separated(
              itemCount: _sections.length,
              separatorBuilder: (_, _) => SizedBox(height: 4.h),
              itemBuilder: (_, index) {
                return FadeInSlide(
                  delay: Duration(milliseconds: index * 120),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: index == 1 ? 0.w : 16.w,
                    ),
                    child: _sections[index],
                  ),
                );
              },
            ),
          ),

          SliverToBoxAdapter(child: SizedBox(height: 60.h)),
        ],
      ),
    );
  }
}
