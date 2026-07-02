import 'package:medi_connect/modules/patient/dashboard/domain/entities/banner_entity.dart';

class BannerModel extends BannerEntity {
  const BannerModel({
    required super.id,
    required super.hospitalId,
    required super.imageUrl,
    required super.linkType,
    super.linkValue,
    required super.displayOrder,
    super.startDate,
    super.endDate,
    required super.isActive,
    required super.targetRole,
    super.createdBy,
    required super.createdAt,
    required super.updatedAt,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id'] as String,
      hospitalId: json['hospital_id'] as String,
      imageUrl: json['image_url'] as String,
      linkType: json['link_type'] as String,
      linkValue: json['link_value'] as String?,
      displayOrder: json['display_order'] as int,
      startDate: json['start_date'] != null
          ? DateTime.parse(json['start_date'] as String)
          : null,
      endDate: json['end_date'] != null
          ? DateTime.parse(json['end_date'] as String)
          : null,
      isActive: json['is_active'] as bool,
      targetRole: json['target_role'] as String,
      createdBy: json['created_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hospital_id': hospitalId,
      'image_url': imageUrl,
      'link_type': linkType,
      'link_value': linkValue,
      'display_order': displayOrder,
      'start_date': startDate?.toIso8601String(),
      'end_date': endDate?.toIso8601String(),
      'is_active': isActive,
      'target_role': targetRole,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory BannerModel.fromEntity(BannerEntity entity) {
    return BannerModel(
      id: entity.id,
      hospitalId: entity.hospitalId,
      imageUrl: entity.imageUrl,
      linkType: entity.linkType,
      linkValue: entity.linkValue,
      displayOrder: entity.displayOrder,
      startDate: entity.startDate,
      endDate: entity.endDate,
      isActive: entity.isActive,
      targetRole: entity.targetRole,
      createdBy: entity.createdBy,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  BannerModel copyWith({
    String? id,
    String? hospitalId,
    String? imageUrl,
    String? linkType,
    String? linkValue,
    int? displayOrder,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
    String? targetRole,
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return BannerModel(
      id: id ?? this.id,
      hospitalId: hospitalId ?? this.hospitalId,
      imageUrl: imageUrl ?? this.imageUrl,
      linkType: linkType ?? this.linkType,
      linkValue: linkValue ?? this.linkValue,
      displayOrder: displayOrder ?? this.displayOrder,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      targetRole: targetRole ?? this.targetRole,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
