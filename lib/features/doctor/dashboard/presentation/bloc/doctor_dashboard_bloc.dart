import 'doctor_dashboard_event.dart';
import 'doctor_dashboard_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/features/doctor/dashboard/domain/usecases/get_doctor_dashboard_stats_usecase.dart';

@injectable
class DoctorDashboardBloc
    extends Bloc<DoctorDashboardEvent, DoctorDashboardState> {
  final GetDoctorDashboardStatsUseCase getStatsUseCase;

  DoctorDashboardBloc({required this.getStatsUseCase})
    : super(DoctorDashboardInitial()) {
    on<LoadDoctorDashboardData>(_onLoadData);
  }

  Future<void> _onLoadData(
    LoadDoctorDashboardData event,
    Emitter<DoctorDashboardState> emit,
  ) async {
    emit(DoctorDashboardLoading());
    final result = await getStatsUseCase(
      DoctorDashboardParams(doctorId: event.doctorId, date: event.date),
    );
    result.fold(
      (failure) => emit(DoctorDashboardError(failure.message)),
      (stats) => emit(DoctorDashboardLoaded(stats)),
    );
  }
}
