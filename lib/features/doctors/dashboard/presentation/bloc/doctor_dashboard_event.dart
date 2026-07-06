import 'package:equatable/equatable.dart';

abstract class DoctorDashboardEvent extends Equatable {
  const DoctorDashboardEvent();

  @override
  List<Object?> get props => [];
}

class LoadDoctorDashboardData extends DoctorDashboardEvent {
  final String doctorId;
  final DateTime date;

  const LoadDoctorDashboardData({required this.doctorId, required this.date});

  @override
  List<Object?> get props => [doctorId, date];
}
