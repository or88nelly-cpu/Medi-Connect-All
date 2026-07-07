import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/features/doctors/ip_info/domain/usecases/get_ip_occupancy_usecase.dart';
import 'ip_info_event.dart';
import 'ip_info_state.dart';

class IpInfoBloc extends Bloc<IpInfoEvent, IpInfoState> {
  final GetIpOccupancyUseCase getIpOccupancy;

  IpInfoBloc({required this.getIpOccupancy}) : super(IpInfoInitial()) {
    on<LoadIpOccupancy>(_onLoadIpOccupancy);
  }

  Future<void> _onLoadIpOccupancy(
    LoadIpOccupancy event,
    Emitter<IpInfoState> emit,
  ) async {
    emit(IpInfoLoading());
    final result = await getIpOccupancy();
    result.fold(
      (failure) => emit(IpInfoError(failure.message)),
      (list) => emit(IpInfoLoaded(list)),
    );
  }
}
