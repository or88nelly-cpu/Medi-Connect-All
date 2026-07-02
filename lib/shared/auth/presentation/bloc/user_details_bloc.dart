import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medi_connect/shared/auth/domain/entities/app_user_entity.dart';
import 'package:medi_connect/shared/auth/domain/repositories/user_details_repository.dart';

// EVENTS
abstract class UserDetailsEvent extends Equatable {
  const UserDetailsEvent();
  @override
  List<Object?> get props => [];
}

class FetchUserDetails extends UserDetailsEvent {
  final String userId;
  const FetchUserDetails(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdatePatientDetails extends UserDetailsEvent {
  final String userId;
  final Map<String, dynamic> data;
  const UpdatePatientDetails(this.userId, this.data);

  @override
  List<Object?> get props => [userId, data];
}

class UpdateEmployeeDetails extends UserDetailsEvent {
  final String userId;
  final Map<String, dynamic> data;
  const UpdateEmployeeDetails(this.userId, this.data);

  @override
  List<Object?> get props => [userId, data];
}

class UpdateDoctorDetails extends UserDetailsEvent {
  final String userId;
  final Map<String, dynamic> data;
  const UpdateDoctorDetails(this.userId, this.data);

  @override
  List<Object?> get props => [userId, data];
}

// STATES
abstract class UserDetailsState extends Equatable {
  const UserDetailsState();
  @override
  List<Object?> get props => [];
}

class UserDetailsInitial extends UserDetailsState {}

class UserDetailsLoading extends UserDetailsState {}

class UserDetailsLoaded extends UserDetailsState {
  final AppUserEntity appUser;
  const UserDetailsLoaded(this.appUser);

  @override
  List<Object?> get props => [appUser];
}

class UserDetailsActionSuccess extends UserDetailsState {
  final String message;
  const UserDetailsActionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class UserDetailsError extends UserDetailsState {
  final String error;
  const UserDetailsError(this.error);

  @override
  List<Object?> get props => [error];
}

// BLOC
class UserDetailsBloc extends Bloc<UserDetailsEvent, UserDetailsState> {
  final UserDetailsRepository _repository;

  UserDetailsBloc(this._repository) : super(UserDetailsInitial()) {
    on<FetchUserDetails>(_onFetchUserDetails);
    on<UpdatePatientDetails>(_onUpdatePatientDetails);
    on<UpdateEmployeeDetails>(_onUpdateEmployeeDetails);
    on<UpdateDoctorDetails>(_onUpdateDoctorDetails);
  }

  Future<void> _onFetchUserDetails(
    FetchUserDetails event,
    Emitter<UserDetailsState> emit,
  ) async {
    emit(UserDetailsLoading());
    final result = await _repository.getFullUserProfile(event.userId);
    result.fold(
      (failure) => emit(UserDetailsError(failure.message)),
      (appUser) => emit(UserDetailsLoaded(appUser)),
    );
  }

  Future<void> _onUpdatePatientDetails(
    UpdatePatientDetails event,
    Emitter<UserDetailsState> emit,
  ) async {
    emit(UserDetailsLoading());
    final result = await _repository.updatePatientProfile(event.userId, event.data);
    result.fold(
      (failure) => emit(UserDetailsError(failure.message)),
      (_) {
        emit(const UserDetailsActionSuccess("Patient profile updated successfully"));
        add(FetchUserDetails(event.userId));
      },
    );
  }

  Future<void> _onUpdateEmployeeDetails(
    UpdateEmployeeDetails event,
    Emitter<UserDetailsState> emit,
  ) async {
    emit(UserDetailsLoading());
    final result = await _repository.updateEmployeeProfile(event.userId, event.data);
    result.fold(
      (failure) => emit(UserDetailsError(failure.message)),
      (_) {
        emit(const UserDetailsActionSuccess("Employee profile updated successfully"));
        add(FetchUserDetails(event.userId));
      },
    );
  }

  Future<void> _onUpdateDoctorDetails(
    UpdateDoctorDetails event,
    Emitter<UserDetailsState> emit,
  ) async {
    emit(UserDetailsLoading());
    final result = await _repository.updateDoctorProfile(event.userId, event.data);
    result.fold(
      (failure) => emit(UserDetailsError(failure.message)),
      (_) {
        emit(const UserDetailsActionSuccess("Doctor profile updated successfully"));
        add(FetchUserDetails(event.userId));
      },
    );
  }
}
