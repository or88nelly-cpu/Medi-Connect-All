/// Service wrapper for secure key-value local storage.
/// Used to store tokens, session information, and sensitive user preferences.
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  /// Write sensitive string data.
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Read sensitive string data.
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// Delete key from storage.
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Wipe all data stored in secure storage.
  Future<void> clear() async {
    await _storage.deleteAll();
  }
}
