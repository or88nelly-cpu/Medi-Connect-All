import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/features/dash_board/domain/use_cases/admin_operations_usecases.dart';

// Events
abstract class AdminSettingsEvent {}

class LoadAdminSettings extends AdminSettingsEvent {}

class UpdateAdminSetting extends AdminSettingsEvent {
  final String key;
  final dynamic value;
  UpdateAdminSetting(this.key, this.value);
}

// States
abstract class AdminSettingsState {}

class AdminSettingsInitial extends AdminSettingsState {}

class AdminSettingsLoading extends AdminSettingsState {}

class AdminSettingsLoaded extends AdminSettingsState {
  final Map<String, dynamic> settings;
  AdminSettingsLoaded(this.settings);
}

class AdminSettingsError extends AdminSettingsState {
  final String message;
  AdminSettingsError(this.message);
}

// Bloc
class AdminSettingsBloc extends Bloc<AdminSettingsEvent, AdminSettingsState> {
  final GetAdminSettingsUseCase _getSettings;
  final UpdateAdminSettingUseCase _updateSetting;

  AdminSettingsBloc({
    required GetAdminSettingsUseCase getSettings,
    required UpdateAdminSettingUseCase updateSetting,
  })  : _getSettings = getSettings,
        _updateSetting = updateSetting,
        super(AdminSettingsInitial()) {
    on<LoadAdminSettings>(_onLoadAdminSettings);
    on<UpdateAdminSetting>(_onUpdateAdminSetting);
  }

  Future<void> _onLoadAdminSettings(
      LoadAdminSettings event, Emitter<AdminSettingsState> emit) async {
    emit(AdminSettingsLoading());
    final result = await _getSettings();
    result.fold(
      (failure) => emit(AdminSettingsError(failure.message)),
      (settings) => emit(AdminSettingsLoaded(settings)),
    );
  }

  Future<void> _onUpdateAdminSetting(
      UpdateAdminSetting event, Emitter<AdminSettingsState> emit) async {
    final result = await _updateSetting(event.key, event.value);
    result.fold(
      (failure) => emit(AdminSettingsError(failure.message)),
      (_) => add(LoadAdminSettings()),
    );
  }
}
