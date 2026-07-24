import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/services/app_logger.dart';
import 'package:medi_connect/features/admin/home/domain/usecases/get_admin_dashboard_modules_usecase.dart';
import 'package:medi_connect/features/admin/home/presentation/bloc/admin_home_event.dart';
import 'package:medi_connect/features/admin/home/presentation/bloc/admin_home_state.dart';

@injectable
class AdminHomeBloc extends Bloc<AdminHomeEvent, AdminHomeState> {
  final GetAdminDashboardModulesUseCase getAdminDashboardModulesUseCase;

  AdminHomeBloc({required this.getAdminDashboardModulesUseCase})
    : super(const AdminHomeInitial()) {
    on<LoadAdminDashboardModules>(_onLoadModules);
    on<FilterAdminDashboardModules>(_onFilterModules);
  }

  Future<void> _onLoadModules(
    LoadAdminDashboardModules event,
    Emitter<AdminHomeState> emit,
  ) async {
    AppLogger.bloc('AdminHomeBloc: Loading dashboard modules...');
    emit(const AdminHomeLoading());

    final result = await getAdminDashboardModulesUseCase();

    result.fold(
      (failure) {
        AppLogger.error(
          'AdminHomeBloc: Failed to load modules: ${failure.message}',
        );
        emit(AdminHomeError(failure.message));
      },
      (modules) {
        AppLogger.bloc(
          'AdminHomeBloc: Loaded ${modules.length} modules successfully.',
        );
        emit(AdminHomeLoaded(allModules: modules, filteredModules: modules));
      },
    );
  }

  void _onFilterModules(
    FilterAdminDashboardModules event,
    Emitter<AdminHomeState> emit,
  ) {
    if (state is AdminHomeLoaded) {
      final currentState = state as AdminHomeLoaded;
      final query = event.query.toLowerCase().trim();

      if (query.isEmpty) {
        emit(
          AdminHomeLoaded(
            allModules: currentState.allModules,
            filteredModules: currentState.allModules,
            searchQuery: '',
          ),
        );
        return;
      }

      final filtered = currentState.allModules.where((mod) {
        return mod.title.toLowerCase().contains(query) ||
            mod.description.toLowerCase().contains(query);
      }).toList();

      emit(
        AdminHomeLoaded(
          allModules: currentState.allModules,
          filteredModules: filtered,
          searchQuery: event.query,
        ),
      );
    }
  }
}
