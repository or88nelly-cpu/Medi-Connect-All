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

import '../../boot_strap/services/secure_storage_service.dart' as _i22;
import '../../boot_strap/services/unique_id_service.dart' as _i386;
import '../../features/admin/management/billing_management/data/datasource/finance_remote_datasource.dart'
    as _i246;
import '../../features/admin/management/billing_management/data/repositories/finance_repository_impl.dart'
    as _i298;
import '../../features/admin/management/billing_management/domain/repositories/finance_repository.dart'
    as _i539;
import '../../features/admin/management/billing_management/domain/usecases/get_finance_stats_usecase.dart'
    as _i2;
import '../../features/admin/management/billing_management/presentation/bloc/finance_bloc.dart'
    as _i263;
import '../../features/admin/management/consultation_management/data/datasource/dyalisis_remote_datasource.dart'
    as _i235;
import '../../features/admin/management/consultation_management/data/datasource/emrd_remote_datasource.dart'
    as _i932;
import '../../features/admin/management/consultation_management/data/datasource/physio_therapy_remote_datasource.dart'
    as _i804;
import '../../features/admin/management/consultation_management/data/repositories/dyalisis_repository_impl.dart'
    as _i533;
import '../../features/admin/management/consultation_management/data/repositories/emrd_repository_impl.dart'
    as _i822;
import '../../features/admin/management/consultation_management/data/repositories/physio_therapy_repository_impl.dart'
    as _i192;
import '../../features/admin/management/consultation_management/domain/repositories/dyalisis_repository.dart'
    as _i145;
import '../../features/admin/management/consultation_management/domain/repositories/emrd_repository.dart'
    as _i818;
import '../../features/admin/management/consultation_management/domain/repositories/physio_therapy_repository.dart'
    as _i321;
import '../../features/admin/management/consultation_management/domain/usecases/get_dyalisis_stats_usecase.dart'
    as _i484;
import '../../features/admin/management/consultation_management/domain/usecases/get_emr_records_usecase.dart'
    as _i427;
import '../../features/admin/management/consultation_management/domain/usecases/get_emrd_stats_usecase.dart'
    as _i333;
import '../../features/admin/management/consultation_management/domain/usecases/get_physio_therapy_stats_usecase.dart'
    as _i498;
import '../../features/admin/management/consultation_management/presentation/bloc/dyalisis_bloc.dart'
    as _i759;
import '../../features/admin/management/consultation_management/presentation/bloc/emrd_bloc.dart'
    as _i669;
import '../../features/admin/management/consultation_management/presentation/bloc/physio_therapy_bloc.dart'
    as _i926;
import '../../features/admin/management/customer_care/data/datasource/customer_care_remote_datasource.dart'
    as _i28;
import '../../features/admin/management/customer_care/data/datasource/marketing_remote_datasource.dart'
    as _i896;
import '../../features/admin/management/customer_care/data/repositories/customer_care_repository_impl.dart'
    as _i197;
import '../../features/admin/management/customer_care/data/repositories/marketing_repository_impl.dart'
    as _i396;
import '../../features/admin/management/customer_care/domain/repositories/customer_care_repository.dart'
    as _i355;
import '../../features/admin/management/customer_care/domain/repositories/marketing_repository.dart'
    as _i791;
import '../../features/admin/management/customer_care/domain/usecases/get_customer_care_stats_usecase.dart'
    as _i975;
import '../../features/admin/management/customer_care/domain/usecases/get_marketing_stats_usecase.dart'
    as _i401;
import '../../features/admin/management/customer_care/presentation/bloc/customer_care_bloc.dart'
    as _i579;
import '../../features/admin/management/customer_care/presentation/bloc/marketing_bloc.dart'
    as _i388;
import '../../features/admin/management/customer_care/presentation/bloc/patient_registration_bloc.dart'
    as _i472;
import '../../features/admin/management/equipment_management/data/datasource/biomedical_engineering_remote_datasource.dart'
    as _i1011;
import '../../features/admin/management/equipment_management/data/datasource/cssd_remote_datasource.dart'
    as _i755;
import '../../features/admin/management/equipment_management/data/datasource/mep_engineer_remote_datasource.dart'
    as _i556;
import '../../features/admin/management/equipment_management/data/repositories/biomedical_engineering_repository_impl.dart'
    as _i910;
import '../../features/admin/management/equipment_management/data/repositories/cssd_repository_impl.dart'
    as _i964;
import '../../features/admin/management/equipment_management/data/repositories/mep_engineer_repository_impl.dart'
    as _i7;
import '../../features/admin/management/equipment_management/domain/repositories/biomedical_engineering_repository.dart'
    as _i594;
import '../../features/admin/management/equipment_management/domain/repositories/cssd_repository.dart'
    as _i26;
import '../../features/admin/management/equipment_management/domain/repositories/mep_engineer_repository.dart'
    as _i377;
import '../../features/admin/management/equipment_management/domain/usecases/get_biomedical_engineering_stats_usecase.dart'
    as _i525;
import '../../features/admin/management/equipment_management/domain/usecases/get_cssd_stats_usecase.dart'
    as _i707;
import '../../features/admin/management/equipment_management/domain/usecases/get_mep_engineer_stats_usecase.dart'
    as _i47;
import '../../features/admin/management/equipment_management/presentation/bloc/biomedical_engineering_bloc.dart'
    as _i317;
import '../../features/admin/management/equipment_management/presentation/bloc/cssd_bloc.dart'
    as _i295;
import '../../features/admin/management/equipment_management/presentation/bloc/mep_engineer_bloc.dart'
    as _i467;
