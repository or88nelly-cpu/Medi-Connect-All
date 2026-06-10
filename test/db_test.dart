import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:medi_connect/core/env_config.dart';
import 'dart:math';

void main() {
  test('Insert and Discover columns of appointments table', () async {
    // Initialize Supabase.
    await Supabase.initialize(
      url: EnvConfig.apiUrl,
      publishableKey: EnvConfig.apiKey,
      authOptions: const FlutterAuthClientOptions(
        localStorage: EmptyLocalStorage(),
      ),
    );
    
    final client = Supabase.instance.client;
    
    String generateUUID() {
      final random = Random();
      String hex(int length) {
        return List.generate(length, (_) => random.nextInt(16).toRadixString(16)).join();
      }
      return '${hex(8)}-${hex(4)}-4${hex(3)}-${(random.nextInt(4) + 8).toRadixString(16)}${hex(3)}-${hex(12)}';
    }
    
    try {
      final newId = generateUUID();
      final res = await client.from('appointments').insert({
        'id': newId,
        'name': 'Test Appointment Name',
      }).select();
      print('Inserted Appointment Result: $res');
      
      // Clean up the inserted test appointment
      await client.from('appointments').delete().eq('id', newId);
    } catch (e) {
      print('Error inserting appointment: $e');
    }
  });
}
