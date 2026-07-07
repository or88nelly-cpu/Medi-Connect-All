import 'package:equatable/equatable.dart';

class IpOccupancyEntity extends Equatable {
  final String name;
  final int occupiedBeds;
  final int totalBeds;
  final double occupiedPercentage;
  final List<double> sparkline;

  const IpOccupancyEntity({
    required this.name,
    required this.occupiedBeds,
    required this.totalBeds,
    required this.occupiedPercentage,
    required this.sparkline,
  });

  @override
  List<Object?> get props => [
        name,
        occupiedBeds,
        totalBeds,
        occupiedPercentage,
        sparkline,
      ];
}
