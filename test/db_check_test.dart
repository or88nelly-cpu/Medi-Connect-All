import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

void main() async {
  final client = SupabaseClient(
    'https://ldxsdyvmfayxuaczmtuu.supabase.co',
    'sb_publishable_AHQA5xSNUg0vwHTGbdskHA_n6MD9Qdz',
  );

  final payload = <String, dynamic>{};
  const uuid = Uuid();
  
  payload['id'] = uuid.v4();

  print('Starting column discovery loop...');
  for (int i = 0; i < 20; i++) {
    try {
      print('Trying payload: $payload');
      final inserted = await client.from('appointments').insert(payload).select();
      print('\nSUCCESS! Found all required columns.');
      print('Inserted record columns: ${inserted.first}');
      
      // Cleanup
      await client.from('appointments').delete().eq('id', payload['id']);
      break;
    } catch (e) {
      final errStr = e.toString();
      print('Failed: $errStr');
      if (errStr.contains('violates not-null constraint')) {
        final match = RegExp(r'column "([^"]+)"').firstMatch(errStr);
        if (match != null) {
          final columnName = match.group(1)!;
          print('Discovered required column: $columnName');
          
          if (columnName.contains('id') || columnName == 'patient_id' || columnName == 'doctor_id' || columnName == 'section_id') {
            payload[columnName] = uuid.v4();
          } else if (columnName.contains('time') || columnName == 'slot' || columnName == 'date') {
            payload[columnName] = '10:30 AM';
          } else if (columnName == 'status') {
            payload[columnName] = 'Confirmed';
          } else if (columnName == 'type') {
            payload[columnName] = 'Consultation';
          } else if (columnName == 'amount') {
            payload[columnName] = 100.00;
          } else {
            payload[columnName] = 'test';
          }
        } else {
          print('Could not parse column name from error.');
          break;
        }
      } else {
        print('Encountered non-not-null error, stopping.');
        break;
      }
    }
  }
}
