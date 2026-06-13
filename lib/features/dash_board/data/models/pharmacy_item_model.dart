/// Data model for pharmacy inventory items with JSON serialization.
import 'package:medi_connect/features/dash_board/domain/entities/pharmacy_item_entity.dart';

class PharmacyItemModel extends PharmacyItemEntity {
  const PharmacyItemModel({
    required super.id,
    required super.name,
    required super.stock,
    required super.category,
    required super.status,
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
      };
}
