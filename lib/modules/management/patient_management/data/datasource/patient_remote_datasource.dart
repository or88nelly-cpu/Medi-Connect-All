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
      
      // Map DB snake_case fields back to CamelCase keys for UserModel compatibility
      if (userJson.containsKey('patient_id')) {
        userJson['patientId'] = userJson['patient_id'];
      }
      if (userJson.containsKey('phone')) {
        userJson['phoneNumber'] = userJson['phone'];
      }
      if (userJson.containsKey('profile_photo')) {
        userJson['profileImage'] = userJson['profile_photo'];
      }
      if (userJson.containsKey('profile_image')) {
        userJson['profileImage'] = userJson['profile_image'];
      }
      if (userJson.containsKey('profile_completed')) {
        userJson['profileCompletionStatus'] = userJson['profile_completed'];
      }
      if (userJson.containsKey('profile_completion_status')) {
        userJson['profileCompletionStatus'] = userJson['profile_completion_status'];
      }
      if (userJson.containsKey('onboarding_step')) {
        userJson['onboardingStep'] = userJson['onboarding_step'];
      }
      if (userJson.containsKey('date_of_birth')) {
        userJson['dateOfBirth'] = userJson['date_of_birth'];
      }
      if (userJson.containsKey('insurance_number')) {
        userJson['insuranceNumber'] = userJson['insurance_number'];
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
      'name': patient.name,
      'phone': patient.phoneNumber,
      'role': 'patient',
      'profile_completed': patient.profileCompletionStatus,
      'onboarding_step': patient.onboardingStep,
      'status': patient.status ?? 'Active',
      'first_name': patient.firstName,
      'last_name': patient.lastName,
      'profile_photo': patient.profileImage,
    };
    await _supabase.from('users').upsert(userPayload);

    // 2. Insert/upsert into patients table
    final patientPayload = {
      'id': patient.id,
      'patient_id': patient.patientId,
      'blood_group': patient.bloodGroup,
      'date_of_birth': patient.dateOfBirth,
      'age': patient.age,
      'gender': patient.gender,
      'address': patient.address,
      'emergency_contact': patient.emergencyContact,
      'insurance_provider': patient.insuranceProvider,
      'insurance_number': patient.insuranceNumber,
      'allergies': patient.allergies,
      'chronic_diseases': patient.chronicDiseases,
      'marital_status': patient.maritalStatus,
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
      'name': patient.name,
      'phone': patient.phoneNumber,
      'profile_completed': patient.profileCompletionStatus,
      'onboarding_step': patient.onboardingStep,
      'status': patient.status,
      'first_name': patient.firstName,
      'last_name': patient.lastName,
      'profile_photo': patient.profileImage,
    };
    await _supabase.from('users').update(userPayload).eq('id', patient.id);

    // 2. Update patients table
    final patientPayload = {
      'id': patient.id,
      'blood_group': patient.bloodGroup,
      'date_of_birth': patient.dateOfBirth,
      'age': patient.age,
      'gender': patient.gender,
      'address': patient.address,
      'emergency_contact': patient.emergencyContact,
      'insurance_provider': patient.insuranceProvider,
      'insurance_number': patient.insuranceNumber,
      'allergies': patient.allergies,
      'chronic_diseases': patient.chronicDiseases,
      'marital_status': patient.maritalStatus,
    };
    if (patient.patientId != null && patient.patientId!.isNotEmpty) {
      patientPayload['patient_id'] = patient.patientId;
    }
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
