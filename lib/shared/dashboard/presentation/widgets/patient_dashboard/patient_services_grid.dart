import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/patient_dashboard/patient_service_item.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/modules/patient/booking/presentation/pages/booking_flow_page.dart';
import 'package:medi_connect/modules/patient/find_doctor/presentation/pages/find_doctor_page.dart';
import 'package:medi_connect/modules/patient/health/presentation/pages/health_page.dart';
import 'package:medi_connect/modules/patient/prescriptions/presentation/pages/prescriptions_page.dart';
import 'package:medi_connect/modules/patient/shared/placeholder_page.dart';

/// The 12-item quick-service grid shown on the patient home screen.
/// Every card now navigates to its dedicated page.
class PatientServicesGrid extends StatelessWidget {
  const PatientServicesGrid({super.key});

  // ── Navigation helpers ───────────────────────────────────────────────────

  /// Pushes a new page and provides existing BLoC instances to it.
  void _pushWithBlocs(BuildContext context, Widget page) {
    final authBloc = context.read<AuthBloc>();
    DoctorStaffBloc? doctorBloc;
    try {
      doctorBloc = context.read<DoctorStaffBloc>();
    } catch (_) {}

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) {
          final providers = <BlocProvider>[
            BlocProvider.value(value: authBloc),
          ];
          if (doctorBloc != null) {
            providers.add(BlocProvider.value(value: doctorBloc));
          }
          return MultiBlocProvider(providers: providers, child: page);
        },
      ),
    );
  }

  void _openBooking(BuildContext context) {
    _pushWithBlocs(context, const BookingFlowPage());
  }

  void _openFindDoctor(BuildContext context) {
    _pushWithBlocs(context, const FindDoctorPage());
  }

  void _openHealth(BuildContext context) {
    _pushWithBlocs(context, const HealthPage());
  }

  void _openPrescriptions(BuildContext context) {
    _pushWithBlocs(context, const PrescriptionsPage());
  }

  void _openPlaceholder(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Color> gradient,
    String? description,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PlaceholderFeaturePage(
          title: title,
          icon: icon,
          gradientColors: gradient,
          description: description ??
              'This feature is coming soon. Stay tuned for updates!',
        ),
      ),
    );
  }

  // ── Build ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final services = _buildServices(context);

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = constraints.maxWidth > 600 ? 4 : 2;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Services',
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
            ),
            SizedBox(height: 12.h),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: services.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 10.w,
                mainAxisSpacing: 10.h,
                childAspectRatio: 0.85,
              ),
              itemBuilder: (context, index) => services[index],
            ),
          ],
        );
      },
    );
  }

  List<PatientServiceItem> _buildServices(BuildContext context) {
    return [
      // 1. Book Appointment → full 5-step booking flow
      PatientServiceItem(
        icon: Icons.calendar_today_rounded,
        title: 'Book\nAppointment',
        description: 'Book doctor appointments easily',
        gradientColors: const [Color(0xFF4F7CFF), Color(0xFF5B42F3)],
        onTap: () => _openBooking(context),
      ),

      // 2. Find Doctors → specialty grid → doctor list
      PatientServiceItem(
        icon: Icons.search_rounded,
        title: 'Find\nDoctors',
        description: 'Search doctors by specialization',
        gradientColors: const [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
        onTap: () => _openFindDoctor(context),
      ),

      // 3. Health Records → placeholder (records tab already in dashboard)
      PatientServiceItem(
        icon: Icons.assignment_rounded,
        title: 'Health\nRecords',
        description: 'View your medical history & reports',
        gradientColors: const [Color(0xFF00C2A8), Color(0xFF00897B)],
        onTap: () => _openPlaceholder(
          context,
          title: 'Health Records',
          icon: Icons.assignment_rounded,
          gradient: const [Color(0xFF00C2A8), Color(0xFF00897B)],
          description:
              'Your health records and lab reports will be available here. Visit the Records tab in the bottom navigation for now.',
        ),
      ),

      // 4. Prescriptions → previous consultations list
      PatientServiceItem(
        icon: Icons.medication_rounded,
        title: 'Prescriptions',
        description: 'View & download your prescriptions',
        gradientColors: const [Color(0xFFFF8C42), Color(0xFFE65100)],
        onTap: () => _openPrescriptions(context),
      ),

      // 5. Lab Reports → placeholder
      PatientServiceItem(
        icon: Icons.science_rounded,
        title: 'Lab\nReports',
        description: 'Access your lab test reports',
        gradientColors: const [Color(0xFFFF4B8B), Color(0xFFD81B60)],
        onTap: () => _openPlaceholder(
          context,
          title: 'Lab Reports',
          icon: Icons.science_rounded,
          gradient: const [Color(0xFFFF4B8B), Color(0xFFD81B60)],
          description:
              'View and download your lab test results and pathology reports. Coming soon!',
        ),
      ),

      // 6. Billing & Payments → placeholder
      PatientServiceItem(
        icon: Icons.credit_card_rounded,
        title: 'Billing &\nPayments',
        description: 'View bills and make payments',
        gradientColors: const [Color(0xFF00B4D8), Color(0xFF0077B6)],
        onTap: () => _openPlaceholder(
          context,
          title: 'Billing & Payments',
          icon: Icons.credit_card_rounded,
          gradient: const [Color(0xFF00B4D8), Color(0xFF0077B6)],
          description:
              'View your billing history, outstanding dues, and make secure payments. Coming soon!',
        ),
      ),

      // 7. Video Consultation → placeholder
      PatientServiceItem(
        icon: Icons.videocam_rounded,
        title: 'Video\nConsultation',
        description: 'Consult doctors from the comfort of home',
        gradientColors: const [Color(0xFF5B8DEF), Color(0xFF3F51B5)],
        onTap: () => _openPlaceholder(
          context,
          title: 'Video Consultation',
          icon: Icons.videocam_rounded,
          gradient: const [Color(0xFF5B8DEF), Color(0xFF3F51B5)],
          description:
              'Connect with doctors via HD video calls from the comfort of your home. Coming soon!',
        ),
      ),

      // 8. Medicines → placeholder
      PatientServiceItem(
        icon: Icons.local_pharmacy_rounded,
        title: 'Medicines',
        description: 'Order medicines and get delivery',
        gradientColors: const [Color(0xFF9C6FFF), Color(0xFF7B2FBE)],
        onTap: () => _openPlaceholder(
          context,
          title: 'Medicines',
          icon: Icons.local_pharmacy_rounded,
          gradient: const [Color(0xFF9C6FFF), Color(0xFF7B2FBE)],
          description:
              'Order prescribed medicines online and get them delivered to your doorstep. Coming soon!',
        ),
      ),

      // 9. Health Tracker → BMI + vitals page
      PatientServiceItem(
        icon: Icons.monitor_heart_rounded,
        title: 'Health\nTracker',
        description: 'Track your health and vitals',
        gradientColors: const [Color(0xFFFF8C42), Color(0xFFFF6B35)],
        onTap: () => _openHealth(context),
      ),

      // 10. Insurance → placeholder
      PatientServiceItem(
        icon: Icons.shield_rounded,
        title: 'Insurance',
        description: 'View insurance details and claims',
        gradientColors: const [Color(0xFF1A8CFF), Color(0xFF0052CC)],
        onTap: () => _openPlaceholder(
          context,
          title: 'Insurance',
          icon: Icons.shield_rounded,
          gradient: const [Color(0xFF1A8CFF), Color(0xFF0052CC)],
          description:
              'Manage your health insurance policies, claims, and coverage details. Coming soon!',
        ),
      ),

      // 11. Offers & Packages → placeholder
      PatientServiceItem(
        icon: Icons.local_offer_rounded,
        title: 'Offers &\nPackages',
        description: 'Explore health offers and packages',
        gradientColors: const [Color(0xFFFF4B8B), Color(0xFFE91E8C)],
        onTap: () => _openPlaceholder(
          context,
          title: 'Offers & Packages',
          icon: Icons.local_offer_rounded,
          gradient: const [Color(0xFFFF4B8B), Color(0xFFE91E8C)],
          description:
              'Explore exclusive health check-up packages, seasonal offers, and discounts. Coming soon!',
        ),
      ),

      // 12. 24/7 Support → placeholder (or navigate to chat tab)
      PatientServiceItem(
        icon: Icons.headset_mic_rounded,
        title: '24/7\nSupport',
        description: 'Our support team is always here to help',
        gradientColors: const [Color(0xFF00C2FF), Color(0xFF0099E6)],
        onTap: () => _openPlaceholder(
          context,
          title: '24/7 Support',
          icon: Icons.headset_mic_rounded,
          gradient: const [Color(0xFF00C2FF), Color(0xFF0099E6)],
          description:
              'Get 24/7 assistance from our dedicated support team for any queries or emergencies.',
        ),
      ),
    ];
  }
}
