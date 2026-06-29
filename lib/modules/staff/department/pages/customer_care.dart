import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/routes/route_names.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/modules/staff/department/widgets/common_card.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/bloc/emrd_bloc.dart';
import 'package:medi_connect/modules/departments/emrd/presentation/pages/medical_record_management_page.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/appointments/create_appointment_wizard_dialog.dart';
import 'package:medi_connect/modules/management/customer_care/presentation/widgets/admit_patient_dialog.dart';

class CustomerCare extends StatefulWidget {
  const CustomerCare({super.key});

  @override
  State<CustomerCare> createState() => _CustomerCareState();
}

class _CustomerCareState extends State<CustomerCare> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  static const List<_CardData> _cards = [
    _CardData(
      title: 'Registration',
      subTitle: 'Register new patient\nmanually',
      icon: Icons.person_add_alt_1_rounded,
      color: Color(0xFF2D7FFF),
    ),
    _CardData(
      title: 'QR Registration',
      subTitle: 'Scan QR code to\nregister new patient',
      icon: Icons.qr_code_2_rounded,
      color: Color(0xFF00C2A8),
    ),
    _CardData(
      title: 'Appointment',
      subTitle: 'Book, reschedule or\nmanage appointments',
      icon: Icons.calendar_month_rounded,
      color: Color(0xFF8A4DFF),
    ),
    _CardData(
      title: 'Patient Search',
      subTitle: 'Search by UHID, phone\nor name & book visit',
      icon: Icons.manage_search_rounded,
      color: Color(0xFF3366FF),
    ),
    _CardData(
      title: 'Admission',
      subTitle: 'New admission &\nmanage stays',
      icon: Icons.hotel_rounded,
      color: Color(0xFFFF981F),
    ),
    _CardData(
      title: 'Feedback',
      subTitle: 'View patient feedbacks\nand ratings',
      icon: Icons.star_rounded,
      color: Color(0xFFFF4D8D),
    ),
    _CardData(
      title: 'Consultation',
      subTitle: 'View completed\nconsultations (EMR)',
      icon: Icons.assignment_rounded,
      color: Color(0xFF10B981),
    ),
  ];

  void _handleCardTap(BuildContext context, int index) {
    if (index == 0) {
      context.push("/staff/patientRegistration");
    } else if (index == 1) {
      context.push(RouteNames.qrRegistration);
    } else if (index == 2) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (ctx) => const CreateAppointmentWizardBottomSheet(),
      );
    } else if (index == 3) {
      context.push(RouteNames.patientSearch);
    } else if (index == 4) {
      showDialog(context: context, builder: (_) => const AdmitPatientDialog());
    } else if (index == 6) {
      final emrdBloc = context.read<EmrdBloc>();
      emrdBloc.add(LoadEmrdStats());
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BlocProvider.value(
            value: emrdBloc,
            child: const MedicalRecordManagementPage(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppColors.isDark(context);

    return Column(
      children: [
        // ── Search bar ──
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: _SearchBar(controller: _searchController, isDark: isDark),
        ),

        // ── Cards Grid ──
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              children: [
                for (int i = 0; i < _cards.length; i += 2)
                  Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: Row(
                      children: [
                        Expanded(
                          child: CommonCard(
                            title: _cards[i].title,
                            subTitle: _cards[i].subTitle,
                            icon: _cards[i].icon,
                            color: _cards[i].color,
                            onTap: () => _handleCardTap(context, i),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        if (i + 1 < _cards.length)
                          Expanded(
                            child: CommonCard(
                              title: _cards[i + 1].title,
                              subTitle: _cards[i + 1].subTitle,
                              icon: _cards[i + 1].icon,
                              color: _cards[i + 1].color,
                              onTap: () => _handleCardTap(context, i + 1),
                            ),
                          )
                        else
                          const Expanded(child: SizedBox()),
                      ],
                    ),
                  ),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Card data model
// ─────────────────────────────────────────────────────────────────────────────
class _CardData {
  final String title;
  final String subTitle;
  final IconData icon;
  final Color color;

  const _CardData({
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.color,
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final bool isDark;

  const _SearchBar({required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border(context)),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow(context),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(width: 14.w),
          Icon(
            Icons.search_rounded,
            color: AppColors.textSecondary(context),
            size: 20.r,
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: TextField(
              controller: controller,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textPrimary(context),
                fontSize: 13.sp,
              ),
              decoration: InputDecoration(
                hintText: 'Search patient or request',
                hintStyle: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary(
                    context,
                  ).withValues(alpha: 0.6),
                  fontSize: 13.sp,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          Container(width: 1, height: 22.h, color: AppColors.border(context)),
          SizedBox(width: 12.w),
          Icon(
            Icons.tune_rounded,
            color: AppColors.textSecondary(context),
            size: 20.r,
          ),
          SizedBox(width: 14.w),
        ],
      ),
    );
  }
}
