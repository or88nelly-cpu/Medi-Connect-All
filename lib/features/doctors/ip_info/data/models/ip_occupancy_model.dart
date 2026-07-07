import 'package:medi_connect/features/doctors/ip_info/domain/entities/ip_occupancy_entity.dart';

class IpOccupancyModel extends IpOccupancyEntity {
  const IpOccupancyModel({
    required super.name,
    required super.occupiedBeds,
    required super.totalBeds,
    required super.occupiedPercentage,
    required super.sparkline,
  });

  factory IpOccupancyModel.fromJson(Map<String, dynamic> json) {
    return IpOccupancyModel(
      name: json['name'] as String? ?? '',
      occupiedBeds: (json['occupied_beds'] as num? ?? 0).toInt(),
      totalBeds: (json['total_beds'] as num? ?? 0).toInt(),
      occupiedPercentage: (json['occupied_percentage'] as num? ?? 0.0).toDouble(),
      sparkline: (json['sparkline'] as List<dynamic>? ?? [0.0, 0.0, 0.0])
          .map((e) => (e as num).toDouble())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'occupied_beds': occupiedBeds,
    'total_beds': totalBeds,
    'occupied_percentage': occupiedPercentage,
    'sparkline': sparkline,
  };
}
