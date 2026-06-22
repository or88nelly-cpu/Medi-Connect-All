import 'package:get_it/get_it.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:medi_connect/modules/management/equipment_management/data/datasource/biomedical_engineering_remote_datasource.dart';
import 'package:medi_connect/modules/management/equipment_management/domain/repositories/biomedical_engineering_repository.dart';
import 'package:medi_connect/modules/management/equipment_management/data/repositories/biomedical_engineering_repository_impl.dart';
import 'package:medi_connect/modules/management/equipment_management/domain/usecases/get_biomedical_engineering_stats_usecase.dart';
import 'package:medi_connect/modules/management/equipment_management/presentation/bloc/biomedical_engineering_bloc.dart';
import 'package:medi_connect/modules/management/queue_management/data/datasource/casuality_remote_datasource.dart';
import 'package:medi_connect/modules/management/queue_management/domain/repositories/casuality_repository.dart';
import 'package:medi_connect/modules/management/queue_management/data/repositories/casuality_repository_impl.dart';
import 'package:medi_connect/modules/management/queue_management/domain/usecases/get_casuality_stats_usecase.dart';
import 'package:medi_connect/modules/management/queue_management/presentation/bloc/casuality_bloc.dart';
import 'package:medi_connect/modules/management/equipment_management/data/datasource/cssd_remote_datasource.dart';
import 'package:medi_connect/modules/management/equipment_management/domain/repositories/cssd_repository.dart';
import 'package:medi_connect/modules/management/equipment_management/data/repositories/cssd_repository_impl.dart';
import 'package:medi_connect/modules/management/equipment_management/domain/usecases/get_cssd_stats_usecase.dart';
import 'package:medi_connect/modules/management/equipment_management/presentation/bloc/cssd_bloc.dart';
import 'package:medi_connect/modules/management/customer_care/data/datasource/customer_care_remote_datasource.dart';
import 'package:medi_connect/modules/management/customer_care/domain/repositories/customer_care_repository.dart';
import 'package:medi_connect/modules/management/customer_care/data/repositories/customer_care_repository_impl.dart';
import 'package:medi_connect/modules/management/customer_care/domain/usecases/get_customer_care_stats_usecase.dart';
import 'package:medi_connect/modules/management/customer_care/presentation/bloc/customer_care_bloc.dart';
import 'package:medi_connect/modules/management/consultation_management/data/datasource/dyalisis_remote_datasource.dart';
import 'package:medi_connect/modules/management/consultation_management/domain/repositories/dyalisis_repository.dart';
import 'package:medi_connect/modules/management/consultation_management/data/repositories/dyalisis_repository_impl.dart';
import 'package:medi_connect/modules/management/consultation_management/domain/usecases/get_dyalisis_stats_usecase.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/bloc/dyalisis_bloc.dart';
import 'package:medi_connect/modules/management/consultation_management/data/datasource/emrd_remote_datasource.dart';
import 'package:medi_connect/modules/management/consultation_management/domain/repositories/emrd_repository.dart';
import 'package:medi_connect/modules/management/consultation_management/data/repositories/emrd_repository_impl.dart';
import 'package:medi_connect/modules/management/consultation_management/domain/usecases/get_emrd_stats_usecase.dart';
import 'package:medi_connect/modules/management/consultation_management/domain/usecases/get_emr_records_usecase.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/bloc/emrd_bloc.dart';
import 'package:medi_connect/modules/management/billing_management/data/datasource/finance_remote_datasource.dart';
import 'package:medi_connect/modules/management/billing_management/domain/repositories/finance_repository.dart';
import 'package:medi_connect/modules/management/billing_management/data/repositories/finance_repository_impl.dart';
import 'package:medi_connect/modules/management/billing_management/domain/usecases/get_finance_stats_usecase.dart';
import 'package:medi_connect/modules/management/billing_management/presentation/bloc/finance_bloc.dart';
import 'package:medi_connect/modules/management/settings_management/data/datasource/fire_safety_remote_datasource.dart';
import 'package:medi_connect/modules/management/settings_management/domain/repositories/fire_safety_repository.dart';
import 'package:medi_connect/modules/management/settings_management/data/repositories/fire_safety_repository_impl.dart';
import 'package:medi_connect/modules/management/settings_management/domain/usecases/get_fire_safety_stats_usecase.dart';
import 'package:medi_connect/modules/management/settings_management/presentation/bloc/fire_safety_bloc.dart';
import 'package:medi_connect/modules/management/inventory_management/data/datasource/general_store_remote_datasource.dart';
import 'package:medi_connect/modules/management/inventory_management/domain/repositories/general_store_repository.dart';
import 'package:medi_connect/modules/management/inventory_management/data/repositories/general_store_repository_impl.dart';
import 'package:medi_connect/modules/management/inventory_management/domain/usecases/get_general_store_stats_usecase.dart';
import 'package:medi_connect/modules/management/inventory_management/presentation/bloc/general_store_bloc.dart';
import 'package:medi_connect/modules/management/staff_management/data/datasource/human_resource_remote_datasource.dart';
import 'package:medi_connect/modules/management/staff_management/domain/repositories/human_resource_repository.dart';
import 'package:medi_connect/modules/management/staff_management/data/repositories/human_resource_repository_impl.dart';
import 'package:medi_connect/modules/management/staff_management/domain/usecases/get_human_resource_stats_usecase.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/human_resource_bloc.dart';
import 'package:medi_connect/modules/management/ward_management/data/datasource/icu_remote_datasource.dart';
import 'package:medi_connect/modules/management/ward_management/domain/repositories/icu_repository.dart';
import 'package:medi_connect/modules/management/ward_management/data/repositories/icu_repository_impl.dart';
import 'package:medi_connect/modules/management/ward_management/domain/usecases/get_icu_stats_usecase.dart';
import 'package:medi_connect/modules/management/ward_management/presentation/bloc/icu_bloc.dart';
import 'package:medi_connect/modules/management/settings_management/data/datasource/information_technology_remote_datasource.dart';
import 'package:medi_connect/modules/management/settings_management/domain/repositories/information_technology_repository.dart';
import 'package:medi_connect/modules/management/settings_management/data/repositories/information_technology_repository_impl.dart';
import 'package:medi_connect/modules/management/settings_management/domain/usecases/get_information_technology_stats_usecase.dart';
import 'package:medi_connect/modules/management/settings_management/presentation/bloc/information_technology_bloc.dart';
import 'package:medi_connect/modules/management/laboratory_management/data/datasource/laboratory_remote_datasource.dart';
import 'package:medi_connect/modules/management/laboratory_management/domain/repositories/laboratory_repository.dart';
import 'package:medi_connect/modules/management/laboratory_management/data/repositories/laboratory_repository_impl.dart';
import 'package:medi_connect/modules/management/laboratory_management/domain/usecases/get_laboratory_stats_usecase.dart';
import 'package:medi_connect/modules/management/laboratory_management/presentation/bloc/laboratory_bloc.dart';
import 'package:medi_connect/modules/management/report_management/data/datasource/management_information_system_remote_datasource.dart';
import 'package:medi_connect/modules/management/report_management/domain/repositories/management_information_system_repository.dart';
import 'package:medi_connect/modules/management/report_management/data/repositories/management_information_system_repository_impl.dart';
import 'package:medi_connect/modules/management/report_management/domain/usecases/get_management_information_system_stats_usecase.dart';
import 'package:medi_connect/modules/management/report_management/presentation/bloc/management_information_system_bloc.dart';
import 'package:medi_connect/modules/management/customer_care/data/datasource/marketing_remote_datasource.dart';
import 'package:medi_connect/modules/management/customer_care/domain/repositories/marketing_repository.dart';
import 'package:medi_connect/modules/management/customer_care/data/repositories/marketing_repository_impl.dart';
import 'package:medi_connect/modules/management/customer_care/domain/usecases/get_marketing_stats_usecase.dart';
import 'package:medi_connect/modules/management/customer_care/presentation/bloc/marketing_bloc.dart';
import 'package:medi_connect/modules/management/equipment_management/data/datasource/mep_engineer_remote_datasource.dart';
import 'package:medi_connect/modules/management/equipment_management/domain/repositories/mep_engineer_repository.dart';
import 'package:medi_connect/modules/management/equipment_management/data/repositories/mep_engineer_repository_impl.dart';
import 'package:medi_connect/modules/management/equipment_management/domain/usecases/get_mep_engineer_stats_usecase.dart';
import 'package:medi_connect/modules/management/equipment_management/presentation/bloc/mep_engineer_bloc.dart';
import 'package:medi_connect/modules/management/staff_management/data/datasource/nursing_remote_datasource.dart';
import 'package:medi_connect/modules/management/staff_management/domain/repositories/nursing_repository.dart';
import 'package:medi_connect/modules/management/staff_management/data/repositories/nursing_repository_impl.dart';
import 'package:medi_connect/modules/management/staff_management/domain/usecases/get_nursing_stats_usecase.dart';
import 'package:medi_connect/modules/management/staff_management/presentation/bloc/nursing_bloc.dart';
import 'package:medi_connect/modules/management/ward_management/data/datasource/nutrition_and_diabetics_remote_datasource.dart';
import 'package:medi_connect/modules/management/ward_management/domain/repositories/nutrition_and_diabetics_repository.dart';
import 'package:medi_connect/modules/management/ward_management/data/repositories/nutrition_and_diabetics_repository_impl.dart';
import 'package:medi_connect/modules/management/ward_management/domain/usecases/get_nutrition_and_diabetics_stats_usecase.dart';
import 'package:medi_connect/modules/management/ward_management/presentation/bloc/nutrition_and_diabetics_bloc.dart';
import 'package:medi_connect/modules/management/room_management/data/datasource/operation_theatre_remote_datasource.dart';
import 'package:medi_connect/modules/management/room_management/domain/repositories/operation_theatre_repository.dart';
import 'package:medi_connect/modules/management/room_management/data/repositories/operation_theatre_repository_impl.dart';
import 'package:medi_connect/modules/management/room_management/domain/usecases/get_operation_theatre_stats_usecase.dart';
import 'package:medi_connect/modules/management/room_management/presentation/bloc/operation_theatre_bloc.dart';
import 'package:medi_connect/modules/management/pharmacy_management/data/datasource/pharmacy_remote_datasource.dart';
import 'package:medi_connect/modules/management/pharmacy_management/domain/repositories/pharmacy_repository.dart';
import 'package:medi_connect/modules/management/pharmacy_management/data/repositories/pharmacy_repository_impl.dart';
import 'package:medi_connect/modules/management/pharmacy_management/domain/usecases/get_pharmacy_stats_usecase.dart';
import 'package:medi_connect/modules/management/pharmacy_management/presentation/bloc/pharmacy_bloc.dart';
import 'package:medi_connect/modules/management/consultation_management/data/datasource/physio_therapy_remote_datasource.dart';
import 'package:medi_connect/modules/management/consultation_management/domain/repositories/physio_therapy_repository.dart';
import 'package:medi_connect/modules/management/consultation_management/data/repositories/physio_therapy_repository_impl.dart';
import 'package:medi_connect/modules/management/consultation_management/domain/usecases/get_physio_therapy_stats_usecase.dart';
import 'package:medi_connect/modules/management/consultation_management/presentation/bloc/physio_therapy_bloc.dart';
import 'package:medi_connect/modules/management/inventory_management/data/datasource/purchase_remote_datasource.dart';
import 'package:medi_connect/modules/management/inventory_management/domain/repositories/purchase_repository.dart';
import 'package:medi_connect/modules/management/inventory_management/data/repositories/purchase_repository_impl.dart';
import 'package:medi_connect/modules/management/inventory_management/domain/usecases/get_purchase_stats_usecase.dart';
import 'package:medi_connect/modules/management/inventory_management/presentation/bloc/purchase_bloc.dart';
import 'package:medi_connect/modules/management/laboratory_management/data/datasource/radiology_remote_datasource.dart';
import 'package:medi_connect/modules/management/laboratory_management/domain/repositories/radiology_repository.dart';
import 'package:medi_connect/modules/management/laboratory_management/data/repositories/radiology_repository_impl.dart';
import 'package:medi_connect/modules/management/laboratory_management/domain/usecases/get_radiology_stats_usecase.dart';
import 'package:medi_connect/modules/management/laboratory_management/presentation/bloc/radiology_bloc.dart';
import 'package:medi_connect/modules/management/ward_management/data/datasource/ward_remote_datasource.dart';
import 'package:medi_connect/modules/management/ward_management/domain/repositories/ward_repository.dart';
import 'package:medi_connect/modules/management/ward_management/data/repositories/ward_repository_impl.dart';
import 'package:medi_connect/modules/management/ward_management/domain/usecases/get_ward_stats_usecase.dart';
import 'package:medi_connect/modules/management/ward_management/presentation/bloc/ward_bloc.dart';

