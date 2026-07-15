import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:medi_connect/features/admin/billing_management/data/datasource/finance_remote_datasource.dart';
import 'package:medi_connect/features/admin/billing_management/data/repositories/finance_repository_impl.dart';
import 'package:medi_connect/features/admin/billing_management/domain/repositories/finance_repository.dart';
import 'package:medi_connect/features/admin/billing_management/domain/usecases/get_finance_stats_usecase.dart';
import 'package:medi_connect/features/admin/billing_management/presentation/bloc/finance_bloc.dart';
import 'package:medi_connect/features/admin/consultation_management/data/datasource/dyalisis_remote_datasource.dart';
import 'package:medi_connect/features/admin/consultation_management/data/datasource/emrd_remote_datasource.dart';
import 'package:medi_connect/features/admin/consultation_management/data/datasource/physio_therapy_remote_datasource.dart';
import 'package:medi_connect/features/admin/consultation_management/data/repositories/dyalisis_repository_impl.dart';
import 'package:medi_connect/features/admin/consultation_management/data/repositories/emrd_repository_impl.dart';
import 'package:medi_connect/features/admin/consultation_management/data/repositories/physio_therapy_repository_impl.dart';
import 'package:medi_connect/features/admin/consultation_management/domain/repositories/dyalisis_repository.dart';
import 'package:medi_connect/features/admin/consultation_management/domain/repositories/emrd_repository.dart';
import 'package:medi_connect/features/admin/consultation_management/domain/repositories/physio_therapy_repository.dart';
import 'package:medi_connect/features/admin/consultation_management/domain/usecases/get_dyalisis_stats_usecase.dart';
import 'package:medi_connect/features/admin/consultation_management/domain/usecases/get_emr_records_usecase.dart';
import 'package:medi_connect/features/admin/consultation_management/domain/usecases/get_emrd_stats_usecase.dart';
import 'package:medi_connect/features/admin/consultation_management/domain/usecases/get_physio_therapy_stats_usecase.dart';
import 'package:medi_connect/features/admin/consultation_management/presentation/bloc/dyalisis_bloc.dart';
import 'package:medi_connect/features/admin/consultation_management/presentation/bloc/emrd_bloc.dart';
import 'package:medi_connect/features/admin/consultation_management/presentation/bloc/physio_therapy_bloc.dart';
import 'package:medi_connect/features/admin/customer_care/data/datasource/customer_care_remote_datasource.dart';
import 'package:medi_connect/features/admin/customer_care/data/datasource/marketing_remote_datasource.dart';
import 'package:medi_connect/features/admin/customer_care/data/repositories/customer_care_repository_impl.dart';
import 'package:medi_connect/features/admin/customer_care/data/repositories/marketing_repository_impl.dart';
import 'package:medi_connect/features/admin/customer_care/domain/repositories/customer_care_repository.dart';
import 'package:medi_connect/features/admin/customer_care/domain/repositories/marketing_repository.dart';
import 'package:medi_connect/features/admin/customer_care/domain/usecases/get_customer_care_stats_usecase.dart';
import 'package:medi_connect/features/admin/customer_care/domain/usecases/get_marketing_stats_usecase.dart';
import 'package:medi_connect/features/admin/customer_care/presentation/bloc/customer_care_bloc.dart';
import 'package:medi_connect/features/admin/customer_care/presentation/bloc/marketing_bloc.dart';
import 'package:medi_connect/features/admin/equipment_management/data/datasource/biomedical_engineering_remote_datasource.dart';
import 'package:medi_connect/features/admin/equipment_management/data/datasource/cssd_remote_datasource.dart';
import 'package:medi_connect/features/admin/equipment_management/data/datasource/mep_engineer_remote_datasource.dart';
import 'package:medi_connect/features/admin/equipment_management/data/repositories/biomedical_engineering_repository_impl.dart';
import 'package:medi_connect/features/admin/equipment_management/data/repositories/cssd_repository_impl.dart';
import 'package:medi_connect/features/admin/equipment_management/data/repositories/mep_engineer_repository_impl.dart';
import 'package:medi_connect/features/admin/equipment_management/domain/repositories/biomedical_engineering_repository.dart';
import 'package:medi_connect/features/admin/equipment_management/domain/repositories/cssd_repository.dart';
import 'package:medi_connect/features/admin/equipment_management/domain/repositories/mep_engineer_repository.dart';
import 'package:medi_connect/features/admin/equipment_management/domain/usecases/get_biomedical_engineering_stats_usecase.dart';
import 'package:medi_connect/features/admin/equipment_management/domain/usecases/get_cssd_stats_usecase.dart';
import 'package:medi_connect/features/admin/equipment_management/domain/usecases/get_mep_engineer_stats_usecase.dart';
import 'package:medi_connect/features/admin/equipment_management/presentation/bloc/biomedical_engineering_bloc.dart';
import 'package:medi_connect/features/admin/equipment_management/presentation/bloc/cssd_bloc.dart';
import 'package:medi_connect/features/admin/equipment_management/presentation/bloc/mep_engineer_bloc.dart';
import 'package:medi_connect/features/admin/inventory_management/data/datasource/general_store_remote_datasource.dart';
import 'package:medi_connect/features/admin/inventory_management/data/datasource/purchase_remote_datasource.dart';
import 'package:medi_connect/features/admin/inventory_management/data/repositories/general_store_repository_impl.dart';
import 'package:medi_connect/features/admin/inventory_management/data/repositories/purchase_repository_impl.dart';
import 'package:medi_connect/features/admin/inventory_management/domain/repositories/general_store_repository.dart';
import 'package:medi_connect/features/admin/inventory_management/domain/repositories/purchase_repository.dart';
import 'package:medi_connect/features/admin/inventory_management/domain/usecases/get_general_store_stats_usecase.dart';
import 'package:medi_connect/features/admin/inventory_management/domain/usecases/get_purchase_stats_usecase.dart';
import 'package:medi_connect/features/admin/inventory_management/presentation/bloc/general_store_bloc.dart';
import 'package:medi_connect/features/admin/inventory_management/presentation/bloc/purchase_bloc.dart';
import 'package:medi_connect/features/admin/laboratory_management/data/datasource/laboratory_remote_datasource.dart';
import 'package:medi_connect/features/admin/laboratory_management/data/datasource/radiology_remote_datasource.dart';
import 'package:medi_connect/features/admin/laboratory_management/data/repositories/laboratory_repository_impl.dart';
import 'package:medi_connect/features/admin/laboratory_management/data/repositories/radiology_repository_impl.dart';
import 'package:medi_connect/features/admin/laboratory_management/domain/repositories/laboratory_repository.dart';
import 'package:medi_connect/features/admin/laboratory_management/domain/repositories/radiology_repository.dart';
import 'package:medi_connect/features/admin/laboratory_management/domain/usecases/get_laboratory_stats_usecase.dart';
import 'package:medi_connect/features/admin/laboratory_management/domain/usecases/get_radiology_stats_usecase.dart';
import 'package:medi_connect/features/admin/laboratory_management/presentation/bloc/laboratory_bloc.dart';
import 'package:medi_connect/features/admin/laboratory_management/presentation/bloc/radiology_bloc.dart';
import 'package:medi_connect/features/admin/pharmacy_management/data/datasource/pharmacy_remote_datasource.dart';
import 'package:medi_connect/features/admin/pharmacy_management/data/repositories/pharmacy_repository_impl.dart';
import 'package:medi_connect/features/admin/pharmacy_management/domain/repositories/pharmacy_repository.dart';
import 'package:medi_connect/features/admin/pharmacy_management/domain/usecases/get_pharmacy_stats_usecase.dart';
import 'package:medi_connect/features/admin/pharmacy_management/presentation/bloc/pharmacy_bloc.dart';
import 'package:medi_connect/features/admin/queue_management/data/datasource/casuality_remote_datasource.dart';
import 'package:medi_connect/features/admin/queue_management/data/repositories/casuality_repository_impl.dart';
import 'package:medi_connect/features/admin/queue_management/domain/repositories/casuality_repository.dart';
import 'package:medi_connect/features/admin/queue_management/domain/usecases/get_casuality_stats_usecase.dart';
import 'package:medi_connect/features/admin/queue_management/presentation/bloc/casuality_bloc.dart';
import 'package:medi_connect/features/admin/report_management/data/datasource/management_information_system_remote_datasource.dart';
import 'package:medi_connect/features/admin/report_management/data/repositories/management_information_system_repository_impl.dart';
import 'package:medi_connect/features/admin/report_management/domain/repositories/management_information_system_repository.dart';
import 'package:medi_connect/features/admin/report_management/domain/usecases/get_management_information_system_stats_usecase.dart';
import 'package:medi_connect/features/admin/report_management/presentation/bloc/management_information_system_bloc.dart';
import 'package:medi_connect/features/admin/room_management/data/datasource/operation_theatre_remote_datasource.dart';
import 'package:medi_connect/features/admin/room_management/data/repositories/operation_theatre_repository_impl.dart';
import 'package:medi_connect/features/admin/room_management/domain/repositories/operation_theatre_repository.dart';
import 'package:medi_connect/features/admin/room_management/domain/usecases/get_operation_theatre_stats_usecase.dart';
import 'package:medi_connect/features/admin/room_management/presentation/bloc/operation_theatre_bloc.dart';
import 'package:medi_connect/features/admin/settings_management/data/datasource/fire_safety_remote_datasource.dart';
import 'package:medi_connect/features/admin/settings_management/data/datasource/information_technology_remote_datasource.dart';
import 'package:medi_connect/features/admin/settings_management/data/repositories/fire_safety_repository_impl.dart';
import 'package:medi_connect/features/admin/settings_management/data/repositories/information_technology_repository_impl.dart';
import 'package:medi_connect/features/admin/settings_management/domain/repositories/fire_safety_repository.dart';
import 'package:medi_connect/features/admin/settings_management/domain/repositories/information_technology_repository.dart';
import 'package:medi_connect/features/admin/settings_management/domain/usecases/get_fire_safety_stats_usecase.dart';
import 'package:medi_connect/features/admin/settings_management/domain/usecases/get_information_technology_stats_usecase.dart';
import 'package:medi_connect/features/admin/settings_management/presentation/bloc/fire_safety_bloc.dart';
import 'package:medi_connect/features/admin/settings_management/presentation/bloc/information_technology_bloc.dart';
import 'package:medi_connect/features/admin/staff_management/data/datasource/human_resource_remote_datasource.dart';
import 'package:medi_connect/features/admin/staff_management/data/datasource/nursing_remote_datasource.dart';
import 'package:medi_connect/features/admin/staff_management/data/repositories/human_resource_repository_impl.dart';
import 'package:medi_connect/features/admin/staff_management/data/repositories/nursing_repository_impl.dart';
import 'package:medi_connect/features/admin/staff_management/domain/repositories/human_resource_repository.dart';
import 'package:medi_connect/features/admin/staff_management/domain/repositories/nursing_repository.dart';
import 'package:medi_connect/features/admin/staff_management/domain/usecases/get_human_resource_stats_usecase.dart';
import 'package:medi_connect/features/admin/staff_management/domain/usecases/get_nursing_stats_usecase.dart';
import 'package:medi_connect/features/admin/staff_management/presentation/bloc/human_resource_bloc.dart';
import 'package:medi_connect/features/admin/staff_management/presentation/bloc/nursing_bloc.dart';
import 'package:medi_connect/features/admin/ward_management/data/datasource/icu_remote_datasource.dart';
import 'package:medi_connect/features/admin/ward_management/data/datasource/nutrition_and_diabetics_remote_datasource.dart';
import 'package:medi_connect/features/admin/ward_management/data/datasource/ward_remote_datasource.dart';
import 'package:medi_connect/features/admin/ward_management/data/repositories/icu_repository_impl.dart';
import 'package:medi_connect/features/admin/ward_management/data/repositories/nutrition_and_diabetics_repository_impl.dart';
import 'package:medi_connect/features/admin/ward_management/data/repositories/ward_repository_impl.dart';
import 'package:medi_connect/features/admin/ward_management/domain/repositories/icu_repository.dart';
import 'package:medi_connect/features/admin/ward_management/domain/repositories/nutrition_and_diabetics_repository.dart';
import 'package:medi_connect/features/admin/ward_management/domain/repositories/ward_repository.dart';
import 'package:medi_connect/features/admin/ward_management/domain/usecases/get_icu_stats_usecase.dart';
import 'package:medi_connect/features/admin/ward_management/domain/usecases/get_nutrition_and_diabetics_stats_usecase.dart';
import 'package:medi_connect/features/admin/ward_management/domain/usecases/get_ward_stats_usecase.dart';
import 'package:medi_connect/features/admin/ward_management/presentation/bloc/icu_bloc.dart';
import 'package:medi_connect/features/admin/ward_management/presentation/bloc/nutrition_and_diabetics_bloc.dart';
import 'package:medi_connect/features/admin/ward_management/presentation/bloc/ward_bloc.dart';

void configureAllDepartmentsDependencies(GetIt sl) {}

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
