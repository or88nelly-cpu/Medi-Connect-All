import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/shared/auth/domain/entities/user_entity.dart';
import 'package:medi_connect/shared/dashboard/data/models/appointment_model.dart';

class SlotManagementGrid extends StatefulWidget {
  final DateTime selectedDate;
  final UserEntity doctor;

  const SlotManagementGrid({
    super.key,
    required this.selectedDate,
    required this.doctor,
  });

  @override
  State<SlotManagementGrid> createState() => _SlotManagementGridState();
}

class _SlotManagementGridState extends State<SlotManagementGrid> {
  bool _isLoading = false;
  List<AppointmentModel> _appointments = [];

  final List<String> _morningSlots = [
    '09:00 AM', '09:30 AM', '10:00 AM', '10:30 AM', '11:00 AM', '11:30 AM'
  ];
  final List<String> _afternoonSlots = [
    '12:00 PM', '12:30 PM', '02:00 PM', '02:30 PM', '03:00 PM', '03:30 PM', '04:00 PM', '04:30 PM', '05:00 PM'
  ];

  @override
  void initState() {
    super.initState();
    _loadSlots();
  }

  @override
  void didUpdateWidget(covariant SlotManagementGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedDate != widget.selectedDate || oldWidget.doctor.id != widget.doctor.id) {
      _loadSlots();
    }
  }

  Future<void> _loadSlots() async {
    setState(() => _isLoading = true);
    try {
      final dateStr = widget.selectedDate.toIso8601String().split('T').first;
      final response = await Supabase.instance.client
          .from('appointments')
          .select()
          .eq('doctor_id', widget.doctor.id)
          .eq('appointment_date', dateStr);

      final list = response as List<dynamic>? ?? [];
      if (mounted) {
        setState(() {
          _appointments = list
              .map((e) => AppointmentModel.fromJson(e as Map<String, dynamic>))
              .toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading slots: $e')),
        );
      }
    }
  }

  Future<void> _toggleSlot(String slot, bool isBlocked) async {
    setState(() => _isLoading = true);
    final dateStr = widget.selectedDate.toIso8601String().split('T').first;

    try {
      if (isBlocked) {
        // Unblock: delete the blocked appointment record
        await Supabase.instance.client
            .from('appointments')
            .delete()
            .eq('doctor_id', widget.doctor.id)
            .eq('appointment_date', dateStr)
            .eq('appointment_time', slot)
            .eq('status', 'Blocked');
      } else {
        // Block: insert a blocked appointment record
        await Supabase.instance.client.from('appointments').insert({
          'doctor_id': widget.doctor.id,
          'doctor_name': widget.doctor.fullName,
          'appointment_date': dateStr,
          'appointment_time': slot,
          'status': 'Blocked',
          'type': 'Blocked',
          'patient_name': 'System Blocked',
          'specialty': 'General Medicine',
          'amount': 0,
        });
      }
      await _loadSlots();
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating slot availability: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: CircularProgressIndicator(color: Color(0xFF0F6FFF)),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader("Morning Session", Icons.wb_sunny_outlined, const Color(0xFFEAB308)),
        SizedBox(height: 12.h),
        _buildSlotGrid(_morningSlots, isDark),
        SizedBox(height: 24.h),
        _buildSectionHeader("Afternoon Session", Icons.nights_stay_outlined, const Color(0xFF0F6FFF)),
        SizedBox(height: 12.h),
        _buildSlotGrid(_afternoonSlots, isDark),
      ],
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Icon(icon, color: color, size: 16.r),
        SizedBox(width: 8.w),
        Text(
          title,
          style: AppTextStyles.titleMedium.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 14.sp,
            color: isDark ? Colors.white70 : Colors.black87,
          ),
        ),
      ],
    );
  }

  Widget _buildSlotGrid(List<String> slots, bool isDark) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.2,
        crossAxisSpacing: 10.w,
        mainAxisSpacing: 10.h,
      ),
      itemCount: slots.length,
      itemBuilder: (context, index) {
        final slot = slots[index];
        final match = _appointments.firstWhere(
          (a) => a.appointmentTime == slot,
          orElse: () => AppointmentModel(
            id: '',
            patientName: '',
            doctorName: '',
            specialty: '',
            appointmentDate: DateTime(2000),
            appointmentTime: '',
            status: '',
            type: '',
          ),
        );

        final bool hasBooking = match.id.isNotEmpty;
        final bool isBlocked = hasBooking && match.status == 'Blocked';
        final bool isBooked = hasBooking && !isBlocked;

        Color cardBg;
        Color borderCol;
        Color textCol;
        Widget statusIndicator;

        if (isBooked) {
          cardBg = isDark ? const Color(0xFF1E3A8A) : const Color(0xFFEFF6FF);
          borderCol = const Color(0xFF3B82F6);
          textCol = const Color(0xFF3B82F6);
          statusIndicator = Text(
            match.patientName,
            style: TextStyle(
              color: textCol.withValues(alpha: 0.8),
              fontSize: 8.sp,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          );
        } else if (isBlocked) {
          cardBg = isDark ? const Color(0xFF881337).withValues(alpha: 0.1) : const Color(0xFFFFF1F2);
          borderCol = const Color(0xFFFDA4AF);
          textCol = const Color(0xFFE11D48);
          statusIndicator = Text(
            "Blocked",
            style: TextStyle(
              color: textCol,
              fontSize: 8.sp,
              fontWeight: FontWeight.bold,
            ),
          );
        } else {
          cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
          borderCol = isDark ? Colors.white10 : Colors.grey[200]!;
          textCol = isDark ? Colors.white70 : Colors.black87;
          statusIndicator = Text(
            "Available",
            style: TextStyle(
              color: const Color(0xFF10B981),
              fontSize: 8.sp,
              fontWeight: FontWeight.bold,
            ),
          );
        }

        return InkWell(
          onTap: isBooked ? null : () => _toggleSlot(slot, isBlocked),
          borderRadius: BorderRadius.circular(10.r),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: cardBg,
              border: Border.all(color: borderCol, width: 1.r),
              borderRadius: BorderRadius.circular(10.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      slot,
                      style: TextStyle(
                        color: textCol,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (isBooked)
                      Icon(Icons.lock_rounded, color: borderCol, size: 10.r)
                    else if (isBlocked)
                      Icon(Icons.block_rounded, color: borderCol, size: 10.r)
                    else
                      Icon(Icons.check_circle_outline_rounded, color: const Color(0xFF10B981), size: 10.r),
                  ],
                ),
                SizedBox(height: 2.h),
                statusIndicator,
              ],
            ),
          ),
        );
      },
    );
  }
}
