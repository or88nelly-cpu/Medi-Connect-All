import 'package:supabase_flutter/supabase_flutter.dart';

abstract class DoctorImageRemoteDataSource {
  Future<String?> getDoctorImageUrl(String doctorId);
}

class DoctorImageRemoteDataSourceImpl implements DoctorImageRemoteDataSource {
  final SupabaseClient _supabase;

  DoctorImageRemoteDataSourceImpl(this._supabase);

  @override
  Future<String?> getDoctorImageUrl(String doctorId) async {
    if (doctorId.isEmpty) return null;

    // Path 1: Join doctors -> employees -> users (to retrieve profile_photo from users table)
    try {
      final response = await _supabase
          .from('doctors')
          .select('employees(users(profile_photo, profile_image))')
          .eq('id', doctorId)
          .maybeSingle();
      if (response != null && response['employees'] != null) {
        final emp = response['employees'];
        if (emp is Map && emp['users'] != null) {
          final usr = emp['users'];
          if (usr is Map) {
            final img = (usr['profile_photo'] ?? usr['profile_image']) as String?;
            if (img != null && img.isNotEmpty) return img;
          }
        }
      }
    } catch (_) {}

    // Path 2: Join doctors (linked by user_id) -> employees -> users
    try {
      final response = await _supabase
          .from('doctors')
          .select('employees(users(profile_photo, profile_image))')
          .eq('user_id', doctorId)
          .maybeSingle();
      if (response != null && response['employees'] != null) {
        final emp = response['employees'];
        if (emp is Map && emp['users'] != null) {
          final usr = emp['users'];
          if (usr is Map) {
            final img = (usr['profile_photo'] ?? usr['profile_image']) as String?;
            if (img != null && img.isNotEmpty) return img;
          }
        }
      }
    } catch (_) {}

    // Path 3: Direct users table lookup (if permissions allow)
    try {
      final response = await _supabase
          .from('users')
          .select('profile_photo, profile_image')
          .eq('id', doctorId)
          .maybeSingle();
      if (response != null) {
        final img = (response['profile_photo'] ?? response['profile_image']) as String?;
        if (img != null && img.isNotEmpty) return img;
      }
    } catch (_) {}

    // Path 4: Join employees -> users
    try {
      final response = await _supabase
          .from('employees')
          .select('users(profile_photo, profile_image)')
          .eq('id', doctorId)
          .maybeSingle();
      if (response != null && response['users'] != null) {
        final usr = response['users'];
        if (usr is Map) {
          final img = (usr['profile_photo'] ?? usr['profile_image']) as String?;
          if (img != null && img.isNotEmpty) return img;
        }
      }
    } catch (_) {}

    return null;
  }
}
