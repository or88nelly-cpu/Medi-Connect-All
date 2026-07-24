import 'package:equatable/equatable.dart';

import 'package:medi_connect/features/admin/home/domain/entities/admin_dashboard_module_entity.dart';

abstract class AdminHomeState extends Equatable {
  const AdminHomeState();

  @override
  List<Object?> get props => [];
}

class AdminHomeInitial extends AdminHomeState {
  const AdminHomeInitial();
}

class AdminHomeLoading extends AdminHomeState {
  const AdminHomeLoading();
}

class AdminHomeLoaded extends AdminHomeState {
  final List<AdminDashboardModuleEntity> allModules;
  final List<AdminDashboardModuleEntity> filteredModules;
  final String searchQuery;

  const AdminHomeLoaded({
    required this.allModules,
    required this.filteredModules,
    this.searchQuery = '',
  });

  @override
  List<Object?> get props => [allModules, filteredModules, searchQuery];
}

class AdminHomeError extends AdminHomeState {
  final String message;

  const AdminHomeError(this.message);

  @override
  List<Object?> get props => [message];
}
