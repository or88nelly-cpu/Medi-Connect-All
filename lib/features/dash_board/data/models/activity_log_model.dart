/// Data model for activity log entries with JSON serialization.
import 'package:medi_connect/features/dash_board/domain/entities/activity_log_entity.dart';

class ActivityLogModel extends ActivityLogEntity {
  const ActivityLogModel({
    required super.id,
    required super.message,
    required super.category,
    required super.createdAt,
  });

  factory ActivityLogModel.fromJson(Map<String, dynamic> json) {
    return ActivityLogModel(
      id: json['id']?.toString() ?? '',
      message: json['message'] as String? ?? '',
      category: json['category'] as String? ?? 'System',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'message': message,
        'category': category,
      };
}
