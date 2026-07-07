import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/features/doctors/dashboard/data/models/doctor_dashboard_stats_model.dart';
import 'package:medi_connect/features/doctors/dashboard/data/models/mrd_record_model.dart';
import 'package:medi_connect/features/doctors/dashboard/data/datasources/doctor_dashboard_remote_data_source.dart';

class DoctorDashboardRemoteDataSourceImpl
    implements DoctorDashboardRemoteDataSource {
  final SupabaseService _supabaseService;

  DoctorDashboardRemoteDataSourceImpl(this._supabaseService);

   @override
  Future<List<MrdRecordModel>> getPendingMrdRecords({
    required String doctorId,
  }) async {
    final resolvedDoctorId = await _supabaseService.resolveDoctorId(doctorId);
  

    final supabase = _supabaseService.client;
    final response = await supabase
        .from('mrd_records')
        .select()
        .eq('doctor_id', resolvedDoctorId)
        .eq('status', 'pending');
    log("response $response");

    final list = response as List<dynamic>? ?? [];
    final records = list.map((json) => MrdRecordModel.fromJson(json)).toList();

    // Fetch patient profiles
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
      } catch (_) {
        log("failed $response $records");
      }
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

      // Add patient profile information directly into a new instance of the model
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
