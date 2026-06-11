import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';

abstract class PatientRemoteDataSource {
  Future<List<UserModel>> getPatients();
  Future<UserModel> createPatient(UserModel patient);
  Future<UserModel> updatePatient(UserModel patient);
  Future<void> deletePatient(String patientId);
}

class PatientRemoteDataSourceImpl implements PatientRemoteDataSource {
  final SupabaseService _supabase;
  PatientRemoteDataSourceImpl(this._supabase);

  @override
  Future<List<UserModel>> getPatients() async {
    final response = await _supabase
        .from('users')
        .select()
        .eq('role', 'patient')
        .isFilter('deleted_at', null);

    return (response as List<dynamic>)
        .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<UserModel> createPatient(UserModel patient) async {
    final payload = patient.toJson();
    final response = await _supabase
        .from('users')
        .insert(payload)
        .select()
        .single();
    return UserModel.fromJson(response);
  }

  @override
  Future<UserModel> updatePatient(UserModel patient) async {
    final payload = patient.toJson();
    final response = await _supabase
        .from('users')
        .update(payload)
        .eq('id', patient.id)
        .select()
        .single();
    return UserModel.fromJson(response);
  }

  @override
  Future<void> deletePatient(String patientId) async {
    await _supabase
        .from('users')
        .update({'deleted_at': DateTime.now().toIso8601String()})
        .eq('id', patientId);
  }
}
