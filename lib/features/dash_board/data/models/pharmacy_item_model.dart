/// Data model for pharmacy inventory items with JSON serialization.
library;

import 'package:medi_connect/features/dash_board/domain/entities/pharmacy_item_entity.dart';

class PharmacyItemModel extends PharmacyItemEntity {
  const PharmacyItemModel({
    required super.id,
    required super.name,
    required super.stock,
    required super.category,
    required super.status,
    super.buyPrice,
    super.sellPrice,
    super.dosage,
    super.imageUrl,
    super.createdAt,
    super.updatedAt,
  });

  factory PharmacyItemModel.fromJson(Map<String, dynamic> json) {
    final stock = json['stock'] as int? ?? 0;
    String status;
    if (stock == 0) {
      status = 'Out of Stock';
    } else if (stock < 10) {
      status = 'Low Stock';
    } else {
      status = 'In Stock';
    }
    return PharmacyItemModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      stock: stock,
      category: json['category'] as String? ?? '',
      status: status,
      buyPrice:
          (json['buy_price'] ?? json['buyprize'] ?? json['buyPrice'] as num?)
              ?.toDouble() ??
          0.0,
      sellPrice:
          (json['sell_price'] ?? json['sellprize'] ?? json['sellPrice'] as num?)
              ?.toDouble() ??
          0.0,
      dosage: json['dosage'] as String? ?? '',
      imageUrl:
          json['image_url'] as String? ?? json['imageUrl'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'stock': stock,
    'category': category,
    'buy_price': buyPrice,
    'sell_price': sellPrice,
    'dosage': dosage,
    'image_url': imageUrl,
  };
}
