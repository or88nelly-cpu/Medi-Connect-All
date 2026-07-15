// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:supabase_flutter/supabase_flutter.dart' as _i454;

import '../../features/admin/billing_management/data/datasource/finance_remote_datasource.dart'
    as _i515;
import '../../features/admin/billing_management/data/repositories/finance_repository_impl.dart'
    as _i516;
import '../../features/admin/billing_management/domain/repositories/finance_repository.dart'
    as _i184;
import '../../features/admin/billing_management/domain/usecases/get_finance_stats_usecase.dart'
    as _i977;
import '../../features/admin/billing_management/presentation/bloc/finance_bloc.dart'
    as _i929;
import '../../features/admin/consultation_management/data/datasource/dyalisis_remote_datasource.dart'
    as _i502;
import '../../features/admin/consultation_management/data/datasource/emrd_remote_datasource.dart'
    as _i28;
import '../../features/admin/consultation_management/data/datasource/physio_therapy_remote_datasource.dart'
    as _i39;
import '../../features/admin/consultation_management/data/repositories/dyalisis_repository_impl.dart'
    as _i327;
import '../../features/admin/consultation_management/data/repositories/emrd_repository_impl.dart'
    as _i2;
import '../../features/admin/consultation_management/data/repositories/physio_therapy_repository_impl.dart'
    as _i861;
import '../../features/admin/consultation_management/domain/repositories/dyalisis_repository.dart'
    as _i106;
import '../../features/admin/consultation_management/domain/repositories/emrd_repository.dart'
    as _i413;
import '../../features/admin/consultation_management/domain/repositories/physio_therapy_repository.dart'
    as _i109;
import '../../features/admin/consultation_management/domain/usecases/get_dyalisis_stats_usecase.dart'
    as _i27;
import '../../features/admin/consultation_management/domain/usecases/get_emr_records_usecase.dart'
    as _i954;
import '../../features/admin/consultation_management/domain/usecases/get_emrd_stats_usecase.dart'
    as _i544;
import '../../features/admin/consultation_management/domain/usecases/get_physio_therapy_stats_usecase.dart'
    as _i333;
import '../../features/admin/consultation_management/presentation/bloc/dyalisis_bloc.dart'
    as _i75;
import '../../features/admin/consultation_management/presentation/bloc/emrd_bloc.dart'
    as _i854;
import '../../features/admin/consultation_management/presentation/bloc/physio_therapy_bloc.dart'
    as _i430;
import '../../features/admin/customer_care/data/datasource/customer_care_remote_datasource.dart'
    as _i221;
import '../../features/admin/customer_care/data/datasource/marketing_remote_datasource.dart'
    as _i442;
import '../../features/admin/customer_care/data/repositories/customer_care_repository_impl.dart'
    as _i347;
import '../../features/admin/customer_care/data/repositories/marketing_repository_impl.dart'
    as _i922;
import '../../features/admin/customer_care/domain/repositories/customer_care_repository.dart'
    as _i464;
import '../../features/admin/customer_care/domain/repositories/marketing_repository.dart'
    as _i968;
import '../../features/admin/customer_care/domain/usecases/get_customer_care_stats_usecase.dart'
    as _i339;
import '../../features/admin/customer_care/domain/usecases/get_marketing_stats_usecase.dart'
    as _i796;
import '../../features/admin/customer_care/presentation/bloc/customer_care_bloc.dart'
    as _i899;
import '../../features/admin/customer_care/presentation/bloc/marketing_bloc.dart'
    as _i357;
import '../../features/admin/customer_care/presentation/bloc/patient_registration_bloc.dart'
    as _i266;
import '../../features/admin/equipment_management/data/datasource/biomedical_engineering_remote_datasource.dart'
    as _i97;
import '../../features/admin/equipment_management/data/datasource/cssd_remote_datasource.dart'
    as _i805;
import '../../features/admin/equipment_management/data/datasource/mep_engineer_remote_datasource.dart'
    as _i523;
import '../../features/admin/equipment_management/data/repositories/biomedical_engineering_repository_impl.dart'
    as _i458;
import '../../features/admin/equipment_management/data/repositories/cssd_repository_impl.dart'
    as _i819;
import '../../features/admin/equipment_management/data/repositories/mep_engineer_repository_impl.dart'
    as _i345;
import '../../features/admin/equipment_management/domain/repositories/biomedical_engineering_repository.dart'
    as _i1012;
import '../../features/admin/equipment_management/domain/repositories/cssd_repository.dart'
    as _i763;
import '../../features/admin/equipment_management/domain/repositories/mep_engineer_repository.dart'
    as _i9;
import '../../features/admin/equipment_management/domain/usecases/get_biomedical_engineering_stats_usecase.dart'
    as _i80;
import '../../features/admin/equipment_management/domain/usecases/get_cssd_stats_usecase.dart'
    as _i53;
import '../../features/admin/equipment_management/domain/usecases/get_mep_engineer_stats_usecase.dart'
    as _i38;
import '../../features/admin/equipment_management/presentation/bloc/biomedical_engineering_bloc.dart'
    as _i708;
import '../../features/admin/equipment_management/presentation/bloc/cssd_bloc.dart'
    as _i1005;
import '../../features/admin/equipment_management/presentation/bloc/mep_engineer_bloc.dart'
    as _i328;
import '../../features/admin/inventory_management/data/datasource/general_store_remote_datasource.dart'
    as _i407;
import '../../features/admin/inventory_management/data/datasource/purchase_remote_datasource.dart'
    as _i525;
import '../../features/admin/inventory_management/data/repositories/general_store_repository_impl.dart'
    as _i1055;
import '../../features/admin/inventory_management/data/repositories/purchase_repository_impl.dart'
    as _i34;
import '../../features/admin/inventory_management/domain/repositories/general_store_repository.dart'
    as _i13;
import '../../features/admin/inventory_management/domain/repositories/purchase_repository.dart'
    as _i231;
import '../../features/admin/inventory_management/domain/usecases/get_general_store_stats_usecase.dart'
    as _i1056;
import '../../features/admin/inventory_management/domain/usecases/get_purchase_stats_usecase.dart'
    as _i503;
import '../../features/admin/inventory_management/presentation/bloc/general_store_bloc.dart'
    as _i214;
import '../../features/admin/inventory_management/presentation/bloc/purchase_bloc.dart'
    as _i579;
import '../../features/admin/laboratory_management/data/datasource/laboratory_remote_datasource.dart'
    as _i416;
import '../../features/admin/laboratory_management/data/datasource/radiology_remote_datasource.dart'
    as _i773;
import '../../features/admin/laboratory_management/data/repositories/laboratory_repository_impl.dart'
    as _i710;
import '../../features/admin/laboratory_management/data/repositories/radiology_repository_impl.dart'
    as _i606;
import '../../features/admin/laboratory_management/domain/repositories/laboratory_repository.dart'
    as _i112;
import '../../features/admin/laboratory_management/domain/repositories/radiology_repository.dart'
    as _i685;
import '../../features/admin/laboratory_management/domain/usecases/get_laboratory_stats_usecase.dart'
    as _i205;
import '../../features/admin/laboratory_management/domain/usecases/get_radiology_stats_usecase.dart'
    as _i981;
import '../../features/admin/laboratory_management/presentation/bloc/laboratory_bloc.dart'
    as _i792;
import '../../features/admin/laboratory_management/presentation/bloc/radiology_bloc.dart'
    as _i984;
import '../../features/admin/patient_management/data/datasource/patient_remote_datasource.dart'
    as _i356;
