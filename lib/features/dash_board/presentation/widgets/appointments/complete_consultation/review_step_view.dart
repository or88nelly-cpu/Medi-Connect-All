import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/themes/app_colors.dart';
import 'package:medi_connect/core/themes/app_text_styles.dart';
import 'package:medi_connect/core/common_widgets/image/custom_image_view.dart';
import 'package:medi_connect/core/utils/profile_image_helper.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';
import 'package:medi_connect/features/patient/presentation/bloc/patient_bloc.dart';
import 'package:medi_connect/features/dash_board/domain/entities/appointment_entity.dart';
import 'complete_consultation_cubit.dart';

class ReviewStepView extends StatelessWidget {
  final AppointmentEntity appointment;
  final TextEditingController prescriptionNotesCtrl;

  const ReviewStepView({
    super.key,
    required this.appointment,
    required this.prescriptionNotesCtrl,
  });

  UserModel? _findPatient(BuildContext context) {
    final state = context.read<PatientBloc>().state;
    if (state is PatientLoaded) {
      try {
        return state.patients.firstWhere(
          (p) =>
              p.patientId == appointment.patientId ||
              p.id == appointment.patientId,
        );
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  double _calculateMedicineCost(CompleteConsultationState state) {
    double total = 0.0;
    for (final row in state.medicines) {
      final nameCtrl = row['name'] as TextEditingController?;
      if (nameCtrl != null && nameCtrl.text.trim().isNotEmpty) {
        final price = row['sell_price'] as double? ?? 150.0;
        final freqStr =
            (row['frequency'] as TextEditingController?)?.text.trim() ?? '';
        final daysStr =
            (row['days'] as TextEditingController?)?.text.trim() ?? '';
        int days = int.tryParse(daysStr) ?? 7;
        double dailyCount = 0.0;
        if (freqStr.contains('-')) {
          final parts = freqStr.split('-');
          double sum = 0.0;
          for (final part in parts) {
            sum += double.tryParse(part.trim()) ?? 0.0;
          }
          dailyCount = sum;
        } else {
          dailyCount = double.tryParse(freqStr) ?? 1.0;
        }
        double totalPills = dailyCount * days;
        total += (totalPills / 10.0) * price;
      }
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cubit = context.watch<CompleteConsultationCubit>();
    final state = cubit.state;

    // Resolve Patient Details
    final patient = _findPatient(context);
    final patientName = patient?.name ?? appointment.patientName;
    final patientId = patient?.patientId ?? 'PAT-20260061';
    final age = patient?.age ?? '34';
    final gender = patient?.gender ?? 'Female';
    final phone = patient?.phoneNumber ?? '+91 98765 43210';
    final bloodGroup = patient?.bloodGroup ?? 'O+';
    final patientImg = ProfileImageHelper.resolveImagePath(
      patient?.profileImage,
      'patient',
      gender,
    );

    // Resolve Doctor Details
    final docGender = appointment.doctorName.toLowerCase().contains('sindhya')
        ? 'female'
        : 'male';
    final docImg = ProfileImageHelper.resolveImagePath(
      null,
      'doctor',
      docGender,
    );
    final cleanDocName = appointment.doctorName
        .replaceAll(RegExp(r'^(Dr\.\s*)+', caseSensitive: false), '')
        .trim();

    // Financial calculations
    final double consultFee = 500.00;
    final double medicineCost = _calculateMedicineCost(state);
    final double labCost = state.selectedTests.length * 250.0;
    //final double totalCost = consultFee + medicineCost + labCost;

    final cardBg = isDark ? AppColors.terminalDarkCard : Colors.white;
    final borderColor = AppColors.border(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. Patient Info Card
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 26.r,
                backgroundColor: Colors.blue.withValues(alpha: 0.1),
                child: ClipOval(
                  child: CustomImageView(
                    imagePath: patientImg,
                    width: 52.r,
                    height: 52.r,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            patientName,
                            style: AppTextStyles.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.textPrimary(context),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(6.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check,
                                size: 12,
                                color: AppColors.success,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'Completed',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: AppColors.success,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 6.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: Text(
                            'PID: $patientId',
                            style: TextStyle(
                              fontSize: 10.sp,
                              color: Colors.blue[600],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '$age Years, $gender',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isDark
                                ? Colors.white70
                                : AppColors.textSecondary(context),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(
                          Icons.phone_outlined,
                          size: 12.r,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          phone,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: isDark
                                ? Colors.white54
                                : AppColors.textSecondary(context),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Icon(
                          Icons.water_drop_outlined,
                          size: 12.r,
                          color: Colors.red,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          bloodGroup,
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: isDark
                                ? Colors.white54
                                : AppColors.textSecondary(context),
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
        SizedBox(height: 12.h),

        // 2. Doctor Info Card
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: borderColor),
          ),
          child: Row(
            children: [
              CircleAvatar(
                radius: 24.r,
                backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                child: ClipOval(
                  child: CustomImageView(
                    imagePath: docImg,
                    width: 48.r,
                    height: 48.r,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Dr. $cleanDocName',
                          style: AppTextStyles.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? Colors.white
                                : AppColors.textPrimary(context),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Icon(
                          Icons.verified,
                          size: 14.r,
                          color: Colors.blue[600],
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      appointment.specialty,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isDark
                            ? Colors.white70
                            : AppColors.textSecondary(context),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      'DM ${appointment.specialty}, 12+ Years Exp.',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 10.sp,
                        color:AppColors.textSecondary(context).withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.phone_outlined, color: Colors.blue),
                style: IconButton.styleFrom(
                  backgroundColor: Colors.blue.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),

        // 3. Prescribed Medicines Card
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.description_outlined,
                        color: Colors.teal[600],
                        size: 18.r,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Prescribed Medicines',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : AppColors.textPrimary(context),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.teal.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      '${state.medicines.where((m) => (m['name'] as TextEditingController).text.trim().isNotEmpty).length} Item(s)',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.teal[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              if (state.medicines
                  .where(
                    (m) => (m['name'] as TextEditingController).text
                        .trim()
                        .isNotEmpty,
                  )
                  .isEmpty)
                Text(
                  'No medicines prescribed.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark
                        ? Colors.white38
                        : AppColors.textSecondary(context),
                  ),
                )
              else
                ...state.medicines
                    .where(
                      (m) => (m['name'] as TextEditingController).text
                          .trim()
                          .isNotEmpty,
                    )
                    .map((row) {
                      final name = (row['name'] as TextEditingController).text
                          .trim();
                      final strength = (row['dosage'] as TextEditingController)
                          .text
                          .trim();
                      final freq = (row['frequency'] as TextEditingController)
                          .text
                          .trim();
                      final days = (row['days'] as TextEditingController).text
                          .trim();
                      final sellPrice = row['sell_price'] as double? ?? 150.0;

                      // Calculate row cost
                      int d = int.tryParse(days) ?? 7;
                      double daily = 1.0;
                      if (freq.contains('-')) {
                        final parts = freq.split('-');
                        double sum = 0.0;
                        for (final p in parts) {
                          sum += double.tryParse(p.trim()) ?? 0.0;
                        }
                        daily = sum;
                      } else {
                        daily = double.tryParse(freq) ?? 1.0;
                      }
                      double pills = daily * d;
                      double cost = (pills / 10.0) * sellPrice;

                      return Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: AppTextStyles.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? Colors.white
                                          : AppColors.textPrimary(context),
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    '${strength.isNotEmpty ? "$strength, " : ""}$freq, $days Days',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: isDark
                                          ? Colors.white54
                                          : AppColors.textSecondary(context),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  '₹${cost.toStringAsFixed(2)}',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.success,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 6.w,
                                    vertical: 2.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.success.withValues(
                                      alpha: 0.15,
                                    ),
                                    borderRadius: BorderRadius.circular(4.r),
                                  ),
                                  child: Text(
                                    'PAID',
                                    style: TextStyle(
                                      fontSize: 8.sp,
                                      color: AppColors.success,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),
            ],
          ),
        ),
        SizedBox(height: 12.h),

        // 4. Scheduled Lab Tests Card
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.science_outlined,
                        color: Colors.orange[600],
                        size: 18.r,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Scheduled Lab Tests',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : AppColors.textPrimary(context),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      '${state.selectedTests.length} Item(s)',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: Colors.orange[700],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              if (state.selectedTests.isEmpty)
                Text(
                  'No lab tests scheduled.',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark
                        ? Colors.white38
                        : AppColors.textSecondary(context),
                  ),
                )
              else
                ...state.selectedTests.map((test) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            test,
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.textPrimary(context),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '₹250.00',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange[700],
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                              child: Text(
                                'PAID',
                                style: TextStyle(
                                  fontSize: 8.sp,
                                  color: Colors.orange[700],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
            ],
          ),
        ),
        SizedBox(height: 12.h),

        // 5. Consultation Notes Card
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.notes, color: Colors.blue[600], size: 18.r),
                      SizedBox(width: 8.w),
                      Text(
                        'Consultation Notes',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : AppColors.textPrimary(context),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'View All',
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: Colors.blue[600],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.format_quote,
                    color: Colors.blue.withValues(alpha: 0.3),
                    size: 24.r,
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      prescriptionNotesCtrl.text.trim().isNotEmpty
                          ? prescriptionNotesCtrl.text.trim()
                          : 'Patient details, clinical diagnosis, and routine EMR notes recorded for this session.',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontStyle: FontStyle.italic,
                        color: isDark
                            ? Colors.white70
                            : AppColors.textPrimary(context),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 12.h),

        // 6. Billing & Payment Card
        Container(
          padding: EdgeInsets.all(16.r),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    color: Colors.purple[600],
                    size: 18.r,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    'Billing & Payment',
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? Colors.white
                          : AppColors.textPrimary(context),
                    ),
                  ),
                ],
              ),
              const Divider(height: 20),
              _buildBillRow(
                'Consultation Fee',
                '₹${consultFee.toStringAsFixed(2)}',
                isDark,
                context
              ),
              if (medicineCost > 0)
                _buildBillRow(
                  'Medicine Total',
                  '₹${medicineCost.toStringAsFixed(2)}',
                  isDark,
                  context
                ),
              if (labCost > 0)
                _buildBillRow(
                  'Lab Test Total',
                  '₹${labCost.toStringAsFixed(2)}',
                  isDark,
                  context
                ),
              _buildBillRow('Payment Method', state.paymentMethod, isDark,context),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Payment Status',
                    style: AppTextStyles.bodySmall.copyWith(
                      color:AppColors.textSecondary(context),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      'PAID',
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: AppColors.success,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(height: 24),
              // Authorized Invoice Stamp
              Container(
                padding: EdgeInsets.all(12.r),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(8.r),
                  border: Border.all(
                    color: Colors.purple.withValues(alpha: 0.1),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.verified_user_outlined,
                      color: Colors.purple[300],
                      size: 18.r,
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Authorized invoice',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontStyle: FontStyle.italic,
                              color: isDark
                                  ? Colors.white54
                                  : AppColors.textSecondary(context),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Dr. $cleanDocName',
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? Colors.white
                                  : AppColors.textPrimary(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // signature graphic placeholder
                    Container(
                      height: 30.h,
                      width: 80.w,
                      alignment: Alignment.center,
                      child: Text(
                        cleanDocName.split(' ').first,
                        style: TextStyle(
                          fontFamily: 'Cursive',
                          fontSize: 18.sp,
                          color: Colors.purple[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBillRow(String label, String value, bool isDark,BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: isDark ? Colors.white54 : AppColors.textSecondary(context),
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppColors.textPrimary(context),
            ),
          ),
        ],
      ),
    );
  }
}