void configureAllDepartmentsDependencies(GetIt sl) {
  // Biomedical Engineering Department
  sl.registerLazySingleton<BiomedicalEngineeringRemoteDataSource>(
    () => BiomedicalEngineeringRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<BiomedicalEngineeringRepository>(
    () => BiomedicalEngineeringRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetBiomedicalEngineeringStatsUseCase>(
    () => GetBiomedicalEngineeringStatsUseCase(sl()),
  );
  sl.registerFactory<BiomedicalEngineeringBloc>(
    () => BiomedicalEngineeringBloc(sl()),
  );

  // Casuality Department
  sl.registerLazySingleton<CasualityRemoteDataSource>(
    () => CasualityRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<CasualityRepository>(
    () => CasualityRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetCasualityStatsUseCase>(
    () => GetCasualityStatsUseCase(sl()),
  );
  sl.registerFactory<CasualityBloc>(() => CasualityBloc(sl()));

  // CSSD Department
  sl.registerLazySingleton<CssdRemoteDataSource>(
    () => CssdRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<CssdRepository>(() => CssdRepositoryImpl(sl()));
  sl.registerLazySingleton<GetCssdStatsUseCase>(
    () => GetCssdStatsUseCase(sl()),
  );
  sl.registerFactory<CssdBloc>(() => CssdBloc(sl()));

  // Customer Care Department
  sl.registerLazySingleton<CustomerCareRemoteDataSource>(
    () => CustomerCareRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<CustomerCareRepository>(
    () => CustomerCareRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetCustomerCareStatsUseCase>(
    () => GetCustomerCareStatsUseCase(sl()),
  );
  sl.registerFactory<CustomerCareBloc>(() => CustomerCareBloc(sl()));

  // Dyalisis Department
  sl.registerLazySingleton<DyalisisRemoteDataSource>(
    () => DyalisisRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<DyalisisRepository>(
    () => DyalisisRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetDyalisisStatsUseCase>(
    () => GetDyalisisStatsUseCase(sl()),
  );
  sl.registerFactory<DyalisisBloc>(() => DyalisisBloc(sl()));

  // EMRD Department
  sl.registerLazySingleton<EmrdRemoteDataSource>(
    () => EmrdRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<EmrdRepository>(() => EmrdRepositoryImpl(sl()));
  sl.registerLazySingleton<GetEmrdStatsUseCase>(
    () => GetEmrdStatsUseCase(sl()),
  );
  sl.registerLazySingleton<GetEmrRecordsUseCase>(
    () => GetEmrRecordsUseCase(sl()),
  );
  sl.registerFactory<EmrdBloc>(() => EmrdBloc(sl(), sl()));

  // Finance Department
  sl.registerLazySingleton<FinanceRemoteDataSource>(
    () => FinanceRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<FinanceRepository>(
    () => FinanceRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetFinanceStatsUseCase>(
    () => GetFinanceStatsUseCase(sl()),
  );
  sl.registerFactory<FinanceBloc>(() => FinanceBloc(sl()));

  // Fire Safety Department
  sl.registerLazySingleton<FireSafetyRemoteDataSource>(
    () => FireSafetyRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<FireSafetyRepository>(
    () => FireSafetyRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetFireSafetyStatsUseCase>(
    () => GetFireSafetyStatsUseCase(sl()),
  );
  sl.registerFactory<FireSafetyBloc>(() => FireSafetyBloc(sl()));

  // General Store Department
  sl.registerLazySingleton<GeneralStoreRemoteDataSource>(
    () => GeneralStoreRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<GeneralStoreRepository>(
    () => GeneralStoreRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetGeneralStoreStatsUseCase>(
    () => GetGeneralStoreStatsUseCase(sl()),
  );
  sl.registerFactory<GeneralStoreBloc>(() => GeneralStoreBloc(sl()));

  // Human Resource Department
  sl.registerLazySingleton<HumanResourceRemoteDataSource>(
    () => HumanResourceRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<HumanResourceRepository>(
    () => HumanResourceRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetHumanResourceStatsUseCase>(
    () => GetHumanResourceStatsUseCase(sl()),
  );
  sl.registerFactory<HumanResourceBloc>(() => HumanResourceBloc(sl()));

  // ICU Department
  sl.registerLazySingleton<IcuRemoteDataSource>(
    () => IcuRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<IcuRepository>(() => IcuRepositoryImpl(sl()));
  sl.registerLazySingleton<GetIcuStatsUseCase>(() => GetIcuStatsUseCase(sl()));
  sl.registerFactory<IcuBloc>(() => IcuBloc(sl()));

  // Information Technology Department
  sl.registerLazySingleton<InformationTechnologyRemoteDataSource>(
    () => InformationTechnologyRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<InformationTechnologyRepository>(
    () => InformationTechnologyRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetInformationTechnologyStatsUseCase>(
    () => GetInformationTechnologyStatsUseCase(sl()),
  );
  sl.registerFactory<InformationTechnologyBloc>(
    () => InformationTechnologyBloc(sl()),
  );

  // Laboratory Department
  sl.registerLazySingleton<LaboratoryRemoteDataSource>(
    () => LaboratoryRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<LaboratoryRepository>(
    () => LaboratoryRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetLaboratoryStatsUseCase>(
    () => GetLaboratoryStatsUseCase(sl()),
  );
  sl.registerFactory<LaboratoryBloc>(() => LaboratoryBloc(sl()));

  // Management Information System Department
  sl.registerLazySingleton<ManagementInformationSystemRemoteDataSource>(
    () => ManagementInformationSystemRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<ManagementInformationSystemRepository>(
    () => ManagementInformationSystemRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetManagementInformationSystemStatsUseCase>(
    () => GetManagementInformationSystemStatsUseCase(sl()),
  );
  sl.registerFactory<ManagementInformationSystemBloc>(
    () => ManagementInformationSystemBloc(sl()),
  );

  // Marketing Department
  sl.registerLazySingleton<MarketingRemoteDataSource>(
    () => MarketingRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<MarketingRepository>(
    () => MarketingRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetMarketingStatsUseCase>(
    () => GetMarketingStatsUseCase(sl()),
  );
  sl.registerFactory<MarketingBloc>(() => MarketingBloc(sl()));

  // MEP Engineer Department
  sl.registerLazySingleton<MepEngineerRemoteDataSource>(
    () => MepEngineerRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<MepEngineerRepository>(
    () => MepEngineerRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetMepEngineerStatsUseCase>(
    () => GetMepEngineerStatsUseCase(sl()),
  );
  sl.registerFactory<MepEngineerBloc>(() => MepEngineerBloc(sl()));

  // Nursing Department
  sl.registerLazySingleton<NursingRemoteDataSource>(
    () => NursingRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<NursingRepository>(
    () => NursingRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetNursingStatsUseCase>(
    () => GetNursingStatsUseCase(sl()),
  );
  sl.registerFactory<NursingBloc>(() => NursingBloc(sl()));

  // Nutrition and Diabetics Department
  sl.registerLazySingleton<NutritionAndDiabeticsRemoteDataSource>(
    () => NutritionAndDiabeticsRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<NutritionAndDiabeticsRepository>(
    () => NutritionAndDiabeticsRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetNutritionAndDiabeticsStatsUseCase>(
    () => GetNutritionAndDiabeticsStatsUseCase(sl()),
  );
  sl.registerFactory<NutritionAndDiabeticsBloc>(
    () => NutritionAndDiabeticsBloc(sl()),
  );

  // Operation Theatre Department
  sl.registerLazySingleton<OperationTheatreRemoteDataSource>(
    () => OperationTheatreRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<OperationTheatreRepository>(
    () => OperationTheatreRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetOperationTheatreStatsUseCase>(
    () => GetOperationTheatreStatsUseCase(sl()),
  );
  sl.registerFactory<OperationTheatreBloc>(() => OperationTheatreBloc(sl()));

  // Pharmacy Department
  sl.registerLazySingleton<PharmacyRemoteDataSource>(
    () => PharmacyRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<PharmacyRepository>(
    () => PharmacyRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetPharmacyStatsUseCase>(
    () => GetPharmacyStatsUseCase(sl()),
  );
  sl.registerFactory<PharmacyBloc>(() => PharmacyBloc(sl()));

  // Physio Therapy Department
  sl.registerLazySingleton<PhysioTherapyRemoteDataSource>(
    () => PhysioTherapyRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<PhysioTherapyRepository>(
    () => PhysioTherapyRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetPhysioTherapyStatsUseCase>(
    () => GetPhysioTherapyStatsUseCase(sl()),
  );
  sl.registerFactory<PhysioTherapyBloc>(() => PhysioTherapyBloc(sl()));

  // Purchase Department
  sl.registerLazySingleton<PurchaseRemoteDataSource>(
    () => PurchaseRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<PurchaseRepository>(
    () => PurchaseRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetPurchaseStatsUseCase>(
    () => GetPurchaseStatsUseCase(sl()),
  );
  sl.registerFactory<PurchaseBloc>(() => PurchaseBloc(sl()));

  // Radiology Department
  sl.registerLazySingleton<RadiologyRemoteDataSource>(
    () => RadiologyRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<RadiologyRepository>(
    () => RadiologyRepositoryImpl(sl()),
  );
  sl.registerLazySingleton<GetRadiologyStatsUseCase>(
    () => GetRadiologyStatsUseCase(sl()),
  );
  sl.registerFactory<RadiologyBloc>(() => RadiologyBloc(sl()));

  // Ward Department
  sl.registerLazySingleton<WardRemoteDataSource>(
    () => WardRemoteDataSourceImpl(),
  );
  sl.registerLazySingleton<WardRepository>(() => WardRepositoryImpl(sl()));
  sl.registerLazySingleton<GetWardStatsUseCase>(
    () => GetWardStatsUseCase(sl()),
  );
  sl.registerFactory<WardBloc>(() => WardBloc(sl()));
}

List<BlocProvider> getAllDepartmentsProviders(GetIt sl) {
  return [
    BlocProvider<BiomedicalEngineeringBloc>(
      create: (_) => sl<BiomedicalEngineeringBloc>(),
    ),
    BlocProvider<CasualityBloc>(create: (_) => sl<CasualityBloc>()),
    BlocProvider<CssdBloc>(create: (_) => sl<CssdBloc>()),
    BlocProvider<CustomerCareBloc>(create: (_) => sl<CustomerCareBloc>()),
    BlocProvider<DyalisisBloc>(create: (_) => sl<DyalisisBloc>()),
    BlocProvider<EmrdBloc>(create: (_) => sl<EmrdBloc>()),
    BlocProvider<FinanceBloc>(create: (_) => sl<FinanceBloc>()),
    BlocProvider<FireSafetyBloc>(create: (_) => sl<FireSafetyBloc>()),
    BlocProvider<GeneralStoreBloc>(create: (_) => sl<GeneralStoreBloc>()),
    BlocProvider<HumanResourceBloc>(create: (_) => sl<HumanResourceBloc>()),
    BlocProvider<IcuBloc>(create: (_) => sl<IcuBloc>()),
    BlocProvider<InformationTechnologyBloc>(
      create: (_) => sl<InformationTechnologyBloc>(),
    ),
    BlocProvider<LaboratoryBloc>(create: (_) => sl<LaboratoryBloc>()),
    BlocProvider<ManagementInformationSystemBloc>(
      create: (_) => sl<ManagementInformationSystemBloc>(),
    ),
    BlocProvider<MarketingBloc>(create: (_) => sl<MarketingBloc>()),
    BlocProvider<MepEngineerBloc>(create: (_) => sl<MepEngineerBloc>()),
    BlocProvider<NursingBloc>(create: (_) => sl<NursingBloc>()),
    BlocProvider<NutritionAndDiabeticsBloc>(
      create: (_) => sl<NutritionAndDiabeticsBloc>(),
    ),
    BlocProvider<OperationTheatreBloc>(
      create: (_) => sl<OperationTheatreBloc>(),
    ),
    BlocProvider<PharmacyBloc>(create: (_) => sl<PharmacyBloc>()),
    BlocProvider<PhysioTherapyBloc>(create: (_) => sl<PhysioTherapyBloc>()),
    BlocProvider<PurchaseBloc>(create: (_) => sl<PurchaseBloc>()),
    BlocProvider<RadiologyBloc>(create: (_) => sl<RadiologyBloc>()),
    BlocProvider<WardBloc>(create: (_) => sl<WardBloc>()),
  ];
}
