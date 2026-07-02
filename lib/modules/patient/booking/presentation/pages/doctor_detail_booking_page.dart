import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/constants/app_assets.dart';
import 'package:medi_connect/core/widgets/image/custom_image_view.dart';
import 'package:medi_connect/modules/patient/booking/presentation/bloc/speciality_booking_cubit.dart';
import 'package:medi_connect/modules/patient/booking/presentation/bloc/speciality_booking_state.dart';
import 'package:medi_connect/modules/patient/booking/presentation/pages/booking_payment_confirm_page.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:intl/intl.dart';

class DoctorDetailBookingPage extends StatefulWidget {
  final List<Color> gradientColors;
  final String specialityName;

  const DoctorDetailBookingPage({
    super.key,
    required this.gradientColors,
    required this.specialityName,
  });

  @override
  State<DoctorDetailBookingPage> createState() =>
      _DoctorDetailBookingPageState();
}

class _DoctorDetailBookingPageState extends State<DoctorDetailBookingPage> {
  final TextEditingController _reasonCtrl = TextEditingController();
  final ValueNotifier<int> _selectedPaymentNotifier = ValueNotifier<int>(0);

  List<DateTime> get _nextSevenDays =>
      List.generate(7, (i) => DateTime.now().add(Duration(days: i)));

  List<String> get _standardSlots => const [
    '09:00 AM',
    '09:30 AM',
    '10:00 AM',
    '10:30 AM',
    '11:00 AM',
    '11:30 AM',
    '12:00 PM',
    '12:30 PM',
  ];

  @override
  void dispose() {
    _reasonCtrl.dispose();
    _selectedPaymentNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? AppColors.terminalDarkCard : Colors.white;
    final textColor = isDark ? Colors.white : AppColors.terminalLightText;

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

        // Formatted Selected Date
        final selectedDateStr = state.selectedDate != null
            ? DateFormat('EEEE, d MMMM yyyy').format(state.selectedDate!)
            : 'Select Date';

        return Scaffold(
          backgroundColor: AppColors.scaffold(context),
          // ── 1. Custom App Bar ───────────────────────
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            automaticallyImplyLeading: false,
            toolbarHeight: 64.h,
            titleSpacing: 0,
            title: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                children: [
                  // Circular Back Button
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: EdgeInsets.all(8.r),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.arrow_back_ios_new_rounded,
                        color: AppColors.primary,
                        size: 16.r,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Brand Logo
                  Image.asset(AppAssets.logoIconPng, width: 32.r, height: 32.r),
                  SizedBox(width: 6.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'MediConnect',
                        style: TextStyle(
                          color: const Color(0xFF0A3BB0),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Connecting Care. Empowering Health.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 7.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),

                  // Search icon
                  Container(
                    padding: EdgeInsets.all(6.r),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.terminalDarkCard
                          : Colors.grey.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.search,
                      color: isDark ? Colors.white70 : Colors.black87,
                      size: 20.r,
                    ),
                  ),
                  SizedBox(width: 8.w),

                  // Notification Bell with badge
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: EdgeInsets.all(6.r),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.terminalDarkCard
                              : Colors.grey.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.notifications_none_rounded,
                          color: isDark ? Colors.white70 : Colors.black87,
                          size: 20.r,
                        ),
                      ),
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          padding: EdgeInsets.all(4.r),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '3',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 7.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 10.w),

