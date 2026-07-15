import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';

class SuccessAppointmentSummaryCard extends StatelessWidget {
  final String doctorName;
  final String doctorQual;
  final String specialityName;
  final String dateStr;
  final String slot;
  final String patientName;
  final double amount;
  final String bookingId;
  final bool isPayLater;
  final Color cardBg;
  final Color textColor;

  const SuccessAppointmentSummaryCard({
    super.key,
    required this.doctorName,
    required this.doctorQual,
    required this.specialityName,
    required this.dateStr,
    required this.slot,
    required this.patientName,
    required this.amount,
    required this.bookingId,
    required this.isPayLater,
    required this.cardBg,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.border(context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Appointment Summary',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w900,
              color: textColor,
            ),
          ),
          const Divider(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor block
              Expanded(
                flex: 5,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44.r,
                      height: 44.r,
                      decoration: const BoxDecoration(
                        color: Colors.black12,
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(Icons.person, size: 24.r, color: Colors.grey),
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
                                  doctorName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w900,
                                    color: textColor,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.verified_rounded,
                                color: const Color(0xFF3B5BFD),
                                size: 10.r,
                              ),
                            ],
                          ),
                          Text(
                            doctorQual,
                            style: TextStyle(
                              fontSize: 8.5.sp,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'MediConnect Hospital',
                            style: TextStyle(
                              fontSize: 7.5.sp,
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.h),
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
                                fontSize: 7.sp,
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

              // Detail fields block
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    _buildSummaryItem('Date', dateStr, textColor),
                    _buildSummaryItem('Time', slot, textColor),
                    _buildSummaryItem('Patient', patientName, textColor),
                    _buildSummaryItem('Booking ID', bookingId, textColor),
                    _buildSummaryItem(
                      isPayLater ? 'Amount Due' : 'Amount Paid',
                      '₹${amount.toStringAsFixed(0)}',
                      AppColors.success,
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

  Widget _buildSummaryItem(String label, String val, Color textColor) {
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
            val,
            style: TextStyle(
              fontSize: 8.sp,
              color: textColor,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