import '../../features/admin/patient_management/data/repositories/patient_repository_impl.dart'
    as _i168;
import '../../features/admin/patient_management/domain/repositories/patient_repository.dart'
    as _i11;
import '../../features/admin/patient_management/presentation/bloc/patient_bloc.dart'
    as _i98;
import '../../features/admin/pharmacy_management/data/datasource/pharmacy_remote_datasource.dart'
    as _i668;
import '../../features/admin/pharmacy_management/data/repositories/pharmacy_repository_impl.dart'
    as _i358;
import '../../features/admin/pharmacy_management/domain/repositories/pharmacy_repository.dart'
    as _i716;
import '../../features/admin/pharmacy_management/domain/usecases/get_pharmacy_stats_usecase.dart'
    as _i115;
import '../../features/admin/pharmacy_management/presentation/bloc/pharmacy_bloc.dart'
    as _i1023;
import '../../features/admin/queue_management/data/datasource/casuality_remote_datasource.dart'
    as _i907;
import '../../features/admin/queue_management/data/repositories/casuality_repository_impl.dart'
    as _i1025;
import '../../features/admin/queue_management/domain/repositories/casuality_repository.dart'
    as _i928;
import '../../features/admin/queue_management/domain/usecases/get_casuality_stats_usecase.dart'
    as _i469;
import '../../features/admin/queue_management/presentation/bloc/casuality_bloc.dart'
    as _i220;
import '../../features/admin/report_management/data/datasource/management_information_system_remote_datasource.dart'
    as _i659;
import '../../features/admin/report_management/data/repositories/management_information_system_repository_impl.dart'
    as _i42;
import '../../features/admin/report_management/domain/repositories/management_information_system_repository.dart'
    as _i451;
import '../../features/admin/report_management/domain/usecases/get_management_information_system_stats_usecase.dart'
    as _i755;
import '../../features/admin/report_management/presentation/bloc/management_information_system_bloc.dart'
    as _i244;
import '../../features/admin/room_management/data/datasource/operation_theatre_remote_datasource.dart'
    as _i103;
import '../../features/admin/room_management/data/repositories/operation_theatre_repository_impl.dart'
    as _i568;
import '../../features/admin/room_management/domain/repositories/operation_theatre_repository.dart'
    as _i856;
import '../../features/admin/room_management/domain/usecases/get_operation_theatre_stats_usecase.dart'
    as _i770;
import '../../features/admin/room_management/presentation/bloc/operation_theatre_bloc.dart'
    as _i786;
import '../../features/admin/settings_management/data/datasource/fire_safety_remote_datasource.dart'
    as _i955;
import '../../features/admin/settings_management/data/datasource/information_technology_remote_datasource.dart'
    as _i924;
import '../../features/admin/settings_management/data/repositories/fire_safety_repository_impl.dart'
    as _i489;
import '../../features/admin/settings_management/data/repositories/information_technology_repository_impl.dart'
    as _i1003;
import '../../features/admin/settings_management/domain/repositories/fire_safety_repository.dart'
    as _i271;
import '../../features/admin/settings_management/domain/repositories/information_technology_repository.dart'
    as _i536;
import '../../features/admin/settings_management/domain/usecases/get_fire_safety_stats_usecase.dart'
    as _i751;
import '../../features/admin/settings_management/domain/usecases/get_information_technology_stats_usecase.dart'
    as _i319;
import '../../features/admin/settings_management/presentation/bloc/fire_safety_bloc.dart'
    as _i40;
import '../../features/admin/settings_management/presentation/bloc/information_technology_bloc.dart'
    as _i871;
import '../../features/admin/staff_management/data/datasource/department_remote_datasource.dart'
    as _i576;
import '../../features/admin/staff_management/data/datasource/doctor_staff_remote_datasource.dart'
    as _i656;
import '../../features/admin/staff_management/data/datasource/human_resource_remote_datasource.dart'
    as _i872;
import '../../features/admin/staff_management/data/datasource/nursing_remote_datasource.dart'
    as _i1014;
import '../../features/admin/staff_management/data/repositories/department_repository_impl.dart'
    as _i234;
import '../../features/admin/staff_management/data/repositories/doctor_staff_repository_impl.dart'
    as _i963;
import '../../features/admin/staff_management/data/repositories/human_resource_repository_impl.dart'
    as _i1000;
import '../../features/admin/staff_management/data/repositories/nursing_repository_impl.dart'
    as _i994;
import '../../features/admin/staff_management/domain/repositories/department_repository.dart'
    as _i691;
import '../../features/admin/staff_management/domain/repositories/doctor_staff_repository.dart'
    as _i1020;
import '../../features/admin/staff_management/domain/repositories/human_resource_repository.dart'
    as _i401;
import '../../features/admin/staff_management/domain/repositories/nursing_repository.dart'
    as _i554;
import '../../features/admin/staff_management/domain/use_cases/add_department_usecase.dart'
    as _i123;
import '../../features/admin/staff_management/domain/use_cases/delete_department_usecase.dart'
    as _i920;
import '../../features/admin/staff_management/domain/use_cases/get_departments_usecase.dart'
    as _i932;
import '../../features/admin/staff_management/domain/use_cases/update_department_usecase.dart'
    as _i695;
import '../../features/admin/staff_management/domain/usecases/get_human_resource_stats_usecase.dart'
    as _i465;
import '../../features/admin/staff_management/domain/usecases/get_nursing_stats_usecase.dart'
    as _i828;
import '../../features/admin/staff_management/presentation/bloc/department_bloc.dart'
    as _i622;
import '../../features/admin/staff_management/presentation/bloc/doctor_staff_bloc.dart'
    as _i100;
import '../../features/admin/staff_management/presentation/bloc/human_resource_bloc.dart'
    as _i843;
import '../../features/admin/staff_management/presentation/bloc/nursing_bloc.dart'
    as _i251;
import '../../features/admin/ward_management/data/datasource/icu_remote_datasource.dart'
    as _i595;
import '../../features/admin/ward_management/data/datasource/nutrition_and_diabetics_remote_datasource.dart'
    as _i829;
import '../../features/admin/ward_management/data/datasource/ward_remote_datasource.dart'
    as _i391;
import '../../features/admin/ward_management/data/repositories/icu_repository_impl.dart'
    as _i657;
import '../../features/admin/ward_management/data/repositories/nutrition_and_diabetics_repository_impl.dart'
    as _i790;
import '../../features/admin/ward_management/data/repositories/ward_repository_impl.dart'
    as _i176;
import '../../features/admin/ward_management/domain/repositories/icu_repository.dart'
    as _i704;
import '../../features/admin/ward_management/domain/repositories/nutrition_and_diabetics_repository.dart'
    as _i772;
import '../../features/admin/ward_management/domain/repositories/ward_repository.dart'
    as _i823;
import '../../features/admin/ward_management/domain/usecases/get_icu_stats_usecase.dart'
    as _i530;
import '../../features/admin/ward_management/domain/usecases/get_nutrition_and_diabetics_stats_usecase.dart'
    as _i443;
import '../../features/admin/ward_management/domain/usecases/get_ward_stats_usecase.dart'
    as _i646;
import '../../features/admin/ward_management/presentation/bloc/icu_bloc.dart'
    as _i847;
import '../../features/admin/ward_management/presentation/bloc/nutrition_and_diabetics_bloc.dart'
    as _i295;
import '../../features/admin/ward_management/presentation/bloc/ward_bloc.dart'
    as _i1004;
