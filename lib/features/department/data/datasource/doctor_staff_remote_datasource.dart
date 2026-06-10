import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';

abstract class DoctorStaffRemoteDataSource {
  Future<List<UserModel>> getDoctorStaff(String departmentName);
  Future<UserModel> createDoctorStaffMember(UserModel user);
  Future<UserModel> updateDoctorStaffMember(UserModel user);
  Future<void> deleteDoctorStaffMember(String userId);
}

class DoctorStaffRemoteDataSourceImpl implements DoctorStaffRemoteDataSource {
  final SupabaseService _supabase;
  DoctorStaffRemoteDataSourceImpl(this._supabase);

  @override
  Future<List<UserModel>> getDoctorStaff(String departmentName) async {
    final response = await _supabase
        .from('users')
        .select()
        .eq('department', departmentName)
        .isFilter('deleted_at', null);

    return (response as List<dynamic>)
        .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<UserModel> createDoctorStaffMember(UserModel user) async {
    final payload = user.toJson();
    payload['profile_completion_status'] = true;
    payload['status'] = 'Available';

    final response = await _supabase
        .from('users')
        .insert(payload)
        .select()
        .single();

    return UserModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<UserModel> updateDoctorStaffMember(UserModel user) async {
    final payload = user.toJson();
    final response = await _supabase
        .from('users')
        .update(payload)
        .eq('id', user.id)
        .select()
        .single();

    return UserModel.fromJson(response as Map<String, dynamic>);
  }

  @override
  Future<void> deleteDoctorStaffMember(String userId) async {
    // Soft delete user record by updating deleted_at timestamp
    await _supabase
        .from('users')
        .update({'deleted_at': DateTime.now().toIso8601String()})
        .eq('id', userId);
  }
}
