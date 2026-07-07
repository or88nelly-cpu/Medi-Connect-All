import 'package:equatable/equatable.dart';

class MrdRecordEntity extends Equatable {
  final int id;
  final String patientId;
  final String? doctorId;
  final String? employeeId;
  final String recordType;
  final String? title;
  final String? description;
  final String? fileUrl;
  final String? fileName;
  final int? fileSize;
  final String? mimeType;
  final bool? isPaid;
  final double? paymentAmount;
  final String? paymentStatus;
  final String status;
  final DateTime? recordDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? appointmentId;

  // Joined patient fields
  final String? patientName;
  final String? patientAge;
  final String? patientGender;
  final String? patientPhoto;

  const MrdRecordEntity({
    required this.id,
    required this.patientId,
    this.doctorId,
    this.employeeId,
    required this.recordType,
    this.title,
    this.description,
    this.fileUrl,
    this.fileName,
    this.fileSize,
    this.mimeType,
    this.isPaid,
    this.paymentAmount,
    this.paymentStatus,
    required this.status,
    this.recordDate,
    this.createdAt,
    this.updatedAt,
    this.appointmentId,
    this.patientName,
    this.patientAge,
    this.patientGender,
    this.patientPhoto,
  });

  @override
  List<Object?> get props => [
        id,
        patientId,
        doctorId,
        employeeId,
        recordType,
        title,
        description,
        fileUrl,
        fileName,
        fileSize,
        mimeType,
        isPaid,
        paymentAmount,
        paymentStatus,
        status,
        recordDate,
        createdAt,
        updatedAt,
        appointmentId,
        patientName,
        patientAge,
        patientGender,
        patientPhoto,
      ];
}
