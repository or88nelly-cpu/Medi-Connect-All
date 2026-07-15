import 'package:equatable/equatable.dart';

class OpProcedureEntity extends Equatable {
  final String id;
  final int tokenNumber;
  final String patientId;
  final String patientName;
  final String age;
  final String gender;
  final String appointmentTime;
  final String status;
  final String? profilePhoto;

  const OpProcedureEntity({
    required this.id,
    required this.tokenNumber,
    required this.patientId,
    required this.patientName,
    required this.age,
    required this.gender,
    required this.appointmentTime,
    required this.status,
    this.profilePhoto,
  });

  @override
  List<Object?> get props => [
    id,
    tokenNumber,
    patientId,
    patientName,
    age,
    gender,
    appointmentTime,
    status,
    profilePhoto,
  ];
}
