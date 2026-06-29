import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/shared/auth/domain/entities/user_entity.dart';
import 'package:medi_connect/shared/dashboard/domain/entities/appointment_entity.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_dashboard/patient_details/patient_header_card.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_dashboard/patient_details/vitals_grid_section.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_dashboard/patient_details/recent_consultation_card.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_dashboard/patient_details/emr_prescription_card.dart';
import 'package:medi_connect/shared/dashboard/presentation/widgets/doctor_dashboard/patient_details/consultation_history_sheet.dart';

class PatientDetailsSheet extends StatefulWidget {
  final UserEntity patient;
  final List<AppointmentEntity> doctorApts;
  final UserEntity doctor;

  const PatientDetailsSheet({
    super.key,
    required this.patient,
    required this.doctorApts,
    required this.doctor,
  });

  @override
  State<PatientDetailsSheet> createState() => _PatientDetailsSheetState();
}

class _PatientDetailsSheetState extends State<PatientDetailsSheet> {
  bool _isLoadingEMR = false;
  Map<String, dynamic>? _emrRecord;
  AppointmentEntity? _recentApt;
  List<AppointmentEntity> _patientApts = [];

  @override
  void initState() {
    super.initState();
    _findRecentAppointmentAndFetchEMR();
  }

  void _findRecentAppointmentAndFetchEMR() async {
    final displayName = widget.patient.fullName;

    // Filter appointments for this patient
    final patientApts = widget.doctorApts.where((a) {
      final matchName =
          a.patientName.toLowerCase().trim() ==
          displayName.toLowerCase().trim();
      final matchId = a.patientId == widget.patient.id;
      return matchId || matchName;
    }).toList();

    if (patientApts.isEmpty) return;

    // Sort to find the most recent one
    patientApts.sort((a, b) {
      final dateCompare = b.appointmentDate.compareTo(a.appointmentDate);
      if (dateCompare != 0) return dateCompare;
      return b.appointmentTime.compareTo(a.appointmentTime);
    });

    setState(() {
      _patientApts = patientApts;
      _recentApt = patientApts.first;
    });

    // Fetch EMR record if recent appointment is Completed
    if (_recentApt != null && _recentApt!.status == 'Completed') {
      setState(() {
        _isLoadingEMR = true;
      });
      try {
        final response = await Supabase.instance.client
            .from('emr_records')
            .select()
            .eq('appointment_id', _recentApt!.id)
            .maybeSingle();

        if (response != null) {
          setState(() {
            _emrRecord = response;
          });
        }
      } catch (e) {
        debugPrint("Error fetching EMR record for patient details sheet: $e");
      } finally {
        setState(() {
          _isLoadingEMR = false;
        });
      }
    }
  }

  void _showConsultationHistory() {
    final displayName = widget.patient.fullName;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ConsultationHistorySheet(
        appointments: _patientApts,
        patientName: displayName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final displayName = widget.patient.fullName;

    final sheetBg = isDark ? AppColors.terminalDarkBg : Colors.white;
    final secondaryText = AppColors.textSecondary(context);
    final primaryText = AppColors.textPrimary(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (ctx, scrollCtrl) {
        return Container(
          decoration: BoxDecoration(
            color: sheetBg,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              // Pull Bar indicator
              SizedBox(height: 12.h),
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white24 : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: 16.h),

              // Title Header
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.patientProfile,
                      style: AppTextStyles.titleLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: primaryText,
                      ),
                    ),
                    // Close button inside a grey circle/outline to match mockup
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(4.r),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark
                              ? const Color(0xFF1E293B)
                              : const Color(0xFFF1F5F9),
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF334155)
                                : const Color(0xFFE2E8F0),
                          ),
                        ),
                        child: Icon(
                          Icons.close,
                          size: 18.r,
                          color: secondaryText,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              const Divider(height: 1),

              // Content Body
              Expanded(
                child: ListView(
                  controller: scrollCtrl,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 16.h,
                  ),
                  children: [
                    // Patient Header Card
                    PatientHeaderCard(patient: widget.patient),
                    SizedBox(height: 20.h),

                    // Vitals Section
                    VitalsGridSection(
                      recentApt: _recentApt,
                      onViewAll: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Vitals history view is under development",
                            ),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20.h),

                    // Recent Consultation Section
                    RecentConsultationCard(
                      recentApt: _recentApt,
                      onViewAll: _showConsultationHistory,
                    ),
                    SizedBox(height: 20.h),

                    // Prescription & Notes Section
                    EmrPrescriptionCard(
                      emrRecord: _emrRecord,
                      isLoading: _isLoadingEMR,
                      onViewAll: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "EMR history view is under development",
                            ),
                            backgroundColor: AppColors.primary,
                          ),
                        );
                      },
                      onInvoicePdfPressed: () {
                        if (_emrRecord != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "PDF Invoice generated: ${_emrRecord!['invoice_number']}",
                              ),
                              backgroundColor: AppColors.primary,
                            ),
                          );
                        }
                      },
                      onShareRxPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "Sharing prescription with patient...",
                            ),
                            backgroundColor: AppColors.success,
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 24.h),
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
