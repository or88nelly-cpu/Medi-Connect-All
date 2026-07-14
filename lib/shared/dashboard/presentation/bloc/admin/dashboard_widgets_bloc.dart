import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/shared/dashboard/domain/use_cases/get_dashboard_widgets_usecase.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/dashboard_widgets_event.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/dashboard_widgets_state.dart';

class DashboardWidgetsBloc extends Bloc<DashboardWidgetsEvent, DashboardWidgetsState> {
  final GetDashboardWidgetsUseCase getDashboardWidgetsUseCase;

  DashboardWidgetsBloc({required this.getDashboardWidgetsUseCase}) : super(DashboardWidgetsInitial()) {
    on<LoadDashboardWidgets>(_onLoadDashboardWidgets);
  }

  Future<void> _onLoadDashboardWidgets(
    LoadDashboardWidgets event,
    Emitter<DashboardWidgetsState> emit,
  ) async {
    emit(DashboardWidgetsLoading());

    final result = await getDashboardWidgetsUseCase();

    result.fold(
      (failure) => emit(DashboardWidgetsError(failure)),
      (widgets) {
        final managementCards = widgets
            .where((w) => w.widgetType == 'MANAGEMENT_CARD')
            .toList();
        final quickActions = widgets
            .where((w) => w.widgetType == 'QUICK_ACTION')
            .toList();

        emit(DashboardWidgetsLoaded(
          managementCards: managementCards,
          quickActions: quickActions,
        ));
      },
    );
  }
}
