import 'package:equatable/equatable.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';

abstract class DoctorStaffEvent extends Equatable {
  const DoctorStaffEvent();

  @override
  List<Object?> get props => [];
}

class LoadDoctorStaff extends DoctorStaffEvent {
  final String departmentName;
  const LoadDoctorStaff(this.departmentName);

  @override
  List<Object?> get props => [departmentName];
}

class CreateDoctorStaffMember extends DoctorStaffEvent {
  final UserModel user;
  const CreateDoctorStaffMember(this.user);

  @override
  List<Object?> get props => [user];
}

class UpdateDoctorStaffMember extends DoctorStaffEvent {
  final UserModel user;
  const UpdateDoctorStaffMember(this.user);

  @override
  List<Object?> get props => [user];
}

class DeleteDoctorStaffMember extends DoctorStaffEvent {
  final String userId;
  final String departmentName;
  const DeleteDoctorStaffMember({required this.userId, required this.departmentName});

  @override
  List<Object?> get props => [userId, departmentName];
}
