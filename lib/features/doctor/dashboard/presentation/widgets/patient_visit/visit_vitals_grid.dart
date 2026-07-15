import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class VisitVitalsGrid extends StatelessWidget {
  final TextEditingController bpCtrl;
  final TextEditingController pulseCtrl;
  final TextEditingController tempCtrl;
  final TextEditingController spo2Ctrl;
  final TextEditingController respRateCtrl;
  final TextEditingController heightCtrl;
  final TextEditingController weightCtrl;
  final TextEditingController bloodSugarCtrl;
  final TextEditingController vitalsNotesCtrl;
  final double bmi;
  final VoidCallback? onHeightOrWeightChanged;
  final bool isEditable;

  const VisitVitalsGrid({
    super.key,
    required this.bpCtrl,
    required this.pulseCtrl,
    required this.tempCtrl,
    required this.spo2Ctrl,
    required this.respRateCtrl,
    required this.heightCtrl,
    required this.weightCtrl,
    required this.bloodSugarCtrl,
    required this.vitalsNotesCtrl,
    required this.bmi,
    this.onHeightOrWeightChanged,
    this.isEditable = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryTextColor = isDark ? Colors.white : AppColors.textDarkNavy;
    final secondaryTextColor = isDark ? Colors.white60 : Colors.grey[600];
    final borderCol = AppColors.border(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: EdgeInsets.all(6.r),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6366F1).withValues(alpha: 0.15),
              ),
              child: Icon(
                Icons.monitor_heart,
                color: const Color(0xFF6366F1),
                size: 18.r,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Vitals',
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryTextColor,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            if (isEditable) ...[
              IconButton(
                icon: Icon(
                  Icons.keyboard_alt_outlined,
                  size: 18.r,
                  color: secondaryTextColor,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(
                  Icons.mic_none_outlined,
                  size: 18.r,
                  color: secondaryTextColor,
                ),
                onPressed: () {},
              ),
            ],
          ],
        ),
        SizedBox(height: 8.h),
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: borderCol),
          ),
          child: Column(
            children: [
              GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 8.w,
                mainAxisSpacing: 8.h,
                childAspectRatio: 1.25,
                children: [
                  _buildInputCard(
                    context,
                    'BP (mmHg)',
                    bpCtrl,
                    Icons.favorite,
                    const Color(0xFFEF4444),
                    isDark,
                  ),
                  _buildInputCard(
                    context,
                    'Pulse (bpm)',
                    pulseCtrl,
                    Icons.speed,
                    const Color(0xFF10B981),
                    isDark,
                  ),
                  _buildInputCard(
                    context,
                    'Temp (°F)',
                    tempCtrl,
                    Icons.thermostat,
                    const Color(0xFFF59E0B),
                    isDark,
                  ),
                  _buildInputCard(
                    context,
                    'SpO2 (%)',
                    spo2Ctrl,
                    Icons.water_drop,
                    const Color(0xFF3B82F6),
                    isDark,
                  ),
                  _buildInputCard(
                    context,
                    'Resp (/min)',
                    respRateCtrl,
                    Icons.air,
                    const Color(0xFF06B6D4),
                    isDark,
                  ),
                  _buildInputCard(
                    context,
                    'Height (cm)',
                    heightCtrl,
                    Icons.straighten,
                    const Color(0xFF8B5CF6),
                    isDark,
                    onChanged: (_) => onHeightOrWeightChanged?.call(),
                  ),
                  _buildInputCard(
                    context,
                    'Weight (kg)',
                    weightCtrl,
                    Icons.scale,
                    const Color(0xFF3B82F6),
                    isDark,
                    onChanged: (_) => onHeightOrWeightChanged?.call(),
                  ),
                  // BMI Card
                  Container(
                    padding: EdgeInsets.all(8.r),
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white10 : const Color(0xFFFEF3C7),
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(
                        color: isDark
                            ? Colors.white12
                            : const Color(0xFFFDE68A),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.monitor,
                              size: 14.r,
                              color: const Color(0xFFD97706),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'BMI',
                              style: TextStyle(
                                color: isDark
                                    ? Colors.white60
                                    : const Color(0xFFD97706),
                                fontSize: 8.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          bmi > 0 ? bmi.toStringAsFixed(1) : 'N/A',
                          style: TextStyle(
                            color: isDark
                                ? Colors.white
                                : const Color(0xFFB45309),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildInputCard(
                    context,
                    'Sugar (mg/dL)',
                    bloodSugarCtrl,
                    Icons.bloodtype,
                    const Color(0xFFEF4444),
                    isDark,
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              TextField(
                controller: vitalsNotesCtrl,
                enabled: isEditable,
                decoration: InputDecoration(
                  hintText: 'Vitals notes (Type or speak...)',
                  hintStyle: TextStyle(
                    color: secondaryTextColor,
                    fontSize: 12.sp,
                  ),
                  prefixIcon: Icon(
                    Icons.notes,
                    size: 18.r,
                    color: secondaryTextColor,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.r),
                    borderSide: BorderSide(color: borderCol),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 8.h,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInputCard(
    BuildContext context,
    String label,
    TextEditingController controller,
    IconData icon,
    Color iconColor,
    bool isDark, {
    ValueChanged<String>? onChanged,
  }) {
    return Container(
      padding: EdgeInsets.all(6.r),
      decoration: BoxDecoration(
        color: isDark ? Colors.white10 : Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 12.r, color: iconColor),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: isDark ? Colors.white60 : Colors.grey[500],
                    fontSize: 8.sp,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 2.h),
          SizedBox(
            height: 22.h,
            child: TextField(
              controller: controller,
              enabled: isEditable,
              style: TextStyle(
                color: isDark ? Colors.white : AppColors.textDarkNavy,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
