import 'package:equatable/equatable.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/shared/dashboard/data/models/dashboard_widget_model.dart';

abstract class DashboardWidgetsState extends Equatable {
  const DashboardWidgetsState();

  @override
  List<Object?> get props => [];
}

class DashboardWidgetsInitial extends DashboardWidgetsState {}

class DashboardWidgetsLoading extends DashboardWidgetsState {}

class DashboardWidgetsLoaded extends DashboardWidgetsState {
  final List<DashboardWidgetModel> managementCards;
  final List<DashboardWidgetModel> quickActions;

  const DashboardWidgetsLoaded({
    required this.managementCards,
    required this.quickActions,
  });

  @override
  List<Object?> get props => [managementCards, quickActions];
}

class DashboardWidgetsError extends DashboardWidgetsState {
  final Failure failure;

  const DashboardWidgetsError(this.failure);

  @override
  List<Object?> get props => [failure];
}