                  // Profile avatar with golden crown
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, authState) {
                      String? profilePhoto;
                      String? gender;
                      if (authState is Authenticated) {
                        profilePhoto = authState.user.profilePhoto;
                        gender = authState.user.gender;
                      }
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(18.r),
                            child: CustomImageView(
                              imagePath: profilePhoto ?? "",
                              width: 36.r,
                              height: 36.r,
                              fit: BoxFit.cover,
                              errorWidget: Image.asset(
                                gender == 'Male'
                                    ? AppAssets.maleAvatarPng
                                    : AppAssets.femaleAvatarPng,
                                width: 36.r,
                                height: 36.r,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: -2,
                            right: -2,
                            child: Container(
                              padding: EdgeInsets.all(2.r),
                              decoration: const BoxDecoration(
                                color: AppColors.secondary,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.workspace_premium_rounded,
                                color: Colors.white,
                                size: 8.r,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // ── Fixed Bottom Checkout Bar ──────────────────────────
          bottomNavigationBar: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: cardBg,
                border: Border(
                  top: BorderSide(color: AppColors.border(context)),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Amount to Pay',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '₹${fee.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF1E3A8A),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Icon(
                            Icons.keyboard_arrow_up_rounded,
                            color: AppColors.primary,
                            size: 16.r,
                          ),
                        ],
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap:
                        (state.selectedDate == null ||
                            state.selectedSlot == null)
                        ? () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please select date and time slot first!',
                                ),
                              ),
                            );
                          }
                        : () {
                            context
                                .read<SpecialityBookingCubit>()
                                .proceedToPayment();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => BlocProvider.value(
                                  value: context.read<SpecialityBookingCubit>(),
                                  child: BookingPaymentConfirmPage(
                                    specialityName: widget.specialityName,
                                  ),
                                ),
                              ),
                            );
                          },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 14.h,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF3B5BFD),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(
                              0xFF3B5BFD,
                            ).withValues(alpha: 0.25),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Text(
                            'Proceed to Pay',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(width: 6.w),
                          Icon(
                            Icons.chevron_right_rounded,
                            color: Colors.white,
                            size: 16.r,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(16.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── 2. Stepper Progress Bar ───────────────────────
                _buildStepper(isDark),
                SizedBox(height: 20.h),

                // ── 3. Doctor Info Card ───────────────────────────
                _buildDoctorInfoCard(
                  context,
                  user,
                  doc,
                  exp,
                  cardBg,
                  textColor,
                ),
                SizedBox(height: 20.h),

                // ── 4. Statistics Row ─────────────────────────────
                _buildStatsRow(isDark),
                SizedBox(height: 24.h),

                // ── 5. Choose Appointment Date ────────────────────
                _buildDatePicker(context, state, isDark, cardBg),
                SizedBox(height: 24.h),

                // ── 6. Select Time Slot ───────────────────────────
                _buildTimeSlotGrid(context, state, isDark, cardBg),
                SizedBox(height: 24.h),

                // ── 7. Reason for Visit ───────────────────────────
                _buildReasonForVisit(isDark, cardBg, textColor),
                SizedBox(height: 24.h),

                // ── 8. Select Patient ─────────────────────────────
                _buildSelectPatientSection(isDark, cardBg, textColor),
                SizedBox(height: 24.h),

                // ── 9. Booking Summary ────────────────────────────
                _buildBookingSummary(
                  user,
                  selectedDateStr,
                  state.selectedSlot,
                  fee,
                  isDark,
                  cardBg,
                  textColor,
                ),
                SizedBox(height: 24.h),

                // ── 10. Payment Method ────────────────────────────
                _buildPaymentMethodSection(isDark, cardBg, textColor),
                SizedBox(height: 32.h),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStepper(bool isDark) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStepItem('1', 'Select Doctor', true),
          _buildStepItem('2', 'Choose Time', false),
          _buildStepItem('3', 'Confirm & Pay', false),
          _buildStepItem('4', 'Booked', false),
        ],
      ),
    );
  }

  Widget _buildStepItem(String step, String label, bool active) {
    return Row(
      children: [
        Container(
          width: 18.r,
          height: 18.r,
          decoration: BoxDecoration(
            color: active ? const Color(0xFF3B5BFD) : Colors.grey.shade400,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            step,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(
            color: active ? const Color(0xFF3B5BFD) : Colors.grey.shade500,
            fontSize: 9.sp,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildDoctorInfoCard(
    BuildContext context,
    dynamic user,
    dynamic doc,
    int exp,
    Color cardBg,
    Color textColor,
  ) {
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
          // Doctor Avatar
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(36.r),
                child: CustomImageView(
                  imagePath: user.profilePhoto ?? "",
                  width: 72.r,
                  height: 72.r,
                  fit: BoxFit.cover,
                  errorWidget: Image.asset(
                    user.gender == 'Male'
                        ? AppAssets.maleAvatarPng
                        : AppAssets.femaleAvatarPng,
                    width: 72.r,
                    height: 72.r,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  width: 14.r,
                  height: 14.r,
                  decoration: BoxDecoration(
                    color: const Color(0xFF22C55E),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(width: 14.w),

          // Detail column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      user.fullName,
                      style: AppTextStyles.titleMedium.copyWith(
                        fontWeight: FontWeight.w900,
                        fontSize: 15.sp,
                        color: textColor,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      Icons.verified_rounded,
                      color: const Color(0xFF3B5BFD),
                      size: 14.r,
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Text(
                  doc?.qualification ?? 'Consultant Cardiologist',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10.h),

                // Badges row
                Wrap(
                  spacing: 6.w,
                  runSpacing: 4.h,
                  children: [
                    _buildBadge(
                      Icons.business_center_outlined,
                      '$exp+ Years Experience',
                    ),
                    _buildBadge(Icons.school_outlined, 'MBBS, MD, DM'),
                    _buildBadge(
                      Icons.star_rounded,
                      '4.9 (128 reviews)',
                      iconColor: const Color(0xFFFFB000),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w),

          // Right Category Card
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
            decoration: BoxDecoration(
              color: const Color(0xFFFFECEF),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.favorite_rounded,
                  color: const Color(0xFFFF296D),
                  size: 24.r,
                ),
                SizedBox(height: 4.h),
                Text(
                  widget.specialityName,
                  style: TextStyle(
                    color: const Color(0xFFFF296D),
                    fontSize: 9.sp,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBadge(IconData icon, String label, {Color? iconColor}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10.r, color: iconColor ?? Colors.grey.shade600),
          SizedBox(width: 3.w),
          Text(
            label,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontSize: 7.5.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(bool isDark) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatBox(Icons.people_outline_rounded, '32+', 'Patients/Day'),
          _buildStatBox(Icons.calendar_today_outlined, '1200+', 'Appointments'),
          _buildStatBox(
            Icons.thumb_up_alt_outlined,
            '98%',
            'Patient Satisfaction',
          ),
          _buildStatBox(
            Icons.chat_bubble_outline_rounded,
            'Eng, Hin, Mal',
            'Languages',
          ),
        ],
      ),
    );
  }

  Widget _buildStatBox(IconData icon, String val, String title) {
    return Column(
      children: [
        Icon(icon, color: AppColors.primary, size: 18.r),
        SizedBox(height: 4.h),
        Text(
          val,
          style: TextStyle(
            color: const Color(0xFF1E3A8A),
            fontSize: 11.sp,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.grey,
            fontSize: 7.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDatePicker(
    BuildContext context,
    SpecialityBookingState state,
    bool isDark,
    Color cardBg,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Choose Appointment Date',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0F172A),
              ),
            ),
            Row(
              children: [
                Text(
                  'May 2025',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.calendar_month_outlined,
                  color: AppColors.primary,
                  size: 14.r,
                ),
                SizedBox(width: 8.w),
                Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.grey,
                  size: 18.r,
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey,
                  size: 18.r,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // List
        SizedBox(
          height: 64.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _nextSevenDays.length,
            itemBuilder: (context, i) {
              final d = _nextSevenDays[i];
              final isSelected =
                  state.selectedDate != null &&
                  state.selectedDate!.year == d.year &&
                  state.selectedDate!.month == d.month &&
                  state.selectedDate!.day == d.day;
              return GestureDetector(
                onTap: () =>
                    context.read<SpecialityBookingCubit>().selectDate(d),
                child: Container(
                  width: 52.w,
                  margin: EdgeInsets.only(right: 8.w),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF3B5BFD) : cardBg,
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF3B5BFD)
                          : AppColors.border(context),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isSelected ? 'Today' : _weekdayAbbr(d.weekday),
                        style: TextStyle(
                          fontSize: 9.sp,
                          color: isSelected ? Colors.white70 : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        "${d.day}",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w900,
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTimeSlotGrid(
    BuildContext context,
    SpecialityBookingState state,
    bool isDark,
    Color cardBg,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Select Time Slot',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF0F172A),
              ),
            ),
            Row(
              children: [
                Text(
                  'Morning',
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                SizedBox(width: 4.w),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: AppColors.primary,
                  size: 16.r,
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 12.h),

        // Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _standardSlots.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 8.w,
            mainAxisSpacing: 8.h,
            childAspectRatio: 1.8,
          ),
          itemBuilder: (context, idx) {
            final slot = _standardSlots[idx];
            final isBooked = idx == 7; // Mock last slot booked
            final isSelected = state.selectedSlot == slot;

            return GestureDetector(
              onTap: isBooked
                  ? null
                  : () =>
                        context.read<SpecialityBookingCubit>().selectSlot(slot),
              child: Container(
                decoration: BoxDecoration(
                  color: isBooked
                      ? const Color(0xFFF1F5F9)
                      : (isSelected ? const Color(0xFF3B5BFD) : cardBg),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: isBooked
                        ? Colors.transparent
                        : (isSelected
                              ? const Color(0xFF3B5BFD)
                              : AppColors.border(context)),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      slot,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w900,
                        color: isBooked
                            ? Colors.grey.shade400
                            : (isSelected
                                  ? Colors.white
                                  : const Color(0xFF0F172A)),
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      isBooked ? 'Booked' : 'Available',
                      style: TextStyle(
                        fontSize: 7.5.sp,
                        fontWeight: FontWeight.bold,
                        color: isBooked
                            ? Colors.grey.shade400
                            : (isSelected
                                  ? Colors.white70
                                  : const Color(0xFF22C55E)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildReasonForVisit(bool isDark, Color cardBg, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Reason for Visit',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0F172A),
          ),
        ),
        SizedBox(height: 10.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: AppColors.border(context)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: _reasonCtrl,
                maxLines: 3,
                style: TextStyle(color: textColor, fontSize: 11.sp),
                decoration: InputDecoration(
                  hintText:
                      "Tell us the reason for your visit (Optional)\nE.g. Chest pain, regular checkup, shortness of breath...",
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 10.sp),
                  border: InputBorder.none,
                ),
              ),
              Text(
                '0/200',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 8.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSelectPatientSection(
    bool isDark,
    Color cardBg,
    Color textColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Patient',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0F172A),
          ),
        ),
        SizedBox(height: 10.h),

        // Patient Card
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, authState) {
            String patientName = 'Likhin Nelliyotan';
            String gender = 'Male';
            String? photo;
            if (authState is Authenticated) {
              patientName = authState.user.fullName;
              gender = authState.user.gender ?? 'Male';
              photo = authState.user.profilePhoto;
            }

            return Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: const Color(0xFF3B5BFD)),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: CustomImageView(
                      imagePath: photo ?? "",
                      width: 40.r,
                      height: 40.r,
                      fit: BoxFit.cover,
                      errorWidget: Image.asset(
                        gender == 'Male'
                            ? AppAssets.maleAvatarPng
                            : AppAssets.femaleAvatarPng,
                        width: 40.r,
                        height: 40.r,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          patientName,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w900,
                            color: textColor,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '$gender • 31 Years • AB+',
                          style: TextStyle(
                            fontSize: 9.sp,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.check_circle_rounded,
                    color: const Color(0xFF3B5BFD),
                    size: 20.r,
                  ),
                ],
              ),
            );
          },
        ),

        SizedBox(height: 10.h),

        // Dashed Add Another
        Container(
          width: double.infinity,
          height: 44.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colors.grey.shade400,
              style: BorderStyle.none,
            ),
          ),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              color: Colors.transparent,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.add, color: AppColors.primary, size: 16.r),
                SizedBox(width: 4.w),
                Text(
                  'Add Another Patient',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBookingSummary(
    dynamic user,
    String selectedDate,
    String? selectedSlot,
    double fee,
    bool isDark,
    Color cardBg,
    Color textColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Booking Summary',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0F172A),
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Details Table
            Expanded(
              flex: 6,
              child: Column(
                children: [
                  _buildSummaryItem(
                    'Doctor',
                    '${user.fullName} (${widget.specialityName})',
                    textColor,
                  ),
                  _buildSummaryItem('Date', selectedDate, textColor),
                  _buildSummaryItem(
                    'Time',
                    selectedSlot ?? 'Not Selected',
                    textColor,
                  ),
                  _buildSummaryItem(
                    'Consultation Fee',
                    '₹${fee.toStringAsFixed(0)}',
                    textColor,
                  ),
                  const Divider(color: Colors.grey, height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w900,
                          color: textColor,
                        ),
                      ),
                      Text(
                        '₹${fee.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF3B5BFD),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 14.w),

            // Safe & Secure Booking Banner
            Expanded(
              flex: 4,
              child: Container(
                padding: EdgeInsets.all(10.r),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F6FF),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.verified_user_outlined,
                          color: const Color(0xFF3B5BFD),
                          size: 14.r,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'Safe & Secure Booking',
                          style: TextStyle(
                            color: const Color(0xFF3B5BFD),
                            fontSize: 7.5.sp,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      'Your appointment is confirmed only after successful payment.',
                      style: TextStyle(
                        fontSize: 7.sp,
                        color: Colors.grey.shade700,
                        height: 1.3,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    _buildSecureBullet('HIPAA Compliant'),
                    _buildSecureBullet('Secure Payments'),
                    _buildSecureBullet('Your data is safe'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryItem(String label, String val, Color textColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.grey,
              fontSize: 10.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            val,
            style: TextStyle(
              color: textColor,
              fontSize: 10.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSecureBullet(String label) {
    return Row(
      children: [
        Icon(
          Icons.check_circle_outline_rounded,
          color: const Color(0xFF10B981),
          size: 8.r,
        ),
        SizedBox(width: 3.w),
        Text(
          label,
          style: TextStyle(
            fontSize: 7.sp,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection(
    bool isDark,
    Color cardBg,
    Color textColor,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF0F172A),
          ),
        ),
        SizedBox(height: 10.h),

        // Row of options
        ValueListenableBuilder<int>(
          valueListenable: _selectedPaymentNotifier,
          builder: (context, selectedIdx, _) {
            return Row(
              children: [
                _buildPaymentItem(
                  0,
                  Icons.qr_code_scanner_rounded,
                  'UPI',
                  'GPay, PhonePe',
                  selectedIdx,
                  cardBg,
                ),
                SizedBox(width: 8.w),
                _buildPaymentItem(
                  1,
                  Icons.credit_card_rounded,
                  'Card',
                  'Visa, MasterCard',
                  selectedIdx,
                  cardBg,
                ),
                SizedBox(width: 8.w),
                _buildPaymentItem(
                  2,
                  Icons.account_balance_rounded,
                  'Net Banking',
                  'All Major Banks',
                  selectedIdx,
                  cardBg,
                ),
                SizedBox(width: 8.w),
                _buildPaymentItem(
                  3,
                  Icons.account_balance_wallet_rounded,
                  'Wallet',
                  'Paytm, Mobikwik',
                  selectedIdx,
                  cardBg,
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildPaymentItem(
    int index,
    IconData icon,
    String label,
    String sub,
    int selectedIdx,
    Color cardBg,
  ) {
    final isSelected = selectedIdx == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _selectedPaymentNotifier.value = index,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFF3B5BFD)
                  : AppColors.border(context),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? const Color(0xFF3B5BFD) : Colors.grey,
                size: 18.r,
              ),
              SizedBox(height: 4.h),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF3B5BFD) : Colors.black87,
                  fontSize: 9.sp,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                sub,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 6.5.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _weekdayAbbr(int wd) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[(wd - 1).clamp(0, 6)];
  }
}
