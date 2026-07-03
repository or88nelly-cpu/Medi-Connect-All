import 'package:intl/intl.dart';
import 'package:medi_connect/modules/patient/booking/domain/repositories/booking_repository.dart';
import 'package:medi_connect/modules/patient/booking/domain/entities/doctor_booking_info.dart';
import 'package:medi_connect/shared/auth/data/models/doctor_model.dart';
import 'package:uuid/uuid.dart';

class LoadDoctorsBySpecialtyUseCase {
  final BookingRepository _repository;

  LoadDoctorsBySpecialtyUseCase(this._repository);

  Future<List<DoctorBookingInfo>> call(String specialityId, String specialityName) async {
    return _repository.getDoctorsBySpecialty(specialityId, specialityName);
  }
}

class BookingSlotsResponse {
  final List<String> availableSlots;
  final List<String> bookedSlots;

  BookingSlotsResponse({required this.availableSlots, required this.bookedSlots});
}

class GetSlotsUseCase {
  final BookingRepository _repository;

  GetSlotsUseCase(this._repository);

  Future<BookingSlotsResponse> call({
    required String doctorId,
    required DateTime selectedDate,
  }) async {
    // 1. Get weekly availability configurations from repository
    List<Map<String, dynamic>> schedules = [];
    try {
      schedules = await _repository.getDoctorAvailability(doctorId);
    } catch (_) {
      // Graceful fallback
    }

    // 2. If no schedules in Supabase, create default 9-1 and 2-5 availability settings
    if (schedules.isEmpty) {
      final defaultSchedules = <Map<String, dynamic>>[];
      for (int day = 1; day <= 7; day++) {
        defaultSchedules.add({
          'id': const Uuid().v4(),
          'doctor_id': doctorId,
          'day_of_week': day,
          'start_time': '09:00',
          'end_time': '13:00',
          'is_available': true,
        });
        defaultSchedules.add({
          'id': const Uuid().v4(),
          'doctor_id': doctorId,
          'day_of_week': day,
          'start_time': '14:00',
          'end_time': '17:00',
          'is_available': true,
        });
      }

      // Try inserting into Supabase
      try {
        await _repository.saveDoctorAvailability(defaultSchedules);
      } catch (e) {
        // Safe catch if RLS denies inserts for current user
        print('Skipped database save for doctor_availability: $e');
      }
      schedules = defaultSchedules;
    }

    // 3. Filter for current day of week
    final weekday = selectedDate.weekday; // 1 = Monday, 7 = Sunday
    final dailySchedules = schedules
        .where((s) => s['day_of_week'] == weekday && s['is_available'] == true)
        .toList();

    // 4. Generate 10-minute slots
    final generatedSlots = <String>[];
    for (final sch in dailySchedules) {
      final startStr = sch['start_time'] as String? ?? '09:00';
      final endStr = sch['end_time'] as String? ?? '13:00';

      final startParts = startStr.split(':');
      final endParts = endStr.split(':');

      if (startParts.length >= 2 && endParts.length >= 2) {
        final startHour = int.tryParse(startParts[0]) ?? 9;
        final startMin = int.tryParse(startParts[1]) ?? 0;
        final endHour = int.tryParse(endParts[0]) ?? 13;
        final endMin = int.tryParse(endParts[1]) ?? 0;

        int currentMins = startHour * 60 + startMin;
        final endMins = endHour * 60 + endMin;

        while (currentMins < endMins) {
          final h = currentMins ~/ 60;
          final m = currentMins % 60;

          final displayHour = h > 12 ? h - 12 : (h == 0 ? 12 : h);
          final amPm = h >= 12 ? 'PM' : 'AM';
          final timeStr = '${displayHour.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')} $amPm';

          generatedSlots.add(timeStr);
          currentMins += 10; // 10 minutes interval
        }
      }
    }

    // 5. Block times that are in the past if the selected date is today
    final now = DateTime.now();
    final isToday = selectedDate.year == now.year &&
        selectedDate.month == now.month &&
        selectedDate.day == now.day;

    final List<String> availableSlots = [];
    final List<String> autoBlockedSlots = [];

    for (final slot in generatedSlots) {
      if (isToday) {
        // Parse slot e.g. "09:10 AM" into today's DateTime
        try {
          final format = DateFormat('hh:mm a');
          final parsedTime = format.parse(slot);
          final slotDateTime = DateTime(
            now.year,
            now.month,
            now.day,
            parsedTime.hour,
            parsedTime.minute,
          );

          if (slotDateTime.isBefore(now)) {
            autoBlockedSlots.add(slot);
            continue;
          }
        } catch (_) {
          // ignore parsing error
        }
      }
      availableSlots.add(slot);
    }

    // 6. Fetch booked slots from Supabase appointments table
    final dateStr = selectedDate.toIso8601String().split('T').first;
    List<String> bookedSlots = [];
    try {
      bookedSlots = await _repository.getBookedSlots(doctorId, dateStr);
    } catch (_) {
      // Graceful fallback
    }

    // Combine booked slots and past slots for the bookedSlots response
    final allBooked = <String>{...bookedSlots, ...autoBlockedSlots}.toList();

    return BookingSlotsResponse(
      availableSlots: availableSlots,
      bookedSlots: allBooked,
    );
  }
}

class BookAppointmentUseCase {
  final BookingRepository _repository;

  BookAppointmentUseCase(this._repository);

  Future<void> call({
    required String patientId,
    required String patientName,
    required String doctorId,
    required String doctorName,
    required String specialty,
    required DateTime date,
    required String slot,
    required double fee,
    required String paymentMethod,
  }) async {
    final dateStr = date.toIso8601String().split('T').first;

    // Generate token prefix
    final cleanDoc = doctorName
        .replaceAll(RegExp(r'^(dr\.|dr|Dr\.|Dr)\s+', caseSensitive: false), '')
        .trim();
    final parts = cleanDoc.split(RegExp(r'\s+')).where((s) => s.isNotEmpty).toList();
    String initials = 'DR';
    if (parts.isNotEmpty) {
      if (parts.length == 1) {
        initials = parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
      } else {
        initials = '${parts.first[0].toUpperCase()}${parts.last[0].toUpperCase()}';
      }
    }
    final token = '${initials}A${(DateTime.now().millisecondsSinceEpoch % 1000).toString().padLeft(3, '0')}';

    final appointmentData = {
      'patient_id': patientId,
      'patient_name': patientName,
      'doctor_id': doctorId,
      'doctor_name': doctorName,
      'specialty': specialty,
      'appointment_date': dateStr,
      'appointment_time': slot,
      'status': paymentMethod == 'Pay Later' ? 'Pending' : 'Confirmed',
      'type': 'Consultation',
      'token': token,
      'amount': fee.round(),
    };

    await _repository.saveAppointment(appointmentData);
  }
}
