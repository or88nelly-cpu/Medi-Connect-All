import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/core/constants/app_enum.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_appointments_bloc.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_event.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_state.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data helpers
// ─────────────────────────────────────────────────────────────────────────────

class _SpecialtyEntry {
  final String name;
  final IconData icon;
  final List<Color> gradient;
  final String description;

  const _SpecialtyEntry({
    required this.name,
    required this.icon,
    required this.gradient,
    required this.description,
  });
}

const _kSpecialties = <_SpecialtyEntry>[
  _SpecialtyEntry(
    name: 'Cardiology',
    icon: Icons.favorite_rounded,
    gradient: [Color(0xFF4F7CFF), Color(0xFF5B42F3)],
    description: 'Heart & Blood Vessels',
  ),
  _SpecialtyEntry(
    name: 'Neurology',
    icon: Icons.psychology_rounded,
    gradient: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
    description: 'Brain & Nerves',
  ),
  _SpecialtyEntry(
    name: 'Orthopedics',
    icon: Icons.accessibility_new_rounded,
    gradient: [Color(0xFF00C2A8), Color(0xFF00897B)],
    description: 'Bones & Joints',
  ),
  _SpecialtyEntry(
    name: 'Pediatrics',
    icon: Icons.child_care_rounded,
    gradient: [Color(0xFFFF8C42), Color(0xFFE65100)],
    description: 'Child Healthcare',
  ),
  _SpecialtyEntry(
    name: 'Dermatology',
    icon: Icons.spa_rounded,
    gradient: [Color(0xFFFF4B8B), Color(0xFFD81B60)],
    description: 'Skin & Hair',
  ),
  _SpecialtyEntry(
    name: 'Ophthalmology',
    icon: Icons.remove_red_eye_rounded,
    gradient: [Color(0xFF00B4D8), Color(0xFF0077B6)],
    description: 'Eye Care',
  ),
  _SpecialtyEntry(
    name: 'ENT',
    icon: Icons.hearing_rounded,
    gradient: [Color(0xFF5B8DEF), Color(0xFF3F51B5)],
    description: 'Ear, Nose & Throat',
  ),
  _SpecialtyEntry(
    name: 'General Medicine',
    icon: Icons.medical_services_rounded,
    gradient: [Color(0xFF22C55E), Color(0xFF15803D)],
    description: 'Primary Healthcare',
  ),
  _SpecialtyEntry(
    name: 'Gynecology',
    icon: Icons.local_hospital_rounded,
    gradient: [Color(0xFFEC4899), Color(0xFFBE185D)],
    description: "Women's Health",
  ),
  _SpecialtyEntry(
    name: 'Psychiatry',
    icon: Icons.mood_rounded,
    gradient: [Color(0xFF9C6FFF), Color(0xFF7B2FBE)],
    description: 'Mental Health',
  ),
  _SpecialtyEntry(
    name: 'Oncology',
    icon: Icons.biotech_rounded,
    gradient: [Color(0xFFFF8C42), Color(0xFFFF6B35)],
    description: 'Cancer Care',
  ),
  _SpecialtyEntry(
    name: 'Urology',
    icon: Icons.water_drop_rounded,
    gradient: [Color(0xFF1A8CFF), Color(0xFF0052CC)],
    description: 'Urinary Tract',
  ),
];

const _kMorningSlots = [
  '09:00 AM',
  '09:30 AM',
  '10:00 AM',
  '10:30 AM',
  '11:00 AM',
  '11:30 AM',
];
const _kAfternoonSlots = [
  '02:00 PM',
  '02:30 PM',
  '03:00 PM',
  '03:30 PM',
  '04:00 PM',
  '04:30 PM',
];
const _kEveningSlots = ['05:00 PM', '05:30 PM', '06:00 PM', '06:30 PM'];
const _kBookedSlots = {'10:00 AM', '03:00 PM', '05:30 PM'};

