import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:medi_connect/features/admin/billing_management/presentation/bloc/finance_bloc.dart';
import 'package:medi_connect/features/admin/consultation_management/presentation/bloc/dyalisis_bloc.dart';
import 'package:medi_connect/features/admin/consultation_management/presentation/bloc/emrd_bloc.dart';
import 'package:medi_connect/features/admin/consultation_management/presentation/bloc/physio_therapy_bloc.dart';
import 'package:medi_connect/features/admin/customer_care/presentation/bloc/customer_care_bloc.dart';
import 'package:medi_connect/features/admin/customer_care/presentation/bloc/marketing_bloc.dart';
import 'package:medi_connect/features/admin/equipment_management/presentation/bloc/biomedical_engineering_bloc.dart';
import 'package:medi_connect/features/admin/equipment_management/presentation/bloc/cssd_bloc.dart';
import 'package:medi_connect/features/admin/equipment_management/presentation/bloc/mep_engineer_bloc.dart';
import 'package:medi_connect/features/admin/inventory_management/presentation/bloc/general_store_bloc.dart';
import 'package:medi_connect/features/admin/inventory_management/presentation/bloc/purchase_bloc.dart';
import 'package:medi_connect/features/admin/laboratory_management/presentation/bloc/laboratory_bloc.dart';
import 'package:medi_connect/features/admin/laboratory_management/presentation/bloc/radiology_bloc.dart';
import 'package:medi_connect/features/admin/pharmacy_management/presentation/bloc/pharmacy_bloc.dart';
import 'package:medi_connect/features/admin/queue_management/presentation/bloc/casuality_bloc.dart';
import 'package:medi_connect/features/admin/report_management/presentation/bloc/management_information_system_bloc.dart';
import 'package:medi_connect/features/admin/room_management/presentation/bloc/operation_theatre_bloc.dart';
import 'package:medi_connect/features/admin/settings_management/presentation/bloc/fire_safety_bloc.dart';
import 'package:medi_connect/features/admin/settings_management/presentation/bloc/information_technology_bloc.dart';
import 'package:medi_connect/features/admin/staff_management/presentation/bloc/human_resource_bloc.dart';
import 'package:medi_connect/features/admin/staff_management/presentation/bloc/nursing_bloc.dart';
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
