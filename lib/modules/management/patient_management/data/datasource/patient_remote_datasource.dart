import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';

abstract class PatientRemoteDataSource {
  Future<List<UserModel>> getPatients();
  Future<UserModel> createPatient(UserModel patient);
  Future<UserModel> updatePatient(UserModel patient);
  Future<void> deletePatient(String patientId);
  Future<void> sendToMRD(Map<String, dynamic> record);
}

class PatientRemoteDataSourceImpl implements PatientRemoteDataSource {
  final SupabaseService _supabase;
  PatientRemoteDataSourceImpl(this._supabase);

  @override
  Future<List<UserModel>> getPatients() async {
    final response = await _supabase
        .from('users')
        .select('*, patients(*)')
        .eq('role', 'patient')
        .isFilter('deleted_at', null);

    return (response as List<dynamic>).map((json) {
      final userJson = Map<String, dynamic>.from(json as Map);
      final patientJson = userJson.remove('patients');

      if (patientJson is List && patientJson.isNotEmpty) {
        userJson.addAll(patientJson.first as Map<String, dynamic>);
      } else if (patientJson is Map<String, dynamic>) {
        userJson.addAll(patientJson);
      }

      // Map DB snake_case fields back to correct UserModel fields
      if (userJson.containsKey('date_of_birth')) {
        userJson['dob'] = userJson['date_of_birth'];
      }

      return UserModel.fromJson(userJson);
    }).toList();
  }

  @override
  Future<UserModel> createPatient(UserModel patient) async {
    // 1. Insert/upsert into users table
    final userPayload = {
      'id': patient.id,
      'email': patient.email,
      'name': patient.fullName,
      'phone': patient.phone,
      'role': 'patient',
      'profile_completed': true,
      'onboarding_step': 3,
      'status': patient.status ?? 'Active',
      'first_name': patient.firstName,
      'last_name': patient.lastName,
      'profile_photo': patient.profilePhoto,
    };
    await _supabase.from('users').upsert(userPayload);

    // 2. Insert/upsert into patients table
    final patientPayload = {
      'id': patient.id,
      'patient_id': patient.id,
      'blood_group': patient.bloodGroup,
      'date_of_birth': patient.dob?.toIso8601String(),
      'age': patient.dob != null
          ? (DateTime.now().year - patient.dob!.year)
          : 30,
      'gender': patient.gender,
      'address': '',
      'emergency_contact': null,
      'insurance_provider': null,
      'insurance_number': null,
      'allergies': null,
      'chronic_diseases': null,
      'marital_status': null,
    };
    await _supabase.from('patients').upsert(patientPayload);

    return patient;
  }

  @override
  Future<UserModel> updatePatient(UserModel patient) async {
    // 1. Update users table
    final userPayload = {
      'id': patient.id,
      'email': patient.email,
      'name': patient.fullName,
      'phone': patient.phone,
      'profile_completed': true,
      'onboarding_step': 3,
      'status': patient.status,
      'first_name': patient.firstName,
      'last_name': patient.lastName,
      'profile_photo': patient.profilePhoto,
    };
    await _supabase.from('users').update(userPayload).eq('id', patient.id);

    // 2. Update patients table
    final patientPayload = {
      'id': patient.id,
      'blood_group': patient.bloodGroup,
      'date_of_birth': patient.dob?.toIso8601String(),
      'age': patient.dob != null
          ? (DateTime.now().year - patient.dob!.year)
          : 30,
      'gender': patient.gender,
      'address': '',
      'emergency_contact': null,
      'insurance_provider': null,
      'insurance_number': null,
      'allergies': null,
      'chronic_diseases': null,
      'marital_status': null,
      'patient_id': patient.id,
    };
    await _supabase.from('patients').upsert(patientPayload);

    return patient;
  }

  @override
  Future<void> deletePatient(String patientId) async {
    await _supabase
        .from('users')
        .update({'deleted_at': DateTime.now().toIso8601String()})
        .eq('id', patientId);
  }

  @override
  Future<void> sendToMRD(Map<String, dynamic> record) async {
    await _supabase.from('emr_records').insert(record);
  }
}
