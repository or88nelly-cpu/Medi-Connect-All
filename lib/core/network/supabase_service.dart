import 'dart:developer';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@lazySingleton
class SupabaseService {
  final SupabaseClient _client;

  SupabaseService(this._client);

  /// Direct client access for custom/advanced queries.
  SupabaseClient get client => _client;

  /// Authentication client.
  GoTrueClient get auth => _client.auth;

  /// PostgreSQL Rest client for table operations.
  SupabaseQueryBuilder from(String tableName) => _client.from(tableName);

  /// Storage client.
  SupabaseStorageClient get storage => _client.storage;

  /// Realtime channel subscription helper.
  RealtimeChannel channel(String name) => _client.channel(name);

  /// Helper to check if a user is currently authenticated.
  bool get isAuthenticated => _client.auth.currentSession != null;

  /// Helper to get current user details.
  User? get currentUser => _client.auth.currentUser;

  /// Helper to get authorization token.
  String? get accessToken => _client.auth.currentSession?.accessToken;

  /// Helper to resolve Doctor ID from User ID
  Future<String> resolveDoctorId(String userId) async {
    try {
      // Get employee ID from users.id
      final employee = await _client
          .from('employees')
          .select('id')
          .eq('user_id', userId)
          .maybeSingle();

      if (employee == null) return userId;

      final employeeId = employee['id'] as String;

      // Get doctor ID from employee.id
      final doctor = await _client
          .from('doctors')
          .select('id')
          .eq('employee_id', employeeId)
          .maybeSingle();
      log("doctor $doctor");

      if (doctor == null) return userId;

      return doctor['id'] as String;
    } catch (e, stackTrace) {
      log('Error resolving doctor ID: $e');
      log(stackTrace.toString());
      return userId;
    }
  }
}
