import 'package:supabase/supabase.dart';

void main() async {
  final client = SupabaseClient(
    'https://ldxsdyvmfayxuaczmtuu.supabase.co',
    'sb_publishable_AHQA5xSNUg0vwHTGbdskHA_n6MD9Qdz',
  );

  print('--- Supabase Diagnostic ---');

  try {
    final response = await client.from('doctors').select();
    print('Doctors count: ${response.length}');
    if (response.isNotEmpty) {
      print('Doctors columns: ${response.first.keys}');
      print('Doctors sample: ${response.take(2).toList()}');
    }
  } catch (e) {
    print('Doctors query failed: $e');
  }

  try {
    final response = await client.from('employees').select();
    print('Employees count: ${response.length}');
    if (response.isNotEmpty) {
      print('Employees columns: ${response.first.keys}');
      print('Employees sample: ${response.take(2).toList()}');
    }
  } catch (e) {
    print('Employees query failed: $e');
  }

  try {
    final response = await client.from('appointments').select();
    print('Appointments count: ${response.length}');
    if (response.isNotEmpty) {
      print('Appointments columns: ${response.first.keys}');
      print('Appointments sample: ${response.take(2).toList()}');
    }
  } catch (e) {
    print('Appointments query failed: $e');
  }
}
