import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:medi_connect/core/app_config.dart';
import 'package:medi_connect/core/core_config.dart';
import 'package:medi_connect/core/env_config.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppInitializer {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Load environment configurations.
    await EnvConfig.initialize();

    // Initialize Supabase.
    await Supabase.initialize(
      url: EnvConfig.apiUrl,
      //   anonKey: EnvConfig.apiKey,
      publishableKey: EnvConfig.apiKey,
    );

    final sl = GetIt.instance;

    // Initialize Core and Feature dependencies.
    await configureCoreDependencies(
      sl,
      supabaseClient: Supabase.instance.client,
    );
    configureAuthDependencies(sl);
    configureAnalyticsDependencies(sl);
  }
}
