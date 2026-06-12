import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';

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
    final query = _supabase.from('users').select().isFilter('deleted_at', null);
    final response = await (departmentName.isNotEmpty && departmentName != 'All'
        ? query.eq('department', departmentName)
        : query);

    var list = (response as List<dynamic>)
        .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
        .toList();

    // Seeding logic for a robust enterprise-ready app
    if (list.isEmpty) {
      if (departmentName == 'Human Resource') {
        final hrStaff = _getHRSeedData();
        for (final u in hrStaff) {
          final payload = u.toJson();
          payload['profile_completion_status'] = true;
          payload['status'] = 'Active';
          try {
            await _supabase.from('users').insert(payload);
          } catch (_) {}
        }
        final req = await _supabase.from('users').select().isFilter('deleted_at', null).eq('department', 'Human Resource');
        list = (req as List<dynamic>)
            .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else if (departmentName == 'Cardiology' ||
                 departmentName == 'Neurology' ||
                 departmentName == 'Pediatrics' ||
                 departmentName == 'All') {
        final docQuery = await _supabase.from('users').select().isFilter('deleted_at', null).eq('role', 'doctor');
        final existingDocs = (docQuery as List<dynamic>)
            .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
            .toList();
        if (existingDocs.isEmpty) {
          final seedDocs = _getDoctorSeedData();
          for (final doc in seedDocs) {
            final payload = doc.toJson();
            payload['profile_completion_status'] = true;
            payload['status'] = 'Available';
            try {
              await _supabase.from('users').insert(payload);
            } catch (_) {}
          }
          final req = await (departmentName.isNotEmpty && departmentName != 'All'
              ? _supabase.from('users').select().isFilter('deleted_at', null).eq('department', departmentName)
              : _supabase.from('users').select().isFilter('deleted_at', null));
          list = (req as List<dynamic>)
              .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
              .toList();
        }
      }
    }

    if (departmentName.isEmpty || departmentName == 'All') {
      return list.where((u) => u.role == 'doctor' || u.role == 'staff').toList();
    }
    return list;
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

  List<UserModel> _getHRSeedData() {
    return [
      const UserModel(
        id: 'hr-seed-1',
        name: 'John Smith',
        staffRole: 'HR Manager',
        department: 'Human Resource',
        email: 'john.smith@hospital.com',
        status: 'Active',
        gender: 'male',
        role: 'staff',
        metadata: {'sub_department': 'Management'},
      ),
      const UserModel(
        id: 'hr-seed-2',
        name: 'Emily Johnson',
        staffRole: 'HR Executive',
        department: 'Human Resource',
        email: 'emily.j@hospital.com',
        status: 'Active',
        gender: 'female',
        role: 'staff',
        metadata: {'sub_department': 'Recruitment'},
      ),
      const UserModel(
        id: 'hr-seed-3',
        name: 'Michael Brown',
        staffRole: 'Payroll Specialist',
        department: 'Human Resource',
        email: 'michael.b@hospital.com',
        status: 'Active',
        gender: 'male',
        role: 'staff',
        metadata: {'sub_department': 'Payroll'},
      ),
      const UserModel(
        id: 'hr-seed-4',
        name: 'Sophia Williams',
        staffRole: 'HR Generalist',
        department: 'Human Resource',
        email: 'sophia.w@hospital.com',
        status: 'Active',
        gender: 'female',
        role: 'staff',
        metadata: {'sub_department': 'Employee Relations'},
      ),
      const UserModel(
        id: 'hr-seed-5',
        name: 'David Miller',
        staffRole: 'Training Coordinator',
        department: 'Human Resource',
        email: 'david.m@hospital.com',
        status: 'Away',
        gender: 'male',
        role: 'staff',
        metadata: {'sub_department': 'Training & Development'},
      ),
      const UserModel(
        id: 'hr-seed-6',
        name: 'Olivia Jones',
        staffRole: 'Recruitment Specialist',
        department: 'Human Resource',
        email: 'olivia.j@hospital.com',
        status: 'Active',
        gender: 'female',
        role: 'staff',
        metadata: {'sub_department': 'Recruitment'},
      ),
      const UserModel(
        id: 'hr-seed-7',
        name: 'James Davis',
        staffRole: 'HR Assistant',
        department: 'Human Resource',
        email: 'james.d@hospital.com',
        status: 'Active',
        gender: 'male',
        role: 'staff',
        metadata: {'sub_department': 'HR Operations'},
      ),
      const UserModel(
        id: 'hr-seed-8',
        name: 'Isabella Garcia',
        staffRole: 'Benefits Specialist',
        department: 'Human Resource',
        email: 'isabella.g@hospital.com',
        status: 'Active',
        gender: 'female',
        role: 'staff',
        metadata: {'sub_department': 'Payroll & Benefits'},
      ),
      const UserModel(
        id: 'hr-seed-9',
        name: 'Robert Martinez',
        staffRole: 'Training Specialist',
        department: 'Human Resource',
        email: 'robert.m@hospital.com',
        status: 'Inactive',
        gender: 'male',
        role: 'staff',
        metadata: {'sub_department': 'Training & Development'},
      ),
      const UserModel(
        id: 'hr-seed-10',
        name: 'Mia Rodriguez',
        staffRole: 'HR Generalist',
        department: 'Human Resource',
        email: 'mia.r@hospital.com',
        status: 'Active',
        gender: 'female',
        role: 'staff',
        metadata: {'sub_department': 'Employee Relations'},
      ),
      const UserModel(
        id: 'hr-seed-11',
        name: 'William Wilson',
        staffRole: 'HR Manager (Compensation)',
        department: 'Human Resource',
        email: 'william.w@hospital.com',
        status: 'Active',
        gender: 'male',
        role: 'staff',
        metadata: {'sub_department': 'Management'},
      ),
      const UserModel(
        id: 'hr-seed-12',
        name: 'Abigail Anderson',
        staffRole: 'Talent Acquisition Partner',
        department: 'Human Resource',
        email: 'abigail.a@hospital.com',
        status: 'Away',
        gender: 'female',
        role: 'staff',
        metadata: {'sub_department': 'Recruitment'},
      ),
      const UserModel(
        id: 'hr-seed-13',
        name: 'Joseph Thomas',
        staffRole: 'HR Specialist',
        department: 'Human Resource',
        email: 'joseph.t@hospital.com',
        status: 'Active',
        gender: 'male',
        role: 'staff',
        metadata: {'sub_department': 'HR Operations'},
      ),
      const UserModel(
        id: 'hr-seed-14',
        name: 'Elizabeth Taylor',
        staffRole: 'Payroll Coordinator',
        department: 'Human Resource',
        email: 'elizabeth.t@hospital.com',
        status: 'Active',
        gender: 'female',
        role: 'staff',
        metadata: {'sub_department': 'Payroll'},
      ),
      const UserModel(
        id: 'hr-seed-15',
        name: 'Charles Moore',
        staffRole: 'Onboarding Coordinator',
        department: 'Human Resource',
        email: 'charles.m@hospital.com',
        status: 'Active',
        gender: 'male',
        role: 'staff',
        metadata: {'sub_department': 'Recruitment'},
      ),
      const UserModel(
        id: 'hr-seed-16',
        name: 'Margaret Jackson',
        staffRole: 'Employee Relations Specialist',
        department: 'Human Resource',
        email: 'margaret.j@hospital.com',
        status: 'Active',
        gender: 'female',
        role: 'staff',
        metadata: {'sub_department': 'Employee Relations'},
      ),
      const UserModel(
        id: 'hr-seed-17',
        name: 'Richard Martin',
        staffRole: 'HR Systems Analyst',
        department: 'Human Resource',
        email: 'richard.m@hospital.com',
        status: 'Active',
        gender: 'male',
        role: 'staff',
        metadata: {'sub_department': 'HR Operations'},
      ),
      const UserModel(
        id: 'hr-seed-18',
        name: 'Dorothy Lee',
        staffRole: 'Compliance Officer',
        department: 'Human Resource',
        email: 'dorothy.l@hospital.com',
        status: 'Active',
        gender: 'female',
        role: 'staff',
        metadata: {'sub_department': 'Legal & Compliance'},
      ),
    ];
  }

  List<UserModel> _getDoctorSeedData() {
    return [
      const UserModel(
        id: 'doc-seed-1',
        email: 'sarah.j@mediconnect.com',
        name: 'Dr. Sarah Johnson',
        role: 'doctor',
        specialization: 'Cardiologist',
        department: 'Cardiology',
        consultationFee: 1200.0,
        experience: 12,
        gender: 'Female',
        status: 'Available',
      ),
      const UserModel(
        id: 'doc-seed-2',
        email: 'michael.c@mediconnect.com',
        name: 'Dr. Michael Chen',
        role: 'doctor',
        specialization: 'Neurologist',
        department: 'Neurology',
        consultationFee: 1500.0,
        experience: 9,
        gender: 'Male',
        status: 'Available',
      ),
      const UserModel(
        id: 'doc-seed-3',
        email: 'james.w@mediconnect.com',
        name: 'Dr. James Wilson',
        role: 'doctor',
        specialization: 'Pediatrician',
        department: 'Pediatrics',
        consultationFee: 1000.0,
        experience: 15,
        gender: 'Male',
        status: 'Available',
      ),
    ];
  }
}

