import 'package:equatable/equatable.dart';

abstract class DashboardWidgetsEvent extends Equatable {
  const DashboardWidgetsEvent();

  @override
  List<Object?> get props => [];
}

class LoadDashboardWidgets extends DashboardWidgetsEvent {
  const LoadDashboardWidgets();
}
