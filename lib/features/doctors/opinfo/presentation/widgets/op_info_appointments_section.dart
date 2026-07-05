import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/features/doctors/opinfo/domain/entities/op_procedure_entity.dart';
import 'package:medi_connect/features/doctors/opinfo/presentation/widgets/op_info_appointment_item.dart';

class OpInfoAppointmentsSection extends StatelessWidget {
  final List<OpProcedureEntity> procedures;
  final int totalCount;

  const OpInfoAppointmentsSection({
    super.key,
    required this.procedures,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 20.h, 16.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${AppStrings.opInfoTodaysAppointments} ($totalCount)',
            style: AppTextStyles.titleMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(height: 12.h),
          if (procedures.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 32.h),
                child: Text(
                  AppStrings.noScheduleToday,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ),
            )
          else
            ...procedures.map(
              (p) => OpInfoAppointmentItem(procedure: p, onTap: () {}),
            ),
        ],
      ),
    );
  }
}
