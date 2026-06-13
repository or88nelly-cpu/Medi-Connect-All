import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/features/dash_board/domain/entities/pharmacy_item_entity.dart';
import 'package:medi_connect/features/dash_board/domain/use_cases/admin_operations_usecases.dart';

// Events
abstract class AdminPharmacyEvent {}

class LoadPharmacyItems extends AdminPharmacyEvent {}

class AddPharmacyItem extends AdminPharmacyEvent {
  final Map<String, dynamic> data;
  AddPharmacyItem(this.data);
}

class UpdatePharmacyItemStock extends AdminPharmacyEvent {
  final String id;
  final int stock;
  UpdatePharmacyItemStock(this.id, this.stock);
}

class EditPharmacyItem extends AdminPharmacyEvent {
  final String id;
  final Map<String, dynamic> data;
  EditPharmacyItem(this.id, this.data);
}

class DeletePharmacyItem extends AdminPharmacyEvent {
  final String id;
  DeletePharmacyItem(this.id);
}

// States
abstract class AdminPharmacyState {}

class AdminPharmacyInitial extends AdminPharmacyState {}

class AdminPharmacyLoading extends AdminPharmacyState {}

class AdminPharmacyLoaded extends AdminPharmacyState {
  final List<PharmacyItemEntity> items;
  AdminPharmacyLoaded(this.items);
}

class AdminPharmacyError extends AdminPharmacyState {
  final String message;
  AdminPharmacyError(this.message);
}

// Bloc
class AdminPharmacyBloc extends Bloc<AdminPharmacyEvent, AdminPharmacyState> {
  final GetPharmacyItemsUseCase _getItems;
  final AddPharmacyItemUseCase _addItem;
  final UpdatePharmacyItemUseCase _updateItem;
  final DeletePharmacyItemUseCase _deleteItem;

  AdminPharmacyBloc({
    required GetPharmacyItemsUseCase getItems,
    required AddPharmacyItemUseCase addItem,
    required UpdatePharmacyItemUseCase updateItem,
    required DeletePharmacyItemUseCase deleteItem,
  })  : _getItems = getItems,
        _addItem = addItem,
        _updateItem = updateItem,
        _deleteItem = deleteItem,
        super(AdminPharmacyInitial()) {
    on<LoadPharmacyItems>(_onLoadPharmacyItems);
    on<AddPharmacyItem>(_onAddPharmacyItem);
    on<UpdatePharmacyItemStock>(_onUpdatePharmacyItemStock);
    on<EditPharmacyItem>(_onEditPharmacyItem);
    on<DeletePharmacyItem>(_onDeletePharmacyItem);
  }

  Future<void> _onLoadPharmacyItems(
      LoadPharmacyItems event, Emitter<AdminPharmacyState> emit) async {
    emit(AdminPharmacyLoading());
    final result = await _getItems();
    result.fold(
      (failure) => emit(AdminPharmacyError(failure.message)),
      (items) => emit(AdminPharmacyLoaded(items)),
    );
  }

  Future<void> _onAddPharmacyItem(
      AddPharmacyItem event, Emitter<AdminPharmacyState> emit) async {
    final result = await _addItem(event.data);
    result.fold(
      (failure) => emit(AdminPharmacyError(failure.message)),
      (_) => add(LoadPharmacyItems()),
    );
  }

  Future<void> _onUpdatePharmacyItemStock(
      UpdatePharmacyItemStock event, Emitter<AdminPharmacyState> emit) async {
    final result = await _updateItem(event.id, {'stock': event.stock});
    result.fold(
      (failure) => emit(AdminPharmacyError(failure.message)),
      (_) => add(LoadPharmacyItems()),
    );
  }

  Future<void> _onDeletePharmacyItem(
      DeletePharmacyItem event, Emitter<AdminPharmacyState> emit) async {
    final result = await _deleteItem(event.id);
    result.fold(
      (failure) => emit(AdminPharmacyError(failure.message)),
      (_) => add(LoadPharmacyItems()),
    );
  }

  Future<void> _onEditPharmacyItem(
      EditPharmacyItem event, Emitter<AdminPharmacyState> emit) async {
    final result = await _updateItem(event.id, event.data);
    result.fold(
      (failure) => emit(AdminPharmacyError(failure.message)),
      (_) => add(LoadPharmacyItems()),
    );
  }
}
