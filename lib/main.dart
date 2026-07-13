import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:medi_connect/core/constants/app_router.dart';
import 'package:medi_connect/core/functions/app_responsive.dart';
import 'package:medi_connect/core/theme/app_theme.dart';
import 'package:medi_connect/core/theme/theme_cubit.dart';

import 'package:medi_connect/bootstrap/app_initializer.dart';
import 'package:medi_connect/bootstrap/dependency_injection.dart';import 'package:sentry_flutter/sentry_flutter.dart';


void main() async {
  await AppInitializer.init();
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://82ef6c388c737bf706ad27b2681400df@o4511729566810112.ingest.de.sentry.io/4511729574215760';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      // The sampling rate for profiling is relative to tracesSampleRate
      // Setting to 1.0 will profile 100% of sampled transactions:
      options.profilesSampleRate = 1.0;
    },
    appRunner: () => runApp(SentryWidget(child: const MyApp())),
  );
  // TODO: Remove this line after sending the first sample event to sentry.
  await Sentry.captureException(Exception('This is a sample exception.'));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = AppRouterConfig.buildRouter();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: AppProviders.getProviders(),
      child: ScreenUtilInit(
        designSize: AppResponsive.getDesignSize(
          context,
        ), // Premium device base reference
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return MaterialApp.router(
                title: 'Medi-Connect Admin',
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeMode,
                routerConfig: _router,
                debugShowCheckedModeBanner: false,
              );
            },
          );
        },
      ),
    );
  }
}
