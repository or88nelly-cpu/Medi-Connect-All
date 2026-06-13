/// Remote data source for all admin operations modules.
/// Handles Supabase CRUD for pharmacy, labs, attendance, emergencies,
/// activity logs, invoices, and admin settings.
import 'package:medi_connect/core/common_models/exceptions/exceptions.dart';
import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/features/dash_board/data/models/pharmacy_item_model.dart';
import 'package:medi_connect/features/dash_board/data/models/lab_test_model.dart';
import 'package:medi_connect/features/dash_board/data/models/attendance_model.dart';
import 'package:medi_connect/features/dash_board/data/models/emergency_model.dart';
import 'package:medi_connect/features/dash_board/data/models/activity_log_model.dart';
import 'package:medi_connect/features/dash_board/data/models/invoice_model.dart';
import 'package:medi_connect/features/dash_board/data/models/appointment_model.dart';


// ─── Abstract Interface ─────────────────────────────────────────────────────

abstract class AdminOperationsRemoteDataSource {
  // Pharmacy
  Future<List<PharmacyItemModel>> getPharmacyItems();
  Future<PharmacyItemModel> addPharmacyItem(Map<String, dynamic> data);
  Future<void> updatePharmacyItem(String id, Map<String, dynamic> data);
  Future<void> deletePharmacyItem(String id);

  // Labs
  Future<List<LabTestModel>> getLabTests();
  Future<LabTestModel> addLabTest(Map<String, dynamic> data);
  Future<void> updateLabTestStatus(String id, String status);

  // Attendance
  Future<List<AttendanceModel>> getStaffAttendance({DateTime? date});
  Future<void> updateAttendanceStatus(String id, String status);

  // Emergencies
  Future<List<EmergencyModel>> getEmergencies();
  Future<EmergencyModel> triggerEmergency(Map<String, dynamic> data);
  Future<void> resolveEmergency(String id);

  // Activity Logs
  Future<List<ActivityLogModel>> getActivityLogs();

  // Billing / Invoices
  Future<List<InvoiceModel>> getInvoices();
  Future<Map<String, double>> getBillingSummary();

  // Settings
  Future<Map<String, dynamic>> getAdminSettings();
  Future<void> updateAdminSetting(String key, dynamic value);

  // Appointments
  Future<List<AppointmentModel>> getAppointments();
  Future<AppointmentModel> createAppointment(Map<String, dynamic> data);
  Future<void> updateAppointmentStatus(String id, String status);
}

// ─── Implementation ─────────────────────────────────────────────────────────

