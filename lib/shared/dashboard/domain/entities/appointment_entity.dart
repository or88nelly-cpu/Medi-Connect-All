import 'package:equatable/equatable.dart';

class AppointmentEntity extends Equatable {
  final String id;
  final String? patientId;
  final String patientName;
  final String? doctorId;
  final String doctorName;
  final String specialty;
  final DateTime appointmentDate;
  final String appointmentTime;
  final String status;
  final String type;
  final DateTime? createdAt;

  // Vitals fields
  final String? bp;
  final String? weight;
  final String? height;
  final String? fever;
  final String? headCircumference;
  final String? additionalVitals;
  final String? token;
  final int? amount;

  const AppointmentEntity({
    required this.id,
    this.patientId,
    required this.patientName,
    this.doctorId,
    required this.doctorName,
    required this.specialty,
    required this.appointmentDate,
    required this.appointmentTime,
    required this.status,
    required this.type,
    this.createdAt,
    this.bp,
    this.weight,
    this.height,
    this.fever,
    this.headCircumference,
    this.additionalVitals,
    this.token,
    this.amount,
  });

  @override
  List<Object?> get props => [
    id,
    patientId,
    patientName,
    doctorId,
    doctorName,
    specialty,
    appointmentDate,
    appointmentTime,
    status,
    type,
    createdAt,
    bp,
    weight,
    height,
    fever,
    headCircumference,
    additionalVitals,
    token,
    amount,
  ];
}
