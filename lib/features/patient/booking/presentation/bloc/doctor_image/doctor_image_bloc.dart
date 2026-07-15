import 'dart:developer';
import 'doctor_image_event.dart';
import 'doctor_image_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:medi_connect/features/patient/booking/domain/usecases/get_doctor_image_usecase.dart';

@injectable
class DoctorImageBloc extends Bloc<DoctorImageEvent, DoctorImageState> {
  final GetDoctorImageUseCase _getDoctorImage;

  DoctorImageBloc({required this._getDoctorImage})
    : super(DoctorImageInitial()) {
    on<LoadDoctorImage>(_onLoadDoctorImage);
  }

  Future<void> _onLoadDoctorImage(
    LoadDoctorImage event,
    Emitter<DoctorImageState> emit,
  ) async {
    if (event.doctorId.isEmpty) {
      emit(DoctorImageLoaded(null, null));
      return;
    }
    emit(DoctorImageLoading());

    final result = await _getDoctorImage(event.doctorId);
    result.fold((failure) {
      log("error ${failure.message}");
      emit(DoctorImageError());
    }, (entity) => emit(DoctorImageLoaded(entity.imageUrl, entity.gender)));
  }
}
