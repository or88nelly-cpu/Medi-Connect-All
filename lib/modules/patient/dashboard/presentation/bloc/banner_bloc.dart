import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medi_connect/modules/patient/dashboard/domain/entities/banner_entity.dart';
import 'package:medi_connect/modules/patient/dashboard/domain/repositories/banner_repository.dart';

// EVENTS
abstract class BannerEvent extends Equatable {
  const BannerEvent();
  @override
  List<Object?> get props => [];
}

class LoadBanners extends BannerEvent {}

// STATES
abstract class BannerState extends Equatable {
  const BannerState();
  @override
  List<Object?> get props => [];
}

class BannerInitial extends BannerState {}

class BannerLoading extends BannerState {}

class BannerLoaded extends BannerState {
  final List<BannerEntity> banners;
  const BannerLoaded(this.banners);

  @override
  List<Object?> get props => [banners];
}

class BannerError extends BannerState {
  final String message;
  const BannerError(this.message);

  @override
  List<Object?> get props => [message];
}

// BLOC
class BannerBloc extends Bloc<BannerEvent, BannerState> {
  final BannerRepository _repository;

  BannerBloc(this._repository) : super(BannerInitial()) {
    on<LoadBanners>(_onLoadBanners);
  }

  Future<void> _onLoadBanners(
    LoadBanners event,
    Emitter<BannerState> emit,
  ) async {
    emit(BannerLoading());
    final result = await _repository.getActiveBanners();
    result.fold(
      (failure) => emit(BannerError(failure.message)),
      (banners) => emit(BannerLoaded(banners)),
    );
  }
}
