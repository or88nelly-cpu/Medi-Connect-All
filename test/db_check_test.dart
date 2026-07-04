import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

void main() {
  test('Insert test into doctor_availability', () async {
    final client = SupabaseClient(
      'https://ldxsdyvmfayxuaczmtuu.supabase.co',
      'sb_publishable_AHQA5xSNUg0vwHTGbdskHA_n6MD9Qdz',
    );

    try {
      final payload = {
        'id': const Uuid().v4(),
        'doctor_id': const Uuid().v4(), // random UUID
        'day_of_week': 1,
        'start_time': '09:00',
        'end_time': '13:00',
        'is_available': true,
      };
      print(
        'Attempting insert with UUID doctor_id and integer day_of_week: $payload',
      );
      final response = await client
          .from('doctor_availability')
          .insert(payload)
          .select();
      print('SUCCESS! Inserted: $response');
    } catch (e) {
      print('Failed: $e');
    }
  });
}
