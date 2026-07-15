import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/features/doctor/op_info/data/models/op_procedure_model.dart';
import 'package:medi_connect/features/doctor/op_info/domain/entities/op_info_summary_entity.dart';

abstract class OpInfoRemoteDataSource {
  Future<OpInfoSummaryEntity> getOpInfo({
    required String doctorId,
    required DateTime date,
  });
}

@LazySingleton(as: OpInfoRemoteDataSource)
class OpInfoRemoteDataSourceImpl implements OpInfoRemoteDataSource {
  final SupabaseService _supabaseService;

  OpInfoRemoteDataSourceImpl(this._supabaseService);

  bool _isAppointmentInPast(DateTime date, String timeStr) {
    try {
      final format = DateFormat('hh:mm a');
      final parsedTime = format.parse(timeStr.trim());
      final combined = DateTime(
        date.year,
        date.month,
        date.day,
        parsedTime.hour,
        parsedTime.minute,
      );
      return combined.isBefore(DateTime.now());
    } catch (_) {
      final now = DateTime.now();
      final todayDateOnly = DateTime(now.year, now.month, now.day);
      return date.isBefore(todayDateOnly);
    }
  }

  @override
  Future<OpInfoSummaryEntity> getOpInfo({
    required String doctorId,
    required DateTime date,
  }) async {
    final dateStr = date.toIso8601String().split('T').first;
    final resolvedDoctorId = await _supabaseService.resolveDoctorId(doctorId);

    final response = await _supabaseService.client
        .from('appointments')
        .select()
        .or('doctor_id.eq.$doctorId,doctor_id.eq.$resolvedDoctorId')
        .eq('appointment_date', dateStr);

    final list = response as List<dynamic>? ?? [];

    final patientIds = list
        .map((apt) => apt['patient_id'] as String?)
        .where((id) => id != null && id.isNotEmpty)
        .cast<String>()
        .toSet()
        .toList();

    final Map<String, Map<String, dynamic>> patientProfiles = {};
    if (patientIds.isNotEmpty) {
      try {
        final usersResponse = await _supabaseService.client
            .from('users')
            .select('*, patients(*)')
            .inFilter('id', patientIds);

        final usersList = usersResponse as List<dynamic>? ?? [];
        for (final user in usersList) {
          final userMap = Map<String, dynamic>.from(user as Map);
          patientProfiles[userMap['id'] as String] = userMap;
        }
      } catch (e) {
        // Fallback or log
      }
    }

    final List<OpProcedureModel> procedures = [];

    int pending = 0;
    int completed = 0;
    int cancelled = 0;

    for (final apt in list) {
      final tokenStr = apt['token'] as String? ?? '';
      int tokenNum = 1;
      final digitsOnly = tokenStr.replaceAll(RegExp(r'\D'), '');
      if (digitsOnly.isNotEmpty) {
        tokenNum = int.tryParse(digitsOnly) ?? 1;
      }

      var displayStatus = apt['status'] as String? ?? 'Pending';
      if (displayStatus.toLowerCase() != 'completed' &&
          displayStatus.toLowerCase() != 'cancelled' &&
          _isAppointmentInPast(
            date,
            apt['appointment_time'] as String? ?? '',
          )) {
        displayStatus = 'Pending MRD';
      }

      final patientIdStr = apt['patient_id']?.toString() ?? '';
      final userMap = patientProfiles[patientIdStr];
      String ageStr = '30 Years';
      String genderStr = 'Male';

      if (userMap != null) {
        final patientMap = userMap['patients'] as Map<String, dynamic>?;
        if (patientMap != null) {
          final ageVal = patientMap['age'];
          if (ageVal != null) {
            ageStr = '$ageVal Years';
          } else {
            final dobStr = patientMap['date_of_birth'] ?? userMap['dob'];
            if (dobStr != null) {
              final dob = DateTime.tryParse(dobStr as String);
              if (dob != null) {
                ageStr = '${DateTime.now().year - dob.year} Years';
              }
            }
          }

          if (patientMap['gender'] != null) {
            genderStr = patientMap['gender'] as String;
          }
        } else if (userMap['gender'] != null) {
          genderStr = userMap['gender'] as String;
        }
      }

      final procedure = OpProcedureModel(
        id: apt['id']?.toString() ?? '',
        tokenNumber: tokenNum,
        patientId: patientIdStr,
        patientName: apt['patient_name']?.toString() ?? '',
        age: ageStr,
        gender: genderStr,
        appointmentTime: apt['appointment_time']?.toString() ?? '',
        status: displayStatus,
        profilePhoto: userMap?['profile_photo']?.toString(),
      );

      procedures.add(procedure);

      switch (displayStatus.toLowerCase()) {
        case 'pending':
        case 'pending mrd':
          pending++;
          break;
        case 'completed':
          completed++;
          break;
        case 'cancelled':
          cancelled++;
          break;
        default:
          pending++;
          break;
      }
    }

    return OpInfoSummaryEntity(
      total: procedures.length,
      pending: pending,
      completed: completed,
      cancelled: cancelled,
      procedures: procedures,
    );
  }
}
