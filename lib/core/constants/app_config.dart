/// Dependency injection mappings for the Authentication package.
/// Connects data sources, repositories, use cases, and Blocs to GetIt.
library;

import 'package:get_it/get_it.dart';
import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/core/services/secure_storage_service.dart';
import 'package:medi_connect/shared/auth/data/data_source/auth_remote_datasource.dart';
import 'package:medi_connect/shared/auth/data/repository/auth_repository_impl.dart';
import 'package:medi_connect/shared/auth/domain/repositories/auth_repository.dart';
import 'package:medi_connect/shared/auth/domain/use_cases/forgot_password_usecase.dart';
import 'package:medi_connect/shared/auth/domain/use_cases/get_current_user_usecase.dart';
import 'package:medi_connect/shared/auth/domain/use_cases/login_usecase.dart';
import 'package:medi_connect/shared/auth/domain/use_cases/logout_usecase.dart';
import 'package:medi_connect/shared/auth/domain/use_cases/register_usecase.dart';
import 'package:medi_connect/shared/auth/domain/use_cases/reset_password_usecase.dart';
import 'package:medi_connect/shared/auth/domain/use_cases/verify_otp_usecase.dart';
import 'package:medi_connect/shared/auth/presentation/bloc/auth_bloc.dart';
import 'package:medi_connect/shared/dashboard/data/data_source/analytics_remote_datasource.dart';
import 'package:medi_connect/shared/dashboard/data/repository/analytics_repository_impl.dart';
import 'package:medi_connect/shared/dashboard/domain/repositories/analytics_repository.dart';
import 'package:medi_connect/shared/dashboard/domain/use_cases/admin_analytics_usecases.dart';
import 'package:medi_connect/shared/dashboard/domain/use_cases/get_analytics_usecase.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/dashboard_analytics_bloc.dart';
import 'package:medi_connect/modules/management/staff_management/data/datasource/department_remote_datasource.dart';
import 'package:medi_connect/modules/management/staff_management/data/datasource/doctor_staff_remote_datasource.dart';
import 'package:medi_connect/modules/management/staff_management/data/repositories/department_repository_impl.dart';
import 'package:medi_connect/modules/management/staff_management/data/repositories/doctor_staff_repository_impl.dart';
import 'package:medi_connect/modules/management/staff_management/domain/repositories/department_repository.dart';
import 'package:medi_connect/modules/management/staff_management/domain/repositories/doctor_staff_repository.dart';
import 'package:medi_connect/modules/management/staff_management/domain/use_cases/add_department_usecase.dart';
import 'package:medi_connect/modules/management/staff_management/domain/use_cases/delete_department_usecase.dart';
import 'package:medi_connect/modules/management/staff_management/domain/use_cases/get_departments_usecase.dart';
import 'package:medi_connect/modules/management/staff_management/domain/use_cases/update_department_usecase.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/department_bloc.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/doctor_staff_bloc.dart';
import 'package:medi_connect/core/constants/departments_config.dart';
import 'package:medi_connect/modules/management/patient_management/data/datasource/patient_remote_datasource.dart';
import 'package:medi_connect/modules/management/patient_management/data/repositories/patient_repository_impl.dart';
import 'package:medi_connect/modules/management/patient_management/domain/repositories/patient_repository.dart';
import 'package:medi_connect/modules/management/patient_management/presentation/bloc/patient_bloc.dart';
import 'package:medi_connect/shared/dashboard/data/data_source/admin_operations_remote_datasource.dart';
import 'package:medi_connect/shared/dashboard/data/repository/admin_operations_repository_impl.dart';
import 'package:medi_connect/shared/dashboard/domain/repositories/admin_operations_repository.dart';
import 'package:medi_connect/shared/dashboard/domain/use_cases/admin_operations_usecases.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_pharmacy_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_labs_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_attendance_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_emergencies_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_billing_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_settings_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_recent_activity_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/admin/admin_appointments_bloc.dart';
import 'package:medi_connect/shared/dashboard/presentation/bloc/doctor/doctor_appointments_bloc.dart';

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

