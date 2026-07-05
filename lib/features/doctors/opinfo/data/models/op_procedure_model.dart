import 'package:medi_connect/features/doctors/opinfo/domain/entities/op_procedure_entity.dart';

class OpProcedureModel extends OpProcedureEntity {
  const OpProcedureModel({
    required super.id,
    required super.tokenNumber,
    required super.patientId,
    required super.patientName,
    required super.age,
    required super.gender,
    required super.appointmentTime,
    required super.status,
    super.profilePhoto,
  });

  factory OpProcedureModel.fromJson(Map<String, dynamic> json) {
    return OpProcedureModel(
      id: json['id'] as String,
      tokenNumber: json['token_number'] as int,
      patientId: json['patient_id'] as String,
      patientName: json['patient_name'] as String,
      age: json['age'] as String,
      gender: json['gender'] as String,
      appointmentTime: json['appointment_time'] as String,
      status: json['status'] as String,
      profilePhoto: json['profile_photo'] as String?,
    );
  }
}
