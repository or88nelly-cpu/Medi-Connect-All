/// Domain entity for an emergency alert.
import 'package:equatable/equatable.dart';

class EmergencyEntity extends Equatable {
  final String id;
  final String message;
  final String level;
  final DateTime createdAt;
  final bool isResolved;

  const EmergencyEntity({
    required this.id,
    required this.message,
    required this.level,
    required this.createdAt,
    this.isResolved = false,
  });

  @override
  List<Object?> get props => [id, message, level, createdAt, isResolved];
}
