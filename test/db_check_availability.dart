import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

void main() {
  test('Reverse engineer doctor_availability columns directly', () async {
    final client = SupabaseClient(
      'https://ldxsdyvmfayxuaczmtuu.supabase.co',
      'sb_publishable_AHQA5xSNUg0vwHTGbdskHA_n6MD9Qdz',
    );

    final payload = <String, dynamic>{};
    const uuid = Uuid();
    
    // We try to find out what columns exist by trying to insert a dummy record
    try {
      print('Trying empty insert into doctor_availability...');
      final res = await client.from('doctor_availability').insert(payload).select();
      print('Insert success: $res');
    } catch (e) {
      print('Insert empty failed: $e');
    }

    // Let's try with doctor_id
    try {
      final docId = uuid.v4();
      print('Trying insert with doctor_id: $docId...');
      final res = await client.from('doctor_availability').insert({
        'doctor_id': docId,
      }).select();
      print('Insert with doctor_id success: $res');
    } catch (e) {
      print('Insert with doctor_id failed: $e');
    }
  });
}
