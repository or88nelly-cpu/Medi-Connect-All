import 'package:medi_connect/core/network/supabase_service.dart';

abstract class BookingRemoteDataSource {
  Future<List<dynamic>> getDoctorsBySpecialty(
    String specialityId,
    String specialityName,
  );
  Future<List<dynamic>> getDoctorAvailability(String doctorId);
  Future<void> saveDoctorAvailability(
    List<Map<String, dynamic>> availabilityList,
  );
  Future<List<dynamic>> getBookedAppointments(String doctorId, String dateStr);
  Future<void> saveAppointment(Map<String, dynamic> data);
}

class BookingRemoteDataSourceImpl implements BookingRemoteDataSource {
  final SupabaseService _supabase;

  BookingRemoteDataSourceImpl(this._supabase);

  @override
  Future<List<dynamic>> getDoctorsBySpecialty(
    String specialityId,
    String specialityName,
  ) async {
    final response = await _supabase.client
        .from('users')
        .select('*, employees(*, doctors!doctors_employee_id_fkey(*))')
        .eq('role', 'Doctor');
    return response as List<dynamic>? ?? [];
  }

  @override
  Future<List<dynamic>> getDoctorAvailability(String doctorId) async {
    final response = await _supabase.client
        .from('doctor_availability')
        .select()
        .eq('doctor_id', doctorId);
    return response as List<dynamic>? ?? [];
  }

  @override
  Future<void> saveDoctorAvailability(
    List<Map<String, dynamic>> availabilityList,
  ) async {
    await _supabase.client.from('doctor_availability').insert(availabilityList);
  }

  @override
  Future<List<dynamic>> getBookedAppointments(
    String doctorId,
    String dateStr,
  ) async {
    final response = await _supabase.client
        .from('appointments')
        .select('appointment_time')
        .eq('doctor_id', doctorId)
        .eq('appointment_date', dateStr)
        .neq('status', 'Cancelled');
    return response as List<dynamic>? ?? [];
  }

  @override
  Future<void> saveAppointment(Map<String, dynamic> data) async {
    await _supabase.client.from('appointments').insert(data);
  }
}
