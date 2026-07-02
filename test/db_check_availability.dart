import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

void main() {
  test('Auth and insert into doctor_availability', () async {
    final client = SupabaseClient(
      'https://ldxsdyvmfayxuaczmtuu.supabase.co',
      'sb_publishable_AHQA5xSNUg0vwHTGbdskHA_n6MD9Qdz',
    );

    final email = 'test_doc_${DateTime.now().millisecondsSinceEpoch}@example.com';
    const password = 'Password123!';

    try {
      print('Signing up test user: $email...');
      final authRes = await client.auth.signUp(email: email, password: password);
      final user = authRes.user;
      if (user == null) {
        print('Sign up failed: User is null');
        return;
      }
      print('Sign up success: ${user.id}');

      // Let's create users record as a doctor
      try {
        await client.from('users').insert({
          'id': user.id,
          'email': email,
          'role': 'Doctor',
          'first_name': 'Test',
          'last_name': 'Doctor',
          'status': 'Registered',
        });
        print('Created users record for doctor.');
      } catch (e) {
        print('Failed to create users record: $e');
      }

      // Now insert into doctor_availability
      final payload = <String, dynamic>{
        'doctor_id': user.id,
      };
      try {
        final res = await client.from('doctor_availability').insert(payload).select();
        print('Doctor availability insert success: $res');
      } catch (e) {
        print('Doctor availability insert failed: $e');
      }

      // Clean up user
      try {
        await client.from('users').delete().eq('id', user.id);
        print('Cleaned up users record.');
      } catch (_) {}
    } catch (e) {
      print('Outer error: $e');
    }
  });
}
