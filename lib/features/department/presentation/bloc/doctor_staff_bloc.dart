import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/features/department/domain/repositories/doctor_staff_repository.dart';
import 'doctor_staff_event.dart';
import 'doctor_staff_state.dart';

class DoctorStaffBloc extends Bloc<DoctorStaffEvent, DoctorStaffState> {
  final DoctorStaffRepository _repository;

  DoctorStaffBloc(this._repository) : super(DoctorStaffInitial()) {
    on<LoadDoctorStaff>(_onLoadDoctorStaff);
    on<CreateDoctorStaffMember>(_onCreateDoctorStaffMember);
    on<UpdateDoctorStaffMember>(_onUpdateDoctorStaffMember);
    on<DeleteDoctorStaffMember>(_onDeleteDoctorStaffMember);
  }

  Future<void> _onLoadDoctorStaff(LoadDoctorStaff event, Emitter<DoctorStaffState> emit) async {
    emit(DoctorStaffLoading());
    final result = await _repository.getDoctorStaff(event.departmentName);
    result.fold(
      (failure) => emit(DoctorStaffError(failure.message)),
      (list) {
        final doctors = list.where((u) => u.role == 'doctor').toList();
        final staff = list.where((u) => u.role == 'staff').toList();
        emit(DoctorStaffLoaded(doctors: doctors, staff: staff));
      },
    );
  }

  Future<void> _onCreateDoctorStaffMember(CreateDoctorStaffMember event, Emitter<DoctorStaffState> emit) async {
    emit(DoctorStaffLoading());
    final result = await _repository.createDoctorStaffMember(event.user);
    result.fold(
      (failure) => emit(DoctorStaffError(failure.message)),
      (user) {
        emit(DoctorStaffActionSuccess());
        add(LoadDoctorStaff(event.user.department ?? ''));
      },
    );
  }

  Future<void> _onUpdateDoctorStaffMember(UpdateDoctorStaffMember event, Emitter<DoctorStaffState> emit) async {
    emit(DoctorStaffLoading());
    final result = await _repository.updateDoctorStaffMember(event.user);
    result.fold(
      (failure) => emit(DoctorStaffError(failure.message)),
      (user) {
        emit(DoctorStaffActionSuccess());
        add(LoadDoctorStaff(event.user.department ?? ''));
      },
    );
  }

  Future<void> _onDeleteDoctorStaffMember(DeleteDoctorStaffMember event, Emitter<DoctorStaffState> emit) async {
    emit(DoctorStaffLoading());
    final result = await _repository.deleteDoctorStaffMember(event.userId);
    result.fold(
      (failure) => emit(DoctorStaffError(failure.message)),
      (_) {
        emit(DoctorStaffActionSuccess());
        add(LoadDoctorStaff(event.departmentName));
      },
    );
  }
}