void configureDepartmentDependencies(GetIt sl) {
  // Remote Datasource
  if (!sl.isRegistered<DepartmentRemoteDataSource>()) {
    sl.registerLazySingleton<DepartmentRemoteDataSource>(
      () => DepartmentRemoteDataSourceImpl(sl<SupabaseService>()),
    );
  }
  if (!sl.isRegistered<DoctorStaffRemoteDataSource>()) {
    sl.registerLazySingleton<DoctorStaffRemoteDataSource>(
      () => DoctorStaffRemoteDataSourceImpl(sl<SupabaseService>()),
    );
  }

  // Repository
  if (!sl.isRegistered<DepartmentRepository>()) {
    sl.registerLazySingleton<DepartmentRepository>(
      () => DepartmentRepositoryImpl(sl<DepartmentRemoteDataSource>()),
    );
  }
  if (!sl.isRegistered<DoctorStaffRepository>()) {
    sl.registerLazySingleton<DoctorStaffRepository>(
      () => DoctorStaffRepositoryImpl(sl<DoctorStaffRemoteDataSource>()),
    );
  }

  // UseCases
  if (!sl.isRegistered<GetDepartmentsUseCase>()) {
    sl.registerLazySingleton<GetDepartmentsUseCase>(
      () => GetDepartmentsUseCase(sl<DepartmentRepository>()),
    );
  }

  if (!sl.isRegistered<AddDepartmentUseCase>()) {
    sl.registerLazySingleton<AddDepartmentUseCase>(
      () => AddDepartmentUseCase(sl<DepartmentRepository>()),
    );
  }

  if (!sl.isRegistered<UpdateDepartmentUseCase>()) {
    sl.registerLazySingleton<UpdateDepartmentUseCase>(
      () => UpdateDepartmentUseCase(sl<DepartmentRepository>()),
    );
  }

  if (!sl.isRegistered<DeleteDepartmentUseCase>()) {
    sl.registerLazySingleton<DeleteDepartmentUseCase>(
      () => DeleteDepartmentUseCase(sl<DepartmentRepository>()),
    );
  }

  // Bloc
  if (!sl.isRegistered<DepartmentBloc>()) {
    sl.registerFactory<DepartmentBloc>(
      () => DepartmentBloc(
        getDepartments: sl<GetDepartmentsUseCase>(),
        addDepartment: sl<AddDepartmentUseCase>(),
        updateDepartment: sl<UpdateDepartmentUseCase>(),
        deleteDepartment: sl<DeleteDepartmentUseCase>(),
      ),
    );
  }
  if (!sl.isRegistered<DoctorStaffBloc>()) {
    sl.registerFactory<DoctorStaffBloc>(
      () => DoctorStaffBloc(sl<DoctorStaffRepository>()),
    );
  }

  // Register all 24 departments
  configureAllDepartmentsDependencies(sl);
}

void configurePatientDependencies(GetIt sl) {
  if (!sl.isRegistered<PatientRemoteDataSource>()) {
    sl.registerLazySingleton<PatientRemoteDataSource>(
      () => PatientRemoteDataSourceImpl(sl<SupabaseService>()),
    );
  }
  if (!sl.isRegistered<PatientRepository>()) {
    sl.registerLazySingleton<PatientRepository>(
      () => PatientRepositoryImpl(sl<PatientRemoteDataSource>()),
    );
  }
  if (!sl.isRegistered<PatientBloc>()) {
    sl.registerFactory<PatientBloc>(() => PatientBloc(sl<PatientRepository>()));
  }
}

