import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/utils/app_toast.dart';
import 'package:medi_connect/core/widgets/scaffold/custom_scaffold.dart';
import 'package:medi_connect/core/widgets/appbar/common_app_bar.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_appointments_bloc.dart';
import 'package:medi_connect/modules/patient/booking/presentation/bloc/speciality_booking_cubit.dart';
import 'package:medi_connect/modules/patient/booking/presentation/bloc/speciality_booking_state.dart';

class BookingPaymentConfirmPage extends StatelessWidget {
  final String specialityName;

  const BookingPaymentConfirmPage({
    super.key,
    required this.specialityName,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : Colors.white;

    return CustomScaffold(
      customAppbar: const CommonAppBar(
        title: "Payment Summary",
      ),
      body: BlocListener<SpecialityBookingCubit, SpecialityBookingState>(
        listener: (context, state) {
          if (state.status == SpecialityBookingStatus.success) {
            // Show Success toast overlay
            AppToast.show(
              context,
              "Appointment booked successfully!",
              type: ToastType.success,
            );
            
            // Pop back to the specialty doctors list and details screens
            // popping 3 times takes us back to the home/dashboard or specialties page
            int count = 0;
            Navigator.popUntil(context, (_) => count++ >= 3);
          } else if (state.status == SpecialityBookingStatus.error) {
            // Show Error toast overlay
            AppToast.show(
              context,
              state.errorMessage ?? "Failed to book appointment",
              type: ToastType.error,
            );
          }
        },
        child: BlocBuilder<SpecialityBookingCubit, SpecialityBookingState>(
          builder: (context, state) {
            final docInfo = state.selectedDoctor;
            final date = state.selectedDate;
            final slot = state.selectedSlot;

            if (docInfo == null || date == null || slot == null) {
              return const Center(child: Text("Missing booking details."));
            }

            final fee = state.consultationFee;
            final tax = fee * 0.18; // 18% tax
            final total = fee + tax;

            return Padding(
              padding: EdgeInsets.all(16.r),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Booking Summary",
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Doctor / Date card
                  Card(
                    color: cardBg,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      side: BorderSide(color: AppColors.border(context)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person_outline, color: AppColors.primary, size: 24.r),
                              SizedBox(width: 12.w),
                              Expanded(
                                child: Text(
                                  docInfo.user.fullName,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary(context),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.h),
                          Row(
                            children: [
                              Icon(Icons.calendar_today_outlined, color: AppColors.primary, size: 20.r),
                              SizedBox(width: 12.w),
                              Text(
                                "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textPrimary(context),
                                ),
                              ),
                              const Spacer(),
                              Icon(Icons.access_time, color: AppColors.primary, size: 20.r),
                              SizedBox(width: 6.w),
                              Text(
                                slot,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  color: AppColors.textPrimary(context),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  Text(
                    "Billing Breakdown",
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Billing Details card
                  Card(
                    color: cardBg,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      side: BorderSide(color: AppColors.border(context)),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.r),
                      child: Column(
                        children: [
                          _BillingRow(
                            label: "Consultation Fee",
                            value: "\$${fee.toStringAsFixed(2)}",
                          ),
                          SizedBox(height: 10.h),
                          _BillingRow(
                            label: "Tax & Service Charge (18%)",
                            value: "\$${tax.toStringAsFixed(2)}",
                          ),
                          SizedBox(height: 12.h),
                          const Divider(height: 1),
                          SizedBox(height: 12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Total",
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary(context),
                                  fontSize: 16.sp,
                                ),
                              ),
                              Text(
                                "\$${total.toStringAsFixed(2)}",
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                  fontSize: 18.sp,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  Text(
                    "Payment Method",
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary(context),
                    ),
                  ),
                  SizedBox(height: 12.h),

                  // Selection of payment mode
                  Card(
                    color: cardBg,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      side: BorderSide(color: AppColors.border(context)),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.payment, color: AppColors.primary),
                      title: Text(
                        "Pay at Hospital (Cash/Card)",
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary(context),
                        ),
                      ),
                      subtitle: const Text("Complete payment at the reception counter"),
                      trailing: Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                      ),
                    ),
                  ),
                  const Spacer(),

                  // Confirm booking Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: state.status == SpecialityBookingStatus.loading
                          ? null
                          : () {
                              final authState = context.read<AuthBloc>().state;
                              if (authState is Authenticated) {
                                final userModel = UserModel.fromEntity(authState.user);
                                context.read<SpecialityBookingCubit>().confirmPayment(
                                      context.read<AdminAppointmentsBloc>(),
                                      userModel.id,
                                      userModel.fullName,
                                      specialityName,
                                    );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(16.r),
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: state.status == SpecialityBookingStatus.loading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              "Confirm Appointment",
                              style: AppTextStyles.buttonLarge.copyWith(
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BillingRow extends StatelessWidget {
  final String label;
  final String value;

  const _BillingRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary(context),
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary(context),
          ),
        ),
      ],
    );
  }
}
