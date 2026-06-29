import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/modules/patient/prescriptions/presentation/pages/consultation_detail_page.dart';

class PrescriptionsPage extends StatelessWidget {
  const PrescriptionsPage({super.key});

  static List<Map<String, dynamic>> get _mockConsultations => [
    {
      'doctor': 'Dr. Sarah Johnson',
      'specialty': 'Cardiologist',
      'date': 'June 08, 2026',
      'diagnosis': 'Hypertension Stage 1',
      'symptoms': 'Headache, dizziness, chest discomfort',
      'notes':
          'Patient advised to reduce sodium intake, exercise regularly (30 min daily), and monitor blood pressure at home.',
      'medicines': [
        {
          'name': 'Amlodipine',
          'dosage': '5mg',
          'frequency': 'Once daily',
          'duration': '30 days',
        },
        {
          'name': 'Losartan',
          'dosage': '50mg',
          'frequency': 'Twice daily',
          'duration': '30 days',
        },
      ],
    },
    {
      'doctor': 'Dr. Michael Chen',
      'specialty': 'Neurologist',
      'date': 'May 20, 2026',
      'diagnosis': 'Tension Headache',
      'symptoms': 'Persistent headache, mild nausea, light sensitivity',
      'notes':
          'Advised adequate sleep (7-8 hours), stress management, and avoiding screen time before bed.',
      'medicines': [
        {
          'name': 'Paracetamol',
          'dosage': '500mg',
          'frequency': 'As needed (max 3x daily)',
          'duration': '7 days',
        },
        {
          'name': 'Metoclopramide',
          'dosage': '10mg',
          'frequency': 'Before meals',
          'duration': '5 days',
        },
      ],
    },
    {
      'doctor': 'Dr. Priya Sharma',
      'specialty': 'General Physician',
      'date': 'April 15, 2026',
      'diagnosis': 'Viral Upper Respiratory Infection',
      'symptoms': 'Fever, sore throat, runny nose, mild cough',
      'notes':
          'Rest and adequate hydration. Return if fever persists beyond 5 days or symptoms worsen.',
      'medicines': [
        {
          'name': 'Cetirizine',
          'dosage': '10mg',
          'frequency': 'Once daily at bedtime',
          'duration': '5 days',
        },
        {
          'name': 'Amoxicillin',
          'dosage': '500mg',
          'frequency': 'Thrice daily',
          'duration': '5 days',
        },
        {
          'name': 'Vitamin C',
          'dosage': '500mg',
          'frequency': 'Twice daily',
          'duration': '10 days',
        },
      ],
    },
  ];

  List<Map<String, dynamic>> _resolveConsultations(AuthState state) {
    return _mockConsultations;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimary(context),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Prescriptions',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimary(context),
          ),
        ),
      ),
      body: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final consultations = _resolveConsultations(state);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header banner
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16.w),
                padding: EdgeInsets.all(16.r),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 44.r,
                      height: 44.r,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.medication_rounded,
                        color: Colors.white,
                        size: 24.r,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Previous Consultations',
                            style: AppTextStyles.titleSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            '${consultations.length} consultation${consultations.length != 1 ? 's' : ''} found',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16.h),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Text(
                  'Tap a consultation to view prescriptions',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ),
              SizedBox(height: 12.h),

              // Consultation list
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                  itemCount: consultations.length,
                  separatorBuilder: (context, _) => SizedBox(height: 12.h),
                  itemBuilder: (context, index) {
                    final c = consultations[index];
                    return _ConsultationCard(
                      consultation: c,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                ConsultationDetailPage(consultation: c),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _ConsultationCard extends StatelessWidget {
  final Map<String, dynamic> consultation;
  final VoidCallback onTap;

  const _ConsultationCard({
    required this.consultation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final medicines =
        (consultation['medicines'] as List<dynamic>?)?.length ?? 0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.card(context),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.border(context)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 48.r,
              height: 48.r,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Icon(
                Icons.medical_services_rounded,
                color: Colors.white,
                size: 22.r,
              ),
            ),
            SizedBox(width: 14.w),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Doctor name + date
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          consultation['doctor'] ?? '',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary(context),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        consultation['date'] ?? '',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary(context),
                          fontSize: 10.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 3.h),
                  Text(
                    consultation['specialty'] ?? '',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: const Color(0xFF8B5CF6),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    'Diagnosis: ${consultation['diagnosis'] ?? 'N/A'}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary(context),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),

                  // Tags row
                  Row(
                    children: [
                      _Tag(
                        label: '$medicines medicine${medicines != 1 ? 's' : ''}',
                        color: const Color(0xFF8B5CF6),
                      ),
                      SizedBox(width: 6.w),
                      _Tag(label: 'View & Download', color: AppColors.primary),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(width: 8.w),
            Icon(
              Icons.chevron_right_rounded,
              color: AppColors.textSecondary(context),
              size: 20.r,
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  const _Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 9.sp,
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
