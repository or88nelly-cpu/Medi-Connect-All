import 'package:injectable/injectable.dart';

abstract class MarketingRemoteDataSource {
  Future<Map<String, dynamic>> getMarketingStats();
}

@LazySingleton(as: MarketingRemoteDataSource)
class MarketingRemoteDataSourceImpl implements MarketingRemoteDataSource {
  @override
  Future<Map<String, dynamic>> getMarketingStats() async {
    return {
      'active_campaigns': 4,
      'leads_generated_this_week': 85,
      'website_visitors_today': 1200,
      'community_events_scheduled': 2,
    };
  }
}
