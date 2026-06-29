import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/constants/app_assets.dart';

class AnalyticsOverviewSection extends StatelessWidget {
  final int patients;
  final int appointments;
  final int availableBeds;
  final int doctors;
  final int staff;
  final double revenue;
  final VoidCallback? onPatientsTap;
  final VoidCallback? onAppointmentsTap;
  final VoidCallback? onBedsTap;
  final VoidCallback? onDoctorsTap;
  final VoidCallback? onStaffTap;
  final VoidCallback? onRevenueTap;

  const AnalyticsOverviewSection({
    super.key,
    required this.patients,
    required this.appointments,
    required this.availableBeds,
    required this.doctors,
    required this.staff,
    required this.revenue,
    this.onPatientsTap,
    this.onAppointmentsTap,
    this.onBedsTap,
    this.onDoctorsTap,
    this.onStaffTap,
    this.onRevenueTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final titleColor = isDark
        ? AppColors.terminalDarkText
        : AppColors.terminalLightText;
    final labelColor = isDark
        ? AppColors.terminalDarkLabel
        : AppColors.terminalLightLabel;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppStrings.analyticsOverview,
              style: AppTextStyles.titleMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
            Text(
              AppStrings.realTime,
              style: AppTextStyles.bodySmall.copyWith(
                fontSize: 9.sp,
                fontWeight: FontWeight.bold,
                color: labelColor,
                letterSpacing: 1.1,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        GridView.count(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12.r,
          mainAxisSpacing: 12.r,
          childAspectRatio: MediaQuery.of(context).size.width > 600 ? 2.5 : 5,
          children: [
            _StatCard(
              label: AppStrings.patients,
              value: patients.toString(),
              iconPath: AppAssets.femaleAvatarPng,
              lineColor: AppColors.primary,
              onTap: onPatientsTap,
              painter: _WavyLinePainter(AppColors.primary),
            ),
            _StatCard(
              label: AppStrings.appointments,
              value: appointments.toString(),
              iconPath: AppAssets.appointments,
              lineColor: AppColors.textSecondary(context),
              onTap: onAppointmentsTap,
              painter: _HorizontalLinePainter(
                isDark
                    ? AppColors.terminalDarkLabel
                    : AppColors.terminalLightLabel,
              ),
            ),
            _StatCard(
              label: AppStrings.availableBeds,
              value: availableBeds.toString(),
              iconPath: AppAssets.bed,
              lineColor: AppColors.secondary,
              onTap: onBedsTap,
              painter: _WavyLinePainter(AppColors.secondary),
            ),
            _StatCard(
              label: AppStrings.doctors,
              value: doctors.toString(),
              iconPath: AppAssets.femaleDoctorAvatarPng,
              lineColor: AppColors.accent,
              onTap: onDoctorsTap,
              painter: _ArcPainter(AppColors.accent),
            ),
            _StatCard(
              label: AppStrings.staff,
              value: staff.toString(),
              iconPath: AppAssets.femaleStaffAvatarPng,
              lineColor: AppColors.infoOrange,
              onTap: onStaffTap,
              painter: _WavyLinePainter(AppColors.infoOrange),
            ),
            _StatCard(
              label: AppStrings.totalRevenue,
              value: "₹ ${revenue.toStringAsFixed(2)}",
              iconPath: AppAssets.revenue,
              lineColor: AppColors.infoIndigo,
              onTap: onRevenueTap,
              painter: _ArcPainter(AppColors.infoIndigo),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String iconPath;
  final Color lineColor;
  final VoidCallback? onTap;
  final CustomPainter painter;

  const _StatCard({
    required this.label,
    required this.value,
    required this.iconPath,
    required this.lineColor,
    required this.painter,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark
        ? AppColors.terminalDarkCard
        : AppColors.terminalLightCard;
    final borderColor = isDark
        ? AppColors.terminalDarkBorder
        : AppColors.terminalLightBorder;
    final textColor = isDark
        ? AppColors.terminalDarkText
        : AppColors.terminalLightText;
    final labelColor = isDark
        ? AppColors.terminalDarkLabel
        : AppColors.terminalLightLabel;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor, width: 1.2),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                width: 100.r,
                height: 30.r,
                child: CustomPaint(painter: painter),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      width: 52.r,
                      height: 52.r,
                      padding: EdgeInsets.all(4.r),
                      decoration: BoxDecoration(
                        // shape: BoxShape.circle,
                        color: AppColors.primary.withAlpha(80),
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: CustomImageView(
                        imagePath: iconPath,
                        fit: BoxFit.contain,
                        borderRadius: 100.r,
                      ),
                    ),
                    SizedBox(width: 20.r),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label.toUpperCase(),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: labelColor,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.8,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          value,
                          style: AppTextStyles.titleLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: textColor,
                            fontSize: 14.sp,
                            height: 1.1,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _WavyLinePainter extends CustomPainter {
  final Color color;
  _WavyLinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.2,
      size.width * 0.5,
      size.height * 0.5,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.8,
      size.width,
      size.height * 0.3,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HorizontalLinePainter extends CustomPainter {
  final Color color;
  _HorizontalLinePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(0, size.height * 0.5),
      Offset(size.width, size.height * 0.5),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ArcPainter extends CustomPainter {
  final Color color;
  _ArcPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(0, size.height * 0.8);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.1,
      size.width,
      size.height * 0.3,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