import '../../features/admin/management/inventory_management/data/datasource/general_store_remote_datasource.dart'
    as _i142;
import '../../features/admin/management/inventory_management/data/datasource/purchase_remote_datasource.dart'
    as _i461;
import '../../features/admin/management/inventory_management/data/repositories/general_store_repository_impl.dart'
    as _i676;
import '../../features/admin/management/inventory_management/data/repositories/purchase_repository_impl.dart'
    as _i966;
import '../../features/admin/management/inventory_management/domain/repositories/general_store_repository.dart'
    as _i161;
import '../../features/admin/management/inventory_management/domain/repositories/purchase_repository.dart'
    as _i641;
import '../../features/admin/management/inventory_management/domain/usecases/get_general_store_stats_usecase.dart'
    as _i327;
import '../../features/admin/management/inventory_management/domain/usecases/get_purchase_stats_usecase.dart'
    as _i902;
import '../../features/admin/management/inventory_management/presentation/bloc/general_store_bloc.dart'
    as _i325;
import '../../features/admin/management/inventory_management/presentation/bloc/purchase_bloc.dart'
    as _i945;
import '../../features/admin/management/laboratory_management/data/datasource/laboratory_remote_datasource.dart'
    as _i718;
import '../../features/admin/management/laboratory_management/data/datasource/radiology_remote_datasource.dart'
    as _i623;
import '../../features/admin/management/laboratory_management/data/repositories/laboratory_repository_impl.dart'
    as _i705;
import '../../features/admin/management/laboratory_management/data/repositories/radiology_repository_impl.dart'
    as _i421;
import '../../features/admin/management/laboratory_management/domain/repositories/laboratory_repository.dart'
    as _i399;
import '../../features/admin/management/laboratory_management/domain/repositories/radiology_repository.dart'
    as _i675;
import '../../features/admin/management/laboratory_management/domain/usecases/get_laboratory_stats_usecase.dart'
    as _i120;
import '../../features/admin/management/laboratory_management/domain/usecases/get_radiology_stats_usecase.dart'
    as _i444;
import '../../features/admin/management/laboratory_management/presentation/bloc/laboratory_bloc.dart'
    as _i683;
import '../../features/admin/management/laboratory_management/presentation/bloc/radiology_bloc.dart'
    as _i793;
import '../../features/admin/management/patient_management/data/datasource/patient_remote_datasource.dart'
    as _i815;
import '../../features/admin/management/patient_management/data/repositories/patient_repository_impl.dart'
    as _i783;
import '../../features/admin/management/patient_management/domain/repositories/patient_repository.dart'
    as _i844;
import '../../features/admin/management/patient_management/presentation/bloc/patient_bloc.dart'
    as _i305;
import '../../features/admin/management/pharmacy_management/data/datasource/pharmacy_remote_datasource.dart'
    as _i994;
import '../../features/admin/management/pharmacy_management/data/repositories/pharmacy_repository_impl.dart'
    as _i678;
import '../../features/admin/management/pharmacy_management/domain/repositories/pharmacy_repository.dart'
    as _i602;
import '../../features/admin/management/pharmacy_management/domain/usecases/get_pharmacy_stats_usecase.dart'
    as _i503;
import '../../features/admin/management/pharmacy_management/presentation/bloc/pharmacy_bloc.dart'
    as _i624;
import '../../features/admin/management/queue_management/data/datasource/casuality_remote_datasource.dart'
    as _i394;
import '../../features/admin/management/queue_management/data/repositories/casuality_repository_impl.dart'
    as _i436;
import '../../features/admin/management/queue_management/domain/repositories/casuality_repository.dart'
    as _i913;
import '../../features/admin/management/queue_management/domain/usecases/get_casuality_stats_usecase.dart'
    as _i817;
import '../../features/admin/management/queue_management/presentation/bloc/casuality_bloc.dart'
    as _i195;
import '../../features/admin/management/report_management/data/datasource/management_information_system_remote_datasource.dart'
    as _i792;
import '../../features/admin/management/report_management/data/repositories/management_information_system_repository_impl.dart'
    as _i704;
import '../../features/admin/management/report_management/domain/repositories/management_information_system_repository.dart'
    as _i764;
import '../../features/admin/management/report_management/domain/usecases/get_management_information_system_stats_usecase.dart'
    as _i807;
import '../../features/admin/management/report_management/presentation/bloc/management_information_system_bloc.dart'
    as _i919;
import '../../features/admin/management/room_management/data/datasource/operation_theatre_remote_datasource.dart'
    as _i57;
import '../../features/admin/management/room_management/data/repositories/operation_theatre_repository_impl.dart'
    as _i29;
import '../../features/admin/management/room_management/domain/repositories/operation_theatre_repository.dart'
    as _i439;
import '../../features/admin/management/room_management/domain/usecases/get_operation_theatre_stats_usecase.dart'
    as _i303;
import '../../features/admin/management/room_management/presentation/bloc/operation_theatre_bloc.dart'
    as _i14;
import '../../features/admin/management/settings_management/data/datasource/fire_safety_remote_datasource.dart'
    as _i1004;
import '../../features/admin/management/settings_management/data/datasource/information_technology_remote_datasource.dart'
    as _i132;
import '../../features/admin/management/settings_management/data/repositories/fire_safety_repository_impl.dart'
    as _i329;
import '../../features/admin/management/settings_management/data/repositories/information_technology_repository_impl.dart'
    as _i586;
import '../../features/admin/management/settings_management/domain/repositories/fire_safety_repository.dart'
    as _i457;
