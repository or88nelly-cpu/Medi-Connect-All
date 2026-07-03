import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/constants/app_assets.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';

class PaymentAppointmentSummaryCard extends StatelessWidget {
  final dynamic docInfo;
  final String dateStr;
  final String slot;
  final double fee;
  final String specialityName;
  final Color cardBg;
  final Color textColor;

  const PaymentAppointmentSummaryCard({
    super.key,
    required this.docInfo,
    required this.dateStr,
    required this.slot,
    required this.fee,
    required this.specialityName,
    required this.cardBg,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    String patientName = 'Likhin Nelliyotan';
    if (authState is Authenticated) {
      patientName = authState.user.fullName;
    }

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Doctor block
          Expanded(
            flex: 4,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(24.r),
                  child: CustomImageView(
                    imagePath: docInfo.user.profilePhoto ?? "",
                    width: 48.r,
                    height: 48.r,
                    fit: BoxFit.cover,
                    errorWidget: Image.asset(
                      docInfo.user.gender == 'Male'
                          ? AppAssets.maleAvatarPng
                          : AppAssets.femaleAvatarPng,
                      width: 48.r,
                      height: 48.r,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              docInfo.user.fullName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w900,
                                color: textColor,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.verified_rounded,
                            color: const Color(0xFF3B5BFD),
                            size: 12.r,
                          ),
                        ],
                      ),
                      Text(
                        docInfo.doctorInfo?.qualification ?? 'Specialist MD',
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        'MediConnect Hospital',
                        style: TextStyle(
                          fontSize: 8.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFECEF),
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          specialityName,
                          style: TextStyle(
                            color: const Color(0xFFFF296D),
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(width: 1),

          // Date/Time Center block
          Expanded(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_month_outlined,
                        color: AppColors.primary,
                        size: 14.r,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Date',
                        style: TextStyle(
                          fontSize: 8.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    dateStr,
                    style: TextStyle(
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_outlined,
                        color: AppColors.primary,
                        size: 14.r,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Time',
                        style: TextStyle(
                          fontSize: 8.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    slot,
                    style: TextStyle(
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Icon(
                        Icons.person_outline_rounded,
                        color: AppColors.primary,
                        size: 14.r,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'Patient',
                        style: TextStyle(
                          fontSize: 8.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    patientName,
                    style: TextStyle(
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w900,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(width: 1),

          // Fees breakdown block
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFeeItem(
                  'Consultation Fee',
                  '₹${fee.toStringAsFixed(0)}',
                  textColor,
                ),
                _buildFeeItem('Platform Fee', '₹0', textColor),
                _buildFeeItem('Taxes & Charges', '₹0', textColor),
                const Divider(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount',
                      style: TextStyle(
                        fontSize: 9.sp,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    Text(
                      '₹${fee.toStringAsFixed(0)}',
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF3B5BFD),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeeItem(String label, String value, Color textColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 8.sp,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 8.sp,
              color: textColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
