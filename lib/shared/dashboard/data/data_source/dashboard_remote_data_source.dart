import 'package:medi_connect/core/constants/app_table_names.dart';
import 'package:medi_connect/core/errors/exceptions.dart';

import 'package:medi_connect/shared/dashboard/data/models/dashboard_widget_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract class DashboardRemoteDataSource {
  Future<List<DashboardWidgetModel>> getDashboardWidgets();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final SupabaseClient supabaseClient;

  DashboardRemoteDataSourceImpl(this.supabaseClient);

  @override
  Future<List<DashboardWidgetModel>> getDashboardWidgets() async {
    try {
      final response = await supabaseClient
          .from(AppTableNames.dashboardWidgets)
          .select()
          .eq('is_active', true);

      return (response as List)
          .map((item) => DashboardWidgetModel.fromJson(item))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
