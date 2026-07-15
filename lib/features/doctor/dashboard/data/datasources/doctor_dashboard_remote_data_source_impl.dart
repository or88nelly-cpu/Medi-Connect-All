import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/features/doctor/dashboard/data/datasources/doctor_dashboard_remote_data_source.dart';
import 'package:medi_connect/features/doctor/dashboard/data/models/doctor_dashboard_stats_model.dart';
import 'package:medi_connect/features/doctor/dashboard/data/models/mrd_record_model.dart';

@LazySingleton(as: DoctorDashboardRemoteDataSource)
class DoctorDashboardRemoteDataSourceImpl implements DoctorDashboardRemoteDataSource {
  final SupabaseService _supabaseService;

  DoctorDashboardRemoteDataSourceImpl(this._supabaseService);

  @override
Future<List<MrdRecordModel>> getPendingMrdRecords({
  required String doctorId,
}) async {
  final resolvedDoctorId =
      await _supabaseService.resolveDoctorId(doctorId);

  final supabase = _supabaseService.client;

  // Get pending MRD records
  final response = await supabase
      .from('mrd_records')
      .select()
      .eq('doctor_id', resolvedDoctorId)
      .eq('status', 'pending');

  final records = (response as List<dynamic>)
      .map((e) => MrdRecordModel.fromJson(e))
      .toList();

  if (records.isEmpty) {
    return [];
  }

  // patientIds are patients.id
  final patientIds = records.map((e) => e.patientId).toSet().toList();

  /// Get patients
  final patientsResponse = await supabase
      .from('patients')
      .select('id,user_id,age,gender,date_of_birth')
      .inFilter('id', patientIds);

  final Map<String, Map<String, dynamic>> patientMap = {};

  for (final item in (patientsResponse as List)) {
    final map = Map<String, dynamic>.from(item);
    patientMap[map['id'] as String] = map;
  }

  /// Collect user ids
  final userIds = patientMap.values
      .map((e) => e['user_id'] as String)
      .toSet()
      .toList();

  final Map<String, Map<String, dynamic>> usersMap = {};

  if (userIds.isNotEmpty) {
    final usersResponse = await supabase
        .from('users')
        .select(
            'id,first_name,middle_name,last_name,profile_photo')
        .inFilter('id', userIds);

    for (final item in (usersResponse as List)) {
      final map = Map<String, dynamic>.from(item);
      usersMap[map['id'] as String] = map;
    }
  }

  final List<MrdRecordModel> joinedRecords = [];

  for (final rec in records) {
    final patient = patientMap[rec.patientId];

    final user = patient != null
        ? usersMap[patient['user_id'] as String]
        : null;

    String patientName = 'Unknown Patient';
    String patientAge = '';
    String patientGender = '';
    String? patientPhoto;

    if (user != null) {
      final first = user['first_name']?.toString() ?? '';
      final middle = user['middle_name']?.toString() ?? '';
      final last = user['last_name']?.toString() ?? '';

      patientName = [
        first,
        middle,
        last,
      ].where((e) => e.isNotEmpty).join(' ');

      patientPhoto = user['profile_photo']?.toString();
    }

    if (patient != null) {
      patientGender = patient['gender']?.toString() ?? '';

      if (patient['age'] != null) {
        patientAge = patient['age'].toString();
      } else if (patient['date_of_birth'] != null) {
        final dob = DateTime.parse(patient['date_of_birth']);
        final now = DateTime.now();

        int age = now.year - dob.year;

        if (now.month < dob.month ||
            (now.month == dob.month && now.day < dob.day)) {
          age--;
        }

        patientAge = age.toString();
      }
    }

    joinedRecords.add(
      MrdRecordModel(
        id: rec.id,
        patientId: rec.patientId,
        doctorId: rec.doctorId,
        employeeId: rec.employeeId,
        recordType: rec.recordType,
        title: rec.title,
        description: rec.description,
        fileUrl: rec.fileUrl,
        fileName: rec.fileName,
        fileSize: rec.fileSize,
        mimeType: rec.mimeType,
        isPaid: rec.isPaid,
        paymentAmount: rec.paymentAmount,
        paymentStatus: rec.paymentStatus,
        status: rec.status,
        recordDate: rec.recordDate,
        createdAt: rec.createdAt,
        updatedAt: rec.updatedAt,
        appointmentId: rec.appointmentId,
        patientName: patientName,
        patientAge: patientAge,
        patientGender: patientGender,
        patientPhoto: patientPhoto,
      ),
    );
  }

  return joinedRecords;
}

  @override
  Future<DoctorDashboardStatsModel> getDashboardStats({
    required String doctorId,
    required DateTime date,
  }) async {
    final resolvedDoctorId = await _supabaseService.resolveDoctorId(doctorId);
    final dateStr = date.toIso8601String().split('T').first;

    final appointmentsResponse = await _supabaseService.client
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

    final mrdCount = await _getPendingMrdCount(resolvedDoctorId);
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

  Future<int> _getPendingMrdCount(String resolvedDoctorId) async {
    try {
      final response = await _supabaseService.client
          .from('mrd_records')
          .select('id')
          .eq('doctor_id', resolvedDoctorId)
          .eq('status', 'pending');
      return (response as List<dynamic>? ?? []).length;
    } catch (_) {
      return 0;
    }
  }
}
