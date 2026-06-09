/// Dependency injection mappings for the Authentication package.
/// Connects data sources, repositories, use cases, and Blocs to GetIt.
import 'package:get_it/get_it.dart';
import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/core/storage/secure_storage_service.dart';
import 'package:medi_connect/features/auth/data/data_source/auth_remote_datasource.dart';
import 'package:medi_connect/features/auth/data/repository/auth_repository_impl.dart';
import 'package:medi_connect/features/auth/domain/repositories/auth_repository.dart';
import 'package:medi_connect/features/auth/domain/use_cases/forgot_password_usecase.dart';
import 'package:medi_connect/features/auth/domain/use_cases/get_current_user_usecase.dart';
import 'package:medi_connect/features/auth/domain/use_cases/login_usecase.dart';
import 'package:medi_connect/features/auth/domain/use_cases/logout_usecase.dart';
import 'package:medi_connect/features/auth/domain/use_cases/register_usecase.dart';
import 'package:medi_connect/features/auth/domain/use_cases/reset_password_usecase.dart';
import 'package:medi_connect/features/auth/domain/use_cases/verify_otp_usecase.dart';
import 'package:medi_connect/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/features/dash_board/data/data_source/analytics_remote_datasource.dart';
import 'package:medi_connect/features/dash_board/data/repository/analytics_repository_impl.dart';
import 'package:medi_connect/features/dash_board/domain/repositories/analytics_repository.dart';
import 'package:medi_connect/features/dash_board/domain/use_cases/admin_analytics_usecases.dart';
import 'package:medi_connect/features/dash_board/domain/use_cases/get_analytics_usecase.dart';
import 'package:medi_connect/features/dash_board/presentation/bloc/dashboard_analytics_bloc.dart';

/// Configures and registers dependencies for the authentication feature package.
void configureAuthDependencies(GetIt sl) {
  // Remote Datasource
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<SupabaseService>()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      sl<AuthRemoteDataSource>(),
      sl<SecureStorageService>(),
    ),
  );

  // Usecases
  sl.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<RegisterUseCase>(
    () => RegisterUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<VerifyOtpUseCase>(
    () => VerifyOtpUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<ForgotPasswordUseCase>(
    () => ForgotPasswordUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<ResetPasswordUseCase>(
    () => ResetPasswordUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<LogoutUseCase>(
    () => LogoutUseCase(sl<AuthRepository>()),
  );
  sl.registerLazySingleton<GetCurrentUserUseCase>(
    () => GetCurrentUserUseCase(sl<AuthRepository>()),
  );

  // Bloc Factory (always fresh instances on retrieval)
  sl.registerFactory<AuthBloc>(
    () => AuthBloc(
      loginUseCase: sl<LoginUseCase>(),
      registerUseCase: sl<RegisterUseCase>(),
      verifyOtpUseCase: sl<VerifyOtpUseCase>(),
      forgotPasswordUseCase: sl<ForgotPasswordUseCase>(),
      resetPasswordUseCase: sl<ResetPasswordUseCase>(),
      logoutUseCase: sl<LogoutUseCase>(),
      getCurrentUserUseCase: sl<GetCurrentUserUseCase>(),
    ),
  );
}

/// Dependency injection mappings for Analytics.

void configureAnalyticsDependencies(GetIt sl) {
  // Remote Datasource
  if (!sl.isRegistered<AnalyticsRemoteDataSource>()) {
    sl.registerLazySingleton<AnalyticsRemoteDataSource>(
      () => AnalyticsRemoteDataSourceImpl(sl<SupabaseService>()),
    );
  }

  // Repository
  if (!sl.isRegistered<AnalyticsRepository>()) {
    sl.registerLazySingleton<AnalyticsRepository>(
      () => AnalyticsRepositoryImpl(sl<AnalyticsRemoteDataSource>()),
    );
  }

  // Usecases
  if (!sl.isRegistered<GetAnalyticsUseCase>()) {
    sl.registerLazySingleton<GetAnalyticsUseCase>(
      () => GetAnalyticsUseCase(sl<AnalyticsRepository>()),
    );
  }

  sl.registerFactory<DashboardAnalyticsBloc>(
    () => DashboardAnalyticsBloc(
      getDashboardStatsUseCase: sl<GetDashboardStatsUseCase>(),
    ),
  );
  sl.registerLazySingleton<GetDashboardStatsUseCase>(
    () => GetDashboardStatsUseCase(sl<AnalyticsRepository>()),
  );
}
