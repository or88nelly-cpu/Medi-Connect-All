/// Analytics entity definition.
import 'package:equatable/equatable.dart';

class AnalyticsEntity extends Equatable {
  final String id;
  final String name;

  const AnalyticsEntity({required this.id, required this.name});

  @override
  List<Object?> get props => [id, name];
}
