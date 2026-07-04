import 'package:equatable/equatable.dart';
import 'package:medi_connect/shared/auth/domain/entities/user_entity.dart';
import 'package:medi_connect/shared/auth/domain/entities/patient_entity.dart';
import 'package:medi_connect/shared/auth/domain/entities/employee_entity.dart';
import 'package:medi_connect/shared/auth/domain/entities/doctor_entity.dart';

class AppUserEntity extends Equatable {
  final UserEntity user;
  final PatientEntity? patient;
  final EmployeeEntity? employee;
  final DoctorEntity? doctor;

  const AppUserEntity({
    required this.user,
    this.patient,
    this.employee,
    this.doctor,
  });

  @override
  List<Object?> get props => [user, patient, employee, doctor];
}
