import 'package:equatable/equatable.dart';
import 'package:medi_connect/shared/auth/data/models/user_model.dart';

abstract class DoctorStaffState extends Equatable {
  const DoctorStaffState();

  @override
  List<Object?> get props => [];
}

class DoctorStaffInitial extends DoctorStaffState {}

class DoctorStaffLoading extends DoctorStaffState {}

class DoctorStaffLoaded extends DoctorStaffState {
  final List<UserModel> doctors;
  final List<UserModel> staff;

  const DoctorStaffLoaded({required this.doctors, required this.staff});

  @override
  List<Object?> get props => [doctors, staff];
}

class DoctorStaffActionSuccess extends DoctorStaffState {}

class DoctorStaffError extends DoctorStaffState {
  final String message;
  const DoctorStaffError(this.message);

  @override
  List<Object?> get props => [message];
}
