import 'package:supabase_flutter/supabase_flutter.dart';

class DoctorImageUrlAndGender {
  final String? imageUrl;
  final String? gender;
  DoctorImageUrlAndGender(this.imageUrl, this.gender);
}

abstract class DoctorImageRemoteDataSource {
  Future<DoctorImageUrlAndGender> getDoctorImageUrl(String doctorId);
}

class DoctorImageRemoteDataSourceImpl implements DoctorImageRemoteDataSource {
  final SupabaseClient _supabase;

  DoctorImageRemoteDataSourceImpl(this._supabase);

  @override
  Future<DoctorImageUrlAndGender> getDoctorImageUrl(String doctorId) async {
    if (doctorId.isEmpty) return DoctorImageUrlAndGender(null, null);

    // Path 1: Join doctors -> employees!doctors_employee_id_fkey -> users (to retrieve profile_photo and gender)
    try {
      final response = await _supabase
          .from('doctors')
          .select('employees!doctors_employee_id_fkey(users(profile_photo, profile_image, gender))')
          .eq('id', doctorId)
          .maybeSingle();
      if (response != null && response['employees!doctors_employee_id_fkey'] != null) {
        final emp = response['employees!doctors_employee_id_fkey'];
        if (emp is Map && emp['users'] != null) {
          final usr = emp['users'];
          if (usr is Map) {
            final img = (usr['profile_photo'] ?? usr['profile_image']) as String?;
            final gen = usr['gender'] as String?;
            return DoctorImageUrlAndGender(img, gen);
          }
        }
      }
    } catch (_) {}

    // Path 2: Join doctors (linked by user_id) -> employees!doctors_employee_id_fkey -> users
    try {
      final response = await _supabase
          .from('doctors')
          .select('employees!doctors_employee_id_fkey(users(profile_photo, profile_image, gender))')
          .eq('user_id', doctorId)
          .maybeSingle();
      if (response != null && response['employees!doctors_employee_id_fkey'] != null) {
        final emp = response['employees!doctors_employee_id_fkey'];
        if (emp is Map && emp['users'] != null) {
          final usr = emp['users'];
          if (usr is Map) {
            final img = (usr['profile_photo'] ?? usr['profile_image']) as String?;
            final gen = usr['gender'] as String?;
            return DoctorImageUrlAndGender(img, gen);
          }
        }
      }
    } catch (_) {}

    // Path 3: Direct users table lookup (if permissions allow)
    try {
      final response = await _supabase
          .from('users')
          .select('profile_photo, profile_image, gender')
          .eq('id', doctorId)
          .maybeSingle();
      if (response != null) {
        final img = (response['profile_photo'] ?? response['profile_image']) as String?;
        final gen = response['gender'] as String?;
        return DoctorImageUrlAndGender(img, gen);
      }
    } catch (_) {}

    // Path 4: Join employees -> users
    try {
      final response = await _supabase
          .from('employees')
          .select('users(profile_photo, profile_image, gender)')
          .eq('id', doctorId)
          .maybeSingle();
      if (response != null && response['users'] != null) {
        final usr = response['users'];
        if (usr is Map) {
          final img = (usr['profile_photo'] ?? usr['profile_image']) as String?;
          final gen = usr['gender'] as String?;
          return DoctorImageUrlAndGender(img, gen);
        }
      }
    } catch (_) {}

    return DoctorImageUrlAndGender(null, null);
  }
}
