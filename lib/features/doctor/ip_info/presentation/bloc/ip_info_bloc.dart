import 'ip_info_event.dart';
import 'ip_info_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/features/doctor/ip_info/domain/usecases/get_ip_occupancy_usecase.dart';

@injectable
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
