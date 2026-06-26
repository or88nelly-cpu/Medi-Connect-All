import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_connect/core/services/secure_storage_service.dart';

class ThemeCubit extends Cubit<ThemeMode> {
  final SecureStorageService _storageService;
  static const String _themeKey = 'app_theme_mode';

  ThemeCubit(this._storageService) : super(ThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    try {
      final savedTheme = await _storageService.read(_themeKey);
      if (savedTheme != null) {
        if (savedTheme == 'light') {
          emit(ThemeMode.light);
        } else if (savedTheme == 'dark') {
          emit(ThemeMode.dark);
        } else {
          emit(ThemeMode.system);
        }
      }
    } catch (_) {
      // Fallback silently to system default
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    emit(mode);
    try {
      String value = 'system';
      if (mode == ThemeMode.light) {
        value = 'light';
      } else if (mode == ThemeMode.dark) {
        value = 'dark';
      }
      await _storageService.write(_themeKey, value);
    } catch (_) {}
  }
}
