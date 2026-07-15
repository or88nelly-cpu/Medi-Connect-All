import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:medi_connect/core/theme/app_colors.dart';
import 'package:medi_connect/core/theme/app_dimensions.dart';
import 'package:medi_connect/core/theme/app_text_styles.dart';
import 'package:medi_connect/features/authentication/data/models/user_model.dart';
import 'package:medi_connect/features/patient/booking/presentation/pages/booking_flow_page.dart';

class SlotStep extends StatelessWidget {
  final UserModel? doctor;
  final DateTime selectedDate;
  final String? selectedSlot;
  final ValueChanged<DateTime> onDateChanged;
  final ValueChanged<String> onSlotSelected;

  const SlotStep({
    super.key,
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

  Future<Set<String>> _fetchBookedSlots(String userId, DateTime date) async {
    try {
      String doctorId = userId;
      final docRes = await Supabase.instance.client
          .from('doctors')
          .select('id')
          .eq('user_id', userId)
          .maybeSingle();
      if (docRes != null && docRes['id'] != null) {
        doctorId = docRes['id'] as String;
      }

      final dateStr = date.toIso8601String().split('T').first;
      final response = await Supabase.instance.client
          .from('appointments')
          .select('appointment_time')
          .eq('doctor_id', doctorId)
          .eq('appointment_date', dateStr)
          .neq('status', 'Cancelled');

      final list = response as List<dynamic>? ?? [];
      return list
          .map((item) => item['appointment_time']?.toString() ?? '')
          .toSet();
    } catch (_) {
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctorId = doctor?.id ?? '';

    return FutureBuilder<Set<String>>(
      future: _fetchBookedSlots(doctorId, selectedDate),
      builder: (context, snapshot) {
        final activeBookedSlots = snapshot.data ?? kBookedSlots;

        return SingleChildScrollView(
          padding: EdgeInsets.all(AppDimensions.paddingL),
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
                SizedBox(height: AppDimensions.spaceXS),
                Text(
                  'With ${doctor!.fullName}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary(context),
                  ),
                ),
              ],
              SizedBox(height: AppDimensions.spaceL),

              // Date row
              SizedBox(
                height: 68,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _days.length,
                  separatorBuilder: (context, _) => SizedBox(width: AppDimensions.spaceWS),
                  itemBuilder: (context, i) {
                    final d = _days[i];
                    final isSelected = _isSameDay(d, selectedDate);
                    return GestureDetector(
                      onTap: () => onDateChanged(d),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 50,
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF4F7CFF),
                                    Color(0xFF5B42F3),
                                  ],
                                )
                              : null,
                          color: isSelected ? null : AppColors.card(context),
                          borderRadius: BorderRadius.circular(AppDimensions.radiusM),
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
                                fontSize: AppTextStyles.s10,
                                color: isSelected
                                    ? Colors.white70
                                    : AppColors.textSecondary(context),
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              '${d.day}',
                              style: TextStyle(
                                fontSize: AppTextStyles.s18,
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
              SizedBox(height: AppDimensions.spaceXL),

              // Time slots
              SlotGroup(
                title: '🌅 Morning',
                slots: kMorningSlots,
                bookedSlots: activeBookedSlots,
                selectedSlot: selectedSlot,
                onSelect: onSlotSelected,
              ),
              SizedBox(height: AppDimensions.spaceM + 2),
              SlotGroup(
                title: '☀️ Afternoon',
                slots: kAfternoonSlots,
                bookedSlots: activeBookedSlots,
                selectedSlot: selectedSlot,
                onSelect: onSlotSelected,
              ),
              SizedBox(height: AppDimensions.spaceM + 2),
              SlotGroup(
                title: '🌆 Evening',
                slots: kEveningSlots,
                bookedSlots: activeBookedSlots,
                selectedSlot: selectedSlot,
                onSelect: onSlotSelected,
              ),
            ],
          ),
        );
      },
    );
  }
}

class SlotGroup extends StatelessWidget {
  final String title;
  final List<String> slots;
  final Set<String> bookedSlots;
  final String? selectedSlot;
  final ValueChanged<String> onSelect;

  const SlotGroup({
    super.key,
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
        SizedBox(height: AppDimensions.spaceS),
        Wrap(
          spacing: AppDimensions.spaceWS,
          runSpacing: AppDimensions.spaceS,
          children: slots.map((slot) {
            final isBooked = bookedSlots.contains(slot);
            final isSelected = slot == selectedSlot;
            return GestureDetector(
              onTap: isBooked ? null : () => onSelect(slot),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingL - 2, // 14
                  vertical: AppDimensions.paddingS + 1, // 9
                ),
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
                  borderRadius: BorderRadius.circular(AppDimensions.radiusM - 2), // 10
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.border(context),
                  ),
                ),
                child: Text(
                  slot,
                  style: TextStyle(
                    fontSize: AppTextStyles.s12,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                    color: isBooked
                        ? AppColors.textSecondary(context).withValues(alpha: 0.5)
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