import '../../features/admin/management/settings_management/domain/repositories/information_technology_repository.dart'
    as _i979;
import '../../features/admin/management/settings_management/domain/usecases/get_fire_safety_stats_usecase.dart'
    as _i565;
import '../../features/admin/management/settings_management/domain/usecases/get_information_technology_stats_usecase.dart'
    as _i1044;
import '../../features/admin/management/settings_management/presentation/bloc/fire_safety_bloc.dart'
    as _i451;
import '../../features/admin/management/settings_management/presentation/bloc/information_technology_bloc.dart'
    as _i242;
import '../../features/admin/management/staff_management/data/datasource/department_remote_datasource.dart'
    as _i706;
import '../../features/admin/management/staff_management/data/datasource/doctor_staff_remote_datasource.dart'
    as _i527;
import '../../features/admin/management/staff_management/data/datasource/human_resource_remote_datasource.dart'
    as _i236;
import '../../features/admin/management/staff_management/data/datasource/nursing_remote_datasource.dart'
    as _i319;
import '../../features/admin/management/staff_management/data/repositories/department_repository_impl.dart'
    as _i124;
import '../../features/admin/management/staff_management/data/repositories/doctor_staff_repository_impl.dart'
    as _i881;
import '../../features/admin/management/staff_management/data/repositories/human_resource_repository_impl.dart'
    as _i253;
import '../../features/admin/management/staff_management/data/repositories/nursing_repository_impl.dart'
    as _i167;
import '../../features/admin/management/staff_management/domain/repositories/department_repository.dart'
    as _i812;
import '../../features/admin/management/staff_management/domain/repositories/doctor_staff_repository.dart'
    as _i42;
import '../../features/admin/management/staff_management/domain/repositories/human_resource_repository.dart'
    as _i672;
import '../../features/admin/management/staff_management/domain/repositories/nursing_repository.dart'
    as _i462;
import '../../features/admin/management/staff_management/domain/use_cases/add_department_usecase.dart'
    as _i158;
import '../../features/admin/management/staff_management/domain/use_cases/delete_department_usecase.dart'
    as _i361;
import '../../features/admin/management/staff_management/domain/use_cases/get_departments_usecase.dart'
    as _i1040;
import '../../features/admin/management/staff_management/domain/use_cases/update_department_usecase.dart'
    as _i1058;
import '../../features/admin/management/staff_management/domain/usecases/get_human_resource_stats_usecase.dart'
    as _i882;
import '../../features/admin/management/staff_management/domain/usecases/get_nursing_stats_usecase.dart'
    as _i240;
import '../../features/admin/management/staff_management/presentation/bloc/department_bloc.dart'
    as _i368;
import '../../features/admin/management/staff_management/presentation/bloc/doctor_staff_bloc.dart'
    as _i340;
import '../../features/admin/management/staff_management/presentation/bloc/human_resource_bloc.dart'
    as _i517;
import '../../features/admin/management/staff_management/presentation/bloc/nursing_bloc.dart'
    as _i959;
import '../../features/admin/management/ward_management/data/datasource/icu_remote_datasource.dart'
    as _i1049;
import '../../features/admin/management/ward_management/data/datasource/nutrition_and_diabetics_remote_datasource.dart'
    as _i316;
import '../../features/admin/management/ward_management/data/datasource/ward_remote_datasource.dart'
    as _i673;
import '../../features/admin/management/ward_management/data/repositories/icu_repository_impl.dart'
    as _i205;
import '../../features/admin/management/ward_management/data/repositories/nutrition_and_diabetics_repository_impl.dart'
    as _i918;
import '../../features/admin/management/ward_management/data/repositories/ward_repository_impl.dart'
    as _i274;
import '../../features/admin/management/ward_management/domain/repositories/icu_repository.dart'
    as _i1037;
import '../../features/admin/management/ward_management/domain/repositories/nutrition_and_diabetics_repository.dart'
    as _i320;
import '../../features/admin/management/ward_management/domain/repositories/ward_repository.dart'
    as _i1065;
import '../../features/admin/management/ward_management/domain/usecases/get_icu_stats_usecase.dart'
    as _i117;
import '../../features/admin/management/ward_management/domain/usecases/get_nutrition_and_diabetics_stats_usecase.dart'
    as _i826;
import '../../features/admin/management/ward_management/domain/usecases/get_ward_stats_usecase.dart'
    as _i920;
import '../../features/admin/management/ward_management/presentation/bloc/icu_bloc.dart'
    as _i400;
import '../../features/admin/management/ward_management/presentation/bloc/nutrition_and_diabetics_bloc.dart'
    as _i597;
import '../../features/admin/management/ward_management/presentation/bloc/ward_bloc.dart'
    as _i1005;
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
    as _i708;
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
    as _i13;
import '../../features/common/dashboard/presentation/bloc/admin/admin_billing_bloc.dart'
    as _i241;
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
    as _i530;
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
    as _i247;
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
import '../../features/doctor/opinfo/data/datasources/op_info_remote_datasource.dart'
    as _i695;
import '../../features/doctor/opinfo/data/repositories/op_info_repository_impl.dart'
    as _i264;
import '../../features/doctor/opinfo/domain/repositories/op_info_repository.dart'
    as _i820;
import '../../features/doctor/opinfo/domain/usecases/get_op_info_usecase.dart'
    as _i1039;
import '../../features/doctor/opinfo/presentation/bloc/op_info_bloc.dart'
    as _i564;
import '../../features/patient/booking/data/datasources/booking_remote_datasource.dart'
    as _i299;
import '../../features/patient/booking/data/datasources/doctor_image_remote_datasource.dart'
    as _i1043;
