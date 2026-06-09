/// Remote data source for analytics.
import 'package:medi_connect/core/common_models/exceptions/exceptions.dart';
import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/features/dash_board/data/models/analytics_model.dart';

abstract class AnalyticsRemoteDataSource {
  Future<List<AnalyticsModel>> getAnalyticsList();
  Future<Map<String, dynamic>> getDashboardStats();
  Future<List<Map<String, dynamic>>> getAuditLogs();
}

class AnalyticsRemoteDataSourceImpl implements AnalyticsRemoteDataSource {
  final SupabaseService _supabase;

  AnalyticsRemoteDataSourceImpl(this._supabase);

  @override
  Future<List<AnalyticsModel>> getAnalyticsList() async {
    try {
      final response = await _supabase.from('analytics').select();
      final list = response as List<dynamic>? ?? [];
      return list
          .map((item) => AnalyticsModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final docsRes = await _supabase
          .from('users')
          .select('id')
          .eq('role', 'doctor')
          .isFilter('deleted_at', null);
      final staffRes = await _supabase
          .from('users')
          .select('id')
          .eq('role', 'staff')
          .isFilter('deleted_at', null);
      final patientsRes = await _supabase
          .from('users')
          .select('id')
          .eq('role', 'patient')
          .isFilter('deleted_at', null);
      final apptsRes = await _supabase.from('appointments').select('id');
      final videosRes = await _supabase.from('video_consultation').select('id');
      final paymentsRes = await _supabase.from('payments').select('id');

      final totalDoctors = (docsRes as List).length;
      final totalStaff = (staffRes as List).length;
      final totalPatients = (patientsRes as List).length;
      final todayAppointments = (apptsRes as List).length;
      final onlineConsultations = (videosRes as List).length;
      final paymentsCount = (paymentsRes as List).length;
      final totalRevenue = paymentsCount * 150.0; // Simulated $150 per payment

      // Department stats
      final deptStats = [
        {
          'department': 'General Medicine',
          'count': (totalDoctors * 0.4).round() + 2,
        },
        {'department': 'Cardiology', 'count': (totalDoctors * 0.2).round() + 1},
        {'department': 'Neurology', 'count': (totalDoctors * 0.2).round() + 1},
        {
          'department': 'Orthopedics',
          'count': (totalDoctors * 0.1).round() + 1,
        },
        {'department': 'Pediatrics', 'count': (totalDoctors * 0.1).round() + 1},
      ];

      return {
        'totalDoctors': totalDoctors,
        'totalStaff': totalStaff,
        'totalPatients': totalPatients,
        'todayAppointments': todayAppointments,
        'onlineConsultations': onlineConsultations,
        'totalRevenue': totalRevenue,
        'departmentStats': deptStats,
      };
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAuditLogs() async {
    try {
      final response = await _supabase
          .from('audit_logs')
          .select('*, users!performed_by(name)')
          .order('created_at', ascending: false)
          .limit(100);
      return (response as List).map((e) => e as Map<String, dynamic>).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
