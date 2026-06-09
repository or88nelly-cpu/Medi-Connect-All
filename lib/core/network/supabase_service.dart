/// Service wrapper around the Supabase Flutter client.
/// Exposes properties and helpers for Authentication, PostgreSQL, Storage, Realtime,
/// and facilitates Row Level Security (RLS) policies.
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class SupabaseService {
  final SupabaseClient _client;

  SupabaseService(this._client);

  /// Direct client access for custom/advanced queries.
  SupabaseClient get client => _client;

  /// Authentication client.
  GoTrueClient get auth => _client.auth;

  /// PostgreSQL Rest client for table operations.
  SupabaseQueryBuilder from(String tableName) => _client.from(tableName);

  /// Storage client.
  SupabaseStorageClient get storage => _client.storage;

  /// Realtime channel subscription helper.
  RealtimeChannel channel(String name) => _client.channel(name);

  /// Helper to check if a user is currently authenticated.
  bool get isAuthenticated => _client.auth.currentSession != null;

  /// Helper to get current user details.
  User? get currentUser => _client.auth.currentUser;

  /// Helper to get authorization token.
  String? get accessToken => _client.auth.currentSession?.accessToken;
}
