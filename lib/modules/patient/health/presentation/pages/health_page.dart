import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/modules/management/staff_management/data/datasource/doctor_staff_remote_datasource.dart';

class HealthPage extends StatefulWidget {
  const HealthPage({super.key});

  @override
  State<HealthPage> createState() => _HealthPageState();
}

class _HealthPageState extends State<HealthPage> {
  final _heightCtrl = TextEditingController(text: '170');
  final _weightCtrl = TextEditingController(text: '70');
  final _bpSysCtrl = TextEditingController(text: '120');
  final _bpDiaCtrl = TextEditingController(text: '80');
  final _heartRateCtrl = TextEditingController(text: '72');
  final _bloodSugarCtrl = TextEditingController(text: '95');

  double _bmi = 24.2;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _heightCtrl.addListener(_recalc);
    _weightCtrl.addListener(_recalc);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final state = context.read<AuthBloc>().state;
      if (state is Authenticated) {
        final health =
            state.user.metadata?['health'] as Map<String, dynamic>?;
        if (health != null) {
          setState(() {
            if (health['height'] != null) {
              _heightCtrl.text = health['height'].toString();
            }
            if (health['weight'] != null) {
              _weightCtrl.text = health['weight'].toString();
            }
            if (health['bp_sys'] != null) {
              _bpSysCtrl.text = health['bp_sys'].toString();
            }
            if (health['bp_dia'] != null) {
              _bpDiaCtrl.text = health['bp_dia'].toString();
            }
            if (health['heart_rate'] != null) {
              _heartRateCtrl.text = health['heart_rate'].toString();
            }
            if (health['blood_sugar'] != null) {
              _bloodSugarCtrl.text = health['blood_sugar'].toString();
            }
          });
        }
      }
      _recalc();
    });
  }

  void _recalc() {
    final h = double.tryParse(_heightCtrl.text) ?? 170;
    final w = double.tryParse(_weightCtrl.text) ?? 70;
    if (h > 0) {
      setState(() => _bmi = w / ((h / 100) * (h / 100)));
    }
  }

  @override
  void dispose() {
    _heightCtrl
      ..removeListener(_recalc)
      ..dispose();
    _weightCtrl
      ..removeListener(_recalc)
      ..dispose();
    _bpSysCtrl.dispose();
    _bpDiaCtrl.dispose();
    _heartRateCtrl.dispose();
    _bloodSugarCtrl.dispose();
    super.dispose();
  }

  String get _bmiCategory {
    if (_bmi < 18.5) return 'Underweight';
    if (_bmi < 25) return 'Normal';
    if (_bmi < 30) return 'Overweight';
    return 'Obese';
  }

  Color get _bmiColor {
    if (_bmi < 18.5) return const Color(0xFF1A8CFF);
    if (_bmi < 25) return const Color(0xFF22C55E);
    if (_bmi < 30) return const Color(0xFFFF8C42);
    return const Color(0xFFEF4444);
  }

  double get _bmiProgress {
    // Map BMI 10-40 to 0-1 progress
    return ((_bmi - 10) / 30).clamp(0.0, 1.0);
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);
    try {
      final state = context.read<AuthBloc>().state;
      if (state is Authenticated) {
        final user = UserModel.fromEntity(state.user);
        final updatedMeta = Map<String, dynamic>.from(user.metadata ?? {});
        updatedMeta['health'] = {
          'height': double.tryParse(_heightCtrl.text) ?? 0,
          'weight': double.tryParse(_weightCtrl.text) ?? 0,
          'bmi': double.parse(_bmi.toStringAsFixed(1)),
          'bp_sys': int.tryParse(_bpSysCtrl.text) ?? 0,
          'bp_dia': int.tryParse(_bpDiaCtrl.text) ?? 0,
          'heart_rate': int.tryParse(_heartRateCtrl.text) ?? 0,
          'blood_sugar': int.tryParse(_bloodSugarCtrl.text) ?? 0,
          'updated_at': DateTime.now().toIso8601String(),
        };
        final updatedUser = user.copyWith(metadata: updatedMeta);
        await GetIt.instance<DoctorStaffRemoteDataSource>()
            .updateDoctorStaffMember(updatedUser);
        if (mounted) {
          context.read<AuthBloc>().add(UserUpdated(updatedUser));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Health data saved successfully!'),
              backgroundColor: const Color(0xFF22C55E),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
          );
        }
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save. Please try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
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
          'Health Tracker',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimary(context),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.r),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── BMI Card ─────────────────────────────────────────
            _BmiCard(
              bmi: _bmi,
              bmiCategory: _bmiCategory,
              bmiColor: _bmiColor,
              bmiProgress: _bmiProgress,
            ),
            SizedBox(height: 20.h),

            // ── Vitals Section ────────────────────────────────────
            Text(
              'Your Vitals',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary(context),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),

            // Height & Weight row
            Row(
              children: [
                Expanded(
                  child: _VitalField(
                    controller: _heightCtrl,
                    label: 'Height',
                    unit: 'cm',
                    icon: Icons.height_rounded,
                    iconColor: const Color(0xFF4F7CFF),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _VitalField(
                    controller: _weightCtrl,
                    label: 'Weight',
                    unit: 'kg',
                    icon: Icons.monitor_weight_outlined,
                    iconColor: const Color(0xFF8B5CF6),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),

            // Blood Pressure row
            _BloodPressureField(
              sysController: _bpSysCtrl,
              diaController: _bpDiaCtrl,
            ),
            SizedBox(height: 12.h),

            // Heart Rate & Blood Sugar row
            Row(
              children: [
                Expanded(
                  child: _VitalField(
                    controller: _heartRateCtrl,
                    label: 'Heart Rate',
                    unit: 'bpm',
                    icon: Icons.favorite_rounded,
                    iconColor: const Color(0xFFEF4444),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: _VitalField(
                    controller: _bloodSugarCtrl,
                    label: 'Blood Sugar',
                    unit: 'mg/dL',
                    icon: Icons.water_drop_rounded,
                    iconColor: const Color(0xFFFF8C42),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),

            // ── Health Tips ───────────────────────────────────────
            _HealthTipsCard(),
            SizedBox(height: 24.h),

            // ── Save Button ───────────────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _isSaving ? null : _save,
                icon: _isSaving
                    ? SizedBox(
                        width: 16.r,
                        height: 16.r,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.save_rounded,
                        color: Colors.white,
                      ),
                label: Text(
                  _isSaving ? 'Saving…' : 'Save Health Data',
                  style: AppTextStyles.buttonLarge.copyWith(
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
                  padding: EdgeInsets.all(16.r),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  elevation: 0,
                ),
              ),
            ),
            SizedBox(height: 30.h),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// BMI Card
// ─────────────────────────────────────────────────────────────────────────────
class _BmiCard extends StatelessWidget {
  final double bmi;
  final String bmiCategory;
  final Color bmiColor;
  final double bmiProgress;

  const _BmiCard({
    required this.bmi,
    required this.bmiCategory,
    required this.bmiColor,
    required this.bmiProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.r),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            bmiColor.withValues(alpha: 0.12),
            bmiColor.withValues(alpha: 0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: bmiColor.withValues(alpha: 0.25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Body Mass Index',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textSecondary(context),
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        bmi.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 40.sp,
                          fontWeight: FontWeight.bold,
                          color: bmiColor,
                          height: 1,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Padding(
                        padding: EdgeInsets.only(bottom: 6.h),
                        child: Text(
                          'kg/m²',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.textSecondary(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: bmiColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: bmiColor.withValues(alpha: 0.3)),
                ),
                child: Text(
                  bmiCategory,
                  style: TextStyle(
                    color: bmiColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // BMI gauge bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: Stack(
              children: [
                // Background gradient track
                Container(
                  height: 10.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6.r),
                    gradient: const LinearGradient(
                      colors: [
                        Color(0xFF1A8CFF),
                        Color(0xFF22C55E),
                        Color(0xFFFF8C42),
                        Color(0xFFEF4444),
                      ],
                    ),
                  ),
                ),
                // Indicator thumb
                Positioned(
                  left: (MediaQuery.of(context).size.width - 72.w) *
                          bmiProgress -
                      4,
                  top: 0,
                  child: Container(
                    width: 10.r,
                    height: 10.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: bmiColor, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: bmiColor.withValues(alpha: 0.3),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Underweight',
                style: TextStyle(
                  fontSize: 9.sp,
                  color: const Color(0xFF1A8CFF),
                ),
              ),
              Text(
                'Normal',
                style: TextStyle(
                  fontSize: 9.sp,
                  color: const Color(0xFF22C55E),
                ),
              ),
              Text(
                'Overweight',
                style: TextStyle(
                  fontSize: 9.sp,
                  color: const Color(0xFFFF8C42),
                ),
              ),
              Text(
                'Obese',
                style: TextStyle(
                  fontSize: 9.sp,
                  color: const Color(0xFFEF4444),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Vital field
// ─────────────────────────────────────────────────────────────────────────────
class _VitalField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String unit;
  final IconData icon;
  final Color iconColor;

  const _VitalField({
    required this.controller,
    required this.label,
    required this.unit,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 16.r),
              SizedBox(width: 6.w),
              Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
            ),
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,
              border: InputBorder.none,
              suffixText: unit,
              suffixStyle: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Blood pressure field (systolic/diastolic)
// ─────────────────────────────────────────────────────────────────────────────
class _BloodPressureField extends StatelessWidget {
  final TextEditingController sysController;
  final TextEditingController diaController;

  const _BloodPressureField({
    required this.sysController,
    required this.diaController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.favorite_rounded,
                color: const Color(0xFFEF4444),
                size: 16.r,
              ),
              SizedBox(width: 6.w),
              Text(
                'Blood Pressure',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary(context),
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                'mmHg',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary(context),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Systolic',
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                    TextField(
                      controller: sysController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Text(
                  '/',
                  style: TextStyle(
                    fontSize: 24.sp,
                    color: AppColors.textSecondary(context),
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Diastolic',
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: AppColors.textSecondary(context),
                      ),
                    ),
                    TextField(
                      controller: diaController,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                        border: InputBorder.none,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Health tips card
// ─────────────────────────────────────────────────────────────────────────────
class _HealthTipsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const tips = [
      ('Stay hydrated — drink 8 glasses of water daily', Icons.water_drop_rounded, Color(0xFF1A8CFF)),
      ('Exercise for 30 minutes a day', Icons.directions_run_rounded, Color(0xFF22C55E)),
      ('Get 7–8 hours of sleep every night', Icons.bedtime_rounded, Color(0xFF8B5CF6)),
      ('Eat a balanced diet rich in fruits & vegetables', Icons.eco_rounded, Color(0xFF22C55E)),
    ];

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tips_and_updates_rounded,
                color: const Color(0xFFFF8C42),
                size: 18.r,
              ),
              SizedBox(width: 8.w),
              Text(
                'Health Tips',
                style: AppTextStyles.titleSmall.copyWith(
                  color: AppColors.textPrimary(context),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          ...tips.map(
            (tip) => Padding(
              padding: EdgeInsets.only(bottom: 10.h),
              child: Row(
                children: [
                  Container(
                    width: 28.r,
                    height: 28.r,
                    decoration: BoxDecoration(
                      color: tip.$3.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(tip.$2, color: tip.$3, size: 14.r),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Text(
                      tip.$1,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary(context),
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
