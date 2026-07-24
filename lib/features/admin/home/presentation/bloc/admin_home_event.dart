import 'package:equatable/equatable.dart';

abstract class AdminHomeEvent extends Equatable {
  const AdminHomeEvent();

  @override
  List<Object?> get props => [];
}

/// Event triggered to load Control Center module cards.
class LoadAdminDashboardModules extends AdminHomeEvent {
  const LoadAdminDashboardModules();
}

/// Event triggered when filtering modules using the search bar.
class FilterAdminDashboardModules extends AdminHomeEvent {
  final String query;

  const FilterAdminDashboardModules(this.query);

  @override
  List<Object?> get props => [query];
}
