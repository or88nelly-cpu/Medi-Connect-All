import 'package:get_it/get_it.dart';
import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/core/network/unique_id_service.dart';
import 'package:medi_connect/core/router/route_guards.dart';
import 'package:medi_connect/core/storage/secure_storage_service.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

/// Central Service Locator instance.
final GetIt getIt = GetIt.instance;

/// Configures and registers all foundational dependencies.
/// Accepts an external SupabaseClient configuration.
Future<void> configureCoreDependencies(
  GetIt sl, {
  required SupabaseClient supabaseClient,
}) async {
  // Register Supabase Client
  sl.registerLazySingleton<SupabaseClient>(() => supabaseClient);

  // Register Supabase Service Wrapper
  sl.registerLazySingleton<SupabaseService>(
    () => SupabaseService(sl<SupabaseClient>()),
  );

  // Register UniqueId Service
  sl.registerLazySingleton<UniqueIdService>(
    () => UniqueIdService(sl<SupabaseService>()),
  );

  // Register Secure Storage
  sl.registerLazySingleton<SecureStorageService>(() => SecureStorageService());

  // Register Routing Guards
  sl.registerLazySingleton<RouteGuards>(
    () => RouteGuards(sl<SupabaseService>(), sl<SecureStorageService>()),
  );
}
