import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/features/department/data/models/department_model.dart';

const _kTable = 'department_master';

/// Remote data source for the Department feature backed by Supabase.
abstract class DepartmentRemoteDataSource {
  Future<List<DepartmentModel>> getDepartments({
    required bool isConsultationDept,
  });
  Future<DepartmentModel> addDepartment({
    required String name,
    String? description,
    String? imageUrl,
  });
  Future<DepartmentModel> updateDepartment({
    required String id,
    required String name,
    String? description,
    String? imageUrl,
  });
  Future<void> deleteDepartment(String id);
}

class DepartmentRemoteDataSourceImpl implements DepartmentRemoteDataSource {
  final SupabaseService _supabase;

  DepartmentRemoteDataSourceImpl(this._supabase);

  @override
  Future<List<DepartmentModel>> getDepartments({
    required bool isConsultationDept,
  }) async {
    final response = await _supabase
        .from(_kTable)
        .select()
        .order('name', ascending: true);
    return (response as List<dynamic>)
        .map((json) => DepartmentModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<DepartmentModel> addDepartment({
    required String name,
    String? description,
    String? imageUrl,
  }) async {
    final response = await _supabase
        .from(_kTable)
        .insert({
          'name': name,
          'description': description,
          'image_url': imageUrl,
        })
        .select()
        .single();
    return DepartmentModel.fromJson(response);
  }

  @override
  Future<DepartmentModel> updateDepartment({
    required String id,
    required String name,
    String? description,
    String? imageUrl,
  }) async {
    final response = await _supabase
        .from(_kTable)
        .update({
          'name': name,
          'description': description,
          'image_url': imageUrl,
        })
        .eq('id', id)
        .select()
        .single();
    return DepartmentModel.fromJson(response);
  }

  @override
  Future<void> deleteDepartment(String id) async {
    await _supabase.from(_kTable).delete().eq('id', id);
  }
}
