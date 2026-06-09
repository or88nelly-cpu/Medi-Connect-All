import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class EnvConfig {
  static String _apiKey = 'sb_publishable_AHQA5xSNUg0vwHTGbdskHA_n6MD9Qdz';
  static String _apiUrl = 'https://ldxsdyvmfayxuaczmtuu.supabase.co';
  static String _storageUrl =
      'https://ldxsdyvmfayxuaczmtuu.storage.supabase.co/storage/v1/s3';
  static String _storageBucket = 'medi_connect_store';

  static String get apiKey => _apiKey;
  static String get apiUrl => _apiUrl;
  static String get storageUrl => _storageUrl;
  static String get storageBucket => _storageBucket;

  /// Loads configuration values. Checks secure storage first, otherwise parses .env and caches them.
  static Future<void> initialize() async {
    const secureStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );

    try {
      final cachedKey = await secureStorage.read(key: 'SUPABASE_API_KEY');
      if (cachedKey != null && cachedKey.isNotEmpty) {
        _apiKey = cachedKey;
        _apiUrl = await secureStorage.read(key: 'SUPABASE_API_URL') ?? _apiUrl;
        _storageUrl =
            await secureStorage.read(key: 'SUPABASE_STORAGE_URL') ??
            _storageUrl;
        _storageBucket =
            await secureStorage.read(key: 'SUPABASE_STORAGE_BUCKET') ??
            _storageBucket;
      } else {
        // Fallback: Parse .env and save to Secure Storage
        await _loadFromEnvFile();
        await secureStorage.write(key: 'SUPABASE_API_KEY', value: _apiKey);
        await secureStorage.write(key: 'SUPABASE_API_URL', value: _apiUrl);
        await secureStorage.write(
          key: 'SUPABASE_STORAGE_URL',
          value: _storageUrl,
        );
        await secureStorage.write(
          key: 'SUPABASE_STORAGE_BUCKET',
          value: _storageBucket,
        );
      }
    } catch (e) {
      // If secure storage read fails (e.g. platform channel not ready), parse directly from .env file
      await _loadFromEnvFile();
    }
  }

  static Future<void> _loadFromEnvFile() async {
    try {
      final content = await rootBundle.loadString('packages/core/assets/.env');
      final lines = content.split('\n');
      for (var line in lines) {
        line = line.trim();
        if (line.isEmpty || line.startsWith('#')) continue;
        final parts = line.split('=');
        if (parts.length >= 2) {
          final key = parts[0].trim();
          final val = parts.sublist(1).join('=').trim();
          switch (key) {
            case 'SUPABASE_API_KEY':
              _apiKey = val;
              break;
            case 'SUPABASE_API_URL':
              _apiUrl = val;
              break;
            case 'SUPABASE_STORAGE_URL':
              _storageUrl = val;
              break;
            case 'SUPABASE_STORAGE_BUCKET':
              _storageBucket = val;
              break;
          }
        }
      }
    } catch (_) {
      // Fallback to compiled-in default constants
    }
  }

  EnvConfig._();
}
