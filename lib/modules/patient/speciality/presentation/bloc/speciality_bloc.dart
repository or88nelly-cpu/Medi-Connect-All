import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/modules/patient/speciality/domain/entities/speciality_entity.dart';
import 'package:medi_connect/modules/patient/speciality/domain/repositories/speciality_repository.dart';

// EVENTS
abstract class SpecialityEvent extends Equatable {
  const SpecialityEvent();
  @override
  List<Object?> get props => [];
}

class LoadSpecialities extends SpecialityEvent {}

class CreateSpecialityEvent extends SpecialityEvent {
  final SpecialityEntity speciality;
  const CreateSpecialityEvent(this.speciality);

  @override
  List<Object?> get props => [speciality];
}

class UpdateSpecialityEvent extends SpecialityEvent {
  final SpecialityEntity speciality;
  const UpdateSpecialityEvent(this.speciality);

  @override
  List<Object?> get props => [speciality];
}

class DeleteSpecialityEvent extends SpecialityEvent {
  final String id;
  const DeleteSpecialityEvent(this.id);

  @override
  List<Object?> get props => [id];
}

// STATES
abstract class SpecialityState extends Equatable {
  const SpecialityState();
  @override
  List<Object?> get props => [];
}

class SpecialityInitial extends SpecialityState {}

class SpecialityLoading extends SpecialityState {}

class SpecialitiesLoaded extends SpecialityState {
  final List<SpecialityEntity> specialities;
  const SpecialitiesLoaded(this.specialities);

  @override
  List<Object?> get props => [specialities];
}

class SpecialityActionSuccess extends SpecialityState {
  final String message;
  final List<SpecialityEntity> updatedList;
  const SpecialityActionSuccess(this.message, this.updatedList);

  @override
  List<Object?> get props => [message, updatedList];
}

class SpecialityError extends SpecialityState {
  final Failure failure;
  const SpecialityError(this.failure);

  @override
  List<Object?> get props => [failure];
}

// BLOC
class SpecialityBloc extends Bloc<SpecialityEvent, SpecialityState> {
  final SpecialityRepository _repository;

  SpecialityBloc(this._repository) : super(SpecialityInitial()) {
    on<LoadSpecialities>(_onLoadSpecialities);
    on<CreateSpecialityEvent>(_onCreateSpeciality);
    on<UpdateSpecialityEvent>(_onUpdateSpeciality);
    on<DeleteSpecialityEvent>(_onDeleteSpeciality);
  }

  Future<void> _onLoadSpecialities(
    LoadSpecialities event,
    Emitter<SpecialityState> emit,
  ) async {
    emit(SpecialityLoading());
    final result = await _repository.getSpecialities();
    
    result.fold(
      (failure) => emit(SpecialityError(failure)),
      (list) => emit(SpecialitiesLoaded(list)),
    );
  }

  Future<void> _onCreateSpeciality(
    CreateSpecialityEvent event,
    Emitter<SpecialityState> emit,
  ) async {
    emit(SpecialityLoading());
    final result = await _repository.createSpeciality(event.speciality);
    await result.fold(
      (failure) async => emit(SpecialityError(failure)),
      (newSpeciality) async {
        final loadRes = await _repository.getSpecialities();
        loadRes.fold(
          (failure) => emit(SpecialityError(failure)),
          (list) => emit(SpecialityActionSuccess("Speciality created successfully", list)),
        );
      },
    );
  }

  Future<void> _onUpdateSpeciality(
    UpdateSpecialityEvent event,
    Emitter<SpecialityState> emit,
  ) async {
    emit(SpecialityLoading());
    final result = await _repository.updateSpeciality(event.speciality);
    await result.fold(
      (failure) async => emit(SpecialityError(failure)),
      (updatedSpeciality) async {
        final loadRes = await _repository.getSpecialities();
        loadRes.fold(
          (failure) => emit(SpecialityError(failure)),
          (list) => emit(SpecialityActionSuccess("Speciality updated successfully", list)),
        );
      },
    );
  }

  Future<void> _onDeleteSpeciality(
    DeleteSpecialityEvent event,
    Emitter<SpecialityState> emit,
  ) async {
    emit(SpecialityLoading());
    final result = await _repository.deleteSpeciality(event.id);
    await result.fold(
      (failure) async => emit(SpecialityError(failure)),
      (_) async {
        final loadRes = await _repository.getSpecialities();
        loadRes.fold(
          (failure) => emit(SpecialityError(failure)),
          (list) => emit(SpecialityActionSuccess("Speciality deleted successfully", list)),
        );
      },
    );
  }
}
