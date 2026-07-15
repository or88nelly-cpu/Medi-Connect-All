import 'package:injectable/injectable.dart';
import 'package:medi_connect/core/network/supabase_service.dart';
import 'package:medi_connect/features/doctor/ip_info/data/models/ip_occupancy_model.dart';

abstract class IpInfoRemoteDataSource {
  Future<List<IpOccupancyModel>> getIpOccupancy();
}

@LazySingleton(as: IpInfoRemoteDataSource)
class IpInfoRemoteDataSourceImpl implements IpInfoRemoteDataSource {
  final SupabaseService _supabaseService;

  IpInfoRemoteDataSourceImpl(this._supabaseService);

  @override
  Future<List<IpOccupancyModel>> getIpOccupancy() async {
    // Return mockup matching exact specs from user upload
    return const [
      IpOccupancyModel(
        name: 'ICU',
        occupiedBeds: 12,
        totalBeds: 20,
        occupiedPercentage: 0.60,
        sparkline: [20.0, 30.0, 25.0, 40.0, 35.0, 50.0, 60.0],
      ),
      IpOccupancyModel(
        name: 'Ward',
        occupiedBeds: 56,
        totalBeds: 80,
        occupiedPercentage: 0.70,
        sparkline: [40.0, 45.0, 50.0, 48.0, 55.0, 65.0, 70.0],
      ),
      IpOccupancyModel(
        name: 'Room',
        occupiedBeds: 32,
        totalBeds: 50,
        occupiedPercentage: 0.64,
        sparkline: [30.0, 32.0, 35.0, 38.0, 45.0, 55.0, 64.0],
      ),
      IpOccupancyModel(
        name: 'Surgery Schedule',
        occupiedBeds: 8,
        totalBeds: 10,
        occupiedPercentage: 0.80,
        sparkline: [10.0, 20.0, 35.0, 40.0, 50.0, 60.0, 80.0],
      ),
      IpOccupancyModel(
        name: 'Block',
        occupiedBeds: 4,
        totalBeds: 6,
        occupiedPercentage: 0.67,
        sparkline: [20.0, 30.0, 40.0, 38.0, 45.0, 50.0, 67.0],
      ),
      IpOccupancyModel(
        name: 'HDU',
        occupiedBeds: 6,
        totalBeds: 10,
        occupiedPercentage: 0.60,
        sparkline: [30.0, 25.0, 40.0, 35.0, 48.0, 55.0, 60.0],
      ),
    ];
  }
}
