import 'dart:developer';
import 'package:injectable/injectable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DoctorImageUrlAndGender {
  final String? imageUrl;
  final String? gender;
  DoctorImageUrlAndGender(this.imageUrl, this.gender);
}

abstract class DoctorImageRemoteDataSource {
  Future<DoctorImageUrlAndGender> getDoctorImageUrl(String doctorId);
}

@LazySingleton(as: DoctorImageRemoteDataSource)
class DoctorImageRemoteDataSourceImpl implements DoctorImageRemoteDataSource {
  final SupabaseClient _supabase;

  DoctorImageRemoteDataSourceImpl(this._supabase);
  @override
  Future<DoctorImageUrlAndGender> getDoctorImageUrl(String doctorId) async {
    if (doctorId.isEmpty) {
      return DoctorImageUrlAndGender(null, null);
    }

    try {
      final doctor = await _supabase
          .from('employees')
          .select('user_id')
          .eq('id', doctorId)
          .maybeSingle();

      if (doctor == null || doctor['user_id'] == null) {
        return DoctorImageUrlAndGender(null, null);
      }

      final user = await _supabase
          .from('users')
          .select('profile_photo, gender')
          .eq('id', doctor['user_id'])
          .maybeSingle();

      if (user == null) {
        return DoctorImageUrlAndGender(null, null);
      }

      return DoctorImageUrlAndGender(
        user['profile_photo'] as String?,
        user['gender'] as String?,
      );
    } catch (e) {
      log('Doctor image error: $e');
      return DoctorImageUrlAndGender(null, null);
    }
  }
}
