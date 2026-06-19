import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:medi_connect/features/auth/data/models/user_model.dart';
import 'package:medi_connect/features/patient/domain/repositories/patient_repository.dart';

// EVENTS
abstract class PatientEvent extends Equatable {
  const PatientEvent();
  @override
  List<Object?> get props => [];
}

class LoadPatients extends PatientEvent {}

class CreatePatient extends PatientEvent {
  final UserModel patient;
  const CreatePatient(this.patient);
  @override
  List<Object?> get props => [patient];
}

class UpdatePatient extends PatientEvent {
  final UserModel patient;
  const UpdatePatient(this.patient);
  @override
  List<Object?> get props => [patient];
}

class DeletePatient extends PatientEvent {
  final String patientId;
  const DeletePatient(this.patientId);
  @override
  List<Object?> get props => [patientId];
}

class RegisterPatientAndSendToMRD extends PatientEvent {
  final UserModel patient;
  final Map<String, dynamic> mrdRecord;
  const RegisterPatientAndSendToMRD({
    required this.patient,
    required this.mrdRecord,
  });
  @override
  List<Object?> get props => [patient, mrdRecord];
}

// STATES
abstract class PatientState extends Equatable {
  const PatientState();
  @override
  List<Object?> get props => [];
}

class PatientInitial extends PatientState {}

class PatientLoading extends PatientState {}

class PatientLoaded extends PatientState {
  final List<UserModel> patients;
  const PatientLoaded(this.patients);
  @override
  List<Object?> get props => [patients];
}

class PatientActionSuccess extends PatientState {}

class PatientError extends PatientState {
  final String message;
  const PatientError(this.message);
  @override
  List<Object?> get props => [message];
}

// BLOC
class PatientBloc extends Bloc<PatientEvent, PatientState> {
  final PatientRepository _repository;

  PatientBloc(this._repository) : super(PatientInitial()) {
    on<LoadPatients>(_onLoadPatients);
    on<CreatePatient>(_onCreatePatient);
    on<UpdatePatient>(_onUpdatePatient);
    on<DeletePatient>(_onDeletePatient);
    on<RegisterPatientAndSendToMRD>(_onRegisterPatientAndSendToMRD);
  }

  Future<void> _onLoadPatients(
    LoadPatients event,
    Emitter<PatientState> emit,
  ) async {
    emit(PatientLoading());
    final result = await _repository.getPatients();
    result.fold(
      (failure) => emit(PatientError(failure.message)),
      (list) => emit(PatientLoaded(list)),
    );
  }

  Future<void> _onCreatePatient(
    CreatePatient event,
    Emitter<PatientState> emit,
  ) async {
    emit(PatientLoading());
    final result = await _repository.createPatient(event.patient);
    result.fold((failure) => emit(PatientError(failure.message)), (patient) {
      emit(PatientActionSuccess());
      add(LoadPatients());
    });
  }

  Future<void> _onUpdatePatient(
    UpdatePatient event,
    Emitter<PatientState> emit,
  ) async {
    emit(PatientLoading());
    final result = await _repository.updatePatient(event.patient);
    result.fold((failure) => emit(PatientError(failure.message)), (patient) {
      emit(PatientActionSuccess());
      add(LoadPatients());
    });
  }

  Future<void> _onDeletePatient(
    DeletePatient event,
    Emitter<PatientState> emit,
  ) async {
    emit(PatientLoading());
    final result = await _repository.deletePatient(event.patientId);
    result.fold((failure) => emit(PatientError(failure.message)), (_) {
      emit(PatientActionSuccess());
      add(LoadPatients());
    });
  }

  Future<void> _onRegisterPatientAndSendToMRD(
    RegisterPatientAndSendToMRD event,
    Emitter<PatientState> emit,
  ) async {
    emit(PatientLoading());
    final result = await _repository.registerPatientAndSendToMRD(
      event.patient,
      event.mrdRecord,
    );
    result.fold((failure) => emit(PatientError(failure.message)), (_) {
      emit(PatientActionSuccess());
      add(LoadPatients());
    });
  }
}
