import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/modules/patient/booking/presentation/pages/booking_flow_page.dart';

class DoctorProfileDetailPage extends StatefulWidget {
  final UserModel doctor;
  final List<Color> gradientColors;

  const DoctorProfileDetailPage({
    super.key,
    required this.doctor,
    required this.gradientColors,
  });

  @override
  State<DoctorProfileDetailPage> createState() =>
      _DoctorProfileDetailPageState();
}

class _DoctorProfileDetailPageState extends State<DoctorProfileDetailPage> {
  int _selectedDateIndex = 0;

  List<DateTime> get _nextSevenDays =>
      List.generate(7, (i) => DateTime.now().add(Duration(days: i)));

  @override
  Widget build(BuildContext context) {
    final doc = widget.doctor;
    final gradient = widget.gradientColors;

    return Scaffold(
      backgroundColor: AppColors.scaffold(context),
      body: CustomScrollView(
        slivers: [
          // ── Hero sliver appbar ─────────────────────────────────
          SliverAppBar(
            expandedHeight: 220.h,
            pinned: true,
            backgroundColor: gradient.first,
            leading: IconButton(
              icon: Container(
                padding: EdgeInsets.all(6.r),
                decoration: BoxDecoration(
                  color: Colors.black26,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradient,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Stack(
                  children: [
                    // Decorative circles
                    Positioned(
                      right: -20,
                      top: -20,
                      child: Container(
                        width: 120.r,
                        height: 120.r,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      left: -30,
                      bottom: -30,
                      child: Container(
                        width: 100.r,
                        height: 100.r,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.06),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),

                    // Doctor info
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding: EdgeInsets.only(
                          left: 20.w,
                          right: 20.w,
                          bottom: 20.h,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 72.r,
                              height: 72.r,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.25),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.white54,
                                  width: 2,
                                ),
                              ),
                              child: Icon(
                                Icons.person_rounded,
                                color: Colors.white,
                                size: 36.r,
                              ),
                            ),
                            SizedBox(width: 16.w),
                            Expanded(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doc.fullName,
                                    style: AppTextStyles.titleLarge.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 3.h),
                                  Text(
                                    'General Medicine',
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      color: Colors.white70,
                                    ),
                                  ),
                                  SizedBox(height: 6.h),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star_rounded,
                                        color: const Color(0xFFFFB547),
                                        size: 16.r,
                                      ),
                                      SizedBox(width: 3.w),
                                      Text(
                                        '4.8 (320 reviews)',
                                        style: AppTextStyles.bodySmall.copyWith(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Stats row ────────────────────────────────────
                  _StatsRow(doctor: doc, gradient: gradient),
                  SizedBox(height: 20.h),

                  // ── About ────────────────────────────────────────
                  _SectionHeader(title: 'About', icon: Icons.info_outline_rounded),
                  SizedBox(height: 10.h),
                  Container(
                    padding: EdgeInsets.all(14.r),
                    decoration: BoxDecoration(
                      color: AppColors.card(context),
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: AppColors.border(context)),
                    ),
                    child: Text(
                      '${doc.fullName} is an experienced specialist with 5+ years of practice. Specializing in diagnosing and treating a wide range of conditions with a patient-centered approach, combining evidence-based medicine with compassionate care.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textPrimary(context),
                        height: 1.6,
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),

                  // ── Available Dates ───────────────────────────────
                  _SectionHeader(
                    title: 'Available Dates',
                    icon: Icons.calendar_month_rounded,
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    height: 70.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _nextSevenDays.length,
                      separatorBuilder: (context, _) => SizedBox(width: 10.w),
                      itemBuilder: (context, i) {
                        final d = _nextSevenDays[i];
                        final isSelected = i == _selectedDateIndex;
                        return GestureDetector(
                          onTap: () =>
                              setState(() => _selectedDateIndex = i),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 50.w,
                            decoration: BoxDecoration(
                              gradient: isSelected
                                  ? LinearGradient(colors: gradient)
                                  : null,
                              color: isSelected
                                  ? null
                                  : AppColors.card(context),
                              borderRadius: BorderRadius.circular(12.r),
                              border: Border.all(
                                color: isSelected
                                    ? gradient.first
                                    : AppColors.border(context),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  _weekdayAbbr(d.weekday),
                                  style: TextStyle(
                                    fontSize: 10.sp,
                                    color: isSelected
                                        ? Colors.white70
                                        : AppColors.textSecondary(context),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  '${d.day}',
                                  style: TextStyle(
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                    color: isSelected
                                        ? Colors.white
                                        : AppColors.textPrimary(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // ── Book Now button ───────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => MultiBlocProvider(
                              providers: [
                                BlocProvider.value(
                                  value: context.read<AuthBloc>(),
                                ),
                              ],
                              child: BookingFlowPage(
                                preselectedDoctor: doc,
                                preselectedSpecialty:
                                    'General Medicine',
                              ),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.calendar_today_rounded,
                        color: Colors.white,
                      ),
                      label: Text(
                        'Book Appointment',
                        style: AppTextStyles.buttonLarge.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(16.r),
                        backgroundColor: gradient.first,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _weekdayAbbr(int wd) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[(wd - 1).clamp(0, 6)];
  }
}

class _StatsRow extends StatelessWidget {
  final UserModel doctor;
  final List<Color> gradient;

  const _StatsRow({required this.doctor, required this.gradient});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _StatChip(
          value: '5+',
          label: 'Years Exp',
          icon: Icons.work_outline_rounded,
          color: gradient.first,
        ),
        SizedBox(width: 10.w),
        _StatChip(
          value: '4.8',
          label: 'Rating',
          icon: Icons.star_rounded,
          color: const Color(0xFFFFB547),
        ),
        SizedBox(width: 10.w),
        _StatChip(
          value: '₹500',
          label: 'Fee',
          icon: Icons.currency_rupee_rounded,
          color: const Color(0xFF22C55E),
        ),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _StatChip({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18.r),
            SizedBox(height: 4.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 9.sp,
                color: AppColors.textSecondary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18.r, color: AppColors.primary),
        SizedBox(width: 8.w),
        Text(
          title,
          style: AppTextStyles.titleSmall.copyWith(
            color: AppColors.textPrimary(context),
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
