import 'package:equatable/equatable.dart';

class DoctorDashboardStats extends Equatable {
  final int opCount;
  final int ipCount;
  final int opProceduresCount;
  final int ipProceduresCount;
  final int surgeryCount;
  final int medicalCertificatesCount;
  final int pendingMrdCount;
  final int availableSlotsCount;

  const DoctorDashboardStats({
    required this.opCount,
    required this.ipCount,
    required this.opProceduresCount,
    required this.ipProceduresCount,
    required this.surgeryCount,
    required this.medicalCertificatesCount,
    required this.pendingMrdCount,
    required this.availableSlotsCount,
  });

  @override
  List<Object?> get props => [
    opCount,
    ipCount,
    opProceduresCount,
    ipProceduresCount,
    surgeryCount,
    medicalCertificatesCount,
    pendingMrdCount,
    availableSlotsCount,
  ];
}
