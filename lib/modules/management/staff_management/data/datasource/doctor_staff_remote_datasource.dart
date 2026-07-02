import 'package:medi_connect/core/constants/app_enum.dart';
import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';

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
    final query = _supabase
        .from('users')
        .select('*, doctors(*), employees(*)')
        .isFilter('deleted_at', null);
    final response = await (departmentName.isNotEmpty && departmentName != 'All'
        ? query.eq('department', departmentName)
        : query);

    var list = (response as List<dynamic>).map((json) {
      final map = Map<String, dynamic>.from(json as Map);

      final docJson = map.remove('doctors');
      if (docJson is List && docJson.isNotEmpty) {
        map.addAll(docJson.first as Map<String, dynamic>);
      } else if (docJson is Map<String, dynamic>) {
        map.addAll(docJson);
      }

      final empJson = map.remove('employees');
      if (empJson is List && empJson.isNotEmpty) {
        map.addAll(empJson.first as Map<String, dynamic>);
      } else if (empJson is Map<String, dynamic>) {
        map.addAll(empJson);
      }

      // Map DB snake_case fields back to CamelCase keys for UserModel compatibility
      if (map.containsKey('phone')) map['phoneNumber'] = map['phone'];
      if (map.containsKey('profile_image'))
        map['profileImage'] = map['profile_image'];
      if (map.containsKey('profile_photo'))
        map['profileImage'] = map['profile_photo'];
      if (map.containsKey('profile_completion_status')) {
        map['profileCompletionStatus'] = map['profile_completion_status'];
      }
      if (map.containsKey('profile_completed')) {
        map['profileCompletionStatus'] = map['profile_completed'];
      }
      if (map.containsKey('onboarding_step')) {
        map['onboardingStep'] = map['onboarding_step'];
      }
      if (map.containsKey('medical_registration_number')) {
        map['medicalRegistrationNumber'] = map['medical_registration_number'];
      }
      if (map.containsKey('employee_id')) {
        map['employeeId'] = map['employee_id'];
      }
      if (map.containsKey('joining_date')) {
        map['joiningDate'] = map['joining_date'];
      }
      if (map.containsKey('staff_role')) {
        map['staffRole'] = map['staff_role'];
      }

      return UserModel.fromJson(map);
    }).toList();

    // Seeding logic for a robust enterprise-ready app
    if (list.isEmpty) {
      if (departmentName == 'Human Resource') {
        final hrStaff = _getHRSeedData();
        for (final u in hrStaff) {
          try {
            await createDoctorStaffMember(u);
          } catch (_) {}
        }
        final req = await _supabase
            .from('users')
            .select('*, doctors(*), employees(*)')
            .isFilter('deleted_at', null)
            .eq('department', 'Human Resource');
        list = (req as List<dynamic>).map((json) {
          final map = Map<String, dynamic>.from(json as Map);
          final docJson = map.remove('doctors');
          if (docJson is List && docJson.isNotEmpty)
            map.addAll(docJson.first as Map<String, dynamic>);
          final empJson = map.remove('employees');
          if (empJson is List && empJson.isNotEmpty)
            map.addAll(empJson.first as Map<String, dynamic>);

          if (map.containsKey('phone')) map['phoneNumber'] = map['phone'];
          if (map.containsKey('profile_image'))
            map['profileImage'] = map['profile_image'];
          if (map.containsKey('profile_completion_status'))
            map['profileCompletionStatus'] = map['profile_completion_status'];
          return UserModel.fromJson(map);
        }).toList();
      } else if (departmentName == 'Cardiology' ||
          departmentName == 'Neurology' ||
          departmentName == 'Pediatrics' ||
          departmentName == 'All') {
        final docQuery = await _supabase
            .from('users')
            .select()
            .isFilter('deleted_at', null)
            .eq('role', "Doctor");
        final existingDocs = (docQuery as List<dynamic>)
            .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
            .toList();
        if (existingDocs.isEmpty) {
          final seedDocs = _getDoctorSeedData();
          for (final doc in seedDocs) {
            try {
              await createDoctorStaffMember(doc);
            } catch (_) {}
          }
          final req =
              await (departmentName.isNotEmpty && departmentName != 'All'
                  ? _supabase
                        .from('users')
                        .select('*, doctors(*), employees(*)')
                        .isFilter('deleted_at', null)
                        .eq('department', departmentName)
                  : _supabase
                        .from('users')
                        .select('*, doctors(*), employees(*)')
                        .isFilter('deleted_at', null));
          list = (req as List<dynamic>).map((json) {
            final map = Map<String, dynamic>.from(json as Map);
            final docJson = map.remove('doctors');
            if (docJson is List && docJson.isNotEmpty)
              map.addAll(docJson.first as Map<String, dynamic>);
            final empJson = map.remove('employees');
            if (empJson is List && empJson.isNotEmpty)
              map.addAll(empJson.first as Map<String, dynamic>);

            if (map.containsKey('phone')) map['phoneNumber'] = map['phone'];
            if (map.containsKey('profile_image'))
              map['profileImage'] = map['profile_image'];
            if (map.containsKey('profile_completion_status'))
              map['profileCompletionStatus'] = map['profile_completion_status'];
            return UserModel.fromJson(map);
          }).toList();
        }
      }
    }

    if (departmentName.isEmpty || departmentName == 'All') {
      return list
          .where((u) => u.role == UserRole.doctor || u.role == UserRole.staff)
          .toList();
    }
    return list;
  }

  @override
  Future<UserModel> createDoctorStaffMember(UserModel user) async {
    final userPayload = {
      'id': user.id,
      'email': user.email,
      'name': user.fullName,
      'phone': user.phone,
      'role': user.role.value,
      'profile_completed': true,
      'status': 'Available',
      'department': 'General',
    };
    await _supabase.from('users').upsert(userPayload);

    if (user.role == UserRole.doctor) {
      final docPayload = {
        'id': user.id,
        'medical_registration_number': 'REG-${user.id.hashCode.abs()}',
        'experience': 5,
        'specialization': 'General Medicine',
        'consultation_fee': 500.0,
        'availability_status': 'Available',
      };
      await _supabase.from('doctors').upsert(docPayload);
    } else {
      final empPayload = {
        'id': user.id,
        'employee_id': 'EMP-${user.id.hashCode.abs()}',
        'joining_date': DateTime.now().toIso8601String().split('T').first,
        'department': 'Human Resource',
        'designation': 'Support Staff',
        'qualification': 'B.Sc',
        'staff_role': 'staff',
      };
      await _supabase.from('employees').upsert(empPayload);
    }

    return user;
  }

  @override
  Future<UserModel> updateDoctorStaffMember(UserModel user) async {
    final userPayload = {
      'id': user.id,
      'email': user.email,
      'name': user.fullName,
      'phone': user.phone,
      'role': user.role.value,
      'status': user.status ?? 'Available',
      'department': 'General',
      'profile_completed': true,
      'onboarding_step': 3,
    };
    await _supabase.from('users').update(userPayload).eq('id', user.id);

    if (user.role == UserRole.doctor) {
      final docPayload = {
        'id': user.id,
        'medical_registration_number': 'REG-${user.id.hashCode.abs()}',
        'experience': 5,
        'specialization': 'General Medicine',
        'consultation_fee': 500.0,
        'availability_status': user.status ?? 'Available',
      };
      await _supabase.from('doctors').upsert(docPayload);
    } else {
      final empPayload = {
        'id': user.id,
        'employee_id': 'EMP-${user.id.hashCode.abs()}',
        'joining_date': DateTime.now().toIso8601String().split('T').first,
        'department': 'Human Resource',
        'designation': 'Support Staff',
        'qualification': 'B.Sc',
        'staff_role': 'staff',
      };
      await _supabase.from('employees').upsert(empPayload);
    }

    return user;
  }

  @override
  Future<void> deleteDoctorStaffMember(String userId) async {
    // Soft delete user record by updating deleted_at timestamp
    await _supabase
        .from('users')
        .update({'deleted_at': DateTime.now().toIso8601String()})
        .eq('id', userId);
  }

  List<UserModel> _getHRSeedData() {
    return [
      const UserModel(
        id: 'hr-seed-1',
        firstName: 'John',
        lastName: 'Smith',
        email: 'john.smith@hospital.com',
        status: 'Active',
        gender: 'male',
        role: UserRole.staff,
      ),
      const UserModel(
        id: 'hr-seed-2',
        firstName: 'Emily',
        lastName: 'Johnson',
        email: 'emily.j@hospital.com',
        status: 'Active',
        gender: 'female',
        role: UserRole.staff,
      ),
      const UserModel(
        id: 'hr-seed-3',
        firstName: 'Michael',
        lastName: 'Brown',
        email: 'michael.b@hospital.com',
        status: 'Active',
        gender: 'male',
        role: UserRole.staff,
      ),
      const UserModel(
        id: 'hr-seed-4',
        firstName: 'Sophia',
        lastName: 'Williams',
        email: 'sophia.w@hospital.com',
        status: 'Active',
        gender: 'female',
        role: UserRole.staff,
      ),
      const UserModel(
        id: 'hr-seed-5',
        firstName: 'David',
        lastName: 'Miller',
        email: 'david.m@hospital.com',
        status: 'Away',
        gender: 'male',
        role: UserRole.staff,
      ),
      const UserModel(
        id: 'hr-seed-6',
        firstName: 'Olivia',
        lastName: 'Jones',
        email: 'olivia.j@hospital.com',
        status: 'Active',
        gender: 'female',
        role: UserRole.staff,
      ),
      const UserModel(
        id: 'hr-seed-7',
        firstName: 'James',
        lastName: 'Davis',
        email: 'james.d@hospital.com',
        status: 'Active',
        gender: 'male',
        role: UserRole.staff,
      ),
      const UserModel(
        id: 'hr-seed-8',
        firstName: 'Isabella',
        lastName: 'Garcia',
        email: 'isabella.g@hospital.com',
        status: 'Active',
        gender: 'female',
        role: UserRole.staff,
      ),
      const UserModel(
        id: 'hr-seed-9',
        firstName: 'Robert',
        lastName: 'Martinez',
        email: 'robert.m@hospital.com',
        status: 'Inactive',
        gender: 'male',
        role: UserRole.staff,
      ),
      const UserModel(
        id: 'hr-seed-10',
        firstName: 'Mia',
        lastName: 'Rodriguez',
        email: 'mia.r@hospital.com',
        status: 'Active',
        gender: 'female',
        role: UserRole.staff,
      ),
      const UserModel(
        id: 'hr-seed-11',
        firstName: 'William',
        lastName: 'Wilson',
        email: 'william.w@hospital.com',
        status: 'Active',
        gender: 'male',
        role: UserRole.staff,
      ),
      const UserModel(
        id: 'hr-seed-12',
        firstName: 'Abigail',
        lastName: 'Anderson',
        email: 'abigail.a@hospital.com',
        status: 'Away',
        gender: 'female',
        role: UserRole.staff,
      ),
      const UserModel(
        id: 'hr-seed-13',
        firstName: 'Joseph',
        lastName: 'Thomas',
        email: 'joseph.t@hospital.com',
        status: 'Active',
        gender: 'male',
        role: UserRole.staff,
      ),
      const UserModel(
        id: 'hr-seed-14',
        firstName: 'Elizabeth',
        lastName: 'Taylor',
        email: 'elizabeth.t@hospital.com',
        status: 'Active',
        gender: 'female',
        role: UserRole.staff,
      ),
      const UserModel(
        id: 'hr-seed-15',
        firstName: 'Charles',
        lastName: 'Moore',
        email: 'charles.m@hospital.com',
        status: 'Active',
        gender: 'male',
        role: UserRole.staff,
      ),
      const UserModel(
        id: 'hr-seed-16',
        firstName: 'Margaret',
        lastName: 'Jackson',
        email: 'margaret.j@hospital.com',
        status: 'Active',
        gender: 'female',
        role: UserRole.staff,
      ),
      const UserModel(
        id: 'hr-seed-17',
        firstName: 'Richard',
        lastName: 'Martin',
        email: 'richard.m@hospital.com',
        status: 'Active',
        gender: 'male',
        role: UserRole.staff,
      ),
      const UserModel(
        id: 'hr-seed-18',
        firstName: 'Dorothy',
        lastName: 'Lee',
        email: 'dorothy.l@hospital.com',
        status: 'Active',
        gender: 'female',
        role: UserRole.staff,
      ),
    ];
  }

  List<UserModel> _getDoctorSeedData() {
    return [
      const UserModel(
        id: 'doc-seed-1',
        email: 'sarah.j@mediconnect.com',
        firstName: 'Dr. Sarah',
        lastName: 'Johnson',
        role: UserRole.doctor,
        gender: 'Female',
        status: 'Available',
      ),
      const UserModel(
        id: 'doc-seed-2',
        email: 'michael.c@mediconnect.com',
        firstName: 'Dr. Michael',
        lastName: 'Chen',
        role: UserRole.doctor,
        gender: 'Male',
        status: 'Available',
      ),
      const UserModel(
        id: 'doc-seed-3',
        email: 'james.w@mediconnect.com',
        firstName: 'Dr. James',
        lastName: 'Wilson',
        role: UserRole.doctor,
        gender: 'Male',
        status: 'Available',
      ),
    ];
  }
}
