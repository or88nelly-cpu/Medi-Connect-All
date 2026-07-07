import 'package:medi_connect/features/doctors/op_procedures/domain/entities/op_procedure_entity.dart';

class OpProcedureModel extends OpProcedureEntity {
  const OpProcedureModel({
    required super.tokenNumber,
    required super.patientName,
    required super.patientId,
    required super.age,
    required super.gender,
    required super.procedure,
    required super.diagnosis,
    required super.time,
    required super.date,
    required super.status,
    required super.paymentAmount,
    required super.paymentStatus,
    required super.priority,
    super.profilePhoto,
  });

  factory OpProcedureModel.fromJson(Map<String, dynamic> json) {
    return OpProcedureModel(
      tokenNumber: json['token_number']?.toString() ?? '',
      patientName: json['patient_name']?.toString() ?? '',
      patientId: json['patient_id']?.toString() ?? '',
      age: json['age']?.toString() ?? '',
      gender: json['gender']?.toString() ?? '',
      procedure: json['procedure']?.toString() ?? '',
      diagnosis: json['diagnosis']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      paymentAmount: (json['payment_amount'] as num? ?? 0).toInt(),
      paymentStatus: json['payment_status']?.toString() ?? '',
      priority: json['priority']?.toString() ?? '',
      profilePhoto: json['profile_photo']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'token_number': tokenNumber,
    'patient_name': patientName,
    'patient_id': patientId,
    'age': age,
    'gender': gender,
    'procedure': procedure,
    'diagnosis': diagnosis,
    'time': time,
    'date': date,
    'status': status,
    'payment_amount': paymentAmount,
    'payment_status': paymentStatus,
    'priority': priority,
    if (profilePhoto != null) 'profile_photo': profilePhoto,
  };
}
