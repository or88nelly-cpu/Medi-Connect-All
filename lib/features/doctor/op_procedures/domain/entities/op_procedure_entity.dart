import 'package:equatable/equatable.dart';

class OpProcedureEntity extends Equatable {
  final String tokenNumber;
  final String patientName;
  final String patientId;
  final String age;
  final String gender;
  final String procedure;
  final String diagnosis;
  final String time;
  final String date;
  final String status;
  final int paymentAmount;
  final String paymentStatus;
  final String priority;
  final String? profilePhoto;

  const OpProcedureEntity({
    required this.tokenNumber,
    required this.patientName,
    required this.patientId,
    required this.age,
    required this.gender,
    required this.procedure,
    required this.diagnosis,
    required this.time,
    required this.date,
    required this.status,
    required this.paymentAmount,
    required this.paymentStatus,
    required this.priority,
    this.profilePhoto,
  });

  @override
  List<Object?> get props => [
    tokenNumber,
    patientName,
    patientId,
    age,
    gender,
    procedure,
    diagnosis,
    time,
    date,
    status,
    paymentAmount,
    paymentStatus,
    priority,
    profilePhoto,
  ];
}
