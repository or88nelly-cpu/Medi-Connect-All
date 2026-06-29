import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/functions/app_responsive.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_strings.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';

class CustomerCareHeader extends StatefulWidget {
  final VoidCallback? onReset;
  final Function(String)? onSpecialityChanged;
  final Function(DateTimeRange)? onDateRangeChanged;

  const CustomerCareHeader({
    super.key,
    this.onReset,
    this.onSpecialityChanged,
    this.onDateRangeChanged,
  });

  @override
  State<CustomerCareHeader> createState() => _CustomerCareHeaderState();
}

class _CustomerCareHeaderState extends State<CustomerCareHeader> {
  String selectedSpeciality = AppStrings.allSpecialities;
  String dateRangeString = "01 Jun 2026 - 17 Jun 2026";

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDesktop = AppResponsive.isDesktop(context);
    final isMobile = AppResponsive.isMobile(context);

    final widgetBg = AppColors.dashboardCardBg(context);
    final borderColor = AppColors.dashboardCardBorder(context);
    final textColor = AppColors.dashboardTextPrimary(context);
    final labelColor = AppColors.dashboardTextSecondary(context);

    // Filter dropdowns list
    final filtersList = [
      // Date Range Picker Dropdown
      InkWell(
        onTap: () async {
          final picked = await showDateRangePicker(
            context: context,
            firstDate: DateTime(2026),
            lastDate: DateTime(2030),
            initialDateRange: DateTimeRange(
              start: DateTime(2026, 6, 1),
              end: DateTime(2026, 6, 17),
            ),
          );
          if (picked != null) {
            setState(() {
              dateRangeString =
                  "${picked.start.day.toString().padLeft(2, '0')} ${_getMonthName(picked.start.month)} ${picked.start.year} - ${picked.end.day.toString().padLeft(2, '0')} ${_getMonthName(picked.end.month)} ${picked.end.year}";
            });
            widget.onDateRangeChanged?.call(picked);
          }
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.03)
                : Colors.black.withValues(alpha: 0.02),
            border: Border.all(color: borderColor, width: 1.2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 16.r,
                color: isDark ? AppColors.primaryLight : AppColors.primary,
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.dateRange,
                    style: AppTextStyles.bodyXSmall.copyWith(
                      color: labelColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    dateRangeString,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 16.r,
                color: labelColor,
              ),
            ],
          ),
        ),
      ),
      SizedBox(width: 12.w, height: 12.h),

      // Speciality Picker Dropdown
      PopupMenuButton<String>(
        onSelected: (val) {
          setState(() {
            selectedSpeciality = val;
          });
          widget.onSpecialityChanged?.call(val);
        },
        itemBuilder: (context) => [
          AppStrings.allSpecialities,
          "General Medicine",
          "Orthopedics",
          "Pediatrics",
          "Dermatology",
          "ENT",
          "Cardiology",
        ].map((spec) => PopupMenuItem(value: spec, child: Text(spec))).toList(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withValues(alpha: 0.03)
                : Colors.black.withValues(alpha: 0.02),
            border: Border.all(color: borderColor, width: 1.2),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.medical_services_outlined,
                size: 16.r,
                color: isDark ? AppColors.primaryLight : AppColors.primary,
              ),
              SizedBox(width: 8.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.speciality,
                    style: AppTextStyles.bodyXSmall.copyWith(
                      color: labelColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    selectedSpeciality,
                    style: AppTextStyles.bodySmall.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 16.r,
                color: labelColor,
              ),
            ],
          ),
        ),
      ),
      SizedBox(width: 12.w, height: 12.h),

      // Reset Button
      ElevatedButton.icon(
        onPressed: () {
          setState(() {
            selectedSpeciality = AppStrings.allSpecialities;
            dateRangeString = "01 Jun 2026 - 17 Jun 2026";
          });
          widget.onReset?.call();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Dashboard filters reset successfully'),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: isDark
              ? Colors.white.withValues(alpha: 0.05)
              : Colors.white,
          foregroundColor: isDark ? Colors.white : AppColors.primary,
          elevation: isDark ? 0 : 2,
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: BorderSide(color: borderColor, width: 1.2),
          ),
        ),
        icon: Icon(Icons.sync_rounded, size: 16.r),
        label: Text(
          AppStrings.reset,
          style: AppTextStyles.buttonMedium.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: widgetBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: borderColor, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: isDesktop
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTitleSection(textColor, labelColor),
                Row(mainAxisSize: MainAxisSize.min, children: filtersList),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitleSection(textColor, labelColor),
                SizedBox(height: 18.h),
                isMobile
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: filtersList,
                      )
                    : Wrap(
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: filtersList,
                      ),
              ],
            ),
    );
  }

  Widget _buildTitleSection(Color textColor, Color labelColor) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final canPop = Navigator.of(context).canPop();
    return Row(
      children: [
        if (canPop) ...[
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: textColor,
              size: 20.r,
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          SizedBox(width: 8.w),
        ],
        Container(
          width: 54.r,
          height: 54.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF0F1A35), const Color(0xFF070F22)]
                  : [const Color(0xFFE0E7FF), const Color(0xFFC7D2FE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: isDark
                  ? AppColors.primaryLight.withValues(alpha: 0.3)
                  : AppColors.primary.withValues(alpha: 0.3),
              width: 2.r,
            ),
            boxShadow: [
              BoxShadow(
                color: isDark
                    ? AppColors.primaryLight.withValues(alpha: 0.15)
                    : AppColors.primary.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              Icons.headset_mic_rounded,
              color: isDark ? AppColors.primaryLight : AppColors.primary,
              size: 26.r,
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.customerCare,
              style: AppTextStyles.dashboardTitle.copyWith(
                color: textColor,
                fontSize: 22.sp,
                height: 1.1,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              AppStrings.smartCareSubtitle,
              style: AppTextStyles.dashboardSubtitle.copyWith(
                color: labelColor,
                fontSize: 12.sp,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _getMonthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    if (month >= 1 && month <= 12) {
      return months[month - 1];
    }
    return "";
  }
}
