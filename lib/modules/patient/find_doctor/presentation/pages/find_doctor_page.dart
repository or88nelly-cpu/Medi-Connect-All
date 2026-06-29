import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/modules/patient/find_doctor/presentation/pages/specialty_doctors_page.dart';

/// Data model for a medical specialty card.
class _SpecialtyData {
  final String name;
  final IconData icon;
  final List<Color> gradient;
  final String docCount;
  final String description;

  const _SpecialtyData({
    required this.name,
    required this.icon,
    required this.gradient,
    required this.docCount,
    required this.description,
  });
}

class FindDoctorPage extends StatefulWidget {
  const FindDoctorPage({super.key});

  @override
  State<FindDoctorPage> createState() => _FindDoctorPageState();
}

class _FindDoctorPageState extends State<FindDoctorPage> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  static final List<_SpecialtyData> _specialties = [
    _SpecialtyData(
      name: 'Cardiology',
      icon: Icons.favorite_rounded,
      gradient: const [Color(0xFF4F7CFF), Color(0xFF5B42F3)],
      docCount: '12',
      description: 'Heart & Blood Vessels',
    ),
    _SpecialtyData(
      name: 'Neurology',
      icon: Icons.psychology_rounded,
      gradient: const [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
      docCount: '8',
      description: 'Brain & Nerves',
    ),
    _SpecialtyData(
      name: 'Orthopedics',
      icon: Icons.accessibility_new_rounded,
      gradient: const [Color(0xFF00C2A8), Color(0xFF00897B)],
      docCount: '10',
      description: 'Bones & Joints',
    ),
    _SpecialtyData(
      name: 'Pediatrics',
      icon: Icons.child_care_rounded,
      gradient: const [Color(0xFFFF8C42), Color(0xFFE65100)],
      docCount: '15',
      description: 'Child Healthcare',
    ),
    _SpecialtyData(
      name: 'Dermatology',
      icon: Icons.spa_rounded,
      gradient: const [Color(0xFFFF4B8B), Color(0xFFD81B60)],
      docCount: '9',
      description: 'Skin & Hair',
    ),
    _SpecialtyData(
      name: 'Ophthalmology',
      icon: Icons.remove_red_eye_rounded,
      gradient: const [Color(0xFF00B4D8), Color(0xFF0077B6)],
      docCount: '7',
      description: 'Eye Care',
    ),
    _SpecialtyData(
      name: 'ENT',
      icon: Icons.hearing_rounded,
      gradient: const [Color(0xFF5B8DEF), Color(0xFF3F51B5)],
      docCount: '6',
      description: 'Ear, Nose & Throat',
    ),
    _SpecialtyData(
      name: 'General Medicine',
      icon: Icons.medical_services_rounded,
      gradient: const [Color(0xFF22C55E), Color(0xFF15803D)],
      docCount: '20',
      description: 'Primary Healthcare',
    ),
    _SpecialtyData(
      name: 'Gynecology',
      icon: Icons.local_hospital_rounded,
      gradient: const [Color(0xFFEC4899), Color(0xFFBE185D)],
      docCount: '11',
      description: "Women's Health",
    ),
    _SpecialtyData(
      name: 'Psychiatry',
      icon: Icons.mood_rounded,
      gradient: const [Color(0xFF9C6FFF), Color(0xFF7B2FBE)],
      docCount: '5',
      description: 'Mental Health',
    ),
    _SpecialtyData(
      name: 'Oncology',
      icon: Icons.biotech_rounded,
      gradient: const [Color(0xFFFF8C42), Color(0xFFFF6B35)],
      docCount: '6',
      description: 'Cancer Care',
    ),
    _SpecialtyData(
      name: 'Urology',
      icon: Icons.water_drop_rounded,
      gradient: const [Color(0xFF1A8CFF), Color(0xFF0052CC)],
      docCount: '8',
      description: 'Urinary Tract',
    ),
  ];

  List<_SpecialtyData> get _filtered {
    if (_query.isEmpty) return _specialties;
    final q = _query.toLowerCase();
    return _specialties
        .where(
          (s) =>
              s.name.toLowerCase().contains(q) ||
              s.description.toLowerCase().contains(q),
        )
        .toList();
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _openSpecialty(BuildContext context, _SpecialtyData sp) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: context.read<DoctorStaffBloc>()),
            BlocProvider.value(value: context.read<AuthBloc>()),
          ],
          child: SpecialtyDoctorsPage(
            specialty: sp.name,
            gradientColors: sp.gradient,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;

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
          'Find Doctors',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimary(context),
          ),
        ),
      ),
      body: Column(
        children: [
          // ── Search bar ─────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.card(context),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: AppColors.border(context)),
              ),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _query = v),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textPrimary(context),
                ),
                decoration: InputDecoration(
                  hintText: 'Search specialty or description…',
                  hintStyle: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary(context),
                  ),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: AppColors.textSecondary(context),
                    size: 20.r,
                  ),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear_rounded,
                            size: 18.r,
                            color: AppColors.textSecondary(context),
                          ),
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() => _query = '');
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 14.h,
                  ),
                ),
              ),
            ),
          ),

          // ── Specialty grid header ──────────────────────────────────
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Choose by Specialty',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.textPrimary(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${filtered.length} found',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),

          // ── Specialty cards grid ───────────────────────────────────
          Expanded(
            child: filtered.isEmpty
                ? Center(
                    child: Text(
                      'No specialties match "$_query"',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final crossCount = constraints.maxWidth > 600 ? 3 : 2;
                      return GridView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 4.h,
                        ),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossCount,
                          crossAxisSpacing: 12.w,
                          mainAxisSpacing: 12.h,
                          childAspectRatio: 0.9,
                        ),
                        itemCount: filtered.length,
                        itemBuilder: (context, i) {
                          final sp = filtered[i];
                          return _SpecialtyCard(
                            data: sp,
                            onTap: () => _openSpecialty(context, sp),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
class _SpecialtyCard extends StatelessWidget {
  final _SpecialtyData data;
  final VoidCallback onTap;

  const _SpecialtyCard({required this.data, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              data.gradient.first,
              data.gradient.last,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: data.gradient.first.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Decorative circles
            Positioned(
              right: -10,
              top: -10,
              child: Container(
                width: 60.r,
                height: 60.r,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              left: -15,
              bottom: -15,
              child: Container(
                width: 50.r,
                height: 50.r,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Main content
            Padding(
              padding: EdgeInsets.all(14.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Icon
                  Container(
                    width: 46.r,
                    height: 46.r,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.25),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(data.icon, color: Colors.white, size: 24.r),
                  ),

                  // Name + description + count
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.name,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        data.description,
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.white70,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 10.r,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              '${data.docCount} Doctors',
                              style: TextStyle(
                                fontSize: 9.sp,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Arrow indicator
            Positioned(
              right: 10.w,
              bottom: 10.h,
              child: Container(
                width: 26.r,
                height: 26.r,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white,
                  size: 14.r,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