import '../../features/authentication/data/data_source/auth_remote_datasource.dart'
    as _i227;
import '../../features/authentication/data/repositories/user_details_repository_impl.dart'
    as _i1033;
import '../../features/authentication/data/repository/auth_repository_impl.dart'
    as _i233;
import '../../features/authentication/domain/repositories/auth_repository.dart'
    as _i742;
import '../../features/authentication/domain/repositories/user_details_repository.dart'
    as _i781;
import '../../features/authentication/domain/use_cases/forgot_password_usecase.dart'
    as _i163;
import '../../features/authentication/domain/use_cases/get_current_user_usecase.dart'
    as _i43;
import '../../features/authentication/domain/use_cases/login_usecase.dart'
    as _i835;
import '../../features/authentication/domain/use_cases/logout_usecase.dart'
    as _i334;
import '../../features/authentication/domain/use_cases/register_usecase.dart'
    as _i1046;
import '../../features/authentication/domain/use_cases/reset_password_usecase.dart'
    as _i313;
import '../../features/authentication/domain/use_cases/verify_otp_usecase.dart'
    as _i706;
import '../../features/authentication/presentation/bloc/auth_bloc.dart'
    as _i180;
import '../../features/authentication/presentation/bloc/user_details_bloc.dart'
    as _i713;
import '../../features/common/dashboard/data/data_source/admin_operations_remote_datasource.dart'
    as _i736;
import '../../features/common/dashboard/data/data_source/analytics_remote_datasource.dart'
    as _i730;
import '../../features/common/dashboard/data/repository/admin_operations_repository_impl.dart'
    as _i135;
import '../../features/common/dashboard/data/repository/analytics_repository_impl.dart'
    as _i1072;
import '../../features/common/dashboard/domain/repositories/admin_operations_repository.dart'
    as _i20;
import '../../features/common/dashboard/domain/repositories/analytics_repository.dart'
    as _i521;
import '../../features/common/dashboard/domain/use_cases/admin_analytics_usecases.dart'
    as _i363;
import '../../features/common/dashboard/domain/use_cases/admin_operations_usecases.dart'
    as _i629;
import '../../features/common/dashboard/domain/use_cases/get_analytics_usecase.dart'
    as _i700;
import '../../features/common/dashboard/presentation/bloc/admin/admin_appointments_bloc.dart'
    as _i891;
import '../../features/common/dashboard/presentation/bloc/admin/admin_attendance_bloc.dart'
    as _i14;
import '../../features/common/dashboard/presentation/bloc/admin/admin_billing_bloc.dart'
    as _i240;
import '../../features/common/dashboard/presentation/bloc/admin/admin_emergencies_bloc.dart'
    as _i402;
import '../../features/common/dashboard/presentation/bloc/admin/admin_labs_bloc.dart'
    as _i614;
import '../../features/common/dashboard/presentation/bloc/admin/admin_pharmacy_bloc.dart'
    as _i62;
import '../../features/common/dashboard/presentation/bloc/admin/admin_recent_activity_bloc.dart'
    as _i82;
import '../../features/common/dashboard/presentation/bloc/admin/admin_settings_bloc.dart'
    as _i125;
import '../../features/common/dashboard/presentation/bloc/admin/dashboard_analytics_bloc.dart'
    as _i950;
import '../../features/common/dashboard/presentation/bloc/common/dashboard_tab_cubit.dart'
    as _i302;
import '../../features/common/dashboard/presentation/bloc/doctor/doctor_appointments_bloc.dart'
    as _i531;
import '../../features/common/dashboard/presentation/widgets/appointments/admin_appointments_filter_cubit.dart'
    as _i559;
import '../../features/common/dashboard/presentation/widgets/appointments/booking_wizard/booking_wizard_cubit.dart'
    as _i412;
import '../../features/common/dashboard/presentation/widgets/appointments/complete_consultation/complete_consultation_cubit.dart'
    as _i1;
import '../../features/doctor/dashboard/data/datasources/doctor_dashboard_remote_data_source.dart'
    as _i569;
import '../../features/doctor/dashboard/data/datasources/doctor_dashboard_remote_data_source_impl.dart'
    as _i703;
import '../../features/doctor/dashboard/data/repositories/doctor_dashboard_repository_impl.dart'
    as _i246;
import '../../features/doctor/dashboard/domain/repositories/doctor_dashboard_repository.dart'
    as _i627;
import '../../features/doctor/dashboard/domain/usecases/get_doctor_dashboard_stats_usecase.dart'
    as _i202;
import '../../features/doctor/dashboard/domain/usecases/get_pending_mrd_records_usecase.dart'
    as _i349;
import '../../features/doctor/dashboard/presentation/bloc/doctor_dashboard_bloc.dart'
    as _i689;
import '../../features/doctor/dashboard/presentation/bloc/pending_mrd/pending_mrd_bloc.dart'
    as _i947;
import '../../features/doctor/ip_info/data/datasources/ip_info_remote_datasource.dart'
    as _i162;
import '../../features/doctor/ip_info/data/repositories/ip_info_repository_impl.dart'
    as _i12;
import '../../features/doctor/ip_info/domain/repositories/ip_info_repository.dart'
    as _i653;
import '../../features/doctor/ip_info/domain/usecases/get_ip_occupancy_usecase.dart'
    as _i52;
import '../../features/doctor/ip_info/presentation/bloc/ip_info_bloc.dart'
    as _i1024;
import '../../features/doctor/op_info/data/datasources/op_info_remote_datasource.dart'
    as _i433;
import '../../features/doctor/op_info/data/repositories/op_info_repository_impl.dart'
    as _i822;
import '../../features/doctor/op_info/domain/repositories/op_info_repository.dart'
    as _i1028;
import '../../features/doctor/op_info/domain/usecases/get_op_info_usecase.dart'
    as _i670;
import '../../features/doctor/op_info/presentation/bloc/op_info_bloc.dart'
    as _i750;
import '../../features/doctor/op_procedures/data/datasources/op_procedures_remote_datasource.dart'
    as _i1035;
import '../../features/doctor/op_procedures/data/repositories/op_procedures_repository_impl.dart'
    as _i408;
import '../../features/doctor/op_procedures/domain/repositories/op_procedures_repository.dart'
    as _i185;
import '../../features/doctor/op_procedures/domain/usecases/get_op_procedures_usecase.dart'
    as _i831;
import '../../features/doctor/op_procedures/presentation/bloc/op_procedures_bloc.dart'
    as _i836;
import '../../features/patient/booking/data/datasources/booking_remote_datasource.dart'
    as _i298;
import '../../features/patient/booking/data/datasources/doctor_image_remote_datasource.dart'
    as _i1043;
import '../../features/patient/booking/data/repositories/booking_repository_impl.dart'
    as _i873;
import '../../features/patient/booking/data/repositories/doctor_image_repository_impl.dart'
    as _i409;
import '../../features/patient/booking/domain/repositories/booking_repository.dart'
    as _i455;
import '../../features/patient/booking/domain/repositories/doctor_image_repository.dart'
    as _i740;
import '../../features/patient/booking/domain/usecases/booking_usecases.dart'
    as _i694;
import '../../features/patient/booking/domain/usecases/get_doctor_image_usecase.dart'
    as _i386;
import '../../features/patient/booking/presentation/bloc/doctor_image/doctor_image_bloc.dart'
    as _i987;
import '../../features/patient/booking/presentation/bloc/speciality_booking_bloc.dart'
    as _i725;
import '../../features/patient/dashboard/data/repositories/banner_repository_impl.dart'
    as _i632;
