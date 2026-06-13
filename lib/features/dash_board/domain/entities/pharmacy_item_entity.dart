/// Domain entity for a pharmacy inventory item.
import 'package:equatable/equatable.dart';

class PharmacyItemEntity extends Equatable {
  final String id;
  final String name;
  final int stock;
  final String category;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PharmacyItemEntity({
    required this.id,
    required this.name,
    required this.stock,
    required this.category,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, name, stock, category, status];
}
