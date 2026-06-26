import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/core/models/failure.dart';
import 'package:medi_connect/modules/management/staff_management/domain/entities/department_entity.dart';
import 'package:medi_connect/modules/management/staff_management/domain/use_cases/add_department_usecase.dart';
import 'package:medi_connect/modules/management/staff_management/domain/use_cases/delete_department_usecase.dart';
import 'package:medi_connect/modules/management/staff_management/domain/use_cases/get_departments_usecase.dart';
import 'package:medi_connect/modules/management/staff_management/domain/use_cases/update_department_usecase.dart';

part 'department_event.dart';
part 'department_state.dart';

class DepartmentBloc extends Bloc<DepartmentEvent, DepartmentState> {
  final GetDepartmentsUseCase _getDepartments;
  final AddDepartmentUseCase _addDepartment;
  final UpdateDepartmentUseCase _updateDepartment;
  final DeleteDepartmentUseCase _deleteDepartment;

  DepartmentBloc({
    required this._getDepartments,
    required this._addDepartment,
    required this._updateDepartment,
    required this._deleteDepartment,
  }) : super(DepartmentInitial()) {
    on<LoadDepartments>(_onLoad);
    on<LoadConsultDepartments>(_onLoadConsult);
    on<AddDepartmentEvent>(_onAdd);
    on<UpdateDepartmentEvent>(_onUpdate);
    on<DeleteDepartmentEvent>(_onDelete);
  }
  Future<void> _onLoadConsult(
    LoadConsultDepartments event,
    Emitter<DepartmentState> emit,
  ) async {
    emit(DepartmentLoading());
    final result = await _getDepartments(true);
    result.fold((failure) => emit(DepartmentError(failure)), (departments) {
      return emit(DepartmentsLoaded(departments, []));
    });
  }

  Future<void> _onLoad(
    LoadDepartments event,
    Emitter<DepartmentState> emit,
  ) async {
    emit(DepartmentLoading());
    final result = await _getDepartments(false);
    result.fold((failure) => emit(DepartmentError(failure)), (departments) {
      final normalDept = departments
          .where((element) => !element.consultation)
          .toList();
      final sections = departments
          .where((element) => element.consultation)
          .toList();
      return emit(DepartmentsLoaded(normalDept, sections));
    });
  }

  Future<void> _onAdd(
    AddDepartmentEvent event,
    Emitter<DepartmentState> emit,
  ) async {
    // Duplicate check against currently loaded list.
    if (state is DepartmentsLoaded) {
      final existing = (state as DepartmentsLoaded).departments;
      final existingSection = (state as DepartmentsLoaded).sections;
      final isDuplicate =
          existing.any(
            (d) =>
                d.name.toLowerCase().trim() == event.name.toLowerCase().trim(),
          ) ||
          existingSection.any(
            (d) =>
                d.name.toLowerCase().trim() == event.name.toLowerCase().trim(),
          );
      if (isDuplicate) {
        emit(
          DepartmentError(
            const ValidationFailure(
              'A department with this name already exists.',
            ),
          ),
        );
        emit(DepartmentsLoaded(existing, existingSection)); // restore
        return;
      }
    }
    final result = await _addDepartment(
      AddDepartmentParams(
        name: event.name,
        description: event.description,
        imageUrl: event.imageUrl,
      ),
    );
    result.fold(
      (failure) => emit(DepartmentError(failure)),
      (department) => emit(
        DepartmentActionSuccess(
          message: 'Department created successfully.',
          // Refresh list after success.
          updatedDepartments: state is DepartmentsLoaded
              ? [...(state as DepartmentsLoaded).departments, department]
              : [department],
        ),
      ),
    );
  }

  Future<void> _onUpdate(
    UpdateDepartmentEvent event,
    Emitter<DepartmentState> emit,
  ) async {
    // Duplicate check (exclude self).
    if (state is DepartmentsLoaded) {
      final existing = (state as DepartmentsLoaded).departments;
      final existingSection = (state as DepartmentsLoaded).sections;
      final isDuplicate =
          existing.any(
            (d) =>
                d.id != event.id &&
                d.name.toLowerCase().trim() == event.name.toLowerCase().trim(),
          ) ||
          existingSection.any(
            (d) =>
                d.id != event.id &&
                d.name.toLowerCase().trim() == event.name.toLowerCase().trim(),
          );
      if (isDuplicate) {
        emit(
          DepartmentError(
            const ValidationFailure(
              'A department with this name already exists.',
            ),
          ),
        );
        emit(DepartmentsLoaded(existing, existingSection));
        return;
      }
    }
    final result = await _updateDepartment(
      UpdateDepartmentParams(
        id: event.id,
        name: event.name,
        description: event.description,
        imageUrl: event.imageUrl,
      ),
    );
    result.fold((failure) => emit(DepartmentError(failure)), (updated) {
      final current = state is DepartmentsLoaded
          ? (state as DepartmentsLoaded).departments
          : <DepartmentEntity>[];
      final newList = current
          .map((d) => d.id == updated.id ? updated : d)
          .toList();
      emit(
        DepartmentActionSuccess(
          message: 'Department updated successfully.',
          updatedDepartments: newList,
        ),
      );
    });
  }

  Future<void> _onDelete(
    DeleteDepartmentEvent event,
    Emitter<DepartmentState> emit,
  ) async {
    final result = await _deleteDepartment(DeleteDepartmentParams(event.id));
    result.fold((failure) => emit(DepartmentError(failure)), (_) {
      final current = state is DepartmentsLoaded
          ? (state as DepartmentsLoaded).departments
          : <DepartmentEntity>[];
      final newList = current.where((d) => d.id != event.id).toList();
      emit(
        DepartmentActionSuccess(
          message: 'Department deleted successfully.',
          updatedDepartments: newList,
        ),
      );
    });
  }
}