import '../../features/patient/booking/data/repositories/booking_repository_impl.dart'
    as _i872;
import '../../features/patient/booking/data/repositories/doctor_image_repository_impl.dart'
    as _i409;
import '../../features/patient/booking/domain/repositories/booking_repository.dart'
    as _i455;
import '../../features/patient/booking/domain/repositories/doctor_image_repository.dart'
    as _i740;
import '../../features/patient/booking/domain/usecases/booking_usecases.dart'
    as _i694;
import '../../features/patient/booking/domain/usecases/get_doctor_image_usecase.dart'
    as _i387;
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
import '../network/supabase_service.dart' as _i658;
import '../routes/route_guards.dart' as _i336;
import '../services/ad_service.dart' as _i397;
import '../theme/theme_cubit.dart' as _i611;
import 'injection.dart' as _i464;

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
    gh.lazySingleton<_i22.SecureStorageService>(
      () => _i22.SecureStorageService(),
    );
    gh.lazySingleton<_i454.SupabaseClient>(() => registerModule.supabaseClient);
    gh.lazySingleton<_i397.AdService>(() => _i397.AdService());
    gh.lazySingleton<_i1049.IcuRemoteDataSource>(
      () => _i1049.IcuRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i57.OperationTheatreRemoteDataSource>(
      () => _i57.OperationTheatreRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i1043.DoctorImageRemoteDataSource>(
      () => _i1043.DoctorImageRemoteDataSourceImpl(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i932.EmrdRemoteDataSource>(
      () => _i932.EmrdRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i896.MarketingRemoteDataSource>(
      () => _i896.MarketingRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i1011.BiomedicalEngineeringRemoteDataSource>(
      () => _i1011.BiomedicalEngineeringRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i132.InformationTechnologyRemoteDataSource>(
      () => _i132.InformationTechnologyRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i755.CssdRemoteDataSource>(
      () => _i755.CssdRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i718.LaboratoryRemoteDataSource>(
      () => _i718.LaboratoryRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i319.NursingRemoteDataSource>(
      () => _i319.NursingRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i556.MepEngineerRemoteDataSource>(
      () => _i556.MepEngineerRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i377.MepEngineerRepository>(
      () => _i7.MepEngineerRepositoryImpl(
        gh<_i556.MepEngineerRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i235.DyalisisRemoteDataSource>(
      () => _i235.DyalisisRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i994.PharmacyRemoteDataSource>(
      () => _i994.PharmacyRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i28.CustomerCareRemoteDataSource>(
      () => _i28.CustomerCareRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i142.GeneralStoreRemoteDataSource>(
      () => _i142.GeneralStoreRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i792.ManagementInformationSystemRemoteDataSource>(
      () => _i792.ManagementInformationSystemRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i394.CasualityRemoteDataSource>(
      () => _i394.CasualityRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i804.PhysioTherapyRemoteDataSource>(
      () => _i804.PhysioTherapyRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i673.WardRemoteDataSource>(
      () => _i673.WardRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i145.DyalisisRepository>(
      () => _i533.DyalisisRepositoryImpl(gh<_i235.DyalisisRemoteDataSource>()),
    );
    gh.lazySingleton<_i461.PurchaseRemoteDataSource>(
      () => _i461.PurchaseRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i913.CasualityRepository>(
      () =>
          _i436.CasualityRepositoryImpl(gh<_i394.CasualityRemoteDataSource>()),
    );
    gh.lazySingleton<_i462.NursingRepository>(
      () => _i167.NursingRepositoryImpl(gh<_i319.NursingRemoteDataSource>()),
    );
    gh.lazySingleton<_i355.CustomerCareRepository>(
      () => _i197.CustomerCareRepositoryImpl(
        gh<_i28.CustomerCareRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i1004.FireSafetyRemoteDataSource>(
      () => _i1004.FireSafetyRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i316.NutritionAndDiabeticsRemoteDataSource>(
      () => _i316.NutritionAndDiabeticsRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i246.FinanceRemoteDataSource>(
      () => _i246.FinanceRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i623.RadiologyRemoteDataSource>(
      () => _i623.RadiologyRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i161.GeneralStoreRepository>(
      () => _i676.GeneralStoreRepositoryImpl(
        gh<_i142.GeneralStoreRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i539.FinanceRepository>(
      () => _i298.FinanceRepositoryImpl(gh<_i246.FinanceRemoteDataSource>()),
    );
    gh.lazySingleton<_i236.HumanResourceRemoteDataSource>(
      () => _i236.HumanResourceRemoteDataSourceImpl(),
    );
    gh.lazySingleton<_i979.InformationTechnologyRepository>(
      () => _i586.InformationTechnologyRepositoryImpl(
        gh<_i132.InformationTechnologyRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i817.GetCasualityStatsUseCase>(
      () => _i817.GetCasualityStatsUseCase(gh<_i913.CasualityRepository>()),
    );
    gh.lazySingleton<_i439.OperationTheatreRepository>(
      () => _i29.OperationTheatreRepositoryImpl(
        gh<_i57.OperationTheatreRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i658.SupabaseService>(
      () => _i658.SupabaseService(gh<_i454.SupabaseClient>()),
    );
    gh.lazySingleton<_i815.PatientRemoteDataSource>(
      () => _i815.PatientRemoteDataSourceImpl(gh<_i658.SupabaseService>()),
    );
    gh.lazySingleton<_i399.LaboratoryRepository>(
      () => _i705.LaboratoryRepositoryImpl(
        gh<_i718.LaboratoryRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i320.NutritionAndDiabeticsRepository>(
      () => _i918.NutritionAndDiabeticsRepositoryImpl(
        gh<_i316.NutritionAndDiabeticsRemoteDataSource>(),
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
    gh.lazySingleton<_i791.MarketingRepository>(
      () =>
          _i396.MarketingRepositoryImpl(gh<_i896.MarketingRemoteDataSource>()),
    );
    gh.lazySingleton<_i818.EmrdRepository>(
      () => _i822.EmrdRepositoryImpl(gh<_i932.EmrdRemoteDataSource>()),
    );
    gh.lazySingleton<_i2.GetFinanceStatsUseCase>(
      () => _i2.GetFinanceStatsUseCase(gh<_i539.FinanceRepository>()),
    );
    gh.lazySingleton<_i327.GetGeneralStoreStatsUseCase>(
      () =>
          _i327.GetGeneralStoreStatsUseCase(gh<_i161.GeneralStoreRepository>()),
    );
    gh.lazySingleton<_i47.GetMepEngineerStatsUseCase>(
      () => _i47.GetMepEngineerStatsUseCase(gh<_i377.MepEngineerRepository>()),
    );
    gh.lazySingleton<_i641.PurchaseRepository>(
      () => _i966.PurchaseRepositoryImpl(gh<_i461.PurchaseRemoteDataSource>()),
    );
    gh.factory<_i195.CasualityBloc>(
      () => _i195.CasualityBloc(gh<_i817.GetCasualityStatsUseCase>()),
    );
    gh.lazySingleton<_i336.RouteGuards>(
      () => _i336.RouteGuards(
        gh<_i658.SupabaseService>(),
        gh<_i22.SecureStorageService>(),
      ),
    );
    gh.lazySingleton<_i299.BookingRemoteDataSource>(
      () => _i299.BookingRemoteDataSourceImpl(gh<_i658.SupabaseService>()),
    );
    gh.lazySingleton<_i672.HumanResourceRepository>(
      () => _i253.HumanResourceRepositoryImpl(
        gh<_i236.HumanResourceRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i602.PharmacyRepository>(
      () => _i678.PharmacyRepositoryImpl(gh<_i994.PharmacyRemoteDataSource>()),
    );
    gh.lazySingleton<_i227.AuthRemoteDataSource>(
      () => _i227.AuthRemoteDataSourceImpl(gh<_i658.SupabaseService>()),
    );
    gh.lazySingleton<_i386.UniqueIdService>(
      () => _i386.UniqueIdService(gh<_i658.SupabaseService>()),
    );
    gh.lazySingleton<_i1065.WardRepository>(
      () => _i274.WardRepositoryImpl(gh<_i673.WardRemoteDataSource>()),
    );
    gh.lazySingleton<_i569.DoctorDashboardRemoteDataSource>(
      () => _i703.DoctorDashboardRemoteDataSourceImpl(
        gh<_i658.SupabaseService>(),
      ),
    );
    gh.lazySingleton<_i1037.IcuRepository>(
      () => _i205.IcuRepositoryImpl(gh<_i1049.IcuRemoteDataSource>()),
    );
    gh.lazySingleton<_i457.FireSafetyRepository>(
      () => _i329.FireSafetyRepositoryImpl(
        gh<_i1004.FireSafetyRemoteDataSource>(),
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
    gh.lazySingleton<_i975.GetCustomerCareStatsUseCase>(
      () =>
          _i975.GetCustomerCareStatsUseCase(gh<_i355.CustomerCareRepository>()),
    );
    gh.lazySingleton<_i611.ThemeCubit>(
      () => _i611.ThemeCubit(gh<_i22.SecureStorageService>()),
    );
    gh.lazySingleton<_i594.BiomedicalEngineeringRepository>(
      () => _i910.BiomedicalEngineeringRepositoryImpl(
        gh<_i1011.BiomedicalEngineeringRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i706.DepartmentRemoteDataSource>(
      () => _i706.DepartmentRemoteDataSourceImpl(gh<_i658.SupabaseService>()),
    );
    gh.lazySingleton<_i781.UserDetailsRepository>(
      () => _i1033.UserDetailsRepositoryImpl(gh<_i658.SupabaseService>()),
    );
    gh.lazySingleton<_i527.DoctorStaffRemoteDataSource>(
      () => _i527.DoctorStaffRemoteDataSourceImpl(gh<_i658.SupabaseService>()),
    );
    gh.lazySingleton<_i800.SpecialityRepository>(
      () => _i111.SpecialityRepositoryImpl(gh<_i658.SupabaseService>()),
    );
    gh.lazySingleton<_i484.GetDyalisisStatsUseCase>(
      () => _i484.GetDyalisisStatsUseCase(gh<_i145.DyalisisRepository>()),
    );
    gh.lazySingleton<_i764.ManagementInformationSystemRepository>(
      () => _i704.ManagementInformationSystemRepositoryImpl(
        gh<_i792.ManagementInformationSystemRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i902.GetPurchaseStatsUseCase>(
      () => _i902.GetPurchaseStatsUseCase(gh<_i641.PurchaseRepository>()),
    );
    gh.lazySingleton<_i740.DoctorImageRepository>(
      () => _i409.DoctorImageRepositoryImpl(
        gh<_i1043.DoctorImageRemoteDataSource>(),
      ),
    );
    gh.factory<_i759.DyalisisBloc>(
      () => _i759.DyalisisBloc(gh<_i484.GetDyalisisStatsUseCase>()),
    );
    gh.lazySingleton<_i120.GetLaboratoryStatsUseCase>(
      () => _i120.GetLaboratoryStatsUseCase(gh<_i399.LaboratoryRepository>()),
    );
    gh.lazySingleton<_i1044.GetInformationTechnologyStatsUseCase>(
      () => _i1044.GetInformationTechnologyStatsUseCase(
        gh<_i979.InformationTechnologyRepository>(),
      ),
    );
    gh.factory<_i325.GeneralStoreBloc>(
      () => _i325.GeneralStoreBloc(gh<_i327.GetGeneralStoreStatsUseCase>()),
    );
    gh.factory<_i263.FinanceBloc>(
      () => _i263.FinanceBloc(gh<_i2.GetFinanceStatsUseCase>()),
    );
    gh.lazySingleton<_i240.GetNursingStatsUseCase>(
      () => _i240.GetNursingStatsUseCase(gh<_i462.NursingRepository>()),
    );
    gh.lazySingleton<_i26.CssdRepository>(
      () => _i964.CssdRepositoryImpl(gh<_i755.CssdRemoteDataSource>()),
    );
    gh.lazySingleton<_i387.GetDoctorImageUseCase>(
      () => _i387.GetDoctorImageUseCase(gh<_i740.DoctorImageRepository>()),
    );
    gh.lazySingleton<_i401.GetMarketingStatsUseCase>(
      () => _i401.GetMarketingStatsUseCase(gh<_i791.MarketingRepository>()),
    );
    gh.lazySingleton<_i707.GetCssdStatsUseCase>(
      () => _i707.GetCssdStatsUseCase(gh<_i26.CssdRepository>()),
    );
    gh.lazySingleton<_i675.RadiologyRepository>(
      () =>
          _i421.RadiologyRepositoryImpl(gh<_i623.RadiologyRemoteDataSource>()),
    );
    gh.factory<_i388.MarketingBloc>(
      () => _i388.MarketingBloc(gh<_i401.GetMarketingStatsUseCase>()),
    );
    gh.factory<_i579.CustomerCareBloc>(
      () => _i579.CustomerCareBloc(gh<_i975.GetCustomerCareStatsUseCase>()),
    );
    gh.lazySingleton<_i503.GetPharmacyStatsUseCase>(
      () => _i503.GetPharmacyStatsUseCase(gh<_i602.PharmacyRepository>()),
    );
    gh.lazySingleton<_i427.GetEmrRecordsUseCase>(
      () => _i427.GetEmrRecordsUseCase(gh<_i818.EmrdRepository>()),
    );
    gh.lazySingleton<_i333.GetEmrdStatsUseCase>(
      () => _i333.GetEmrdStatsUseCase(gh<_i818.EmrdRepository>()),
    );
    gh.lazySingleton<_i321.PhysioTherapyRepository>(
      () => _i192.PhysioTherapyRepositoryImpl(
        gh<_i804.PhysioTherapyRemoteDataSource>(),
      ),
    );
    gh.factory<_i624.PharmacyBloc>(
      () => _i624.PharmacyBloc(gh<_i503.GetPharmacyStatsUseCase>()),
    );
    gh.factory<_i683.LaboratoryBloc>(
      () => _i683.LaboratoryBloc(gh<_i120.GetLaboratoryStatsUseCase>()),
    );
    gh.lazySingleton<_i42.DoctorStaffRepository>(
      () => _i881.DoctorStaffRepositoryImpl(
        gh<_i527.DoctorStaffRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i826.GetNutritionAndDiabeticsStatsUseCase>(
      () => _i826.GetNutritionAndDiabeticsStatsUseCase(
        gh<_i320.NutritionAndDiabeticsRepository>(),
      ),
    );
    gh.lazySingleton<_i742.AuthRepository>(
      () => _i233.AuthRepositoryImpl(
        gh<_i227.AuthRemoteDataSource>(),
        gh<_i22.SecureStorageService>(),
      ),
    );
    gh.lazySingleton<_i444.GetRadiologyStatsUseCase>(
      () => _i444.GetRadiologyStatsUseCase(gh<_i675.RadiologyRepository>()),
    );
    gh.factory<_i467.MepEngineerBloc>(
      () => _i467.MepEngineerBloc(gh<_i47.GetMepEngineerStatsUseCase>()),
    );
    gh.lazySingleton<_i303.GetOperationTheatreStatsUseCase>(
      () => _i303.GetOperationTheatreStatsUseCase(
        gh<_i439.OperationTheatreRepository>(),
      ),
    );
    gh.factory<_i945.PurchaseBloc>(
      () => _i945.PurchaseBloc(gh<_i902.GetPurchaseStatsUseCase>()),
    );
    gh.lazySingleton<_i525.GetBiomedicalEngineeringStatsUseCase>(
      () => _i525.GetBiomedicalEngineeringStatsUseCase(
        gh<_i594.BiomedicalEngineeringRepository>(),
      ),
    );
    gh.factory<_i711.SpecialityBloc>(
      () => _i711.SpecialityBloc(gh<_i800.SpecialityRepository>()),
    );
    gh.lazySingleton<_i730.AnalyticsRemoteDataSource>(
      () => _i730.AnalyticsRemoteDataSourceImpl(gh<_i658.SupabaseService>()),
    );
    gh.lazySingleton<_i695.OpInfoRemoteDataSource>(
      () => _i695.OpInfoRemoteDataSourceImpl(gh<_i658.SupabaseService>()),
    );
    gh.lazySingleton<_i844.PatientRepository>(
      () => _i783.PatientRepositoryImpl(gh<_i815.PatientRemoteDataSource>()),
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
    gh.lazySingleton<_i708.VerifyOtpUseCase>(
      () => _i708.VerifyOtpUseCase(gh<_i742.AuthRepository>()),
    );
    gh.lazySingleton<_i455.BookingRepository>(
      () => _i872.BookingRepositoryImpl(gh<_i299.BookingRemoteDataSource>()),
    );
    gh.lazySingleton<_i807.GetManagementInformationSystemStatsUseCase>(
      () => _i807.GetManagementInformationSystemStatsUseCase(
        gh<_i764.ManagementInformationSystemRepository>(),
      ),
    );
    gh.lazySingleton<_i185.OpProceduresRepository>(
      () => _i408.OpProceduresRepositoryImpl(
        gh<_i1035.OpProceduresRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i812.DepartmentRepository>(
      () => _i124.DepartmentRepositoryImpl(
        gh<_i706.DepartmentRemoteDataSource>(),
      ),
    );
    gh.factory<_i987.DoctorImageBloc>(
      () => _i987.DoctorImageBloc(
        getDoctorImage: gh<_i387.GetDoctorImageUseCase>(),
      ),
    );
    gh.lazySingleton<_i565.GetFireSafetyStatsUseCase>(
      () => _i565.GetFireSafetyStatsUseCase(gh<_i457.FireSafetyRepository>()),
    );
    gh.factory<_i713.UserDetailsBloc>(
      () => _i713.UserDetailsBloc(gh<_i781.UserDetailsRepository>()),
    );
    gh.factory<_i597.NutritionAndDiabeticsBloc>(
      () => _i597.NutritionAndDiabeticsBloc(
        gh<_i826.GetNutritionAndDiabeticsStatsUseCase>(),
      ),
    );
    gh.lazySingleton<_i882.GetHumanResourceStatsUseCase>(
      () => _i882.GetHumanResourceStatsUseCase(
        gh<_i672.HumanResourceRepository>(),
      ),
    );
    gh.lazySingleton<_i52.GetIpOccupancyUseCase>(
      () => _i52.GetIpOccupancyUseCase(gh<_i653.IpInfoRepository>()),
    );
    gh.lazySingleton<_i920.GetWardStatsUseCase>(
      () => _i920.GetWardStatsUseCase(gh<_i1065.WardRepository>()),
    );
    gh.factory<_i669.EmrdBloc>(
      () => _i669.EmrdBloc(
        gh<_i333.GetEmrdStatsUseCase>(),
        gh<_i427.GetEmrRecordsUseCase>(),
      ),
    );
    gh.lazySingleton<_i627.DoctorDashboardRepository>(
      () => _i247.DoctorDashboardRepositoryImpl(
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
    gh.factory<_i830.BannerBloc>(
      () => _i830.BannerBloc(gh<_i128.BannerRepository>()),
    );
    gh.factory<_i295.CssdBloc>(
      () => _i295.CssdBloc(gh<_i707.GetCssdStatsUseCase>()),
    );
    gh.lazySingleton<_i820.OpInfoRepository>(
      () => _i264.OpInfoRepositoryImpl(gh<_i695.OpInfoRemoteDataSource>()),
    );
    gh.factory<_i959.NursingBloc>(
      () => _i959.NursingBloc(gh<_i240.GetNursingStatsUseCase>()),
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
    gh.factory<_i180.AuthBloc>(
      () => _i180.AuthBloc(
        loginUseCase: gh<_i835.LoginUseCase>(),
        registerUseCase: gh<_i1046.RegisterUseCase>(),
        verifyOtpUseCase: gh<_i708.VerifyOtpUseCase>(),
        forgotPasswordUseCase: gh<_i163.ForgotPasswordUseCase>(),
        resetPasswordUseCase: gh<_i313.ResetPasswordUseCase>(),
        logoutUseCase: gh<_i334.LogoutUseCase>(),
        getCurrentUserUseCase: gh<_i43.GetCurrentUserUseCase>(),
      ),
    );
    gh.lazySingleton<_i20.AdminOperationsRepository>(
      () => _i135.AdminOperationsRepositoryImpl(
        gh<_i736.AdminOperationsRemoteDataSource>(),
      ),
    );
    gh.lazySingleton<_i117.GetIcuStatsUseCase>(
      () => _i117.GetIcuStatsUseCase(gh<_i1037.IcuRepository>()),
    );
    gh.factory<_i340.DoctorStaffBloc>(
      () => _i340.DoctorStaffBloc(gh<_i42.DoctorStaffRepository>()),
    );
    gh.factory<_i242.InformationTechnologyBloc>(
      () => _i242.InformationTechnologyBloc(
        gh<_i1044.GetInformationTechnologyStatsUseCase>(),
      ),
    );
    gh.lazySingleton<_i1039.GetOpInfoUseCase>(
      () => _i1039.GetOpInfoUseCase(gh<_i820.OpInfoRepository>()),
    );
    gh.lazySingleton<_i498.GetPhysioTherapyStatsUseCase>(
      () => _i498.GetPhysioTherapyStatsUseCase(
        gh<_i321.PhysioTherapyRepository>(),
      ),
    );
    gh.lazySingleton<_i831.GetOpProceduresUseCase>(
      () => _i831.GetOpProceduresUseCase(gh<_i185.OpProceduresRepository>()),
    );
    gh.lazySingleton<_i521.AnalyticsRepository>(
      () =>
          _i1072.AnalyticsRepositoryImpl(gh<_i730.AnalyticsRemoteDataSource>()),
    );
    gh.factory<_i14.OperationTheatreBloc>(
      () => _i14.OperationTheatreBloc(
        gh<_i303.GetOperationTheatreStatsUseCase>(),
      ),
    );
    gh.factory<_i305.PatientBloc>(
      () => _i305.PatientBloc(gh<_i844.PatientRepository>()),
    );
    gh.factory<_i472.PatientRegistrationBloc>(
      () => _i472.PatientRegistrationBloc(gh<_i844.PatientRepository>()),
    );
    gh.factory<_i689.DoctorDashboardBloc>(
      () => _i689.DoctorDashboardBloc(
        getStatsUseCase: gh<_i202.GetDoctorDashboardStatsUseCase>(),
      ),
    );
    gh.factory<_i317.BiomedicalEngineeringBloc>(
      () => _i317.BiomedicalEngineeringBloc(
        gh<_i525.GetBiomedicalEngineeringStatsUseCase>(),
      ),
    );
    gh.factory<_i793.RadiologyBloc>(
      () => _i793.RadiologyBloc(gh<_i444.GetRadiologyStatsUseCase>()),
    );
    gh.lazySingleton<_i158.AddDepartmentUseCase>(
      () => _i158.AddDepartmentUseCase(gh<_i812.DepartmentRepository>()),
    );
    gh.lazySingleton<_i361.DeleteDepartmentUseCase>(
      () => _i361.DeleteDepartmentUseCase(gh<_i812.DepartmentRepository>()),
    );
    gh.lazySingleton<_i1040.GetDepartmentsUseCase>(
      () => _i1040.GetDepartmentsUseCase(gh<_i812.DepartmentRepository>()),
    );
    gh.lazySingleton<_i1058.UpdateDepartmentUseCase>(
      () => _i1058.UpdateDepartmentUseCase(gh<_i812.DepartmentRepository>()),
    );
    gh.factory<_i919.ManagementInformationSystemBloc>(
      () => _i919.ManagementInformationSystemBloc(
        gh<_i807.GetManagementInformationSystemStatsUseCase>(),
      ),
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
    gh.factory<_i13.AdminAttendanceBloc>(
      () => _i13.AdminAttendanceBloc(
        getAttendance: gh<_i629.GetStaffAttendanceUseCase>(),
        updateStatus: gh<_i629.UpdateAttendanceStatusUseCase>(),
      ),
    );
    gh.factory<_i564.OpInfoBloc>(
      () => _i564.OpInfoBloc(getOpInfo: gh<_i1039.GetOpInfoUseCase>()),
    );
    gh.factory<_i402.AdminEmergenciesBloc>(
      () => _i402.AdminEmergenciesBloc(
        getEmergencies: gh<_i629.GetEmergenciesUseCase>(),
        trigger: gh<_i629.TriggerEmergencyUseCase>(),
        resolve: gh<_i629.ResolveEmergencyUseCase>(),
      ),
    );
    gh.factory<_i62.AdminPharmacyBloc>(
      () => _i62.AdminPharmacyBloc(
        getItems: gh<_i629.GetPharmacyItemsUseCase>(),
        addItem: gh<_i629.AddPharmacyItemUseCase>(),
        updateItem: gh<_i629.UpdatePharmacyItemUseCase>(),
        deleteItem: gh<_i629.DeletePharmacyItemUseCase>(),
      ),
    );
    gh.factory<_i926.PhysioTherapyBloc>(
      () => _i926.PhysioTherapyBloc(gh<_i498.GetPhysioTherapyStatsUseCase>()),
    );
    gh.factory<_i1024.IpInfoBloc>(
      () => _i1024.IpInfoBloc(getIpOccupancy: gh<_i52.GetIpOccupancyUseCase>()),
    );
    gh.factory<_i451.FireSafetyBloc>(
      () => _i451.FireSafetyBloc(gh<_i565.GetFireSafetyStatsUseCase>()),
    );
    gh.factory<_i891.AdminAppointmentsBloc>(
      () => _i891.AdminAppointmentsBloc(
        getAppointments: gh<_i629.GetAppointmentsUseCase>(),
        createAppointment: gh<_i629.CreateAppointmentUseCase>(),
        updateStatus: gh<_i629.UpdateAppointmentStatusUseCase>(),
        updateVitals: gh<_i629.UpdateAppointmentVitalsUseCase>(),
      ),
    );
    gh.factory<_i530.DoctorAppointmentsBloc>(
      () => _i530.DoctorAppointmentsBloc(
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
    gh.factory<_i400.IcuBloc>(
      () => _i400.IcuBloc(gh<_i117.GetIcuStatsUseCase>()),
    );
    gh.factory<_i517.HumanResourceBloc>(
      () => _i517.HumanResourceBloc(gh<_i882.GetHumanResourceStatsUseCase>()),
    );
    gh.factory<_i368.DepartmentBloc>(
      () => _i368.DepartmentBloc(
        getDepartments: gh<_i1040.GetDepartmentsUseCase>(),
        addDepartment: gh<_i158.AddDepartmentUseCase>(),
        updateDepartment: gh<_i1058.UpdateDepartmentUseCase>(),
        deleteDepartment: gh<_i361.DeleteDepartmentUseCase>(),
      ),
    );
    gh.factory<_i1005.WardBloc>(
      () => _i1005.WardBloc(gh<_i920.GetWardStatsUseCase>()),
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
    gh.factory<_i836.OpProceduresBloc>(
      () => _i836.OpProceduresBloc(
        getOpProcedures: gh<_i831.GetOpProceduresUseCase>(),
      ),
    );
    gh.factory<_i241.AdminBillingBloc>(
      () => _i241.AdminBillingBloc(
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

class _$RegisterModule extends _i464.RegisterModule {}