class AdminOperationsRemoteDataSourceImpl
    implements AdminOperationsRemoteDataSource {
  final SupabaseService _supabase;

  AdminOperationsRemoteDataSourceImpl(this._supabase);

  // ─── Pharmacy ───────────────────────────────────────────────────────────

  @override
  Future<List<PharmacyItemModel>> getPharmacyItems() async {
    try {
      final response = await _supabase
          .from('pharmacy_inventory')
          .select()
          .order('name', ascending: true);
      final list = response as List<dynamic>? ?? [];
      if (list.isEmpty) {
        await _seedPharmacyData();
        final seeded = await _supabase
            .from('pharmacy_inventory')
            .select()
            .order('name', ascending: true);
        return (seeded as List)
            .map((e) => PharmacyItemModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return list
          .map((e) => PharmacyItemModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<PharmacyItemModel> addPharmacyItem(Map<String, dynamic> data) async {
    try {
      final response = await _supabase
          .from('pharmacy_inventory')
          .insert(data)
          .select()
          .single();
      return PharmacyItemModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updatePharmacyItem(String id, Map<String, dynamic> data) async {
    try {
      await _supabase.from('pharmacy_inventory').update(data).eq('id', id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> deletePharmacyItem(String id) async {
    try {
      await _supabase.from('pharmacy_inventory').delete().eq('id', id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> _seedPharmacyData() async {
    final seedItems = [
      {'name': 'Paracetamol 500mg', 'stock': 120, 'category': 'Analgesic'},
      {'name': 'Amoxicillin 250mg', 'stock': 8, 'category': 'Antibiotic'},
      {'name': 'Ibuprofen 400mg', 'stock': 45, 'category': 'Analgesic'},
      {'name': 'Metformin 850mg', 'stock': 0, 'category': 'Antidiabetic'},
      {'name': 'Atorvastatin 10mg', 'stock': 3, 'category': 'Antihypertensive'},
      {'name': 'Omeprazole 20mg', 'stock': 230, 'category': 'Antacid'},
    ];
    try {
      await _supabase.from('pharmacy_inventory').insert(seedItems);
    } catch (_) {
      // Seed failure is non-critical
    }
  }

  // ─── Labs ───────────────────────────────────────────────────────────────

  @override
  Future<List<LabTestModel>> getLabTests() async {
    try {
      final response = await _supabase
          .from('lab_records')
          .select()
          .order('created_at', ascending: false);
      final list = response as List<dynamic>? ?? [];
      if (list.isEmpty) {
        await _seedLabData();
        final seeded = await _supabase
            .from('lab_records')
            .select()
            .order('created_at', ascending: false);
        return (seeded as List)
            .map((e) => LabTestModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return list
          .map((e) => LabTestModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<LabTestModel> addLabTest(Map<String, dynamic> data) async {
    try {
      final response = await _supabase
          .from('lab_records')
          .insert(data)
          .select()
          .single();
      return LabTestModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateLabTestStatus(String id, String status) async {
    try {
      await _supabase
          .from('lab_records')
          .update({'status': status})
          .eq('id', id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> _seedLabData() async {
    final seedData = [
      {
        'patient_name': 'John Doe',
        'test_name': 'Lipid Profile',
        'status': 'Completed',
        'priority': 'Normal',
      },
      {
        'patient_name': 'Alice Smith',
        'test_name': 'CBC & Hemoglobin',
        'status': 'Pending',
        'priority': 'High',
      },
      {
        'patient_name': 'Robert Johnson',
        'test_name': 'Thyroid Panel (T3, T4, TSH)',
        'status': 'Completed',
        'priority': 'Normal',
      },
      {
        'patient_name': 'Emily Davis',
        'test_name': 'Blood Sugar Fasting',
        'status': 'Pending',
        'priority': 'Critical',
      },
      {
        'patient_name': 'David Miller',
        'test_name': 'Kidney Function Test',
        'status': 'Completed',
        'priority': 'Normal',
      },
    ];
    try {
      await _supabase.from('lab_records').insert(seedData);
    } catch (_) {}
  }

  // ─── Attendance ─────────────────────────────────────────────────────────

  @override
  Future<List<AttendanceModel>> getStaffAttendance({DateTime? date}) async {
    try {
      final targetDate = date ?? DateTime.now();
      final dateStr = targetDate.toIso8601String().split('T').first;
      final response = await _supabase
          .from('staff_attendance')
          .select()
          .eq('date', dateStr)
          .order('staff_name', ascending: true);
      final list = response as List<dynamic>? ?? [];
      if (list.isEmpty) {
        await _seedAttendanceData(dateStr);
        final seeded = await _supabase
            .from('staff_attendance')
            .select()
            .eq('date', dateStr)
            .order('staff_name', ascending: true);
        return (seeded as List)
            .map((e) => AttendanceModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return list
          .map((e) => AttendanceModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateAttendanceStatus(String id, String status) async {
    try {
      final updateData = <String, dynamic>{'status': status};
      if (status == 'Present') {
        final now = DateTime.now();
        updateData['check_in_time'] =
            '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      }
      await _supabase.from('staff_attendance').update(updateData).eq('id', id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> _seedAttendanceData(String dateStr) async {
    try {
      final usersResponse = await _supabase
          .from('users')
          .select()
          .eq('role', 'staff');
      final list = usersResponse as List<dynamic>? ?? [];
      
      if (list.isNotEmpty) {
        final seedData = list.map((u) {
          final user = u as Map<String, dynamic>;
          final name = user['name'] as String? ??
              (user['first_name'] != null
                  ? "${user['first_name']} ${user['last_name'] ?? ''}".trim()
                  : 'Staff Member');
          final role = user['staff_role'] as String? ?? user['department'] as String? ?? 'Staff';
          final hash = name.hashCode;
          String status = 'Absent';
          String? checkIn;
          if (hash % 3 == 0) {
            status = 'Present';
            checkIn = '08:00';
          } else if (hash % 3 == 1) {
            status = 'On Leave';
          }
          return {
            'staff_id': user['id'],
            'staff_name': name,
            'role': role,
            'status': status,
            'check_in_time': checkIn,
            'date': dateStr,
          };
        }).toList();
        
        await _supabase.from('staff_attendance').insert(seedData);
        return;
      }
    } catch (_) {
      // Fallback below
    }

    final seedData = [
      {
        'staff_name': 'Nurse Emma Watson',
        'role': 'General Nurse',
        'status': 'Present',
        'check_in_time': '08:00',
        'date': dateStr,
      },
      {
        'staff_name': 'Nurse Clara Oswald',
        'role': 'ICU Nurse',
        'status': 'Present',
        'check_in_time': '07:45',
        'date': dateStr,
      },
      {
        'staff_name': 'Thomas Shelby',
        'role': 'Lab Technician',
        'status': 'On Leave',
        'date': dateStr,
      },
      {
        'staff_name': 'Sherlock Holmes',
        'role': 'Pharmacist',
        'status': 'Present',
        'check_in_time': '08:15',
        'date': dateStr,
      },
      {
        'staff_name': 'John Watson',
        'role': 'Assistant Pharmacist',
        'status': 'Absent',
        'date': dateStr,
      },
      {
        'staff_name': 'Rose Tyler',
        'role': 'Receptionist',
        'status': 'Present',
        'check_in_time': '08:00',
        'date': dateStr,
      },
    ];
    try {
      await _supabase.from('staff_attendance').insert(seedData);
    } catch (_) {}
  }

  // ─── Emergencies ────────────────────────────────────────────────────────

  @override
  Future<List<EmergencyModel>> getEmergencies() async {
    try {
      final response = await _supabase
          .from('emergency_alerts')
          .select()
          .eq('is_resolved', false)
          .order('created_at', ascending: false);
      final list = response as List<dynamic>? ?? [];
      if (list.isEmpty) {
        await _seedEmergencyData();
        final seeded = await _supabase
            .from('emergency_alerts')
            .select()
            .eq('is_resolved', false)
            .order('created_at', ascending: false);
        return (seeded as List)
            .map((e) => EmergencyModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return list
          .map((e) => EmergencyModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<EmergencyModel> triggerEmergency(Map<String, dynamic> data) async {
    try {
      final response = await _supabase
          .from('emergency_alerts')
          .insert(data)
          .select()
          .single();
      return EmergencyModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> resolveEmergency(String id) async {
    try {
      await _supabase
          .from('emergency_alerts')
          .update({'is_resolved': true})
          .eq('id', id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> _seedEmergencyData() async {
    final seedData = [
      {
        'message': 'Code Blue in Emergency Ward - Room 108',
        'level': 'Critical',
        'is_resolved': false,
      },
      {
        'message': 'Intense Patient Influx in ICU - Staff assistance requested',
        'level': 'High',
        'is_resolved': false,
      },
      {
        'message':
            'Power Generator Failure - Emergency Backup Active in Block B',
        'level': 'High',
        'is_resolved': false,
      },
      {
        'message': 'Ambulance Out of Service - Unit AMB-04 reported flat tire',
        'level': 'Medium',
        'is_resolved': false,
      },
    ];
    try {
      await _supabase.from('emergency_alerts').insert(seedData);
    } catch (_) {}
  }

  // ─── Activity Logs ──────────────────────────────────────────────────────

  @override
  Future<List<ActivityLogModel>> getActivityLogs() async {
    try {
      final response = await _supabase
          .from('activity_logs')
          .select()
          .order('created_at', ascending: false)
          .limit(50);
      final list = response as List<dynamic>? ?? [];
      if (list.isEmpty) {
        await _seedActivityLogs();
        final seeded = await _supabase
            .from('activity_logs')
            .select()
            .order('created_at', ascending: false)
            .limit(50);
        return (seeded as List)
            .map((e) => ActivityLogModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return list
          .map((e) => ActivityLogModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> _seedActivityLogs() async {
    final seedData = [
      {
        'message': 'Dr. Sarah Chen updated patient medical record',
        'category': 'Record',
      },
      {'message': 'New patient registered: John Doe', 'category': 'Patient'},
      {
        'message': 'Lab report uploaded for Cardiology department',
        'category': 'Lab',
      },
      {
        'message': 'Appointment booked with Dr. Sarah Chen',
        'category': 'Appointment',
      },
      {
        'message': 'Inventory reordered: Amoxicillin (50 units)',
        'category': 'Pharmacy',
      },
      {
        'message': 'Doctor schedule updated: Dr. James Wilson',
        'category': 'Doctor',
      },
      {
        'message': 'Admin settings modified: Biometrics enabled',
        'category': 'System',
      },
    ];
    try {
      await _supabase.from('activity_logs').insert(seedData);
    } catch (_) {}
  }

  // ─── Billing / Invoices ─────────────────────────────────────────────────

  @override
  Future<List<InvoiceModel>> getInvoices() async {
    try {
      final response = await _supabase
          .from('invoices')
          .select()
          .order('created_at', ascending: false);
      final list = response as List<dynamic>? ?? [];
      if (list.isEmpty) {
        await _seedInvoiceData();
        final seeded = await _supabase
            .from('invoices')
            .select()
            .order('created_at', ascending: false);
        return (seeded as List)
            .map((e) => InvoiceModel.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return list
          .map((e) => InvoiceModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Map<String, double>> getBillingSummary() async {
    try {
      final response = await _supabase
          .from('invoices')
          .select('amount, status');
      final list = response as List<dynamic>? ?? [];
      double totalRevenue = 0.0;
      double pendingBills = 0.0;
      for (final item in list) {
        final map = item as Map<String, dynamic>;
        final amount = (map['amount'] as num?)?.toDouble() ?? 0.0;
        final status = map['status'] as String? ?? '';
        totalRevenue += amount;
        if (status == 'Pending') pendingBills += amount;
      }
      return {'totalRevenue': totalRevenue, 'pendingBills': pendingBills};
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> _seedInvoiceData() async {
    final seedData = [
      {
        'patient_name': 'John Doe',
        'amount': 1500.00,
        'status': 'Paid',
        'payment_method': 'UPI',
      },
      {
        'patient_name': 'Alice Smith',
        'amount': 800.00,
        'status': 'Pending',
        'payment_method': 'Card',
      },
      {
        'patient_name': 'Robert Johnson',
        'amount': 2400.00,
        'status': 'Paid',
        'payment_method': 'Cash',
      },
      {
        'patient_name': 'Emily Davis',
        'amount': 500.00,
        'status': 'Failed',
        'payment_method': 'Net Banking',
      },
    ];
    try {
      await _supabase.from('invoices').insert(seedData);
    } catch (_) {}
  }

  // ─── Settings ───────────────────────────────────────────────────────────

  @override
  Future<Map<String, dynamic>> getAdminSettings() async {
    try {
      final response = await _supabase.from('admin_settings').select();
      final list = response as List<dynamic>? ?? [];
      if (list.isEmpty) {
        await _seedDefaultSettings();
        final seeded = await _supabase.from('admin_settings').select();
        return _settingsListToMap(seeded as List);
      }
      return _settingsListToMap(list);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateAdminSetting(String key, dynamic value) async {
    try {
      await _supabase
          .from('admin_settings')
          .update({'value': value.toString()})
          .eq('key', key);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Map<String, dynamic> _settingsListToMap(List<dynamic> list) {
    final map = <String, dynamic>{};
    for (final item in list) {
      final row = item as Map<String, dynamic>;
      final key = row['key'] as String? ?? '';
      final value = row['value'] as String? ?? '';
      if (value == 'true' || value == 'false') {
        map[key] = value == 'true';
      } else {
        map[key] = value;
      }
    }
    return map;
  }

  Future<void> _seedDefaultSettings() async {
    final seedData = [
      {'key': 'push_notifications', 'value': 'true'},
      {'key': 'sms_alerts', 'value': 'false'},
      {'key': 'email_reports', 'value': 'true'},
      {'key': 'biometric_login', 'value': 'false'},
    ];
    try {
      await _supabase.from('admin_settings').insert(seedData);
    } catch (_) {}
  }

  // ─── Appointments ────────────────────────────────────────────────────────

  @override
  Future<List<AppointmentModel>> getAppointments() async {
    try {
      final response = await _supabase
          .from('appointments')
          .select()
          .order('created_at', ascending: false);
      final list = response as List<dynamic>? ?? [];
      return list
          .map((e) => AppointmentModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AppointmentModel> createAppointment(Map<String, dynamic> data) async {
    try {
      final response = await _supabase
          .from('appointments')
          .insert(data)
          .select()
          .single();
      return AppointmentModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateAppointmentStatus(String id, String status) async {
    try {
      await _supabase
          .from('appointments')
          .update({'status': status})
          .eq('id', id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
