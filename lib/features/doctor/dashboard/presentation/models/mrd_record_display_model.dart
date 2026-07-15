import 'package:medi_connect/features/doctor/dashboard/domain/entities/mrd_record_entity.dart';

class MrdRecordDisplayModel {
  final MrdRecordEntity record;
  final String patientName;
  final String patientAge;
  final String patientGender;
  final String? patientPhoto;
  final String ipdLocation;
  final String pendingSince;
  final String priority;

  const MrdRecordDisplayModel({
    required this.record,
    required this.patientName,
    required this.patientAge,
    required this.patientGender,
    this.patientPhoto,
    required this.ipdLocation,
    required this.pendingSince,
    required this.priority,
  });
}