void configureAdminOperationsDependencies(GetIt sl) {
  // Remote Datasource
  if (!sl.isRegistered<AdminOperationsRemoteDataSource>()) {
    sl.registerLazySingleton<AdminOperationsRemoteDataSource>(
      () => AdminOperationsRemoteDataSourceImpl(sl<SupabaseService>()),
    );
  }

  // Repository
  if (!sl.isRegistered<AdminOperationsRepository>()) {
    sl.registerLazySingleton<AdminOperationsRepository>(
      () =>
          AdminOperationsRepositoryImpl(sl<AdminOperationsRemoteDataSource>()),
    );
  }

  // UseCases
  sl.registerLazySingleton<GetPharmacyItemsUseCase>(
    () => GetPharmacyItemsUseCase(sl<AdminOperationsRepository>()),
  );
  sl.registerLazySingleton<AddPharmacyItemUseCase>(
    () => AddPharmacyItemUseCase(sl<AdminOperationsRepository>()),
  );
  sl.registerLazySingleton<UpdatePharmacyItemUseCase>(
    () => UpdatePharmacyItemUseCase(sl<AdminOperationsRepository>()),
  );
  sl.registerLazySingleton<DeletePharmacyItemUseCase>(
    () => DeletePharmacyItemUseCase(sl<AdminOperationsRepository>()),
  );

  sl.registerLazySingleton<GetLabTestsUseCase>(
    () => GetLabTestsUseCase(sl<AdminOperationsRepository>()),
  );
  sl.registerLazySingleton<AddLabTestUseCase>(
    () => AddLabTestUseCase(sl<AdminOperationsRepository>()),
  );
  sl.registerLazySingleton<UpdateLabTestStatusUseCase>(
    () => UpdateLabTestStatusUseCase(sl<AdminOperationsRepository>()),
  );

  sl.registerLazySingleton<GetStaffAttendanceUseCase>(
    () => GetStaffAttendanceUseCase(sl<AdminOperationsRepository>()),
  );
  sl.registerLazySingleton<UpdateAttendanceStatusUseCase>(
    () => UpdateAttendanceStatusUseCase(sl<AdminOperationsRepository>()),
  );

  sl.registerLazySingleton<GetEmergenciesUseCase>(
    () => GetEmergenciesUseCase(sl<AdminOperationsRepository>()),
  );
  sl.registerLazySingleton<TriggerEmergencyUseCase>(
    () => TriggerEmergencyUseCase(sl<AdminOperationsRepository>()),
  );
  sl.registerLazySingleton<ResolveEmergencyUseCase>(
    () => ResolveEmergencyUseCase(sl<AdminOperationsRepository>()),
  );

  sl.registerLazySingleton<GetActivityLogsUseCase>(
    () => GetActivityLogsUseCase(sl<AdminOperationsRepository>()),
  );

  sl.registerLazySingleton<GetInvoicesUseCase>(
    () => GetInvoicesUseCase(sl<AdminOperationsRepository>()),
  );
  sl.registerLazySingleton<GetBillingSummaryUseCase>(
    () => GetBillingSummaryUseCase(sl<AdminOperationsRepository>()),
  );
  sl.registerLazySingleton<CreateInvoiceUseCase>(
    () => CreateInvoiceUseCase(sl<AdminOperationsRepository>()),
  );

  sl.registerLazySingleton<GetAdminSettingsUseCase>(
    () => GetAdminSettingsUseCase(sl<AdminOperationsRepository>()),
  );
  sl.registerLazySingleton<UpdateAdminSettingUseCase>(
    () => UpdateAdminSettingUseCase(sl<AdminOperationsRepository>()),
  );

  sl.registerLazySingleton<GetAppointmentsUseCase>(
    () => GetAppointmentsUseCase(sl<AdminOperationsRepository>()),
  );
  sl.registerLazySingleton<CreateAppointmentUseCase>(
    () => CreateAppointmentUseCase(sl<AdminOperationsRepository>()),
  );
  sl.registerLazySingleton<UpdateAppointmentStatusUseCase>(
    () => UpdateAppointmentStatusUseCase(sl<AdminOperationsRepository>()),
  );
  sl.registerLazySingleton<UpdateAppointmentVitalsUseCase>(
    () => UpdateAppointmentVitalsUseCase(sl<AdminOperationsRepository>()),
  );

  // Blocs
  sl.registerFactory<AdminPharmacyBloc>(
    () => AdminPharmacyBloc(
      getItems: sl<GetPharmacyItemsUseCase>(),
      addItem: sl<AddPharmacyItemUseCase>(),
      updateItem: sl<UpdatePharmacyItemUseCase>(),
      deleteItem: sl<DeletePharmacyItemUseCase>(),
    ),
  );

  sl.registerFactory<AdminLabsBloc>(
    () => AdminLabsBloc(
      getTests: sl<GetLabTestsUseCase>(),
      addTest: sl<AddLabTestUseCase>(),
      updateStatus: sl<UpdateLabTestStatusUseCase>(),
    ),
  );

  sl.registerFactory<AdminAttendanceBloc>(
    () => AdminAttendanceBloc(
      getAttendance: sl<GetStaffAttendanceUseCase>(),
      updateStatus: sl<UpdateAttendanceStatusUseCase>(),
    ),
  );

  sl.registerFactory<AdminEmergenciesBloc>(
    () => AdminEmergenciesBloc(
      getEmergencies: sl<GetEmergenciesUseCase>(),
      trigger: sl<TriggerEmergencyUseCase>(),
      resolve: sl<ResolveEmergencyUseCase>(),
    ),
  );

  sl.registerFactory<AdminBillingBloc>(
    () => AdminBillingBloc(
      getInvoices: sl<GetInvoicesUseCase>(),
      getSummary: sl<GetBillingSummaryUseCase>(),
      createInvoice: sl<CreateInvoiceUseCase>(),
    ),
  );

  sl.registerFactory<AdminSettingsBloc>(
    () => AdminSettingsBloc(
      getSettings: sl<GetAdminSettingsUseCase>(),
      updateSetting: sl<UpdateAdminSettingUseCase>(),
    ),
  );

  sl.registerFactory<AdminRecentActivityBloc>(
    () =>
        AdminRecentActivityBloc(getActivityLogs: sl<GetActivityLogsUseCase>()),
  );

  sl.registerLazySingleton<AdminAppointmentsBloc>(
    () => AdminAppointmentsBloc(
      getAppointments: sl<GetAppointmentsUseCase>(),
      createAppointment: sl<CreateAppointmentUseCase>(),
      updateStatus: sl<UpdateAppointmentStatusUseCase>(),
      updateVitals: sl<UpdateAppointmentVitalsUseCase>(),
    ),
  );

  sl.registerLazySingleton<DoctorAppointmentsBloc>(
    () => DoctorAppointmentsBloc(
      getAppointments: sl<GetAppointmentsUseCase>(),
      createAppointment: sl<CreateAppointmentUseCase>(),
      updateStatus: sl<UpdateAppointmentStatusUseCase>(),
      updateVitals: sl<UpdateAppointmentVitalsUseCase>(),
    ),
  );
}
