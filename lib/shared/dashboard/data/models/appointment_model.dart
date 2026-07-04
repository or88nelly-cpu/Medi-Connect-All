import 'package:medi_connect/shared/dashboard/domain/entities/appointment_entity.dart';

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
    super.bp,
    super.weight,
    super.height,
    super.fever,
    super.headCircumference,
    super.additionalVitals,
    super.token,
    super.amount,
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
          ? DateTime.tryParse(json['appointment_date'] as String) ??
                DateTime.now()
          : DateTime.now(),
      appointmentTime: json['appointment_time'] as String? ?? '',
      status: json['status'] as String? ?? 'Pending',
      type: json['type'] as String? ?? 'Consultation',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      bp: json['bp']?.toString(),
      weight: json['weight']?.toString(),
      height: json['height']?.toString(),
      fever: json['fever']?.toString(),
      headCircumference: json['head_circumference']?.toString(),
      additionalVitals: json['additional_vitals']?.toString(),
      token: json['token']?.toString(),
      amount: json['amount'] != null ? (json['amount'] as num).toInt() : null,
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
    if (bp != null) 'bp': bp,
    if (weight != null) 'weight': weight,
    if (height != null) 'height': height,
    if (fever != null) 'fever': fever,
    if (headCircumference != null) 'head_circumference': headCircumference,
    if (additionalVitals != null) 'additional_vitals': additionalVitals,
    if (token != null) 'token': token,
    if (amount != null) 'amount': amount,
  };
}
