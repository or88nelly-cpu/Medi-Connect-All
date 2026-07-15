library;

import 'package:medi_connect/features/common/dashboard/domain/entities/analytics_entity.dart';

/// Analytics data model.

class AnalyticsModel extends AnalyticsEntity {
  const AnalyticsModel({required super.id, required super.name});

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
