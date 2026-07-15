import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:medi_connect/core/constants/env_config.dart';
import 'package:medi_connect/core/dependency_injection/injection.dart';
import 'package:medi_connect/core/services/ad_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AppInitializer {
  static Future<void> init() async {
    WidgetsFlutterBinding.ensureInitialized();

    // Load environment configurations.
    await EnvConfig.initialize();

    // Initialize Supabase.
    await Supabase.initialize(
      url: EnvConfig.apiUrl,
      publishableKey: EnvConfig.apiKey,
    );

    // Initialize automatic dependency injection via Injectable
    await configureDependencies();

    // Initialize AdService (Google Mobile Ads)
    await GetIt.instance<AdService>().initialize();
  }
}
