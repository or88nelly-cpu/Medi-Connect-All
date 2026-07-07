import 'dart:developer';
import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/features/doctors/dashboard/data/models/doctor_dashboard_stats_model.dart';
import 'package:medi_connect/features/doctors/dashboard/data/models/mrd_record_model.dart';
import 'package:medi_connect/features/doctors/dashboard/data/datasources/doctor_dashboard_remote_data_source.dart';

class DoctorDashboardRemoteDataSourceImpl implements DoctorDashboardRemoteDataSource {
  final SupabaseService _supabaseService;

  DoctorDashboardRemoteDataSourceImpl(this._supabaseService);

  Future<void> _seedMrdRecordsIfEmpty(String resolvedDoctorId) async {
    final supabase = _supabaseService.client;
    try {
      final existing = await supabase.from('mrd_records').select('id');
      if (existing.isNotEmpty) return;

      var patientsRes = await supabase.from('users').select('id, name').eq('role', 'patient');
      if (patientsRes.isEmpty) {
        final mockPatients = [
          {'id': 'a1111111-1111-1111-1111-111111111111', 'first_name': 'Arjun', 'last_name': 'Nambiar', 'name': 'Arjun Nambiar', 'gender': 'Male', 'dob': '1994-06-27'},
          {'id': 'b2222222-2222-2222-2222-222222222222', 'first_name': 'Sneha', 'last_name': 'Menon', 'name': 'Sneha Menon', 'gender': 'Female', 'dob': '1998-09-12'},
          {'id': 'c3333333-3333-3333-3333-333333333333', 'first_name': 'Vishnu', 'last_name': 'Prasad', 'name': 'Vishnu Prasad', 'gender': 'Male', 'dob': '1981-02-05'},
          {'id': 'd4444444-4444-4444-4444-444444444444', 'first_name': 'Anjali', 'last_name': 'Raj', 'name': 'Anjali Raj', 'gender': 'Female', 'dob': '1992-11-20'},
          {'id': 'e5555555-5555-5555-5555-555555555555', 'first_name': 'Ramesh', 'last_name': 'Kumar', 'name': 'Ramesh Kumar', 'gender': 'Male', 'dob': '1970-05-18'},
        ];

        for (final p in mockPatients) {
          await supabase.from('users').upsert({
            'id': p['id'],
            'email': '${p['first_name']!.toLowerCase()}@example.com',
            'name': p['name'],
            'first_name': p['first_name'],
            'last_name': p['last_name'],
            'role': 'patient',
            'status': 'Active',
          });

          final dob = DateTime.parse(p['dob']!);
          await supabase.from('patients').upsert({
            'id': p['id'],
            'patient_id': p['id'],
            'date_of_birth': p['dob'],
            'age': DateTime.now().year - dob.year,
            'gender': p['gender'],
          });
        }
        patientsRes = await supabase.from('users').select('id, name').eq('role', 'patient');
      }

      final List<Map<String, dynamic>> recordsToSeed = [
        {
          'patient_id': patientsRes[0]['id'],
          'doctor_id': resolvedDoctorId,
          'record_type': 'Discharge Summary',
          'title': 'Discharge Summary - Arjun Nambiar',
          'description': 'IPD Discharge summary documentation pending.',
          'status': 'pending',
        },
        {
          'patient_id': patientsRes[1]['id'],
          'doctor_id': resolvedDoctorId,
          'record_type': 'Operative Notes',
          'title': 'Operative Notes - Sneha Menon',
          'description': 'Post-op clinical documentation pending approval.',
          'status': 'pending',
        },
        {
          'patient_id': patientsRes[2]['id'],
          'doctor_id': resolvedDoctorId,
          'record_type': 'Consultation',
          'title': 'Consultation Notes - Vishnu Prasad',
          'description': 'Daily clinical OPD consultation note signature pending.',
          'status': 'pending',
        },
        {
          'patient_id': patientsRes[3]['id'],
          'doctor_id': resolvedDoctorId,
          'record_type': 'Digital Signature',
          'title': 'Digital Signature - Anjali Raj',
          'description': 'IPD Progress notes signature pending.',
          'status': 'pending',
        },
        {
          'patient_id': patientsRes[4]['id'],
          'doctor_id': resolvedDoctorId,
          'record_type': 'Discharge Summary',
          'title': 'Discharge Summary - Ramesh Kumar',
          'description': 'Daily chart entries and summaries signature pending.',
          'status': 'pending',
        },
      ];

      await supabase.from('mrd_records').insert(recordsToSeed);
    } catch (e) {
      log("Error seeding MRD records: $e");
    }
  }

  @override
  Future<List<MrdRecordModel>> getPendingMrdRecords({
    required String doctorId,
  }) async {
    final resolvedDoctorId = await _supabaseService.resolveDoctorId(doctorId);
    await _seedMrdRecordsIfEmpty(resolvedDoctorId);

    final supabase = _supabaseService.client;
    final response = await supabase
        .from('mrd_records')
        .select()
        .eq('doctor_id', resolvedDoctorId)
        .eq('status', 'pending');

    final list = response as List<dynamic>? ?? [];
    final records = list.map((json) => MrdRecordModel.fromJson(json)).toList();

    final patientIds = records.map((r) => r.patientId).toSet().toList();
    final Map<String, Map<String, dynamic>> patientProfiles = {};

    if (patientIds.isNotEmpty) {
      try {
        final usersResponse = await supabase
            .from('users')
            .select('*, patients(*)')
            .inFilter('id', patientIds);

        final usersList = usersResponse as List<dynamic>? ?? [];
        for (final user in usersList) {
          final userMap = Map<String, dynamic>.from(user as Map);
          patientProfiles[userMap['id'] as String] = userMap;
        }
      } catch (_) {}
    }

    final List<MrdRecordModel> joinedRecords = [];

    for (final rec in records) {
      final profile = patientProfiles[rec.patientId];
      String ageStr = '30';
      String genderStr = 'Male';
      String? photo = profile?['profile_photo'];

      if (profile != null) {
        final patientMap = profile['patients'] as Map<String, dynamic>?;
        if (patientMap != null) {
          final ageVal = patientMap['age'];
          if (ageVal != null) ageStr = ageVal.toString();
          if (patientMap['gender'] != null) {
            genderStr = patientMap['gender'] as String;
          }
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
          patientName: profile?['name']?.toString() ?? 'Arjun Nambiar',
          patientAge: ageStr,
          patientGender: genderStr,
          patientPhoto: photo,
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