const _kPaymentMethods = [
  {
    'id': 'UPI',
    'label': 'UPI / BHIM',
    'icon': Icons.account_balance_wallet_rounded,
    'color': 0xFF4F7CFF,
  },
  {
    'id': 'CARD',
    'label': 'Credit / Debit Card',
    'icon': Icons.credit_card_rounded,
    'color': 0xFF8B5CF6,
  },
  {
    'id': 'CASH',
    'label': 'Pay at Clinic (Cash)',
    'icon': Icons.payments_rounded,
    'color': 0xFF22C55E,
  },
];

const _kFallbackDoctors = <UserModel>[
  UserModel(
    id: 'doc-1',
    email: 'sarah.j@mediconnect.com',
    firstName: 'Dr. Sarah',
    lastName: 'Johnson',
    role: UserRole.doctor,
  ),
  UserModel(
    id: 'doc-2',
    email: 'michael.c@mediconnect.com',
    firstName: 'Dr. Michael',
    lastName: 'Chen',
    role: UserRole.doctor,
  ),
  UserModel(
    id: 'doc-3',
    email: 'james.w@mediconnect.com',
    firstName: 'Dr. James',
    lastName: 'Wilson',
    role: UserRole.doctor,
  ),
  UserModel(
    id: 'doc-4',
    email: 'priya.s@mediconnect.com',
    firstName: 'Dr. Priya',
    lastName: 'Sharma',
    role: UserRole.doctor,
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Main Booking Flow Page
// ─────────────────────────────────────────────────────────────────────────────

class BookingFlowPage extends StatefulWidget {
  final UserModel? preselectedDoctor;
  final String? preselectedSpecialty;

  const BookingFlowPage({
    super.key,
    this.preselectedDoctor,
    this.preselectedSpecialty,
  });

  @override
  State<BookingFlowPage> createState() => _BookingFlowPageState();
}

class _BookingFlowPageState extends State<BookingFlowPage> {
  int _step = 0;
  _SpecialtyEntry? _specialty;
  UserModel? _doctor;
  DateTime _selectedDate = DateTime.now();
  String? _selectedSlot;
  String _paymentMethod = 'UPI';
  bool _isProcessing = false;
  String _bookingId = '';

  static const _stepLabels = [
    'Specialty',
    'Doctor',
    'Slot',
    'Payment',
    'Done!',
  ];

  @override
  void initState() {
    super.initState();
    // Pre-select if navigated from profile or service
    if (widget.preselectedDoctor != null) {
      _doctor = widget.preselectedDoctor;
    }
    if (widget.preselectedSpecialty != null) {
      try {
        _specialty = _kSpecialties.firstWhere(
          (s) =>
              s.name.toLowerCase() ==
              widget.preselectedSpecialty!.toLowerCase(),
        );
      } catch (_) {}
    }
    // If both preselected, skip to slot step
    if (_doctor != null && _specialty != null) {
      _step = 2;
    } else if (_specialty != null) {
      _step = 1;
    }

    // Load doctor list
    try {
      context.read<DoctorStaffBloc>().add(const LoadDoctorStaff('All'));
    } catch (_) {}
  }

  bool get _canGoNext {
    switch (_step) {
      case 0:
        return _specialty != null;
      case 1:
        return _doctor != null;
      case 2:
        return _selectedSlot != null;
      case 3:
        return true;
      default:
        return false;
    }
  }

  void _next() async {
    if (_step == 3) {
      // Process payment (mock)
      setState(() => _isProcessing = true);
      await Future.delayed(const Duration(milliseconds: 1500));
      // Save appointment to metadata
      await _saveAppointment();
      setState(() {
        _isProcessing = false;
        _bookingId = 'MC${DateTime.now().millisecondsSinceEpoch % 100000}';
        _step = 4;
      });
    } else if (_step < 4) {
      setState(() => _step++);
    }
  }

  void _prev() {
    if (_step > 0) setState(() => _step--);
  }

  Future<void> _saveAppointment() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      final user = authState.user;
      final dateStr = _selectedDate.toIso8601String().split('T').first;
      final docName = _doctor?.fullName ?? 'Doctor';

      // Generate initials for token
      final cleanName = docName
          .replaceAll(RegExp(r'^(dr\.|dr|Dr\.|Dr)\s+', caseSensitive: false), '')
          .trim();
      final parts = cleanName
          .split(RegExp(r'\s+'))
          .where((s) => s.isNotEmpty)
          .toList();
      String initials = 'DR';
      if (parts.isNotEmpty) {
        if (parts.length == 1) {
          initials = parts[0]
              .substring(0, parts[0].length >= 2 ? 2 : 1)
              .toUpperCase();
        } else {
          initials =
              '${parts.first[0].toUpperCase()}${parts.last[0].toUpperCase()}';
        }
      }
      final token = '${initials}A${(DateTime.now().millisecondsSinceEpoch % 1000).toString().padLeft(3, '0')}';

      context.read<AdminAppointmentsBloc>().add(
        CreateAppointmentEvent({
          'patient_id': user.id,
          'patient_name': user.fullName,
          'doctor_id': _doctor?.id ?? '',
          'doctor_name': docName,
          'specialty': _specialty?.name ?? '',
          'appointment_date': dateStr,
          'appointment_time': _selectedSlot ?? '',
          'status': 'Confirmed',
          'type': 'Consultation',
          'token': token,
        }),
      );
    }
  }

  String _shortDate(DateTime d) {
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
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffold(context),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _step == 4
            ? const SizedBox()
            : IconButton(
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.textPrimary(context),
                ),
                onPressed: _step == 0
                    ? () => Navigator.of(context).pop()
                    : _prev,
              ),
        title: Text(
          'Book Appointment',
          style: AppTextStyles.titleLarge.copyWith(
            color: AppColors.textPrimary(context),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // ── Step indicator ────────────────────────────────────────
          if (_step < 4) _StepIndicator(current: _step, labels: _stepLabels),

          // ── Step content ──────────────────────────────────────────
          Expanded(child: _buildBody()),

          // ── Bottom bar ────────────────────────────────────────────
          if (_step < 4) _buildBottomBar(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    switch (_step) {
      case 0:
        return _SpecialtyStep(
          selected: _specialty,
          onSelect: (sp) => setState(() => _specialty = sp),
        );
      case 1:
        return _DoctorStep(
          specialty: _specialty,
          selected: _doctor,
          onSelect: (d) => setState(() => _doctor = d),
        );
      case 2:
        return _SlotStep(
          doctor: _doctor,
          selectedDate: _selectedDate,
          selectedSlot: _selectedSlot,
          onDateChanged: (d) => setState(() {
            _selectedDate = d;
            _selectedSlot = null;
          }),
          onSlotSelected: (s) => setState(() => _selectedSlot = s),
        );
      case 3:
        return _PaymentStep(
          doctor: _doctor,
          specialty: _specialty,
          date: _selectedDate,
          slot: _selectedSlot ?? '',
          paymentMethod: _paymentMethod,
          isProcessing: _isProcessing,
          onMethodChanged: (m) => setState(() => _paymentMethod = m),
        );
      case 4:
        return _ConfirmationStep(
          bookingId: _bookingId,
          doctor: _doctor,
          specialty: _specialty,
          date: _selectedDate,
          slot: _selectedSlot ?? '',
          paymentMethod: _paymentMethod,
          onGoHome: () => Navigator.of(context).pop(),
        );
      default:
        return const SizedBox();
    }
  }

  Widget _buildBottomBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: AppColors.card(context),
        border: Border(top: BorderSide(color: AppColors.border(context))),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (_canGoNext && !_isProcessing) ? _next : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
              padding: EdgeInsets.all(16.r),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            child: _isProcessing
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 18.r,
                        height: 18.r,
                        child: const CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        'Processing Payment…',
                        style: AppTextStyles.buttonLarge.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                : Text(
                    _step == 3 ? 'Pay & Confirm' : 'Continue',
                    style: AppTextStyles.buttonLarge.copyWith(
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step Indicator
// ─────────────────────────────────────────────────────────────────────────────
class _StepIndicator extends StatelessWidget {
  final int current;
  final List<String> labels;

  const _StepIndicator({required this.current, required this.labels});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        children: List.generate(labels.length - 1, (i) {
          // Skip the last step label in indicator
          final isDone = i < current;
          final isActive = i == current;
          return Expanded(
            child: Row(
              children: [
                _StepCircle(
                  index: i,
                  label: labels[i],
                  isDone: isDone,
                  isActive: isActive,
                ),
                if (i < labels.length - 2)
                  Expanded(
                    child: Container(
                      height: 2,
                      color: isDone
                          ? AppColors.primary
                          : AppColors.border(context),
                    ),
                  ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class _StepCircle extends StatelessWidget {
  final int index;
  final String label;
  final bool isDone;
  final bool isActive;

  const _StepCircle({
    required this.index,
    required this.label,
    required this.isDone,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 28.r,
          height: 28.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: (isDone || isActive)
                ? const LinearGradient(
                    colors: [Color(0xFF4F7CFF), Color(0xFF5B42F3)],
                  )
                : null,
            color: (isDone || isActive) ? null : AppColors.border(context),
          ),
          child: Center(
            child: isDone
                ? Icon(Icons.check_rounded, color: Colors.white, size: 14.r)
                : Text(
                    '${index + 1}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: isActive
                          ? Colors.white
                          : AppColors.textSecondary(context),
                    ),
                  ),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 9.sp,
            color: (isDone || isActive)
                ? AppColors.primary
                : AppColors.textSecondary(context),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 1: Specialty
// ─────────────────────────────────────────────────────────────────────────────
class _SpecialtyStep extends StatelessWidget {
  final _SpecialtyEntry? selected;
  final ValueChanged<_SpecialtyEntry> onSelect;

  const _SpecialtyStep({required this.selected, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose a Specialty',
            style: AppTextStyles.headingSmall.copyWith(
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Select the type of doctor you want to see',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary(context),
            ),
          ),
          SizedBox(height: 16.h),
          LayoutBuilder(
            builder: (context, constraints) {
              final cols = constraints.maxWidth > 500 ? 3 : 2;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: cols,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.h,
                  childAspectRatio: 1.0,
                ),
                itemCount: _kSpecialties.length,
                itemBuilder: (context, i) {
                  final sp = _kSpecialties[i];
                  final isSelected = selected?.name == sp.name;
                  return GestureDetector(
                    onTap: () => onSelect(sp),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isSelected
                              ? sp.gradient
                              : [
                                  sp.gradient.first.withValues(alpha: 0.12),
                                  sp.gradient.last.withValues(alpha: 0.06),
                                ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        border: Border.all(
                          color: isSelected
                              ? sp.gradient.first
                              : sp.gradient.first.withValues(alpha: 0.2),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: sp.gradient.first.withValues(
                                    alpha: 0.3,
                                  ),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12.r),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 44.r,
                              height: 44.r,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.white.withValues(alpha: 0.25)
                                    : sp.gradient.first.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Icon(
                                sp.icon,
                                color: isSelected
                                    ? Colors.white
                                    : sp.gradient.first,
                                size: 22.r,
                              ),
                            ),
                            SizedBox(height: 10.h),
                            Text(
                              sp.name,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.bold,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.textPrimary(context),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 3.h),
                            Text(
                              sp.description,
                              style: TextStyle(
                                fontSize: 9.sp,
                                color: isSelected
                                    ? Colors.white70
                                    : AppColors.textSecondary(context),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            if (isSelected) ...[
                              SizedBox(height: 6.h),
                              Icon(
                                Icons.check_circle_rounded,
                                color: Colors.white,
                                size: 16.r,
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 2: Doctor
// ─────────────────────────────────────────────────────────────────────────────
class _DoctorStep extends StatelessWidget {
  final _SpecialtyEntry? specialty;
  final UserModel? selected;
  final ValueChanged<UserModel> onSelect;

  const _DoctorStep({
    required this.specialty,
    required this.selected,
    required this.onSelect,
  });

  List<UserModel> _filtered(List<UserModel> all) {
    if (specialty == null)
      return all.where((d) => d.role == UserRole.doctor).toList();
    final res = all.where((d) {
      return d.role == UserRole.doctor;
    }).toList();
    return res.isEmpty ? _kFallbackDoctors : res;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Choose a Doctor',
                style: AppTextStyles.headingSmall.copyWith(
                  color: AppColors.textPrimary(context),
                ),
              ),
              if (specialty != null)
                Text(
                  'Showing ${specialty!.name} specialists',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary(context),
                  ),
                ),
            ],
          ),
        ),
        SizedBox(height: 12.h),
        Expanded(
          child: BlocBuilder<DoctorStaffBloc, DoctorStaffState>(
            builder: (context, state) {
              final docs =
                  state is DoctorStaffLoaded && state.doctors.isNotEmpty
                  ? _filtered(state.doctors)
                  : _kFallbackDoctors;

              if (state is DoctorStaffLoading && docs.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }

              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
                itemCount: docs.length,
                separatorBuilder: (context, _) => SizedBox(height: 10.h),
                itemBuilder: (context, i) {
                  final doc = docs[i];
                  final isSelected = selected?.id == doc.id;
                  final color = specialty?.gradient.first ?? AppColors.primary;
                  return GestureDetector(
                    onTap: () => onSelect(doc),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.all(14.r),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? color.withValues(alpha: 0.07)
                            : AppColors.card(context),
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: isSelected ? color : AppColors.border(context),
                          width: isSelected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 50.r,
                            height: 50.r,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors:
                                    specialty?.gradient ??
                                    [AppColors.primary, AppColors.secondary],
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person_rounded,
                              color: Colors.white,
                              size: 24.r,
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doc.fullName,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary(context),
                                  ),
                                ),
                                SizedBox(height: 2.h),
                                Text(
                                  'General Medicine',
                                  style: AppTextStyles.bodySmall.copyWith(
                                    color: color,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star_rounded,
                                      color: const Color(0xFFFFB547),
                                      size: 12.r,
                                    ),
                                    SizedBox(width: 2.w),
                                    Text(
                                      '4.8',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary(context),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    Text(
                                      '5 yrs · ₹500',
                                      style: AppTextStyles.bodySmall.copyWith(
                                        color: AppColors.textSecondary(context),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 24.r,
                            height: 24.r,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected ? color : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? color
                                    : AppColors.border(context),
                                width: 1.5,
                              ),
                            ),
                            child: isSelected
                                ? Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 14.r,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 3: Slot
// ─────────────────────────────────────────────────────────────────────────────
class _SlotStep extends StatelessWidget {
  final UserModel? doctor;
  final DateTime selectedDate;
  final String? selectedSlot;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<String> onSlotSelected;

  const _SlotStep({
    required this.doctor,
    required this.selectedDate,
    required this.selectedSlot,
    required this.onDateChanged,
    required this.onSlotSelected,
  });

  List<DateTime> get _days =>
      List.generate(7, (i) => DateTime.now().add(Duration(days: i)));

  String _weekday(int wd) {
    const d = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return d[(wd - 1).clamp(0, 6)];
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select Date & Time',
            style: AppTextStyles.headingSmall.copyWith(
              color: AppColors.textPrimary(context),
            ),
          ),
          if (doctor != null) ...[
            SizedBox(height: 4.h),
            Text(
              'With ${doctor!.fullName}',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary(context),
              ),
            ),
          ],
          SizedBox(height: 16.h),

          // Date row
          SizedBox(
            height: 68.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _days.length,
              separatorBuilder: (context, _) => SizedBox(width: 10.w),
              itemBuilder: (context, i) {
                final d = _days[i];
                final isSelected = _isSameDay(d, selectedDate);
                return GestureDetector(
                  onTap: () => onDateChanged(d),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 50.w,
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(
                              colors: [Color(0xFF4F7CFF), Color(0xFF5B42F3)],
                            )
                          : null,
                      color: isSelected ? null : AppColors.card(context),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.border(context),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _weekday(d.weekday),
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: isSelected
                                ? Colors.white70
                                : AppColors.textSecondary(context),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '${d.day}',
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
          SizedBox(height: 20.h),

          // Time slots
          _SlotGroup(
            title: '🌅 Morning',
            slots: _kMorningSlots,
            bookedSlots: _kBookedSlots,
            selectedSlot: selectedSlot,
            onSelect: onSlotSelected,
          ),
          SizedBox(height: 14.h),
          _SlotGroup(
            title: '☀️ Afternoon',
            slots: _kAfternoonSlots,
            bookedSlots: _kBookedSlots,
            selectedSlot: selectedSlot,
            onSelect: onSlotSelected,
          ),
          SizedBox(height: 14.h),
          _SlotGroup(
            title: '🌆 Evening',
            slots: _kEveningSlots,
            bookedSlots: _kBookedSlots,
            selectedSlot: selectedSlot,
            onSelect: onSlotSelected,
          ),
        ],
      ),
    );
  }
}

class _SlotGroup extends StatelessWidget {
  final String title;
  final List<String> slots;
  final Set<String> bookedSlots;
  final String? selectedSlot;
  final ValueChanged<String> onSelect;

  const _SlotGroup({
    required this.title,
    required this.slots,
    required this.bookedSlots,
    required this.selectedSlot,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.labelMedium.copyWith(
            color: AppColors.textPrimary(context),
          ),
        ),
        SizedBox(height: 10.h),
        Wrap(
          spacing: 10.w,
          runSpacing: 10.h,
          children: slots.map((slot) {
            final isBooked = bookedSlots.contains(slot);
            final isSelected = slot == selectedSlot;
            return GestureDetector(
              onTap: isBooked ? null : () => onSelect(slot),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? const LinearGradient(
                          colors: [Color(0xFF4F7CFF), Color(0xFF5B42F3)],
                        )
                      : null,
                  color: isBooked
                      ? AppColors.border(context)
                      : isSelected
                      ? null
                      : AppColors.card(context),
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.border(context),
                  ),
                ),
                child: Text(
                  slot,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isBooked
                        ? AppColors.textSecondary(
                            context,
                          ).withValues(alpha: 0.5)
                        : isSelected
                        ? Colors.white
                        : AppColors.textPrimary(context),
                    decoration: isBooked ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 4: Payment
// ─────────────────────────────────────────────────────────────────────────────
class _PaymentStep extends StatelessWidget {
  final UserModel? doctor;
  final _SpecialtyEntry? specialty;
  final DateTime date;
  final String slot;
  final String paymentMethod;
  final bool isProcessing;
  final ValueChanged<String> onMethodChanged;

  const _PaymentStep({
    required this.doctor,
    required this.specialty,
    required this.date,
    required this.slot,
    required this.paymentMethod,
    required this.isProcessing,
    required this.onMethodChanged,
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
    final fee = 500;
    final tax = (fee * 0.18).round();
    final total = fee + tax;
    final color = specialty?.gradient.first ?? AppColors.primary;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment',
            style: AppTextStyles.headingSmall.copyWith(
              color: AppColors.textPrimary(context),
            ),
          ),
          SizedBox(height: 16.h),

          // Booking summary card
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Booking Summary',
                  style: AppTextStyles.titleSmall.copyWith(
                    color: AppColors.textPrimary(context),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(color: color.withValues(alpha: 0.2), height: 16.h),
                _SummaryRow(
                  label: 'Doctor',
                  value: doctor?.fullName ?? 'Dr. Specialist',
                  color: color,
                ),
                SizedBox(height: 8.h),
                _SummaryRow(
                  label: 'Specialty',
                  value: specialty?.name ?? 'General Medicine',
                  color: color,
                ),
                SizedBox(height: 8.h),
                _SummaryRow(
                  label: 'Date & Time',
                  value:
                      '${_monthName(date.month)} ${date.day}, ${date.year} · $slot',
                  color: color,
                ),
                Divider(color: color.withValues(alpha: 0.2), height: 20.h),
                _SummaryRow(
                  label: 'Consultation Fee',
                  value: '₹$fee',
                  color: color,
                ),
                SizedBox(height: 6.h),
                _SummaryRow(label: 'GST (18%)', value: '₹$tax', color: color),
                Divider(color: color.withValues(alpha: 0.2), height: 16.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Payable',
                      style: AppTextStyles.titleSmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary(context),
                      ),
                    ),
                    Text(
                      '₹$total',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 20.h),

          Text(
            'Payment Method',
            style: AppTextStyles.titleSmall.copyWith(
              color: AppColors.textPrimary(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12.h),

          ..._kPaymentMethods.map((m) {
            final id = m['id'] as String;
            final label = m['label'] as String;
            final icon = m['icon'] as IconData;
            final mColor = Color(m['color'] as int);
            final isSelected = paymentMethod == id;

            return GestureDetector(
              onTap: () => onMethodChanged(id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.only(bottom: 10.h),
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: isSelected
                      ? mColor.withValues(alpha: 0.07)
                      : AppColors.card(context),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: isSelected ? mColor : AppColors.border(context),
                    width: isSelected ? 1.5 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        color: mColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10.r),
                      ),
                      child: Icon(icon, color: mColor, size: 20.r),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Text(
                        label,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textPrimary(context),
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 22.r,
                      height: 22.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isSelected ? mColor : Colors.transparent,
                        border: Border.all(
                          color: isSelected
                              ? mColor
                              : AppColors.border(context),
                        ),
                      ),
                      child: isSelected
                          ? Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 12.r,
                            )
                          : null,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _SummaryRow({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100.w,
          child: Text(
            label,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary(context),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textPrimary(context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Step 5: Confirmation
// ─────────────────────────────────────────────────────────────────────────────
class _ConfirmationStep extends StatelessWidget {
  final String bookingId;
  final UserModel? doctor;
  final _SpecialtyEntry? specialty;
  final DateTime date;
  final String slot;
  final String paymentMethod;
  final VoidCallback onGoHome;

  const _ConfirmationStep({
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
      padding: EdgeInsets.all(24.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 20.h),

          // Animated checkmark
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 800),
            curve: Curves.elasticOut,
            builder: (context, value, child) =>
                Transform.scale(scale: value, child: child),
            child: Container(
              width: 100.r,
              height: 100.r,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF22C55E), Color(0xFF15803D)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_rounded, color: Colors.white, size: 50.r),
            ),
          ),
          SizedBox(height: 24.h),

          Text(
            'Booking Confirmed! 🎉',
            style: AppTextStyles.headingSmall.copyWith(
              color: AppColors.textPrimary(context),
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Your appointment has been booked successfully.',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary(context),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),

          // Booking ID
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10.r),
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
                SizedBox(height: 4.h),
                Text(
                  bookingId,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          // Details card
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: AppColors.card(context),
              borderRadius: BorderRadius.circular(16.r),
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
                Divider(color: AppColors.border(context), height: 16.h),
                _ConfirmRow(
                  icon: Icons.person_rounded,
                  label: 'Doctor',
                  value: doctor?.fullName ?? 'Dr. Specialist',
                  color: AppColors.primary,
                ),
                SizedBox(height: 10.h),
                _ConfirmRow(
                  icon: Icons.medical_services_rounded,
                  label: 'Specialty',
                  value: specialty?.name ?? 'General Medicine',
                  color: specialty?.gradient.first ?? AppColors.secondary,
                ),
                SizedBox(height: 10.h),
                _ConfirmRow(
                  icon: Icons.calendar_today_rounded,
                  label: 'Date & Time',
                  value:
                      '${_monthName(date.month)} ${date.day}, ${date.year}  ·  $slot',
                  color: const Color(0xFF22C55E),
                ),
                SizedBox(height: 10.h),
                _ConfirmRow(
                  icon: Icons.account_balance_wallet_rounded,
                  label: 'Payment',
                  value: paymentMethod,
                  color: const Color(0xFFFFB547),
                ),
              ],
            ),
          ),
          SizedBox(height: 32.h),

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
                padding: EdgeInsets.all(16.r),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
            ),
          ),
          SizedBox(height: 30.h),
        ],
      ),
    );
  }
}

class _ConfirmRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _ConfirmRow({
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
          width: 32.r,
          height: 32.r,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Icon(icon, color: color, size: 16.r),
        ),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10.sp,
                color: AppColors.textSecondary(context),
              ),
            ),
            SizedBox(height: 1.h),
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
