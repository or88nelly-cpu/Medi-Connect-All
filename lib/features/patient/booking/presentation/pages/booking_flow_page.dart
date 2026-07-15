import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medi_connect/core/constants/app_enum.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/features/admin/staff_management/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/features/admin/staff_management/presentation/bloc/doctor_staff_event.dart';
import 'package:medi_connect/features/admin/staff_management/presentation/bloc/doctor_staff_state.dart';
import 'package:medi_connect/features/authentication/data/models/user_model.dart';
import 'package:medi_connect/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/common/dashboard/presentation/bloc/admin/admin_appointments_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/booking_flow/specialty_step.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/booking_flow/doctor_step.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/booking_flow/slot_step.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/booking_flow/payment_step.dart';
import 'package:medi_connect/features/patient/booking/presentation/widgets/booking_flow/confirmation_step.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Data helpers
// ─────────────────────────────────────────────────────────────────────────────

class SpecialtyEntry {
  final String name;
  final IconData icon;
  final List<Color> gradient;
  final String description;

  const SpecialtyEntry({
    required this.name,
    required this.icon,
    required this.gradient,
    required this.description,
  });
}

const kSpecialties = <SpecialtyEntry>[
  SpecialtyEntry(
    name: 'Cardiology',
    icon: Icons.favorite_rounded,
    gradient: [Color(0xFF4F7CFF), Color(0xFF5B42F3)],
    description: 'Heart & Blood Vessels',
  ),
  SpecialtyEntry(
    name: 'Neurology',
    icon: Icons.psychology_rounded,
    gradient: [Color(0xFF8B5CF6), Color(0xFF7C3AED)],
    description: 'Brain & Nerves',
  ),
  SpecialtyEntry(
    name: 'Orthopedics',
    icon: Icons.accessibility_new_rounded,
    gradient: [Color(0xFF00C2A8), Color(0xFF00897B)],
    description: 'Bones & Joints',
  ),
  SpecialtyEntry(
    name: 'Pediatrics',
    icon: Icons.child_care_rounded,
    gradient: [Color(0xFFFF8C42), Color(0xFFE65100)],
    description: 'Child Healthcare',
  ),
  SpecialtyEntry(
    name: 'Dermatology',
    icon: Icons.spa_rounded,
    gradient: [Color(0xFFFF4B8B), Color(0xFFD81B60)],
    description: 'Skin & Hair',
  ),
  SpecialtyEntry(
    name: 'Ophthalmology',
    icon: Icons.remove_red_eye_rounded,
    gradient: [Color(0xFF00B4D8), Color(0xFF0077B6)],
    description: 'Eye Care',
  ),
  SpecialtyEntry(
    name: 'ENT',
    icon: Icons.hearing_rounded,
    gradient: [Color(0xFF5B8DEF), Color(0xFF3F51B5)],
    description: 'Ear, Nose & Throat',
  ),
  SpecialtyEntry(
    name: 'General Medicine',
    icon: Icons.medical_services_rounded,
    gradient: [AppColors.success, Color(0xFF15803D)],
    description: 'Primary Healthcare',
  ),
  SpecialtyEntry(
    name: 'Gynecology',
    icon: Icons.local_hospital_rounded,
    gradient: [Color(0xFFEC4899), Color(0xFFBE185D)],
    description: "Women's Health",
  ),
  SpecialtyEntry(
    name: 'Psychiatry',
    icon: Icons.mood_rounded,
    gradient: [Color(0xFF9C6FFF), Color(0xFF7B2FBE)],
    description: 'Mental Health',
  ),
  SpecialtyEntry(
    name: 'Oncology',
    icon: Icons.biotech_rounded,
    gradient: [Color(0xFFFF8C42), Color(0xFFFF6B35)],
    description: 'Cancer Care',
  ),
  SpecialtyEntry(
    name: 'Urology',
    icon: Icons.water_drop_rounded,
    gradient: [Color(0xFF1A8CFF), Color(0xFF0052CC)],
    description: 'Urinary Tract',
  ),
];

const kMorningSlots = [
  '09:00 AM',
  '09:30 AM',
  '10:00 AM',
  '10:30 AM',
  '11:00 AM',
  '11:30 AM',
];
const kAfternoonSlots = [
  '02:00 PM',
  '02:30 PM',
  '03:00 PM',
  '03:30 PM',
  '04:00 PM',
  '04:30 PM',
];
const kEveningSlots = ['05:00 PM', '05:30 PM', '06:00 PM', '06:30 PM'];
const kBookedSlots = {'10:00 AM', '03:00 PM', '05:30 PM'};

const kPaymentMethods = [
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

const kFallbackDoctors = <UserModel>[
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
  SpecialtyEntry? _specialty;
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
        _specialty = kSpecialties.firstWhere(
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
          .replaceAll(
            RegExp(r'^(dr\.|dr|Dr\.|Dr)\s+', caseSensitive: false),
            '',
          )
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
      final token =
          '${initials}A${(DateTime.now().millisecondsSinceEpoch % 1000).toString().padLeft(3, '0')}';

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
        return SpecialtyStep(
          selected: _specialty,
          onSelect: (sp) => setState(() => _specialty = sp),
        );
      case 1:
        return DoctorStep(
          specialty: _specialty,
          selected: _doctor,
          onSelect: (d) => setState(() => _doctor = d),
        );
      case 2:
        return SlotStep(
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
        return PaymentStep(
          doctor: _doctor,
          specialty: _specialty,
          date: _selectedDate,
          slot: _selectedSlot ?? '',
          paymentMethod: _paymentMethod,
          isProcessing: _isProcessing,
          onMethodChanged: (m) => setState(() => _paymentMethod = m),
        );
      case 4:
        return ConfirmationStep(
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
