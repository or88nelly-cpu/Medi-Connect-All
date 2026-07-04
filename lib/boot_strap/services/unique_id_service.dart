import 'package:medi_connect/core/models/exceptions.dart';

import 'package:medi_connect/core/network/supabase_service.dart';

class UniqueIdService {
  final SupabaseService _supabase;

  UniqueIdService(this._supabase);

  /// Generates a unique sequential Doctor ID (e.g. DOC-000001).
  Future<String> generateDoctorId() async {
    return _generateId('doctor');
  }

  /// Generates a unique sequential Staff ID (e.g. STF-000001).
  Future<String> generateStaffId() async {
    return _generateId('staff');
  }

  /// Generates a unique sequential Patient ID (e.g. PAT-000001).
  Future<String> generatePatientId() async {
    return _generateId('patient');
  }

  /// Generates a unique sequential Admin ID (e.g. ADM-000001).
  Future<String> generateAdminId() async {
    return _generateId('admin');
  }

  Future<String> _generateId(String role) async {
    try {
      final response = await _supabase.client.rpc(
        'generate_unique_id',
        params: {'user_role': role},
      );
      return response as String;
    } catch (e) {
      throw ServerException('Failed to generate unique ID: ${e.toString()}');
    }
  }
}
