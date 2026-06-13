/// Domain entity for an activity log entry.
import 'package:equatable/equatable.dart';

class ActivityLogEntity extends Equatable {
  final String id;
  final String message;
  final String category;
  final DateTime createdAt;

  const ActivityLogEntity({
    required this.id,
    required this.message,
    required this.category,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, message, category, createdAt];
}
