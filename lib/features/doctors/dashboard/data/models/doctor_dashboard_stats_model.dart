import 'package:medi_connect/features/doctors/dashboard/domain/entities/doctor_dashboard_stats.dart';

class DoctorDashboardStatsModel extends DoctorDashboardStats {
  const DoctorDashboardStatsModel({
    required super.opCount,
    required super.ipCount,
    required super.opProceduresCount,
    required super.ipProceduresCount,
    required super.surgeryCount,
    required super.medicalCertificatesCount,
    required super.pendingMrdCount,
    required super.availableSlotsCount,
  });
}