import '../../features/patient/dashboard/domain/repositories/banner_repository.dart'
    as _i128;
import '../../features/patient/dashboard/presentation/bloc/banner_bloc.dart'
    as _i830;
import '../../features/patient/speciality/data/repositories/speciality_repository_impl.dart'
    as _i111;
import '../../features/patient/speciality/domain/repositories/speciality_repository.dart'
    as _i800;
import '../../features/patient/speciality/presentation/bloc/speciality_bloc.dart'
    as _i711;
import '../network/dio_client.dart' as _i667;
import '../network/supabase_service.dart' as _i658;
import '../routes/route_guards.dart' as _i336;
import '../services/ad_service.dart' as _i397;
import '../services/secure_storage_service.dart' as _i535;
import '../services/unique_id_service.dart' as _i775;
import '../theme/theme_cubit.dart' as _i611;
import 'injection.dart' as _i466;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.factory<_i302.DashboardTabCubit>(() => _i302.DashboardTabCubit());
    gh.factory<_i559.AdminAppointmentsFilterCubit>(
      () => _i559.AdminAppointmentsFilterCubit(),
    );
    gh.factory<_i412.BookingWizardCubit>(() => _i412.BookingWizardCubit());
    gh.lazySingleton<_i454.SupabaseClient>(() => registerModule.supabaseClient);
    gh.lazySingleton<_i667.DioClient>(() => _i667.DioClient());
    gh.lazySingleton<_i397.AdService>(() => _i397.AdService());
    gh.lazySingleton<_i535.SecureStorageService>(
      () => _i535.SecureStorageService(),
    );
    gh.lazySingleton<_i103.OperationTheatreRemoteDataSource>(
      () => _i103.OperationTheatreRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i659.ManagementInformationSystemRemoteDataSource>(
      () => _i659.ManagementInformationSystemRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i1043.DoctorImageRemoteDataSource>(
      () => _i1043.DoctorImageRemoteDataSourceImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i907.CasualityRemoteDataSource>(
      () => _i907.CasualityRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i515.FinanceRemoteDataSource>(
      () => _i515.FinanceRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i442.MarketingRemoteDataSource>(
      () => _i442.MarketingRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i525.PurchaseRemoteDataSource>(
      () => _i525.PurchaseRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i502.DyalisisRemoteDataSource>(
      () => _i502.DyalisisRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i924.InformationTechnologyRemoteDataSource>(
      () => _i924.InformationTechnologyRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i391.WardRemoteDataSource>(
      () => _i391.WardRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i955.FireSafetyRemoteDataSource>(
      () => _i955.FireSafetyRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i523.MepEngineerRemoteDataSource>(
      () => _i523.MepEngineerRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i221.CustomerCareRemoteDataSource>(
      () => _i221.CustomerCareRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i407.GeneralStoreRemoteDataSource>(
      () => _i407.GeneralStoreRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i39.PhysioTherapyRemoteDataSource>(
      () => _i39.PhysioTherapyRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i97.BiomedicalEngineeringRemoteDataSource>(
      () => _i97.BiomedicalEngineeringRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i829.NutritionAndDiabeticsRemoteDataSource>(
      () => _i829.NutritionAndDiabeticsRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i1014.NursingRemoteDataSource>(
      () => _i1014.NursingRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i271.FireSafetyRepository>(
      () => _i489.FireSafetyRepositoryImpl(
        gh<_i955.FireSafetyRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i184.FinanceRepository>(
      () => _i516.FinanceRepositoryImpl(gh<_i515.FinanceRemoteDataSource>()),
    );
    gh.lazySingleton<_i536.InformationTechnologyRepository>(
      () => _i1003.InformationTechnologyRepositoryImpl(
        gh<_i924.InformationTechnologyRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i805.CssdRemoteDataSource>(
      () => _i805.CssdRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i416.LaboratoryRemoteDataSource>(
      () => _i416.LaboratoryRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i668.PharmacyRemoteDataSource>(
      () => _i668.PharmacyRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i28.EmrdRemoteDataSource>(
      () => _i28.EmrdRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i823.WardRepository>(
      () => _i176.WardRepositoryImpl(gh<_i391.WardRemoteDataSource>()),
    );
    gh.lazySingleton<_i773.RadiologyRemoteDataSource>(
      () => _i773.RadiologyRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i595.IcuRemoteDataSource>(
      () => _i595.IcuRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i872.HumanResourceRemoteDataSource>(
      () => _i872.HumanResourceRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i658.SupabaseService>(
      () => _i658.SupabaseService(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i1012.BiomedicalEngineeringRepository>(
      () => _i458.BiomedicalEngineeringRepositoryImpl(
        gh<_i97.BiomedicalEngineeringRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i401.HumanResourceRepository>(
      () => _i1000.HumanResourceRepositoryImpl(
        gh<_i872.HumanResourceRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i1035.OpProceduresRemoteDataSource>(
      () =>
          _i1035.OpProceduresRemoteDataSourceImpl(gh<_i658.SupabaseService>()),
    );
    gh.factory<_i1.CompleteConsultationCubit>(
      () => _i1.CompleteConsultationCubit(initialConsultationFee: gh<double>()),
    );
    gh.lazySingleton<_i162.IpInfoRemoteDataSource>(
      () => _i162.IpInfoRemoteDataSourceImpl(gh<_i658.SupabaseService>()),
    );
    gh.lazySingleton<_i928.CasualityRepository>(
      () =>
          _i1025.CasualityRepositoryImpl(gh<_i907.CasualityRemoteDataSource>()),
    );
    gh.lazySingleton<_i576.DepartmentRemoteDataSource>(
      () => _i576.DepartmentRemoteDataSourceImpl(gh<_i658.SupabaseService>()),
    );
    gh.lazySingleton<_i356.PatientRemoteDataSource>(
      () => _i356.PatientRemoteDataSourceImpl(gh<_i658.SupabaseService>()),
    );
    gh.lazySingleton<_i469.GetCasualityStatsUseCase>(
      () => _i469.GetCasualityStatsUseCase(gh<_i928.CasualityRepository>()),
    );
    gh.factory<_i220.CasualityBloc>(
      () => _i220.CasualityBloc(gh<_i469.GetCasualityStatsUseCase>()),
    );
    gh.lazySingleton<_i231.PurchaseRepository>(
      () => _i34.PurchaseRepositoryImpl(gh<_i525.PurchaseRemoteDataSource>()),
    );
    gh.lazySingleton<_i433.OpInfoRemoteDataSource>(
      () => _i433.OpInfoRemoteDataSourceImpl(gh<_i658.SupabaseService>()),
    );
    gh.lazySingleton<_i298.BookingRemoteDataSource>(
      () => _i298.BookingRemoteDataSourceImpl(gh<_i658.SupabaseService>()),
    );
    gh.lazySingleton<_i763.CssdRepository>(
      () => _i819.CssdRepositoryImpl(gh<_i805.CssdRemoteDataSource>()),
    );
    gh.lazySingleton<_i968.MarketingRepository>(
      () =>
          _i922.MarketingRepositoryImpl(gh<_i442.MarketingRemoteDataSource>()),
    );
    gh.lazySingleton<_i227.AuthRemoteDataSource>(
      () => _i227.AuthRemoteDataSourceImpl(gh<_i658.SupabaseService>()),
    );
    gh.lazySingleton<_i775.UniqueIdService>(
      () => _i775.UniqueIdService(gh<_i658.SupabaseService>()),
    );
    gh.lazySingleton<_i451.ManagementInformationSystemRepository>(
      () => _i42.ManagementInformationSystemRepositoryImpl(
        gh<_i659.ManagementInformationSystemRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i716.PharmacyRepository>(
      () => _i358.PharmacyRepositoryImpl(gh<_i668.PharmacyRemoteDataSource>()),
    );
    gh.lazySingleton<_i569.DoctorDashboardRemoteDataSource>(
      () => _i703.DoctorDashboardRemoteDataSourceImpl(
        gh<_i658.SupabaseService>(),
      ),
    );
    gh.lazySingleton<_i109.PhysioTherapyRepository>(
      () => _i861.PhysioTherapyRepositoryImpl(
        gh<_i39.PhysioTherapyRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i653.IpInfoRepository>(
      () => _i12.IpInfoRepositoryImpl(gh<_i162.IpInfoRemoteDataSource>()),
    );
    gh.lazySingleton<_i736.AdminOperationsRemoteDataSource>(
      () => _i736.AdminOperationsRemoteDataSourceImpl(
        gh<_i658.SupabaseService>(),
      ),
    );
    gh.lazySingleton<_i128.BannerRepository>(
      () => _i632.BannerRepositoryImpl(gh<_i658.SupabaseService>()),
    );
    gh.lazySingleton<_i656.DoctorStaffRemoteDataSource>(
      () => _i656.DoctorStaffRemoteDataSourceImpl(gh<_i658.SupabaseService>()),
    );
    gh.lazySingleton<_i9.MepEngineerRepository>(
      () => _i345.MepEngineerRepositoryImpl(
        gh<_i523.MepEngineerRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i781.UserDetailsRepository>(
      () => _i1033.UserDetailsRepositoryImpl(gh<_i658.SupabaseService>()),
    );
    gh.lazySingleton<_i800.SpecialityRepository>(
      () => _i111.SpecialityRepositoryImpl(gh<_i658.SupabaseService>()),
    );
    gh.lazySingleton<_i611.ThemeCubit>(
      () => _i611.ThemeCubit(gh<_i535.SecureStorageService>()),
    );
    gh.lazySingleton<_i772.NutritionAndDiabeticsRepository>(
      () => _i790.NutritionAndDiabeticsRepositoryImpl(
        gh<_i829.NutritionAndDiabeticsRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i740.DoctorImageRepository>(
      () => _i409.DoctorImageRepositoryImpl(
        gh<_i1043.DoctorImageRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i856.OperationTheatreRepository>(
      () => _i568.OperationTheatreRepositoryImpl(
        gh<_i103.OperationTheatreRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i755.GetManagementInformationSystemStatsUseCase>(
      () => _i755.GetManagementInformationSystemStatsUseCase(
        gh<_i451.ManagementInformationSystemRepository>(),
      ),
    );
    gh.lazySingleton<_i465.GetHumanResourceStatsUseCase>(
      () => _i465.GetHumanResourceStatsUseCase(
        gh<_i401.HumanResourceRepository>(),
      ),
    );
    gh.lazySingleton<_i704.IcuRepository>(
      () => _i657.IcuRepositoryImpl(gh<_i595.IcuRemoteDataSource>()),
    );
    gh.lazySingleton<_i443.GetNutritionAndDiabeticsStatsUseCase>(
      () => _i443.GetNutritionAndDiabeticsStatsUseCase(
        gh<_i772.NutritionAndDiabeticsRepository>(),
      ),
    );
    gh.lazySingleton<_i13.GeneralStoreRepository>(
      () => _i1055.GeneralStoreRepositoryImpl(
        gh<_i407.GeneralStoreRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i464.CustomerCareRepository>(
      () => _i347.CustomerCareRepositoryImpl(
        gh<_i221.CustomerCareRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i796.GetMarketingStatsUseCase>(
      () => _i796.GetMarketingStatsUseCase(gh<_i968.MarketingRepository>()),
    );
    gh.lazySingleton<_i386.GetDoctorImageUseCase>(
      () => _i386.GetDoctorImageUseCase(gh<_i740.DoctorImageRepository>()),
    );
    gh.lazySingleton<_i413.EmrdRepository>(
      () => _i2.EmrdRepositoryImpl(gh<_i28.EmrdRemoteDataSource>()),
    );
    gh.lazySingleton<_i319.GetInformationTechnologyStatsUseCase>(
      () => _i319.GetInformationTechnologyStatsUseCase(
        gh<_i536.InformationTechnologyRepository>(),
      ),
    );
    gh.lazySingleton<_i106.DyalisisRepository>(
      () => _i327.DyalisisRepositoryImpl(gh<_i502.DyalisisRemoteDataSource>()),
    );
    gh.lazySingleton<_i112.LaboratoryRepository>(
      () => _i710.LaboratoryRepositoryImpl(
        gh<_i416.LaboratoryRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i954.GetEmrRecordsUseCase>(
      () => _i954.GetEmrRecordsUseCase(gh<_i413.EmrdRepository>()),
    );
    gh.lazySingleton<_i544.GetEmrdStatsUseCase>(
      () => _i544.GetEmrdStatsUseCase(gh<_i413.EmrdRepository>()),
    );
    gh.lazySingleton<_i977.GetFinanceStatsUseCase>(
      () => _i977.GetFinanceStatsUseCase(gh<_i184.FinanceRepository>()),
    );
    gh.factory<_i843.HumanResourceBloc>(
      () => _i843.HumanResourceBloc(gh<_i465.GetHumanResourceStatsUseCase>()),
    );
    gh.lazySingleton<_i554.NursingRepository>(
      () => _i994.NursingRepositoryImpl(gh<_i1014.NursingRemoteDataSource>()),
    );
    gh.lazySingleton<_i685.RadiologyRepository>(
      () =>
          _i606.RadiologyRepositoryImpl(gh<_i773.RadiologyRemoteDataSource>()),
    );
    gh.lazySingleton<_i646.GetWardStatsUseCase>(
      () => _i646.GetWardStatsUseCase(gh<_i823.WardRepository>()),
    );
    gh.lazySingleton<_i981.GetRadiologyStatsUseCase>(
      () => _i981.GetRadiologyStatsUseCase(gh<_i685.RadiologyRepository>()),
    );
    gh.lazySingleton<_i53.GetCssdStatsUseCase>(
      () => _i53.GetCssdStatsUseCase(gh<_i763.CssdRepository>()),
    );
    gh.lazySingleton<_i751.GetFireSafetyStatsUseCase>(
      () => _i751.GetFireSafetyStatsUseCase(gh<_i271.FireSafetyRepository>()),
    );
    gh.factory<_i929.FinanceBloc>(
      () => _i929.FinanceBloc(gh<_i977.GetFinanceStatsUseCase>()),
    );
    gh.factory<_i854.EmrdBloc>(
      () => _i854.EmrdBloc(
        gh<_i544.GetEmrdStatsUseCase>(),
        gh<_i954.GetEmrRecordsUseCase>(),
      ),
    );
    gh.lazySingleton<_i11.PatientRepository>(
      () => _i168.PatientRepositoryImpl(gh<_i356.PatientRemoteDataSource>()),
    );
    gh.factory<_i295.NutritionAndDiabeticsBloc>(
      () => _i295.NutritionAndDiabeticsBloc(
        gh<_i443.GetNutritionAndDiabeticsStatsUseCase>(),
      ),
    );
    gh.lazySingleton<_i336.RouteGuards>(
      () => _i336.RouteGuards(
        gh<_i658.SupabaseService>(),
        gh<_i535.SecureStorageService>(),
      ),
    );
    gh.lazySingleton<_i80.GetBiomedicalEngineeringStatsUseCase>(
      () => _i80.GetBiomedicalEngineeringStatsUseCase(
        gh<_i1012.BiomedicalEngineeringRepository>(),
      ),
    );
    gh.factory<_i1004.WardBloc>(
      () => _i1004.WardBloc(gh<_i646.GetWardStatsUseCase>()),
    );
    gh.lazySingleton<_i333.GetPhysioTherapyStatsUseCase>(
      () => _i333.GetPhysioTherapyStatsUseCase(
        gh<_i109.PhysioTherapyRepository>(),
      ),
    );
    gh.lazySingleton<_i530.GetIcuStatsUseCase>(
      () => _i530.GetIcuStatsUseCase(gh<_i704.IcuRepository>()),
    );
    gh.lazySingleton<_i205.GetLaboratoryStatsUseCase>(
      () => _i205.GetLaboratoryStatsUseCase(gh<_i112.LaboratoryRepository>()),
    );
    gh.factory<_i244.ManagementInformationSystemBloc>(
      () => _i244.ManagementInformationSystemBloc(
        gh<_i755.GetManagementInformationSystemStatsUseCase>(),
      ),
    );
    gh.factory<_i711.SpecialityBloc>(
      () => _i711.SpecialityBloc(gh<_i800.SpecialityRepository>()),
    );
    gh.lazySingleton<_i730.AnalyticsRemoteDataSource>(
      () => _i730.AnalyticsRemoteDataSourceImpl(gh<_i658.SupabaseService>()),
    );
    gh.factory<_i357.MarketingBloc>(
      () => _i357.MarketingBloc(gh<_i796.GetMarketingStatsUseCase>()),
    );
    gh.factory<_i984.RadiologyBloc>(
      () => _i984.RadiologyBloc(gh<_i981.GetRadiologyStatsUseCase>()),
    );
    gh.factory<_i98.PatientBloc>(
      () => _i98.PatientBloc(gh<_i11.PatientRepository>()),
    );
    gh.lazySingleton<_i455.BookingRepository>(
      () => _i873.BookingRepositoryImpl(gh<_i298.BookingRemoteDataSource>()),
    );
    gh.lazySingleton<_i185.OpProceduresRepository>(
      () => _i408.OpProceduresRepositoryImpl(
        gh<_i1035.OpProceduresRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i691.DepartmentRepository>(
      () => _i234.DepartmentRepositoryImpl(
        gh<_i576.DepartmentRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i503.GetPurchaseStatsUseCase>(
      () => _i503.GetPurchaseStatsUseCase(gh<_i231.PurchaseRepository>()),
    );
    gh.lazySingleton<_i38.GetMepEngineerStatsUseCase>(
      () => _i38.GetMepEngineerStatsUseCase(gh<_i9.MepEngineerRepository>()),
    );
    gh.lazySingleton<_i115.GetPharmacyStatsUseCase>(
      () => _i115.GetPharmacyStatsUseCase(gh<_i716.PharmacyRepository>()),
    );
    gh.lazySingleton<_i27.GetDyalisisStatsUseCase>(
      () => _i27.GetDyalisisStatsUseCase(gh<_i106.DyalisisRepository>()),
    );
    gh.factory<_i987.DoctorImageBloc>(
      () => _i987.DoctorImageBloc(
        getDoctorImage: gh<_i386.GetDoctorImageUseCase>(),
      ),
    );
    gh.lazySingleton<_i828.GetNursingStatsUseCase>(
      () => _i828.GetNursingStatsUseCase(gh<_i554.NursingRepository>()),
    );
    gh.factory<_i430.PhysioTherapyBloc>(
      () => _i430.PhysioTherapyBloc(gh<_i333.GetPhysioTherapyStatsUseCase>()),
    );
    gh.lazySingleton<_i1028.OpInfoRepository>(
      () => _i822.OpInfoRepositoryImpl(gh<_i433.OpInfoRemoteDataSource>()),
    );
    gh.factory<_i713.UserDetailsBloc>(
      () => _i713.UserDetailsBloc(gh<_i781.UserDetailsRepository>()),
    );
    gh.lazySingleton<_i770.GetOperationTheatreStatsUseCase>(
      () => _i770.GetOperationTheatreStatsUseCase(
        gh<_i856.OperationTheatreRepository>(),
      ),
    );
    gh.factory<_i251.NursingBloc>(
      () => _i251.NursingBloc(gh<_i828.GetNursingStatsUseCase>()),
    );
    gh.lazySingleton<_i52.GetIpOccupancyUseCase>(
      () => _i52.GetIpOccupancyUseCase(gh<_i653.IpInfoRepository>()),
    );
    gh.lazySingleton<_i627.DoctorDashboardRepository>(
      () => _i246.DoctorDashboardRepositoryImpl(
        gh<_i569.DoctorDashboardRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i694.LoadDoctorsBySpecialtyUseCase>(
      () => _i694.LoadDoctorsBySpecialtyUseCase(gh<_i455.BookingRepository>()),
    );
    gh.lazySingleton<_i694.GetSlotsUseCase>(
      () => _i694.GetSlotsUseCase(gh<_i455.BookingRepository>()),
    );
    gh.lazySingleton<_i694.BookAppointmentUseCase>(
      () => _i694.BookAppointmentUseCase(gh<_i455.BookingRepository>()),
    );
    gh.factory<_i871.InformationTechnologyBloc>(
      () => _i871.InformationTechnologyBloc(
        gh<_i319.GetInformationTechnologyStatsUseCase>(),
      ),
    );
    gh.factory<_i830.BannerBloc>(
      () => _i830.BannerBloc(gh<_i128.BannerRepository>()),
    );
    gh.factory<_i1005.CssdBloc>(
      () => _i1005.CssdBloc(gh<_i53.GetCssdStatsUseCase>()),
    );
    gh.lazySingleton<_i202.GetDoctorDashboardStatsUseCase>(
      () => _i202.GetDoctorDashboardStatsUseCase(
        gh<_i627.DoctorDashboardRepository>(),
      ),
    );
    gh.lazySingleton<_i349.GetPendingMrdRecordsUseCase>(
      () => _i349.GetPendingMrdRecordsUseCase(
        gh<_i627.DoctorDashboardRepository>(),
      ),
    );
    gh.lazySingleton<_i742.AuthRepository>(
      () => _i233.AuthRepositoryImpl(
        gh<_i227.AuthRemoteDataSource>(),
        gh<_i535.SecureStorageService>(),
      ),
    );
    gh.factory<_i75.DyalisisBloc>(
      () => _i75.DyalisisBloc(gh<_i27.GetDyalisisStatsUseCase>()),
    );
    gh.lazySingleton<_i1020.DoctorStaffRepository>(
      () => _i963.DoctorStaffRepositoryImpl(
        gh<_i656.DoctorStaffRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i20.AdminOperationsRepository>(
      () => _i135.AdminOperationsRepositoryImpl(
        gh<_i736.AdminOperationsRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i339.GetCustomerCareStatsUseCase>(
      () =>
          _i339.GetCustomerCareStatsUseCase(gh<_i464.CustomerCareRepository>()),
    );
    gh.factory<_i328.MepEngineerBloc>(
      () => _i328.MepEngineerBloc(gh<_i38.GetMepEngineerStatsUseCase>()),
    );
    gh.lazySingleton<_i831.GetOpProceduresUseCase>(
      () => _i831.GetOpProceduresUseCase(gh<_i185.OpProceduresRepository>()),
    );
    gh.lazySingleton<_i521.AnalyticsRepository>(
      () =>
          _i1072.AnalyticsRepositoryImpl(gh<_i730.AnalyticsRemoteDataSource>()),
    );
    gh.factory<_i1023.PharmacyBloc>(
      () => _i1023.PharmacyBloc(gh<_i115.GetPharmacyStatsUseCase>()),
    );
    gh.factory<_i899.CustomerCareBloc>(
      () => _i899.CustomerCareBloc(gh<_i339.GetCustomerCareStatsUseCase>()),
    );
    gh.lazySingleton<_i1056.GetGeneralStoreStatsUseCase>(
      () =>
          _i1056.GetGeneralStoreStatsUseCase(gh<_i13.GeneralStoreRepository>()),
    );
    gh.factory<_i708.BiomedicalEngineeringBloc>(
      () => _i708.BiomedicalEngineeringBloc(
        gh<_i80.GetBiomedicalEngineeringStatsUseCase>(),
      ),
    );
    gh.factory<_i689.DoctorDashboardBloc>(
      () => _i689.DoctorDashboardBloc(
        getStatsUseCase: gh<_i202.GetDoctorDashboardStatsUseCase>(),
      ),
    );
    gh.factory<_i266.PatientRegistrationBloc>(
      () => _i266.PatientRegistrationBloc(gh<_i11.PatientRepository>()),
    );
    gh.lazySingleton<_i670.GetOpInfoUseCase>(
      () => _i670.GetOpInfoUseCase(gh<_i1028.OpInfoRepository>()),
    );
    gh.factory<_i750.OpInfoBloc>(
      () => _i750.OpInfoBloc(getOpInfo: gh<_i670.GetOpInfoUseCase>()),
    );
    gh.factory<_i40.FireSafetyBloc>(
      () => _i40.FireSafetyBloc(gh<_i751.GetFireSafetyStatsUseCase>()),
    );
    gh.lazySingleton<_i629.GetPharmacyItemsUseCase>(
      () => _i629.GetPharmacyItemsUseCase(gh<_i20.AdminOperationsRepository>()),
    );
    gh.lazySingleton<_i629.AddPharmacyItemUseCase>(
      () => _i629.AddPharmacyItemUseCase(gh<_i20.AdminOperationsRepository>()),
    );
    gh.lazySingleton<_i629.UpdatePharmacyItemUseCase>(
      () =>
          _i629.UpdatePharmacyItemUseCase(gh<_i20.AdminOperationsRepository>()),
    );
    gh.lazySingleton<_i629.DeletePharmacyItemUseCase>(
      () =>
          _i629.DeletePharmacyItemUseCase(gh<_i20.AdminOperationsRepository>()),
    );
    gh.lazySingleton<_i629.GetLabTestsUseCase>(
      () => _i629.GetLabTestsUseCase(gh<_i20.AdminOperationsRepository>()),
    );
    gh.lazySingleton<_i629.AddLabTestUseCase>(
      () => _i629.AddLabTestUseCase(gh<_i20.AdminOperationsRepository>()),
    );
    gh.lazySingleton<_i629.UpdateLabTestStatusUseCase>(
      () => _i629.UpdateLabTestStatusUseCase(
        gh<_i20.AdminOperationsRepository>(),
      ),
    );
    gh.lazySingleton<_i629.GetStaffAttendanceUseCase>(
      () =>
          _i629.GetStaffAttendanceUseCase(gh<_i20.AdminOperationsRepository>()),
    );
    gh.lazySingleton<_i629.UpdateAttendanceStatusUseCase>(
      () => _i629.UpdateAttendanceStatusUseCase(
        gh<_i20.AdminOperationsRepository>(),
      ),
    );
    gh.lazySingleton<_i629.GetEmergenciesUseCase>(
      () => _i629.GetEmergenciesUseCase(gh<_i20.AdminOperationsRepository>()),
    );
    gh.lazySingleton<_i629.TriggerEmergencyUseCase>(
      () => _i629.TriggerEmergencyUseCase(gh<_i20.AdminOperationsRepository>()),
    );
    gh.lazySingleton<_i629.ResolveEmergencyUseCase>(
      () => _i629.ResolveEmergencyUseCase(gh<_i20.AdminOperationsRepository>()),
    );
    gh.lazySingleton<_i629.GetActivityLogsUseCase>(
      () => _i629.GetActivityLogsUseCase(gh<_i20.AdminOperationsRepository>()),
    );
    gh.lazySingleton<_i629.GetInvoicesUseCase>(
      () => _i629.GetInvoicesUseCase(gh<_i20.AdminOperationsRepository>()),
    );
    gh.lazySingleton<_i629.GetBillingSummaryUseCase>(
      () =>
          _i629.GetBillingSummaryUseCase(gh<_i20.AdminOperationsRepository>()),
    );
    gh.lazySingleton<_i629.CreateInvoiceUseCase>(
      () => _i629.CreateInvoiceUseCase(gh<_i20.AdminOperationsRepository>()),
    );
    gh.lazySingleton<_i629.GetAdminSettingsUseCase>(
      () => _i629.GetAdminSettingsUseCase(gh<_i20.AdminOperationsRepository>()),
    );
    gh.lazySingleton<_i629.UpdateAdminSettingUseCase>(
      () =>
          _i629.UpdateAdminSettingUseCase(gh<_i20.AdminOperationsRepository>()),
    );
    gh.lazySingleton<_i629.GetAppointmentsUseCase>(
      () => _i629.GetAppointmentsUseCase(gh<_i20.AdminOperationsRepository>()),
    );
    gh.lazySingleton<_i629.CreateAppointmentUseCase>(
      () =>
          _i629.CreateAppointmentUseCase(gh<_i20.AdminOperationsRepository>()),
    );
    gh.lazySingleton<_i629.UpdateAppointmentStatusUseCase>(
      () => _i629.UpdateAppointmentStatusUseCase(
        gh<_i20.AdminOperationsRepository>(),
      ),
    );
    gh.lazySingleton<_i629.UpdateAppointmentVitalsUseCase>(
      () => _i629.UpdateAppointmentVitalsUseCase(
        gh<_i20.AdminOperationsRepository>(),
      ),
    );
    gh.factory<_i14.AdminAttendanceBloc>(
      () => _i14.AdminAttendanceBloc(
        getAttendance: gh<_i629.GetStaffAttendanceUseCase>(),
        updateStatus: gh<_i629.UpdateAttendanceStatusUseCase>(),
      ),
    );
    gh.factory<_i100.DoctorStaffBloc>(
      () => _i100.DoctorStaffBloc(gh<_i1020.DoctorStaffRepository>()),
    );
    gh.factory<_i792.LaboratoryBloc>(
      () => _i792.LaboratoryBloc(gh<_i205.GetLaboratoryStatsUseCase>()),
    );
    gh.factory<_i402.AdminEmergenciesBloc>(
      () => _i402.AdminEmergenciesBloc(
        getEmergencies: gh<_i629.GetEmergenciesUseCase>(),
        trigger: gh<_i629.TriggerEmergencyUseCase>(),
        resolve: gh<_i629.ResolveEmergencyUseCase>(),
      ),
    );
    gh.factory<_i847.IcuBloc>(
      () => _i847.IcuBloc(gh<_i530.GetIcuStatsUseCase>()),
    );
    gh.factory<_i62.AdminPharmacyBloc>(
      () => _i62.AdminPharmacyBloc(
        getItems: gh<_i629.GetPharmacyItemsUseCase>(),
        addItem: gh<_i629.AddPharmacyItemUseCase>(),
        updateItem: gh<_i629.UpdatePharmacyItemUseCase>(),
        deleteItem: gh<_i629.DeletePharmacyItemUseCase>(),
      ),
    );
    gh.factory<_i214.GeneralStoreBloc>(
      () => _i214.GeneralStoreBloc(gh<_i1056.GetGeneralStoreStatsUseCase>()),
    );
    gh.factory<_i1024.IpInfoBloc>(
      () => _i1024.IpInfoBloc(getIpOccupancy: gh<_i52.GetIpOccupancyUseCase>()),
    );
    gh.factory<_i891.AdminAppointmentsBloc>(
      () => _i891.AdminAppointmentsBloc(
        getAppointments: gh<_i629.GetAppointmentsUseCase>(),
        createAppointment: gh<_i629.CreateAppointmentUseCase>(),
        updateStatus: gh<_i629.UpdateAppointmentStatusUseCase>(),
        updateVitals: gh<_i629.UpdateAppointmentVitalsUseCase>(),
      ),
    );
    gh.factory<_i531.DoctorAppointmentsBloc>(
      () => _i531.DoctorAppointmentsBloc(
        getAppointments: gh<_i629.GetAppointmentsUseCase>(),
        createAppointment: gh<_i629.CreateAppointmentUseCase>(),
        updateStatus: gh<_i629.UpdateAppointmentStatusUseCase>(),
        updateVitals: gh<_i629.UpdateAppointmentVitalsUseCase>(),
      ),
    );
    gh.factory<_i614.AdminLabsBloc>(
      () => _i614.AdminLabsBloc(
        getTests: gh<_i629.GetLabTestsUseCase>(),
        addTest: gh<_i629.AddLabTestUseCase>(),
        updateStatus: gh<_i629.UpdateLabTestStatusUseCase>(),
      ),
    );
    gh.factory<_i725.SpecialityBookingBloc>(
      () => _i725.SpecialityBookingBloc.create(
        gh<_i694.LoadDoctorsBySpecialtyUseCase>(),
        gh<_i694.GetSlotsUseCase>(),
        gh<_i694.BookAppointmentUseCase>(),
      ),
    );
    gh.factory<_i82.AdminRecentActivityBloc>(
      () => _i82.AdminRecentActivityBloc(
        getActivityLogs: gh<_i629.GetActivityLogsUseCase>(),
      ),
    );
    gh.lazySingleton<_i363.GetDashboardStatsUseCase>(
      () => _i363.GetDashboardStatsUseCase(gh<_i521.AnalyticsRepository>()),
    );
    gh.lazySingleton<_i363.GetAuditLogsUseCase>(
      () => _i363.GetAuditLogsUseCase(gh<_i521.AnalyticsRepository>()),
    );
    gh.lazySingleton<_i700.GetAnalyticsUseCase>(
      () => _i700.GetAnalyticsUseCase(gh<_i521.AnalyticsRepository>()),
    );
    gh.lazySingleton<_i123.AddDepartmentUseCase>(
      () => _i123.AddDepartmentUseCase(gh<_i691.DepartmentRepository>()),
    );
    gh.lazySingleton<_i920.DeleteDepartmentUseCase>(
      () => _i920.DeleteDepartmentUseCase(gh<_i691.DepartmentRepository>()),
    );
    gh.lazySingleton<_i932.GetDepartmentsUseCase>(
      () => _i932.GetDepartmentsUseCase(gh<_i691.DepartmentRepository>()),
    );
    gh.lazySingleton<_i695.UpdateDepartmentUseCase>(
      () => _i695.UpdateDepartmentUseCase(gh<_i691.DepartmentRepository>()),
    );
    gh.factory<_i579.PurchaseBloc>(
      () => _i579.PurchaseBloc(gh<_i503.GetPurchaseStatsUseCase>()),
    );
    gh.lazySingleton<_i163.ForgotPasswordUseCase>(
      () => _i163.ForgotPasswordUseCase(gh<_i742.AuthRepository>()),
    );
    gh.lazySingleton<_i43.GetCurrentUserUseCase>(
      () => _i43.GetCurrentUserUseCase(gh<_i742.AuthRepository>()),
    );
    gh.lazySingleton<_i835.LoginUseCase>(
      () => _i835.LoginUseCase(gh<_i742.AuthRepository>()),
    );
    gh.lazySingleton<_i334.LogoutUseCase>(
      () => _i334.LogoutUseCase(gh<_i742.AuthRepository>()),
    );
    gh.lazySingleton<_i1046.RegisterUseCase>(
      () => _i1046.RegisterUseCase(gh<_i742.AuthRepository>()),
    );
    gh.lazySingleton<_i313.ResetPasswordUseCase>(
      () => _i313.ResetPasswordUseCase(gh<_i742.AuthRepository>()),
    );
    gh.lazySingleton<_i706.VerifyOtpUseCase>(
      () => _i706.VerifyOtpUseCase(gh<_i742.AuthRepository>()),
    );
    gh.factory<_i622.DepartmentBloc>(
      () => _i622.DepartmentBloc(
        getDepartments: gh<_i932.GetDepartmentsUseCase>(),
        addDepartment: gh<_i123.AddDepartmentUseCase>(),
        updateDepartment: gh<_i695.UpdateDepartmentUseCase>(),
        deleteDepartment: gh<_i920.DeleteDepartmentUseCase>(),
      ),
    );
    gh.factory<_i786.OperationTheatreBloc>(
      () => _i786.OperationTheatreBloc(
        gh<_i770.GetOperationTheatreStatsUseCase>(),
      ),
    );
    gh.factory<_i125.AdminSettingsBloc>(
      () => _i125.AdminSettingsBloc(
        getSettings: gh<_i629.GetAdminSettingsUseCase>(),
        updateSetting: gh<_i629.UpdateAdminSettingUseCase>(),
      ),
    );
    gh.factory<_i947.PendingMrdBloc>(
      () => _i947.PendingMrdBloc(gh<_i349.GetPendingMrdRecordsUseCase>()),
    );
    gh.factory<_i180.AuthBloc>(
      () => _i180.AuthBloc(
        loginUseCase: gh<_i835.LoginUseCase>(),
        registerUseCase: gh<_i1046.RegisterUseCase>(),
        verifyOtpUseCase: gh<_i706.VerifyOtpUseCase>(),
        forgotPasswordUseCase: gh<_i163.ForgotPasswordUseCase>(),
        resetPasswordUseCase: gh<_i313.ResetPasswordUseCase>(),
        logoutUseCase: gh<_i334.LogoutUseCase>(),
        getCurrentUserUseCase: gh<_i43.GetCurrentUserUseCase>(),
      ),
    );
    gh.factory<_i836.OpProceduresBloc>(
      () => _i836.OpProceduresBloc(
        getOpProcedures: gh<_i831.GetOpProceduresUseCase>(),
      ),
    );
    gh.factory<_i240.AdminBillingBloc>(
      () => _i240.AdminBillingBloc(
        getInvoices: gh<_i629.GetInvoicesUseCase>(),
        getSummary: gh<_i629.GetBillingSummaryUseCase>(),
        createInvoice: gh<_i629.CreateInvoiceUseCase>(),
      ),
    );
    gh.factory<_i950.DashboardAnalyticsBloc>(
      () => _i950.DashboardAnalyticsBloc(
        getDashboardStatsUseCase: gh<_i363.GetDashboardStatsUseCase>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i466.RegisterModule {}
