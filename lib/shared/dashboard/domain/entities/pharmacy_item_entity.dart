/// Domain entity for a pharmacy inventory item.
library;

import 'package:equatable/equatable.dart';

class PharmacyItemEntity extends Equatable {
  final String id;
  final String name;
  final int stock;
  final String category;
  final String status;
  final double buyPrice;
  final double sellPrice;
  final String dosage;
  final String imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const PharmacyItemEntity({
    required this.id,
    required this.name,
    required this.stock,
    required this.category,
    required this.status,
    this.buyPrice = 0.0,
    this.sellPrice = 0.0,
    this.dosage = '',
    this.imageUrl = '',
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    stock,
    category,
    status,
    buyPrice,
    sellPrice,
    dosage,
    imageUrl,
  ];
}
