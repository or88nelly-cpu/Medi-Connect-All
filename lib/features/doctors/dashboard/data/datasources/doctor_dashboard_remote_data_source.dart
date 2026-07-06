import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/features/doctors/dashboard/data/models/doctor_dashboard_stats_model.dart';
import 'package:medi_connect/features/doctors/dashboard/data/models/mrd_record_model.dart';

abstract class DoctorDashboardRemoteDataSource {
  Future<DoctorDashboardStatsModel> getDashboardStats({
    required String doctorId,
    required DateTime date,
  });

  Future<List<MrdRecordModel>> getPendingMrdRecords({required String doctorId});
}

class DoctorDashboardRemoteDataSourceImpl
    implements DoctorDashboardRemoteDataSource {
  final SupabaseService _supabaseService;

  DoctorDashboardRemoteDataSourceImpl(this._supabaseService);

  Future<String> _resolveDoctorId(String userId) async {
    try {
      final response = await _supabaseService
          .from('doctors')
          .select('id')
          .eq('user_id', userId)
          .maybeSingle();
      if (response != null && response['id'] != null) {
        return response['id'] as String;
      }
    } catch (_) {}
    return userId;
  }

  @override
  Future<DoctorDashboardStatsModel> getDashboardStats({
    required String doctorId,
    required DateTime date,
  }) async {
    final resolvedDoctorId = await _resolveDoctorId(doctorId);
    final dateStr = date.toIso8601String().split('T').first;

    // Query appointments for dynamic counts
    final appointmentsResponse = await _supabaseService
        .from('appointments')
        .select()
        .eq('doctor_id', resolvedDoctorId)
        .eq('appointment_date', dateStr);

    final appointments = appointmentsResponse as List<dynamic>? ?? [];

    int opCount = 0;
    int ipCount = 0;
    int opProcCount = 0;
    int ipProcCount = 0;
    int surgeryCount = 0;
    int certCount = 0;

    final Set<String> bookedOrBlockedTimes = {};

    for (final apt in appointments) {
      final type = (apt['type'] as String? ?? '').toLowerCase();
      final status = (apt['status'] as String? ?? '').toLowerCase();
      final time = apt['appointment_time'] as String? ?? '';

      if (time.isNotEmpty) {
        bookedOrBlockedTimes.add(time);
      }

      if (type == 'consultation' || type.contains('op')) {
        opCount++;
      } else if (type == 'ipd') {
        ipCount++;
      } else if (type == 'procedure') {
        opProcCount++;
      } else if (type == 'ipd procedure') {
        ipProcCount++;
      } else if (type == 'surgery') {
        surgeryCount++;
      }

      if (status == 'completed') {
        certCount++;
      }
    }

    // Query pending MRDs count
    final mrdCount = await _getPendingMrdCount(resolvedDoctorId);

    // Calculate available slots out of 15 total slots
    final availableSlots = 15 - bookedOrBlockedTimes.length;

    return DoctorDashboardStatsModel(
      opCount: opCount,
      ipCount: ipCount,
      opProceduresCount: opProcCount,
      ipProceduresCount: ipProcCount,
      surgeryCount: surgeryCount,
      medicalCertificatesCount: certCount,
      pendingMrdCount: mrdCount,
      availableSlotsCount: availableSlots >= 0 ? availableSlots : 0,
    );
  }

  @override
  Future<List<MrdRecordModel>> getPendingMrdRecords({
    required String doctorId,
  }) async {
    final resolvedDoctorId = await _resolveDoctorId(doctorId);
    final response = await _supabaseService
        .from('mrd_records')
        .select()
        .eq('doctor_id', resolvedDoctorId)
        .eq('status', 'pending');

    final list = response as List<dynamic>? ?? [];
    return list.map((json) => MrdRecordModel.fromJson(json)).toList();
  }

  Future<int> _getPendingMrdCount(String resolvedDoctorId) async {
    try {
      final response = await _supabaseService
          .from('mrd_records')
          .select('id')
          .eq('doctor_id', resolvedDoctorId)
          .eq('status', 'pending');
      return (response as List<dynamic>? ?? []).length;
    } catch (_) {
      // Fallback to 0 if table does not exist or schema differs
      return 0;
    }
  }
}
