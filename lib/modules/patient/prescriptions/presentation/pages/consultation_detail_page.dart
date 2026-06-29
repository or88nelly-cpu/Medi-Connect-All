import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

/// Full detail view for a single past consultation / prescription.
///
/// [consultation] map keys:
///   doctor, specialty, date, diagnosis, symptoms, notes,
///   medicines: List<Map> with keys: name, dosage, frequency, duration
class ConsultationDetailPage extends StatelessWidget {
  final Map<String, dynamic> consultation;

  const ConsultationDetailPage({super.key, required this.consultation});

  @override
  Widget build(BuildContext context) {
    final medicines =
        (consultation['medicines'] as List<dynamic>?)
            ?.cast<Map<String, dynamic>>() ??
        [];

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
          'Consultation Details',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimary(context),
          ),
        ),
        actions: [
          IconButton(
            tooltip: 'Download Prescription',
            icon: const Icon(Icons.download_outlined),
            color: AppColors.primary,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Downloading prescription PDF…'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Doctor Header ──────────────────────────────────────
            _DoctorHeader(consultation: consultation),
            SizedBox(height: 16.h),

            // ── Diagnosis & Symptoms ───────────────────────────────
            _SectionCard(
              title: 'Diagnosis & Symptoms',
              icon: Icons.medical_information_outlined,
              iconColor: const Color(0xFF4F7CFF),
              children: [
                _InfoRow(
                  label: 'Diagnosis',
                  value: consultation['diagnosis'] ?? 'N/A',
                ),
                SizedBox(height: 8.h),
                _InfoRow(
                  label: 'Symptoms',
                  value: consultation['symptoms'] ?? 'N/A',
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // ── Medicines Prescribed ───────────────────────────────
            _SectionCard(
              title: 'Medicines Prescribed',
              icon: Icons.medication_rounded,
              iconColor: const Color(0xFF8B5CF6),
              children: [
                if (medicines.isEmpty)
                  Text(
                    'No medicines prescribed.',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary(context),
                    ),
                  )
                else
                  ...medicines.asMap().entries.map(
                    (e) => Column(
                      children: [
                        if (e.key > 0)
                          Divider(
                            color: AppColors.border(context),
                            height: 16.h,
                          ),
                        _MedicineRow(medicine: e.value),
                      ],
                    ),
                  ),
              ],
            ),
            SizedBox(height: 16.h),

            // ── Doctor Notes ───────────────────────────────────────
            if ((consultation['notes'] as String? ?? '').isNotEmpty)
              _SectionCard(
                title: "Doctor's Notes",
                icon: Icons.note_alt_outlined,
                iconColor: const Color(0xFF00C2A8),
                children: [
                  Text(
                    consultation['notes'] ?? '',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textPrimary(context),
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            SizedBox(height: 24.h),

            // ── Download Button ────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Downloading prescription PDF…'),
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.download_rounded, color: Colors.white),
                label: Text(
                  'Download Prescription',
                  style: AppTextStyles.buttonMedium.copyWith(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: EdgeInsets.all(16.r),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            SizedBox(height: 16.h),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                icon: Icon(
                  Icons.arrow_back_rounded,
                  size: 16.r,
                  color: AppColors.primary,
                ),
                label: Text(
                  'Back to Prescriptions',
                  style: AppTextStyles.buttonMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.all(16.r),
                  side: BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
              ),
            ),
            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _DoctorHeader extends StatelessWidget {
  final Map<String, dynamic> consultation;
  const _DoctorHeader({required this.consultation});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF4F7CFF), Color(0xFF5B42F3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Container(
            width: 54.r,
            height: 54.r,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.person_rounded, color: Colors.white, size: 28.r),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  consultation['doctor'] ?? 'Unknown Doctor',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  consultation['specialty'] ?? '',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      color: Colors.white60,
                      size: 12.r,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      consultation['date'] ?? '',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: Colors.white70,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              'Completed',
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color iconColor;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border(context)),
        boxShadow: [
          BoxShadow(
            color: iconColor.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32.r,
                height: 32.r,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: iconColor, size: 16.r),
              ),
              SizedBox(width: 10.w),
              Text(
                title,
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.textPrimary(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Divider(color: AppColors.border(context), height: 20.h),
          ...children,
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90.w,
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary(context),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textPrimary(context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _MedicineRow extends StatelessWidget {
  final Map<String, dynamic> medicine;
  const _MedicineRow({required this.medicine});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 8.r,
          height: 8.r,
          margin: EdgeInsets.only(top: 5.h),
          decoration: BoxDecoration(
            color: const Color(0xFF8B5CF6),
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                medicine['name'] ?? '',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                '${medicine['dosage'] ?? ''} · ${medicine['frequency'] ?? ''} · ${medicine['duration'] ?? ''}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary(context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
