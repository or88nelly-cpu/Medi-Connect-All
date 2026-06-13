import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/core/storage/secure_storage_service.dart';

abstract class EmrdRemoteDataSource {
  Future<Map<String, dynamic>> getEmrdStats();
  Future<List<Map<String, dynamic>>> getEmrRecords();
}

class EmrdRemoteDataSourceImpl implements EmrdRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getEmrdStats() async {
    return {
      'records_scanned_today': 320,
      'pending_digitization': 45,
      'retrieval_requests_active': 2,
      'storage_capacity_used_pct': 78.4,
    };
  }

  @override
  Future<List<Map<String, dynamic>>> getEmrRecords() async {
    try {
      final supabase = GetIt.I<SupabaseService>().client;
      final response = await supabase
          .from('emr_records')
          .select()
          .order('recorded_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint("Supabase getEmrRecords query failed, falling back to local storage: $e");
      try {
        final storage = GetIt.I<SecureStorageService>();
        final localDataStr = await storage.read('emr_records');
        if (localDataStr != null) {
          final List<dynamic> decoded = jsonDecode(localDataStr);
          decoded.sort((a, b) {
            final aDate = DateTime.tryParse(a['recorded_at'] ?? '') ?? DateTime.now();
            final bDate = DateTime.tryParse(b['recorded_at'] ?? '') ?? DateTime.now();
            return bDate.compareTo(aDate);
          });
          return decoded.map((e) => Map<String, dynamic>.from(e)).toList();
        }
      } catch (err) {
        debugPrint("Local EMR storage read failed: $err");
      }
      return [];
    }
  }
}
