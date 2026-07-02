import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/modules/patient/booking/presentation/bloc/speciality_booking_cubit.dart';
import 'package:medi_connect/modules/patient/booking/presentation/bloc/speciality_booking_state.dart';
import 'package:medi_connect/modules/patient/booking/presentation/pages/booking_payment_confirm_page.dart';

class DoctorDetailBookingPage extends StatelessWidget {
  final List<Color> gradientColors;
  final String specialityName;

  const DoctorDetailBookingPage({
    super.key,
    required this.gradientColors,
    required this.specialityName,
  });

  List<DateTime> get _nextSevenDays =>
      List.generate(7, (i) => DateTime.now().add(Duration(days: i)));

  List<String> get _standardSlots => const [
        '09:00 AM',
        '10:00 AM',
        '11:00 AM',
        '12:00 PM',
        '02:00 PM',
        '03:00 PM',
        '04:00 PM',
        '05:00 PM',
      ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SpecialityBookingCubit, SpecialityBookingState>(
      builder: (context, state) {
        final docInfo = state.selectedDoctor;
        if (docInfo == null) {
          return const Scaffold(
            body: Center(child: Text("No doctor selected.")),
          );
        }

        final user = docInfo.user;
        final doc = docInfo.doctorInfo;
        final exp = doc?.yearsOfExperience ?? doc?.experienceYears ?? 5;
        final fee = state.consultationFee;

        return Scaffold(
          backgroundColor: AppColors.scaffold(context),
          body: CustomScrollView(
            slivers: [
              // Hero AppBar
              SliverAppBar(
                expandedHeight: 220.h,
                pinned: true,
                backgroundColor: gradientColors.first,
                leading: IconButton(
                  icon: Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: const Icon(
                      Icons.arrow_back_rounded,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradientColors,
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          right: -20,
                          top: -20,
                          child: Container(
                            width: 120.r,
                            height: 120.r,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: EdgeInsets.only(
                              left: 20.w,
                              right: 20.w,
                              bottom: 20.h,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 72.r,
                                  height: 72.r,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.25),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.white54,
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.person_rounded,
                                    color: Colors.white,
                                    size: 36.r,
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user.fullName,
                                        style: AppTextStyles.titleLarge.copyWith(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 3.h),
                                      Text(
                                        doc?.qualification ?? "Specialist MD",
                                        style: AppTextStyles.bodyMedium.copyWith(
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Stats Row
                      Row(
                        children: [
                          _StatBox(
                            value: "$exp+",
                            label: "Years Exp",
                            icon: Icons.work_outline,
                            color: gradientColors.first,
                          ),
                          SizedBox(width: 12.w),
                          _StatBox(
                            value: "\$${fee.toStringAsFixed(2)}",
                            label: "Cons. Fee",
                            icon: Icons.payments_outlined,
                            color: const Color(0xFF22C55E),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),

                      // About Section
                      _SectionTitle(title: "Biography", icon: Icons.info_outline),
                      SizedBox(height: 8.h),
                      Container(
                        padding: EdgeInsets.all(14.r),
                        decoration: BoxDecoration(
                          color: AppColors.card(context),
                          borderRadius: BorderRadius.circular(14.r),
                          border: Border.all(color: AppColors.border(context)),
                        ),
                        child: Text(
                          doc?.biography ??
                              "${user.fullName} is a dedicated medical specialist with extensive years of practice. Highly committed to offering clinical guidance, evidence-based diagnoses, and patient-centered rehabilitation.",
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textPrimary(context),
                            height: 1.5,
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Available Dates Section
                      _SectionTitle(
                        title: "Available Dates",
                        icon: Icons.calendar_month_outlined,
                      ),
                      SizedBox(height: 10.h),
                      SizedBox(
                        height: 72.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _nextSevenDays.length,
                          separatorBuilder: (context, _) => SizedBox(width: 10.w),
                          itemBuilder: (context, i) {
                            final d = _nextSevenDays[i];
                            final isSelected = state.selectedDate != null &&
                                state.selectedDate!.year == d.year &&
                                state.selectedDate!.month == d.month &&
                                state.selectedDate!.day == d.day;
                            return GestureDetector(
                              onTap: () => context
                                  .read<SpecialityBookingCubit>()
                                  .selectDate(d),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                width: 56.w,
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? LinearGradient(colors: gradientColors)
                                      : null,
                                  color: isSelected
                                      ? null
                                      : AppColors.card(context),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: isSelected
                                        ? gradientColors.first
                                        : AppColors.border(context),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      _weekdayAbbr(d.weekday),
                                      style: TextStyle(
                                        fontSize: 10.sp,
                                        color: isSelected
                                            ? Colors.white70
                                            : AppColors.textSecondary(context),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 4.h),
                                    Text(
                                      "${d.day}",
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                        color: isSelected
                                            ? Colors.white
                                            : AppColors.textPrimary(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 24.h),

                      // Time Slots Section
                      if (state.selectedDate != null) ...[
                        _SectionTitle(
                          title: "Select Slot",
                          icon: Icons.access_time_outlined,
                        ),
                        SizedBox(height: 12.h),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 10.w,
                            mainAxisSpacing: 10.h,
                            childAspectRatio: 2.2,
                          ),
                          itemCount: _standardSlots.length,
                          itemBuilder: (context, idx) {
                            final slotTime = _standardSlots[idx];
                            final isBooked = state.bookedSlots.contains(slotTime);
                            final isSelected = state.selectedSlot == slotTime;

                            return InkWell(
                              onTap: isBooked
                                  ? null
                                  : () => context
                                      .read<SpecialityBookingCubit>()
                                      .selectSlot(slotTime),
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: isBooked
                                      ? (Theme.of(context).brightness ==
                                              Brightness.dark
                                          ? Colors.grey.shade900
                                          : Colors.grey.shade200)
                                      : isSelected
                                          ? gradientColors.first
                                          : AppColors.card(context),
                                  borderRadius: BorderRadius.circular(10.r),
                                  border: Border.all(
                                    color: isBooked
                                        ? Colors.transparent
                                        : isSelected
                                            ? gradientColors.first
                                            : AppColors.border(context),
                                  ),
                                ),
                                child: Text(
                                  slotTime,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    decoration: isBooked
                                        ? TextDecoration.lineThrough
                                        : null,
                                    color: isBooked
                                        ? AppColors.textSecondary(context)
                                            .withValues(alpha: 0.4)
                                        : isSelected
                                            ? Colors.white
                                            : AppColors.textPrimary(context),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 32.h),
                      ],

                      // Book Now Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: (state.selectedDate == null ||
                                  state.selectedSlot == null)
                              ? null
                              : () {
                                  context
                                      .read<SpecialityBookingCubit>()
                                      .proceedToPayment();

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (ctx) => BlocProvider.value(
                                        value: context
                                            .read<SpecialityBookingCubit>(),
                                        child: BookingPaymentConfirmPage(
                                          specialityName: specialityName,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                          icon: const Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                          ),
                          label: Text(
                            "Book Now",
                            style: AppTextStyles.buttonLarge.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(16.r),
                            backgroundColor: gradientColors.first,
                            disabledBackgroundColor: Colors.grey.shade400,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _weekdayAbbr(int wd) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[(wd - 1).clamp(0, 6)];
  }
}

class _StatBox extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _StatBox({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 10.w),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: color.withValues(alpha: 0.15)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20.r),
            SizedBox(height: 6.h),
            Text(
              value,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: AppColors.textSecondary(context),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final IconData icon;

  const _SectionTitle({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20.r, color: AppColors.primary),
        SizedBox(width: 8.w),
        Text(
          title,
          style: AppTextStyles.titleSmall.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary(context),
          ),
        ),
      ],
    );
  }
}
