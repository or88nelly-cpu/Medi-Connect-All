import 'package:supabase/supabase.dart';

void main() async {
  final client = SupabaseClient(
    'https://ldxsdyvmfayxuaczmtuu.supabase.co',
    'sb_publishable_AHQA5xSNUg0vwHTGbdskHA_n6MD9Qdz',
  );

  try {
    print('Querying appointments...');
    final appts = await client.from('appointments').select().limit(5);
    for (var apt in appts) {
      print('Apt:');
      print(' - ID: ${apt['id']}');
      print(' - doctor_id: ${apt['doctor_id']}');
      print(' - doctor_name: ${apt['doctor_name']}');
    }
  } catch (e) {
    print('Error: $e');
  }
}
