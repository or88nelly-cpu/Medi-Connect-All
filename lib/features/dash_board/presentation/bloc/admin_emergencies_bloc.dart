import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/features/dash_board/domain/entities/emergency_entity.dart';
import 'package:medi_connect/features/dash_board/domain/use_cases/admin_operations_usecases.dart';

// Events
abstract class AdminEmergenciesEvent {}

class LoadEmergencies extends AdminEmergenciesEvent {}

class TriggerEmergency extends AdminEmergenciesEvent {
  final Map<String, dynamic> data;
  TriggerEmergency(this.data);
}

class ResolveEmergency extends AdminEmergenciesEvent {
  final String id;
  ResolveEmergency(this.id);
}

// States
abstract class AdminEmergenciesState {}

class AdminEmergenciesInitial extends AdminEmergenciesState {}

class AdminEmergenciesLoading extends AdminEmergenciesState {}

class AdminEmergenciesLoaded extends AdminEmergenciesState {
  final List<EmergencyEntity> emergencies;
  AdminEmergenciesLoaded(this.emergencies);
}

class AdminEmergenciesError extends AdminEmergenciesState {
  final String message;
  AdminEmergenciesError(this.message);
}

// Bloc
class AdminEmergenciesBloc
    extends Bloc<AdminEmergenciesEvent, AdminEmergenciesState> {
  final GetEmergenciesUseCase _getEmergencies;
  final TriggerEmergencyUseCase _trigger;
  final ResolveEmergencyUseCase _resolve;

  AdminEmergenciesBloc({
    required GetEmergenciesUseCase getEmergencies,
    required TriggerEmergencyUseCase trigger,
    required ResolveEmergencyUseCase resolve,
  })  : _getEmergencies = getEmergencies,
        _trigger = trigger,
        _resolve = resolve,
        super(AdminEmergenciesInitial()) {
    on<LoadEmergencies>(_onLoadEmergencies);
    on<TriggerEmergency>(_onTriggerEmergency);
    on<ResolveEmergency>(_onResolveEmergency);
  }

  Future<void> _onLoadEmergencies(
      LoadEmergencies event, Emitter<AdminEmergenciesState> emit) async {
    emit(AdminEmergenciesLoading());
    final result = await _getEmergencies();
    result.fold(
      (failure) => emit(AdminEmergenciesError(failure.message)),
      (emergencies) => emit(AdminEmergenciesLoaded(emergencies)),
    );
  }

  Future<void> _onTriggerEmergency(
      TriggerEmergency event, Emitter<AdminEmergenciesState> emit) async {
    final result = await _trigger(event.data);
    result.fold(
      (failure) => emit(AdminEmergenciesError(failure.message)),
      (_) => add(LoadEmergencies()),
    );
  }

  Future<void> _onResolveEmergency(
      ResolveEmergency event, Emitter<AdminEmergenciesState> emit) async {
    final result = await _resolve(event.id);
    result.fold(
      (failure) => emit(AdminEmergenciesError(failure.message)),
      (_) => add(LoadEmergencies()),
    );
  }
}
