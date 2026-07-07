import 'package:medi_connect/features/doctors/dashboard/domain/entities/mrd_record_entity.dart';

class MrdRecordModel extends MrdRecordEntity {
  const MrdRecordModel({
    required super.id,
    required super.patientId,
    super.doctorId,
    super.employeeId,
    required super.recordType,
    super.title,
    super.description,
    super.fileUrl,
    super.fileName,
    super.fileSize,
    super.mimeType,
    super.isPaid,
    super.paymentAmount,
    super.paymentStatus,
    required super.status,
    super.recordDate,
    super.createdAt,
    super.updatedAt,
    super.appointmentId,
    super.patientName,
    super.patientAge,
    super.patientGender,
    super.patientPhoto,
  });

  factory MrdRecordModel.fromJson(Map<String, dynamic> json) {
    return MrdRecordModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      patientId: json['patient_id']?.toString() ?? '',
      doctorId: json['doctor_id']?.toString(),
      employeeId: json['employee_id']?.toString(),
      recordType: json['record_type']?.toString() ?? '',
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      fileUrl: json['file_url']?.toString(),
      fileName: json['file_name']?.toString(),
      fileSize: int.tryParse(json['file_size']?.toString() ?? ''),
      mimeType: json['mime_type']?.toString(),
      isPaid: json['is_paid'] as bool?,
      paymentAmount: double.tryParse(json['payment_amount']?.toString() ?? ''),
      paymentStatus: json['payment_status']?.toString(),
      status: json['status']?.toString() ?? 'active',
      recordDate: json['record_date'] != null
          ? DateTime.tryParse(json['record_date'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
      appointmentId: json['appointment_id']?.toString(),
      patientName: json['patient_name']?.toString(),
      patientAge: json['patient_age']?.toString(),
      patientGender: json['patient_gender']?.toString(),
      patientPhoto: json['patient_photo']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    'patient_id': patientId,
    if (doctorId != null) 'doctor_id': doctorId,
    if (employeeId != null) 'employee_id': employeeId,
    'record_type': recordType,
    if (title != null) 'title': title,
    if (description != null) 'description': description,
    if (fileUrl != null) 'file_url': fileUrl,
    if (fileName != null) 'file_name': fileName,
    if (fileSize != null) 'file_size': fileSize,
    if (mimeType != null) 'mime_type': mimeType,
    if (isPaid != null) 'is_paid': isPaid,
    if (paymentAmount != null) 'payment_amount': paymentAmount,
    if (paymentStatus != null) 'payment_status': paymentStatus,
    'status': status,
    if (recordDate != null) 'record_date': recordDate?.toIso8601String(),
    if (appointmentId != null) 'appointment_id': appointmentId,
    if (patientName != null) 'patient_name': patientName,
    if (patientAge != null) 'patient_age': patientAge,
    if (patientGender != null) 'patient_gender': patientGender,
    if (patientPhoto != null) 'patient_photo': patientPhoto,
  };
}
