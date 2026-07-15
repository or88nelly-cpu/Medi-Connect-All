import 'package:equatable/equatable.dart';
import 'package:medi_connect/features/doctor/dashboard/domain/entities/doctor_dashboard_stats.dart';

abstract class DoctorDashboardState extends Equatable {
  const DoctorDashboardState();

  @override
  List<Object?> get props => [];
}

class DoctorDashboardInitial extends DoctorDashboardState {}

class DoctorDashboardLoading extends DoctorDashboardState {}

class DoctorDashboardLoaded extends DoctorDashboardState {
  final DoctorDashboardStats stats;

  const DoctorDashboardLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class DoctorDashboardError extends DoctorDashboardState {
  final String message;

  const DoctorDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
