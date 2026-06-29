import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/shared/dashboard/domain/entities/lab_test_entity.dart';
import 'package:medi_connect/shared/dashboard/domain/use_cases/admin_operations_usecases.dart';

// Events
abstract class AdminLabsEvent {}

class LoadLabTests extends AdminLabsEvent {}

class AddLabTest extends AdminLabsEvent {
  final Map<String, dynamic> data;
  AddLabTest(this.data);
}

class UpdateLabTestStatus extends AdminLabsEvent {
  final String id;
  final String status;
  UpdateLabTestStatus(this.id, this.status);
}

// States
abstract class AdminLabsState {}

class AdminLabsInitial extends AdminLabsState {}

class AdminLabsLoading extends AdminLabsState {}

class AdminLabsLoaded extends AdminLabsState {
  final List<LabTestEntity> tests;
  AdminLabsLoaded(this.tests);
}

class AdminLabsError extends AdminLabsState {
  final String message;
  AdminLabsError(this.message);
}

// Bloc
class AdminLabsBloc extends Bloc<AdminLabsEvent, AdminLabsState> {
  final GetLabTestsUseCase _getTests;
  final AddLabTestUseCase _addTest;
  final UpdateLabTestStatusUseCase _updateStatus;

  AdminLabsBloc({
    required this._getTests,
    required this._addTest,
    required this._updateStatus,
  }) : super(AdminLabsInitial()) {
    on<LoadLabTests>(_onLoadLabTests);
    on<AddLabTest>(_onAddLabTest);
    on<UpdateLabTestStatus>(_onUpdateLabTestStatus);
  }

  Future<void> _onLoadLabTests(
    LoadLabTests event,
    Emitter<AdminLabsState> emit,
  ) async {
    emit(AdminLabsLoading());
    final result = await _getTests();
    result.fold(
      (failure) => emit(AdminLabsError(failure.message)),
      (tests) => emit(AdminLabsLoaded(tests)),
    );
  }

  Future<void> _onAddLabTest(
    AddLabTest event,
    Emitter<AdminLabsState> emit,
  ) async {
    final result = await _addTest(event.data);
    result.fold(
      (failure) => emit(AdminLabsError(failure.message)),
      (_) => add(LoadLabTests()),
    );
  }

  Future<void> _onUpdateLabTestStatus(
    UpdateLabTestStatus event,
    Emitter<AdminLabsState> emit,
  ) async {
    final result = await _updateStatus(event.id, event.status);
    result.fold(
      (failure) => emit(AdminLabsError(failure.message)),
      (_) => add(LoadLabTests()),
    );
  }
}
