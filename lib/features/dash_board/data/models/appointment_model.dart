import 'package:medi_connect/features/dash_board/domain/entities/appointment_entity.dart';

class AppointmentModel extends AppointmentEntity {
  const AppointmentModel({
    required super.id,
    super.patientId,
    required super.patientName,
    super.doctorId,
    required super.doctorName,
    required super.specialty,
    required super.appointmentDate,
    required super.appointmentTime,
    required super.status,
    required super.type,
    super.createdAt,
  });

  factory AppointmentModel.fromJson(Map<String, dynamic> json) {
    return AppointmentModel(
      id: json['id']?.toString() ?? '',
      patientId: json['patient_id']?.toString(),
      patientName: json['patient_name'] as String? ?? '',
      doctorId: json['doctor_id']?.toString(),
      doctorName: json['doctor_name'] as String? ?? '',
      specialty: json['specialty'] as String? ?? '',
      appointmentDate: json['appointment_date'] != null
          ? DateTime.tryParse(json['appointment_date'] as String) ?? DateTime.now()
          : DateTime.now(),
      appointmentTime: json['appointment_time'] as String? ?? '',
      status: json['status'] as String? ?? 'Pending',
      type: json['type'] as String? ?? 'Consultation',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        if (patientId != null) 'patient_id': patientId,
        'patient_name': patientName,
        if (doctorId != null) 'doctor_id': doctorId,
        'doctor_name': doctorName,
        'specialty': specialty,
        'appointment_date': appointmentDate.toIso8601String().split('T').first,
        'appointment_time': appointmentTime,
        'status': status,
        'type': type,
      };
}
