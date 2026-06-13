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
      ];
}
