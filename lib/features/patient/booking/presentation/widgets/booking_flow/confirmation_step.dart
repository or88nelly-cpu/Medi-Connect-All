import 'package:flutter/material.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_dimensions.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/features/authentication/data/models/user_model.dart';
import 'package:medi_connect/features/patient/booking/presentation/pages/booking_flow_page.dart';

class ConfirmationStep extends StatelessWidget {
  final String bookingId;
  final UserModel? doctor;
  final SpecialtyEntry? specialty;
  final DateTime date;
  final String slot;
  final String paymentMethod;
  final VoidCallback onGoHome;

  const ConfirmationStep({
    super.key,
    required this.bookingId,
    required this.doctor,
    required this.specialty,
    required this.date,
    required this.slot,
    required this.paymentMethod,
    required this.onGoHome,
  });

  String _monthName(int m) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return months[(m - 1).clamp(0, 11)];
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.paddingXXL),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: AppDimensions.spaceXL),

          // Animated checkmark
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            builder: (context, value, child) =>
                Transform.scale(scale: value, child: child),
            child: Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.success, Color(0xFF15803D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
          SizedBox(height: AppDimensions.spaceXXL),

          Text(
            'Booking Confirmed! 🎉',
            style: AppTextStyles.headingSmall.copyWith(
              color: AppColors.textPrimary(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: AppDimensions.spaceS),
          Text(
            'Your appointment has been booked successfully.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary(context),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppDimensions.spaceXXL),

          // Booking ID
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.paddingXL,
              vertical: AppDimensions.paddingS + 2, // 10
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(
                AppDimensions.radiusM - 2,
              ), // 10
              border: Border.all(
                color: AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Booking ID',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary(context),
                  ),
                ),
                SizedBox(height: AppDimensions.spaceXS),
                Text(
                  bookingId,
                  style: TextStyle(
                    fontSize: AppTextStyles.s16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppDimensions.spaceXXL),

          // Details card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(AppDimensions.paddingL),
            decoration: BoxDecoration(
              color: AppColors.card(context),
              borderRadius: BorderRadius.circular(AppDimensions.radiusL),
              border: Border.all(color: AppColors.border(context)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Appointment Details',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.textPrimary(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(
                  color: AppColors.border(context),
                  height: AppDimensions.spaceL,
                ),
                ConfirmRow(
                  icon: Icons.person_rounded,
                  label: 'Doctor',
                  value: doctor?.fullName ?? 'Dr. Specialist',
                  color: AppColors.primary,
                ),
                SizedBox(height: AppDimensions.spaceS + 2),
                ConfirmRow(
                  icon: Icons.medical_services_rounded,
                  label: 'Specialty',
                  value: specialty?.name ?? 'General Medicine',
                  color: specialty?.gradient.first ?? AppColors.secondary,
                ),
                SizedBox(height: AppDimensions.spaceS + 2),
                ConfirmRow(
                  icon: Icons.calendar_today_rounded,
                  label: 'Date & Time',
                  value:
                      '${_monthName(date.month)} ${date.day}, ${date.year}  ·  $slot',
                  color: AppColors.success,
                ),
                SizedBox(height: AppDimensions.spaceS + 2),
                ConfirmRow(
                  icon: Icons.account_balance_wallet_rounded,
                  label: 'Payment',
                  value: paymentMethod,
                  color: AppColors.accent,
                ),
              ],
            ),
          ),
          SizedBox(height: AppDimensions.space32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onGoHome,
              icon: const Icon(Icons.home_rounded, color: Colors.white),
              label: Text(
                'Go to Home',
                style: AppTextStyles.buttonLarge.copyWith(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: EdgeInsets.all(AppDimensions.paddingL),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    AppDimensions.radiusL - 2,
                  ), // 14
                ),
              ),
            ),
          ),
          SizedBox(height: AppDimensions.space32 - 2),
        ],
      ),
    );
  }
}

class ConfirmRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const ConfirmRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusS),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
        SizedBox(width: AppDimensions.spaceWS + 2),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: AppTextStyles.s10,
                color: AppColors.textSecondary(context),
              ),
            ),
            SizedBox(height: 1),
            Text(
              value,
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary(context),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
